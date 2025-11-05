local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
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

-- Setup lazy.nvim
require("lazy").setup({
	spec = {
		-- import your plugins folder (more automated feel)
		-- { import = "plugins" },
		--
		-- import your plugins file by file (more control)
		require("plugins.lsp"),
		require("plugins.floater"),
		require("plugins.debugger"),
		require("plugins.git"),
		require("plugins.live-server"),
		require("plugins.text-editing"),
		require("plugins.navigation"),
		require("plugins.markdown"),
		require("plugins.ui"),
		require("plugins.nonesense"),
	},
	-- Configure any other settings here. See the documentation for more details.
	-- colorscheme that will be used when installing plugins.
})
