local M = { name = "mojoid" }

-- std path ~/.config/nvim/lua/ .. info.name
M.path = {
    home = M.name,
    config = M.name .. ".config",
    plugins = M.name .. ".plugins",
    core = M.name .. ".core",
}

M.icons = {
    diagnostics = {
        hint = "⚑",
        info = "",
        warning = "",
        error = "",
    },
    search = '',
    newfile = '',
    history = '',
}

return M
