vim.g.mapleader = " "
vim.g.maplocalleader = ","

-- general opts
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.scrolloff = 8
vim.opt.termguicolors = true
vim.opt.expandtab = true
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2

-- the right side line
vim.opt.cursorline = true
vim.opt.cursorlineopt = "number"
vim.opt.colorcolumn = "130"

-- encoding
vim.opt.encoding = "utf-8"
vim.opt.termbidi = true
vim.opt.rightleft = false -- Keep false for mixed content
vim.opt.arabicshape = false

-- Initialize the variable to store the last command
vim.g.last_command = ""
--
-- Autocommand to capture the last command
vim.api.nvim_create_autocmd("CmdlineLeave", {
	callback = function()
		-- Capture the last command line input
		vim.g.last_command = vim.fn.getcmdline()
	end,
})
