return {
    -- treesitter
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        config = function()
            local config = require("nvim-treesitter.configs")
            config.setup({
                ensure_installed = { "lua", "rust" },
                highlight = { enable = true },
                indent = { enable = true },
                auto_install = true,
            })
        end
    },

    -- nvim surround
    {
        --[[  Old text                    Command         New text
        --------------------------------------------------------------------------------
        surround_words             ysiw)           (surround_words)
        make strings               ys$"            "make strings"
        [delete around me!]        ds]             delete around me!
        remove <b>HTML tags</b>    dst             remove HTML tags
        "change quotes"            cs"'            'change quotes'
        <b>or tag types</b>        csth1<CR>       <h1>or tag types</h1>
        delete(function calls)     dsf             function calls
    --]]

        "kylechui/nvim-surround",
        version = "*", -- Use for stability; omit to use `main` branch for the latest features
        event = "InsertEnter",
        config = function()
            require("nvim-surround").setup({})
        end
    },

    -- color palet
    {
        'norcalli/nvim-colorizer.lua',
        config = function()
            require 'colorizer'.setup()
        end
    },

    -- comment / uncomment
    {
        -- <gcc> comment single line
        -- <gbc> comment multyline
        'numToStr/Comment.nvim',
        event = "InsertEnter",
        config = function()
            require('Comment').setup()
        end
    },

    -- auto pairs
    {
        "jiangmiao/auto-pairs", event = "InsertEnter"
    },
}
