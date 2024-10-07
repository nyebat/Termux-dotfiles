-- nvim/lua/user/lsp/init.lua

require("mojoid.lsp.cmp") 
require("mojoid.lsp.mason")
require("mojoid.lsp.handlers").setup()
require("mojoid.lsp.null-ls") 
