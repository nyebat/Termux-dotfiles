vim.cmd("let g:netrw_liststyle = 3")
-- clipboard
-- vim.opt.clipboard:append("unnamedplus")

local opts = {
  relativenumber = true,
  number = true,

  -- tabs & indentation
  tabstop = 4,
  shiftwidth = 4,
  expandtab = true,
  autoindent = true,

  wrap = false,

  -- searxh setting
  ignorecase = true,
  smartcase = true,

  cursorline = true,
  termguicolors = true,
  background = "dark",
  signcolumn = "yes",

  -- backspaces
  backspace = "indent,eol,start",
  clipboard = "unnamedplus",

  -- split window
  splitright = true,
  splitbelow = true,

  backup = false,
  writebackup = false,
  swapfile = false,

  undodir = 'undodir',
  undofile = false,

  ruler = false,
}

for k, v in pairs(opts) do
  vim.opt[k] = v
end
