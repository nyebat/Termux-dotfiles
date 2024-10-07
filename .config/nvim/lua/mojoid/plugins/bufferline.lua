-- bufferline
local M = {
  'akinsho/bufferline.nvim',
  event = "BufReadPre",
  dependencies = {
    { 'nvim-tree/nvim-web-devicons' }
  },
}

M.config = function()
  local bufferline = require("bufferline")
  -- local status_ok, bufferline = pcall(require, "bufferline")
  -- if not status_ok then
  --   return
  -- end
  bufferline.setup({
    options = {
      mode = 'buffers',
      offsets = {
        { filetype = 'NvimTree' }
      },
      numbers = 'none',
      diagnostics = 'nvim_lsp',
      diagnostics_indicator = function(count, level)
        local icon = level:match("error") and " " or " "
        return " " .. icon .. count
      end,
      seperator_style = 'slant' or 'padded_slant',
      show_tab_indicators = true,
      show_buffer_close_icons = false,
      show_close_icon = false,
    }
  })

  local keymap = vim.keymap
  keymap.set({ 'n', }, '<leader>tp', '<cmd>BufferLineCyclePrev<cr>')
  keymap.set({ 'n', }, '<leader>tn', '<cmd>BufferLineCycleNext<cr>')
end

return M
