return {
	{
		"mfussenegger/nvim-dap",
		config = function()
			local dap = require("dap")
			vim.fn.sign_define("DapBreakpoint", {
				text = "🔴",
				texthl = "DapBreakpoint",
				linehl = "DapBreakpoint",
				numhl = "DapBreakpoint",
			})
			vim.keymap.set("n", "<Leader>dc", function()
				dap.continue()
			end)
			vim.keymap.set("n", "<Leader>do", function()
				dap.step_over()
			end)
			vim.keymap.set("n", "<Leader>di", function()
				dap.step_into()
			end)
			vim.keymap.set("n", "<Leader><Leader>do", function()
				dap.step_out()
			end)
			vim.keymap.set("n", "<Leader>db", function()
				dap.toggle_breakpoint()
			end)
			vim.keymap.set("n", "<Leader>dB", function()
				dap.set_breakpoint()
			end)
			vim.keymap.set("n", "<Leader>lp", function()
				dap.set_breakpoint(nil, nil, vim.fn.input("Log point message: "))
			end)
			vim.keymap.set("n", "<Leader>dr", function()
				dap.repl.open()
			end)
			vim.keymap.set("n", "<Leader>dl", function()
				dap.run_last()
			end)

			dap.adapters.node2 = {
				type = "executable",
				command = "node",
				args = { vim.fn.stdpath("data") .. "/mason/packages/node-debug2-adapter/out/src/nodeDebug.js" },
			}

			dap.configurations.typescript = {
				{
					name = "ts-node (current file)",
					type = "node2",
					request = "launch",
					cwd = vim.fn.getcwd(),
					runtimeArgs = { "--loader", "ts-node/esm" },
					runtimeExecutable = "node",
					args = { "${file}" },
					sourceMaps = true,
					skipFiles = { "<node_internals>/**", "node_modules/**" },
					resolveSourceMapLocations = {
						"${workspaceFolder}/**",
						"!**/node_modules/**",
					},
					protocol = "inspector",
					console = "integratedTerminal",
				},
				{
					name = "Debug compiled JS (current file)",
					type = "node2",
					request = "launch",
					program = function()
						-- Get the path to the current TypeScript file
						local ts_file = vim.fn.expand("%:p")
						-- Replace the file extension and directory path as needed for your project
						-- This example assumes TypeScript files in 'src' compile to 'dist'
						local js_file = string.gsub(ts_file, "%.ts$", ".js")
						js_file = string.gsub(js_file, "/src/", "/dist/")
						return js_file
					end,
					cwd = vim.fn.getcwd(),
					sourceMaps = true,
					resolveSourceMapLocations = {
						"${workspaceFolder}/dist/**/*.js",
						"${workspaceFolder}/**/*.js",
					},
					protocol = "inspector",
					console = "integratedTerminal",
					skipFiles = { "<node_internals>/**", "node_modules/**" },
				},
				{
					name = "Attach to process",
					type = "node2",
					request = "attach",
					processId = require("dap.utils").pick_process,
					sourceMaps = true,
					resolveSourceMapLocations = {
						"${workspaceFolder}/dist/**/*.js",
						"${workspaceFolder}/**/*.js",
					},
					skipFiles = { "<node_internals>/**", "node_modules/**" },
				},
			}

			-- JavaScript configuration (shares most settings with TypeScript)
			dap.configurations.javascript = {
				{
					name = "Launch",
					type = "node2",
					request = "launch",
					program = "${file}",
					cwd = vim.fn.getcwd(),
					sourceMaps = true,
					protocol = "inspector",
					console = "integratedTerminal",
				},
				{
					name = "Attach to process",
					type = "node2",
					request = "attach",
					processId = require("dap.utils").pick_process,
				},
			}

			-- Configure Go debugging with Delve
			dap.adapters.delve = {
				type = "server",
				port = "${port}",
				executable = {
					command = "dlv",
					args = { "dap", "-l", "127.0.0.1:${port}" },
				},
			}

			dap.configurations.go = {
				{
					type = "delve",
					name = "Debug",
					request = "launch",
					program = "${file}",
				},
				{
					type = "delve",
					name = "Debug test",
					request = "launch",
					mode = "test",
					program = "${file}",
				},
				{
					type = "delve",
					name = "Debug package",
					request = "launch",
					program = "${fileDirname}",
				},
			}

			-- Configure Lua debugging (for Neovim development)
			dap.adapters.nlua = function(callback, config)
				callback({ type = "server", host = config.host or "127.0.0.1", port = config.port or 8086 })
			end

			dap.configurations.lua = {
				{
					type = "nlua",
					request = "attach",
					name = "Attach to running Neovim instance",
				},
			}
		end,
	},
	{
		"rcarriga/nvim-dap-ui",
		dependencies = {
			"mfussenegger/nvim-dap",
			"nvim-neotest/nvim-nio",
		},
		config = function()
			local dap = require("dap")
			local dapui = require("dapui")

			-- Add explicit configuration for dapui
			dapui.setup({
				icons = { expanded = "▾", collapsed = "▸" },
				mappings = {
					-- Use a table to apply multiple mappings
					expand = { "<CR>", "<2-LeftMouse>" },
					open = "o",
					remove = "d",
					edit = "e",
					repl = "r",
					toggle = "t",
				},
				-- Use a simple layout if you prefer
				layouts = {
					{
						elements = {
							"scopes",
							"breakpoints",
							"stacks",
							"watches",
						},
						size = 40,
						position = "left",
					},
					{
						elements = {
							"repl",
							"console",
						},
						size = 10,
						position = "bottom",
					},
				},
				controls = {
					-- Requires Neovim nightly (or 0.8 when released)
					enabled = true,
					-- Display controls in this element
					element = "repl",
					icons = {
						pause = "⏸️",
						play = "▶️",
						step_into = "⏎",
						step_over = "⏭️",
						step_out = "⏮️",
						step_back = "b",
						run_last = "↻",
						terminate = "⏹️",
					},
				},
				floating = {
					max_height = nil,
					max_width = nil,
					border = "single",
					mappings = {
						close = { "q", "<Esc>" },
					},
				},
			})

			-- Toggle UI with your existing keymap
			vim.keymap.set("n", "<leader>dt", function()
				dapui.toggle()
			end)

			-- Auto-open when debugging starts
			dap.listeners.after.event_initialized["dapui_config"] = function()
				dapui.open()
			end

			-- Auto-close when debugging ends
			dap.listeners.before.event_terminated["dapui_config"] = function()
				dapui.close()
			end

			dap.listeners.before.event_exited["dapui_config"] = function()
				dapui.close()
			end
		end,
	},
	-- Add specialized Go debugging
	{
		"leoluz/nvim-dap-go",
		dependencies = { "mfussenegger/nvim-dap" },
		config = function()
			require("dap-go").setup()
			-- Add Go-specific keymaps
			vim.api.nvim_create_autocmd("FileType", {
				pattern = "go",
				callback = function()
					local opts = { noremap = true, silent = true, buffer = true }
					vim.keymap.set("n", "<leader>dgt", function()
						require("dap-go").debug_test()
					end, opts)
					vim.keymap.set("n", "<leader>dgL", function()
						require("dap-go").debug_last_test()
					end, opts)
				end,
			})
		end,
	},
	-- Add vscode-js-debug adapter support for modern JS/TS debugging
	{
		"mxsdev/nvim-dap-vscode-js",
		dependencies = { "mfussenegger/nvim-dap" },
		config = function()
			require("dap-vscode-js").setup({
				-- Path for the adapter - this will use node-debug2-adapter if not specified
				-- debugger_path = vim.fn.stdpath("data") .. "/mason/packages/js-debug-adapter",
				adapters = { "pwa-node", "pwa-chrome", "node-terminal" },
			})
		end,
	},
	-- Mason integration for easier adapter management
	{
		"jay-babu/mason-nvim-dap.nvim",
		dependencies = {
			"williamboman/mason.nvim",
			"mfussenegger/nvim-dap",
		},
		config = function()
			require("mason-nvim-dap").setup({
				automatic_installation = true,
				ensure_installed = {
					"node-debug2-adapter", -- For JS/TypeScript
					"delve", -- For Go
				},
			})
		end,
	},
	-- Enhance debugging with virtual text
	{
		"theHamsta/nvim-dap-virtual-text",
		dependencies = { "mfussenegger/nvim-dap" },
		opts = {
			enabled = true,
			enabled_commands = true,
			highlight_changed_variables = true,
			highlight_new_as_changed = false,
			show_stop_reason = true,
			commented = false,
			virt_text_pos = "eol",
		},
	},
}
