
-- Dapatkan path konfigurasi Neovim
local config_path = vim.fn.stdpath('config')

-- Tambahkan path ~/.config/nvim/ ke package.path
package.path = config_path .. '/?.lua;' .. package.path

-- Muat modul id.lua
require(require('id').path.home)
