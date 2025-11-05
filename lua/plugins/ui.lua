local function last_exec_command()
	local foo = vim.g.last_command
	return (foo ~= nil and foo ~= "") and string.format(":%s", foo) or ""
end

return {
	-- COLORSCHEMES
	{
		"morhetz/gruvbox",
		lazy = false,
		priority = 1000,
		config = function()
			vim.cmd.colorscheme("gruvbox")
		end,
	},
	-- STATUS LINE
	{
		"nvim-lualine/lualine.nvim",
		event = "VeryLazy",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			require("lualine").setup({
				options = {
					icons_enabled = true,
					theme = "gruvbox",
					component_separators = { left = "", right = "" },
					section_separators = { left = "", right = "" },
					disabled_filetypes = {
						statusline = {},
						winbar = {},
					},
					ignore_focus = {},
					always_divide_middle = true,
					globalstatus = true,
					refresh = {
						statusline = 1000,
						tabline = 1000,
						winbar = 1000,
					},
				},
				sections = {
					lualine_b = { "branch", "diff", "diagnostics" },
					lualine_c = { "filename" },
					lualine_x = { last_exec_command },
					lualine_y = { "progress" },
					lualine_z = { "location" },
				},
				inactive_sections = {
					lualine_a = {},
					lualine_b = {},
					lualine_c = { "filename" },
					lualine_x = {},
					lualine_y = {},
					lualine_z = {},
				},
				extensions = { "oil", "mason", "lazy" },
			})
		end,
	},
	{
		"nvim-treesitter/nvim-treesitter",
		event = { "BufReadPost", "BufNewFile" },
		cmd = { "TSUpdateSync", "TSUpdate", "TSInstall" },
		build = ":TSUpdate",
		config = function()
			local configs = require("nvim-treesitter.configs")

			configs.setup({
				ensure_installed = {
					"lua",
					"vim",
					"vimdoc",
					"query",
					"go",
					"typescript",
					"javascript",
					"bash",
					"tsx",
					"json",
					"html",
					"css",
					"markdown",
					"markdown_inline",
				},
				auto_install = true,
				sync_install = false,
				ignore_install = {},
				modules = {},
				highlight = {
					enable = true,
					disable = function(lang, buf)
						local max_filesize = 100 * 1024 -- 100 KB
						local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
						if ok and stats and stats.size > max_filesize then
							return true
						end
						if lang == "zsh" then
							return true
						end
					end,
					additional_vim_regex_highlighting = { "zsh" },
				},
				indent = { enable = true },
				folds = {
					enable = true,
				},
				incremental_selection = {
					enable = true,
					keymaps = {
						init_selection = "<C-space>",
						node_incremental = "<C-space>",
						scope_incremental = false,
						node_decremental = "<bs>",
					},
				},
			})

			vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
				pattern = { "*.md", "*.markdown" },
				group = vim.api.nvim_create_augroup("MarkdownConceal", { clear = true }),
				callback = function()
					vim.opt_local.conceallevel = 2
					vim.opt_local.concealcursor = "nc" -- Hide in normal/command mode, show in insert

					-- --- START OF NEW/MODIFIED LINES ---
					vim.opt_local.foldmethod = "expr" -- Explicitly set foldmethod to expr
					vim.opt_local.foldexpr = "v:lua.vim.treesitter.foldexpr()" -- Explicitly set foldexpr to Treesitter's
					vim.opt_local.foldenable = true -- Ensure folding is enabled for this buffer
					vim.opt_local.foldcolumn = "1" -- Show a fold column
					vim.opt_local.foldlevel = 2 -- Set default open level (adjust to your preference)
					-- --- END OF NEW/MODIFIED LINES ---
				end,
			})
		end, -- Set conceallevel for markdown files (fixes Obsidian warning)
	},
	{
		"nvim-treesitter/nvim-treesitter-context",
		dependencies = { "nvim-treesitter/nvim-treesitter" },
		event = { "BufReadPost", "BufNewFile" },
		cmd = { "TSContextEnable", "TSContextDisable", "TSContextToggle" },
		config = function()
			local configs = require("treesitter-context")
			configs.setup({
				enable = true,
				multiwindow = false,
				max_lines = 3,
				min_window_height = 0,
				line_numbers = true,
				multiline_threshold = 20,
				trim_scope = "outer",
				mode = "cursor",
				separator = nil,
				zindex = 20,
				on_attach = function(buf)
					-- Disable in very large files
					local max_filesize = 100 * 1024 -- 100 KB
					local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
					if ok and stats and stats.size > max_filesize then
						return false
					end
					return true
				end,
			})
		end,
	},
	{
		"norcalli/nvim-colorizer.lua",
		config = function()
			require("colorizer").setup({
				"*",
				"!vim",
			})
		end,
	},
}
