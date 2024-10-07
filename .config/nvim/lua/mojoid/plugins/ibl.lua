-- imdent_blankline
local M = {
  -- 'lukas-reineke/indent-blankline.nvim',
  "lukas-reineke/indent-blankline.nvim",
  event = { "BufReadPre", "BufNewFile" },
  main = "ibl",
  opts = {},
  dependencies = {
    "echasnovski/mini.indentscope",
    version = false, -- wait till new 0.7.0 release to put it back on semver
  },
}

M.config = function()
  local ibl = require("ibl")

  ibl.setup({
    enabled = true,
    debounce = 100,
    indent = {
      char = "│", --center
      smart_indent_cap = true,
    },
    scope = { enabled = false, },
  })
  vim.keymap.set('n', '<leader>ui', '<cmd>IBLToggle<cr>')

  -- mini
  require('mini.indentscope').setup({
    symbol = "│", --center
    options = {
      try_as_border = true
    },
    draw = {
      -- Delay (in ms) between event and start of drawing scope indicator
      delay = 100,
      -- Symbol priority. Increase to display on top of more symbols.
      priority = 2,
    },
  })

  vim.api.nvim_create_autocmd("FileType", {
    pattern = {
      "lsp",
      "help",
      "alpha",
      "dashboard",
      "neo-tree",
      "Trouble",
      "lazy",
      "mason",
      "notify",
      "toggleterm",
      "lazyterm",
      "nvimtree",
    },
    callback = function()
      vim.b.miniindentscope_disable = true
    end,
  })
end

return M
