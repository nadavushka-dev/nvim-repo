vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")
vim.keymap.set("v", "<leader>yc", "\"+y")
vim.keymap.set("n", "<leader>us", "<cmd>e!<CR>")
vim.keymap.set("n", "<leader><leader>x", "<cmd>source %<CR>")

-- Navigate vim panes better
vim.keymap.set("n", "<c-h>", ":wincmd h<CR>")
vim.keymap.set("n", "<c-l>", ":wincmd l<CR>")
vim.keymap.set("n", "<c-k>", ":wincmd k<CR>")
vim.keymap.set("n", "<c-j>", ":wincmd j<CR>")

-- Split window
vim.keymap.set("n", "<leader>sh", ":sp | enew<CR>")
vim.keymap.set("n", "<leader>sv", ":vsp | enew<CR>")

-- Disable arrow keys
vim.api.nvim_set_keymap('n', '<Up>', '', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<Down>', '', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<Left>', '', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<Right>', '', { noremap = true, silent = true })

vim.keymap.set("n", "<leader>err", "o if err != nil {\n}<Esc>O")
