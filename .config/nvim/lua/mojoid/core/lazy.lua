
-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not (vim.uv or vim.loop).fs_stat(lazypath) then
    print('Installing lazy....')

    local lazyrepo = "https://github.com/folke/lazy.nvim.git"
    local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })

    if vim.v.shell_error ~= 0 then
        vim.api.nvim_echo({
            { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
            { out, "WarningMsg" },
            { "\nPress any key to exit..." },
        }, true, {})
        vim.fn.getchar()
        os.exit(1)
    end
end
vim.opt.rtp:prepend(lazypath)

-- PLUGINS

require("lazy").setup(
    "mojoid.plugins",
    {
        ui = {
            border = 'rounded',
        },
        install = {
            missing = true,                        -- install missing plugins on startup.
            colorscheme = { "catppuccin", "habamax" } -- use this theme during first install process
        },
        change_detection = {
            enabled = false, -- check for config file changes
            notify = false,  -- get a notification when changes are found
        },
        checker = {
            -- automatically check for plugin updates
            enabled = false,
            -- concurrency = nil, ---@type number? set to 1 to check fo
            notify = true, -- get a notification when new updates ar
            -- frequency = 3600,     -- check for updates every hour
            -- check_pinned = false, -- check for pinned packages that
        },
    }
)

