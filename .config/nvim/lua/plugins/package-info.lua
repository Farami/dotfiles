return {
	{
		"vuki656/package-info.nvim",
		ft = "json",
		dependencies = {
			"MunifTanjim/nui.nvim",
		},
		config = function()
			require("package-info").setup()

			local wk = require("which-key")
			wk.add({ { "<leader>n", desc = "+npm" } })

			vim.keymap.set(
				{ "n" },
				"<LEADER>nt",
				require("package-info").toggle,
				{ silent = true, noremap = true, desc = "Toggle dependency versions" }
			)

			vim.keymap.set(
				{ "n" },
				"<LEADER>nu",
				require("package-info").update,
				{ silent = true, noremap = true, desc = "Update dependency" }
			)

			vim.keymap.set(
				{ "n" },
				"<LEADER>nd",
				require("package-info").delete,
				{ silent = true, noremap = true, desc = "Delete dependency" }
			)

			vim.keymap.set(
				{ "n" },
				"<LEADER>ni",
				require("package-info").install,
				{ silent = true, noremap = true, desc = "Install a new dependency" }
			)

			vim.keymap.set(
				{ "n" },
				"<LEADER>np",
				require("package-info").change_version,
				{ silent = true, noremap = true, desc = "Install a different dependency version" }
			)
		end,
	},
	{
		"nvim-lualine/lualine.nvim",
		requires = { "kyazdani42/nvim-web-devicons", opt = true },
		config = function()
			require("lualine").setup({
				sections = {
					lualine_c = {
						{
							"filename",
							path = 1,
						},
						{
							function()
								local package_info = require("package-info")
								return package_info.get_status()
							end,
							cond = function()
								return vim.fn.expand("%:t") == "package.json"
							end,
							color = { fg = "#d19a66", gui = "bold" },
						},
					},
				},
			})
		end,
	},
}
