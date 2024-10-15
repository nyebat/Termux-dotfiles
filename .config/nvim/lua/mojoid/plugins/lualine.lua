-- lualine

local M = {
    'nvim-lualine/lualine.nvim',
    event = { "BufReadPre", "BufNewFile" },
    dependencies = 'nvim-tree/nvim-web-devicons',
}

M.config = function()
    local status_ok, lualine = pcall(require, "lualine")
    if not status_ok then
        return
    end

    lualine.setup({
        options = {
            icons_enabled = true,
            theme = 'catppuccin',
            component_separators = { left = '', right = '' },
            section_separators = { left = '', right = '' },
        },
        sections = {
            lualine_a = { 'mode' },
            lualine_b = { 'branch', 'diff' },
            lualine_c = { { 'filename', path = 1 } },
            lualine_x = {},
            lualine_y = { 'diagnostics', 'location' },
            lualine_z = {
                function()
                    return " " .. os.date("%R")
                end,
            },
        },
        inactive_sections = {
            lualine_a = {},
            lualine_b = {},
            lualine_c = { 'filename' },
            lualine_x = { 'location' },
            lualine_y = {},
            lualine_z = { function() return " " .. os.date("%R") end, },
        }
    })
end

return M
