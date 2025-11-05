return {
	{
		"MeanderingProgrammer/render-markdown.nvim",
		enable = false,
		dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" }, -- if you prefer nvim-web-devicons
		---@module 'render-markdown'
		---@type render.md.UserConfig
		opts = {},
	},
	{
		"epwalsh/obsidian.nvim",
		version = "*",
		lazy = false,
		event = {
			"BufReadPre "
				.. vim.fn.expand("~")
				.. "/Library/Mobile Documents/iCloud~md~obsidian/Documents/ObsidianVault/**.md",
		},
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-telescope/telescope.nvim",
		},
		config = function()
			local obsidian = require("obsidian")

			obsidian.setup({
				workspaces = {
					{
						name = "ObsidianVault",
						path = "~/Library/Mobile Documents/iCloud~md~obsidian/Documents/ObsidianVault",
					},
				},
				notes_subdir = "0-Temp",
				-- Fix the crazy title generation
				note_id_func = function(title)
					-- Just use the title as-is, with some cleanup
					if title ~= nil then
						return title:gsub(" ", "-"):gsub("[^A-Za-z0-9-]", ""):lower()
					else
						return "untitled-" .. os.date("%Y-%m-%d-%H-%M-%S")
					end
				end,

				picker = {
					name = "telescope.nvim",
				},

				ui = { enable = true },
			})

			-- Keymaps using direct function calls
			vim.keymap.set("n", "<leader>of", "<cmd>ObsidianQuickSwitch<CR>", { desc = "Find Obsidian notes" })
			vim.keymap.set("n", "<leader>os", "<cmd>ObsidianSearch<cr>", { desc = "Search Obsidian vault" })
			vim.keymap.set("n", "<leader>on", "<cmd>ObsidianNew<cr>", { desc = "New Obsidian note" })

			vim.api.nvim_create_autocmd({ "FileType" }, {
				pattern = { "markdown" },
				group = vim.api.nvim_create_augroup("MarkdownWrap", { clear = true }),
				callback = function()
					-- Set text width
					vim.bo.textwidth = 130

					-- Configure format options for auto-wrapping
					vim.bo.formatoptions = "tcqjn"
					-- t = auto-wrap text using textwidth
					-- c = auto-wrap comments
					-- q = allow formatting with 'gq'
					-- j = remove comment leader when joining lines
					-- n = recognize numbered lists

					-- Enable wrapping display
					vim.wo.wrap = true
					vim.wo.linebreak = true
					vim.wo.breakindent = true
				end,
			})
		end,
	},
	{
		"iamcco/markdown-preview.nvim",
		cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
		ft = { "markdown" },
		build = function()
			vim.fn["mkdp#util#install"]()
		end,
		config = function()
			vim.g.mkdp_auto_start = 0
			vim.g.mkdp_auto_close = 1
			vim.g.mkdp_refresh_slow = 0
			vim.g.mkdp_command_for_global = 0
			vim.g.mkdp_open_to_the_world = 0
			vim.g.mkdp_open_ip = ""
			vim.g.mkdp_browser = ""
			vim.g.mkdp_echo_preview_url = 0
			vim.g.mkdp_browserfunc = ""
			vim.g.mkdp_preview_options = {
				mkit = {},
				katex = {},
				uml = {},
				maid = {},
				disable_sync_scroll = 0,
				sync_scroll_type = "middle",
				hide_yaml_meta = 1,
				sequence_diagrams = {},
				flowchart_diagrams = {},
			}
			vim.g.mkdp_markdown_css = ""
			vim.g.mkdp_highlight_css = ""
			vim.g.mkdp_port = ""
			vim.g.mkdp_page_title = "「${name}」"

			-- Keymaps
			vim.keymap.set("n", "<leader>mp", "<cmd>MarkdownPreview<cr>", { desc = "Markdown Preview" })
			vim.keymap.set("n", "<leader>ms", "<cmd>MarkdownPreviewStop<cr>", { desc = "Markdown Preview Stop" })
			vim.keymap.set("n", "<leader>mt", "<cmd>MarkdownPreviewToggle<cr>", { desc = "Markdown Preview Toggle" })
		end,
	},
}
