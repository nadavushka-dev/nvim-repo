return {
	{
		"github/copilot.vim",
		config = function()
			vim.keymap.set("i", "<C-a>", 'copilot#Accept("\\<CR>")', {
				expr = true,
				replace_keycodes = false,
				desc = "Accept Copilot suggestion",
			})
			vim.g.copilot_no_tab_map = true

			vim.keymap.set("i", "gn", function()
				vim.fn["copilot#Next"]()
			end, {
				desc = "Next Copilot suggestion",
			})

			vim.keymap.set("i", "gp", function()
				vim.fn["copilot#Previous"]()
			end, {
				desc = "Previous Copilot suggestion",
			})
		end,
	},
	-- {
	-- 	"supermaven-inc/supermaven-nvim",
	-- 	config = function()
	-- 		require("supermaven-nvim").setup({
	-- 			keymaps = {
	-- 				accept_suggestion = "<C-a>",
	-- 				clear_suggestion = "<C-]>",
	-- 				accept_word = "<C-w>",
	-- 			},
	-- 			ignore_filetypes = { markdown = true },
	-- 		})
	-- 	end,
	-- },
	{
		"NickvanDyke/opencode.nvim",
		dependencies = {
			{ "folke/snacks.nvim", opts = { input = {}, picker = {}, terminal = {} } },
		},
		config = function()
			---@type opencode.Opts
			vim.g.opencode_opts = {
				-- Your configuration, if any — see `lua/opencode/config.lua`, or "goto definition".
			}

			vim.o.autoread = true

			local opencode = require("opencode")

			vim.keymap.set({ "n", "x" }, "<C-a>", function()
				opencode.ask("@this: ", { submit = true, clear = true })
			end, { desc = "Ask opencode" })

			vim.keymap.set({ "n", "x" }, "<C-x>", function()
				opencode.select()
			end, { desc = "Execute opencode action…" })

			vim.keymap.set({ "n", "x" }, "ga", function()
				opencode.prompt("@this")
			end, { desc = "Add to opencode" })

			vim.keymap.set({ "n", "t" }, "<leader>oo", function()
				opencode.toggle()
			end, { desc = "Toggle opencode" })

			vim.keymap.set("n", "goj", function()
				opencode.command("session.half.page.down")
			end, { desc = "opencode session half page down" })

			vim.keymap.set("n", "gok", function()
				opencode.command("session.half.page.up")
			end, { desc = "opencode session half page up" })
		end,
	},
}
