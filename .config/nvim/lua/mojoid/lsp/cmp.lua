-- nvim/lua/user/cmp.lua


local cmp_status_ok, cmp = pcall(require, "cmp")
if not cmp_status_ok then
    return
end

-- size menu char
local ELLIPSIS_CHAR = '…'
local MAX_LABEL_WIDTH = 13
local MIN_LABEL_WIDTH = 5

require("luasnip.loaders.from_vscode").lazy_load()

-- Basic mapping
cmp.setup({
    snippet = {
        expand = function(args)
            require("luasnip").lsp_expand(args.body)
        end,
    },
    window = {
        completion = cmp.config.window.bordered(),
        documentation = cmp.config.window.bordered(),
    },

    mapping = cmp.mapping.preset.insert({
        ["<C-k>"] = cmp.mapping.select_prev_item(), -- previous suggestion
        ["<C-j>"] = cmp.mapping.select_next_item(), -- next suggestion
        ["<C-u>"] = cmp.mapping.scroll_docs(-4),
        ["<C-d>"] = cmp.mapping.scroll_docs(4),
        ["<C-Space>"] = cmp.mapping.complete(), -- show completion suggestions
        ["<C-e>"] = cmp.mapping.abort(),        -- close completion window
        ["<CR>"] = cmp.mapping.confirm({ select = false }),
    }),

    -- Here we choose how the completion window will appear
    formatting = {
        fields = { "kind", "abbr", "menu" },
        format = function(entry, vim_item)
            local menu_icon = {
                nvim_lsp = '[LSP]', --'λ ',
                luasnip = '[Snip]', --'⋗ ',
                buffer = '[buff]',  --'Ω ',
            }

            local label = vim_item.abbr
            local truncated_label = vim.fn.strcharpart(label, 0, MAX_LABEL_WIDTH)
            if truncated_label ~= label then
                vim_item.abbr = truncated_label .. ELLIPSIS_CHAR
            elseif string.len(label) < MIN_LABEL_WIDTH then
                local padding = string.rep(' ', MIN_LABEL_WIDTH - string.len(label))
                vim_item.abbr = label .. padding
            end

            vim_item.menu = menu_icon[entry.source.name]
            return vim_item
        end,

    },

    -- Here is the place where we can choose our sources, if the cmp is already configured, we can just add it here.
    sources = {
        { name = "nvim_lsp" },
        { name = "luasnip" }, -- For luasnip users.
        { name = "buffer" },
    },
    confirm_opts = {
        behavior = cmp.ConfirmBehavior.Replace,
        select = false,
    },
    experimental = {
        ghost_text = true,
    },
})
