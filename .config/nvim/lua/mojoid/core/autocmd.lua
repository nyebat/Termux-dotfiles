-- [[ COMMANDS ]]

local group = vim.api.nvim_create_augroup('user_cmds', { clear = true })

vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight on yank',
  group = group,
  callback = function()
    vim.highlight.on_yank({ higroup = 'Visual', timeout = 300 })
  end,
})

vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'help', 'man' },
  group = group,
  command = 'nnoremap <buffer> q <cmd>quit<cr>'
})

-- disable nomor baris pada TermOpen
vim.api.nvim_create_autocmd('TermOpen', {
  pattern = '*',
  group = group,
  callback = function()
    vim.cmd('file Terminal')
    vim.cmd('setlocal nonumber')
    vim.cmd('setlocal norelativenumber')
    vim.api.nvim_feedkeys('i', 'n', false)
  end,
})

