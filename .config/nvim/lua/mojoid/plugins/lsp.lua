return {
    {
        "neovim/nvim-lspconfig",
        dependencies = {
            "williamboman/mason.nvim",
            "williamboman/mason.nvim",
            "williamboman/mason-lspconfig.nvim",
            "hrsh7th/nvim-cmp",
            -- "hrsh7th/cmp-nvim-lsp",
            -- "L3MON4D3/LuaSnip",
            -- "saadparwaiz1/cmp_luasnip",
            -- "rafamadriz/friendly-snippets",
        },
        config = function()
            -- we'll need to call lspconfig to pass our server to the native neovim lspconfig.
            local lspconfig_status_ok, lspconfig = pcall(require, "lspconfig")
            if not lspconfig_status_ok then
                vim.notify("Failed to load nvim-lspconfig")
                return
            end

            -- Protected calls to load necessary modules
            local status_ok, mason = pcall(require, "mason")
            if not status_ok then
                vim.notify("Failed to load mason")
                return
            end

            local status_ok_1, mason_lspconfig = pcall(require, "mason-lspconfig")
            if not status_ok_1 then
                vim.notify("Failed to load mason-lspconfig")
                return
            end

            local M = {}

            local status_cmp_ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
            if not status_cmp_ok then
                vim.notify("Failed to load cmp_nvim_lsp")
                return
            end
            -- Setup LSP capabilities
            M.capabilities = vim.lsp.protocol.make_client_capabilities()
            M.capabilities = cmp_nvim_lsp.default_capabilities(M.capabilities)
            M.capabilities.textDocument.completion.completionItem.snippetSupport = true

            -- Setup Mason
            -- Define the LSP servers to be managed by Mason
            local servers = { "lua_ls", "rust_analyzer", "clangd", "bashls" }

            -- Here we declare which settings to pass to the mason, and also ensure servers are installed. If not, they will be installed automatically.
            local settings = {
                ui = {
                    border = "rounded",
                    icons = {
                        package_installed = "◍",
                        package_pending = "◍",
                        package_uninstalled = "◍",
                    },
                },
                log_level = vim.log.levels.INFO,
                max_concurrent_installers = 4,
            }
            mason.setup(settings)
            mason_lspconfig.setup {
                ensure_installed = { "bashls", }, --servers,
                automatic_installation = false,
            }


            local opts = {}

            for _, server in pairs(servers) do
                opts = {
                    -- getting "on_attach" and capabilities from handlers
                    on_attach = M.on_attach,
                    capabilities = M.capabilities,
                }

                -- pass them to lspconfig
                lspconfig[server].setup(opts)
            end
            -- Setup function to initialize Mason and configure diagnostics
            -- Define diagnostic signs
            local signs = {
                { name = 'DiagnosticSignError', text = '' },
                { name = 'DiagnosticSignWarn', text = '' },
                { name = 'DiagnosticSignHint', text = '⚑' },
                { name = 'DiagnosticSignInfo', text = '' },
            }

            -- Register diagnostic signs
            for _, sign in ipairs(signs) do
                vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.text, numhl = "" })
            end

            -- Configure diagnostics
            local config = {
                virtual_text = true,
                signs = { active = signs },
                update_in_insert = true,
                underline = true,
                severity_sort = true,
            }
            vim.diagnostic.config(config)

            -- Setup LSP handlers for hover and signature help
            vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(vim.lsp.handlers.hover,
                { border = 'rounded' })
            vim.lsp.handlers['textDocument/signatureHelp'] = vim.lsp.with(vim.lsp.handlers.signature_help,
                { border = 'rounded' })



            -- Function to set up key mappings for LSP
            local function lsp_keymaps(bufnr)
                local opts = { noremap = true, silent = true }
                vim.api.nvim_buf_set_keymap(bufnr, "n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", opts)
                vim.api.nvim_buf_set_keymap(bufnr, "n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>", opts)
                vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>lr", "<cmd>lua vim.lsp.buf.rename()<CR>", opts)
                vim.api.nvim_buf_set_keymap(bufnr, "n", "gl", "<cmd>lua vim.diagnostic.open_float()<CR>", opts)
                vim.cmd([[ command! Format execute 'lua vim.lsp.buf.format()' ]])
            end

            -- Function for formatting with null-ls on buffer write
            local function lsp_formatting(bufnr)
                vim.lsp.buf.format({
                    filter = function(client)
                        return client.name == "null-ls"
                    end,
                    bufnr = bufnr,
                })
            end

            -- Auto command group for formatting on save
            local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

            -- Attach function to be called when LSP server attaches to a buffer
            M.on_attach = function(client, bufnr)
                lsp_keymaps(bufnr)
                if client.supports_method("textDocument/formatting") then
                    vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
                    vim.api.nvim_create_autocmd("BufWritePre", {
                        group = augroup,
                        buffer = bufnr,
                        callback = function()
                            lsp_formatting(bufnr)
                        end,
                    })
                end
            end

            -- Functions to manage format on save
            function M.enable_format_on_save()
                vim.cmd [[
                    augroup format_on_save
                    autocmd!
                    autocmd BufWritePre * lua vim.lsp.buf.format({ async = false })
                    augroup end
                    ]]
                vim.notify("Enabled format on save")
            end

            function M.disable_format_on_save()
                M.remove_augroup("format_on_save")
                vim.notify("Disabled format on save")
            end

            function M.toggle_format_on_save()
                if vim.fn.exists("#format_on_save#BufWritePre") == 0 then
                    M.enable_format_on_save()
                else
                    M.disable_format_on_save()
                end
            end

            function M.remove_augroup(name)
                if vim.fn.exists("#" .. name) == 1 then
                    vim.cmd("au! " .. name)
                end
            end

            -- Toggle format on save at the start
            M.toggle_format_on_save()

            -- Return the module
            return M
        end
    },


    {
        'simrat39/rust-tools.nvim',
        config = function()
            local opts = {
                tools = { -- rust-tools options

                    -- how to execute terminal commands
                    -- options right now: termopen / quickfix / toggleterm / vimux
                    executor = require("rust-tools.executors").termopen,

                    -- callback to execute once rust-analyzer is done initializing the workspace
                    -- The callback receives one parameter indicating the `health` of the server: "ok" | "warning" | "error"
                    on_initialized = nil,

                    -- automatically call RustReloadWorkspace when writing to a Cargo.toml file.
                    reload_workspace_from_cargo_toml = true,

                    -- These apply to the default RustSetInlayHints command
                    inlay_hints = {
                        -- automatically set inlay hints (type hints)
                        -- default: true
                        auto = true,

                        -- Only show inlay hints for the current line
                        only_current_line = false,

                        -- whether to show parameter hints with the inlay hints or not
                        -- default: true
                        show_parameter_hints = true,

                        -- prefix for parameter hints
                        -- default: "<-"
                        parameter_hints_prefix = "<- ",

                        -- prefix for all the other hints (type, chaining)
                        -- default: "=>"
                        other_hints_prefix = "=> ",

                        -- whether to align to the extreme right or not
                        right_align = false,

                        -- padding from the right if right_align is true
                        right_align_padding = 7,

                        -- The color of the hints
                        highlight = "Comment",
                    },
                },
            }

            require('rust-tools').setup(opts)
        end
    }
}
