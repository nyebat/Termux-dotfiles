return {
    { "neovim/nvim-lspconfig" },

    { "williamboman/mason.nvim" },

    { "williamboman/mason-lspconfig.nvim" },

    { "jose-elias-alvarez/null-ls.nvim" },

    {
        "hrsh7th/nvim-cmp",
        dependencies = {
            { "hrsh7th/cmp-nvim-lsp" },
            { "L3MON4D3/LuaSnip", },
            { "saadparwaiz1/cmp_luasnip", },
            { "rafamadriz/friendly-snippets", },
        }
    },

}
