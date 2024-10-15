vim.g.mapleader = " "

local keymap = vim.keymap

-- go to homeline
keymap.set({ 'n', 'x', 'o' }, '<leader>h', '^')
-- goto endline
keymap.set({ 'n', 'x', 'o' }, '<leader>l', 'g_')

-- Basic clipboard interaction
keymap.set({ 'n', 'x' }, 'cp', '"+y')
keymap.set({ 'n', 'x' }, 'cv', '"+p')

-- Delete text
keymap.set({ 'n', 'x' }, 'x', '"_x')


--keymap.set({"i","n","v"}, ",.", "<ESC>", { desc = "Exit insert mode with jk", silent = true })

keymap.set("n", "<leader>in", "ggVG=<CR>", { desc = "Reindent", silent = true })
keymap.set('n', '<leader>a', ':keepjumps normal! ggVG<cr>', { desc = "Select all text in buffer", silent = true })

-- save, quit, reload config for this buffer
keymap.set("n", "<leader>ww", "<cmd>:write<CR>", { desc = "Seve file", silent = true })
keymap.set("n", "<leader>qq", "<cmd>:quit<CR>", { desc = "Quit buffer", silent = true })
keymap.set("n", "<leader>wq", "<cmd>:wq<CR>", { desc = "Save and quit", silent = true })
keymap.set("n", "<leader>r", "<cmd>:source %<CR>", { desc = "Reload config this for buffer", silent = true })

keymap.set("n", "<leader>nh", ":nohl<CR>", { desc = "Clear highlith search", silent = true })

-- increment/decrement number
keymap.set("n", "<leader>+", "<C-a>", { desc = "increment number", silent = true })
keymap.set("n", "<leader>-", "<C-x>", { desc = "decrement number", silent = true })

-- window management
-- split window
keymap.set("n", "<leader>sv", "<C-w>v", { desc = "split window vertical", silent = true })
keymap.set("n", "<leader>sh", "<C-w>s", { desc = "split window horizontal", silent = true })
keymap.set("n", "<leader>se", "<C-w>=", { desc = "make split equal size", silent = true })

-- open terminal
keymap.set("n", "<leader>sr", "<cmd>:split term://$SHELL<CR>", { desc = "terminal", silent = true })
keymap.set("n", "<leader>bd", "<cmd>:bdelete<CR>", { desc = "close buffer" })

-- tab window
keymap.set("n", "<leader>to", "<cmd>tabnew<CR>", { desc = "open new tab", silent = true })
keymap.set("n", "<leader>tn", "<cmd>tabn<CR>", { desc = "goto next tab", silent = true })
keymap.set("n", "<leader>tp", "<cmd>tabp<CR>", { desc = "goto previouse tab", silent = true })
keymap.set("n", "<leader>tf", "<cmd>tabnew %<CR>", { desc = "open current buffer in new tab", silent = true })

-- code runner
keymap.set("n", "<leader>x", "<cmd>BuffRun<cr>", { desc = "Code runner" })
keymap.set("n", "<leader>run", ':split term://cd %:h && RUSTFLAGS=\\"-Awarnings\\" cargo run', { desc = "Code runner" })
