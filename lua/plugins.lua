vim.cmd("packadd packer.nvim")
return require("packer").startup(function(use)
	use("wbthomason/packer.nvim")

	-- LSP
	use({
		"neovim/nvim-lspconfig",
		requires = {
			"hrsh7th/nvim-cmp",
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-path",
			"hrsh7th/cmp-cmdline",
			"hrsh7th/cmp-vsnip",
			"hrsh7th/vim-vsnip",
			"onsails/lspkind.nvim",
			"lukas-reineke/cmp-under-comparator",

			"hrsh7th/cmp-calc",

			"windwp/nvim-autopairs",
		},

		config = function()
			local custom_menu_icon = {
				nvim_lsp = "",
				vsnip = "",
				calc = "󰃬",
				-- buffer = "[Buf]",
				-- path = "[Path]",
				-- cmdline = "[CMD]",
				-- git = "[Git]",
			}
			require("nvim-autopairs").setup({})
			local cmp_autopairs = require("nvim-autopairs.completion.cmp")
			require("cmp").event:on("confirm_done", cmp_autopairs.on_confirm_done())
			-- Set up nvim-cmp
			require("cmp").setup({
				snippet = {
					expand = function(args)
						vim.fn["vsnip#anonymous"](args.body)
					end,
				},
				mapping = {
					["<C-p>"] = require("cmp").mapping.select_prev_item(),
					["<C-n>"] = require("cmp").mapping.select_next_item(),
					["<C-b>"] = require("cmp").mapping.scroll_docs(-4),
					["<C-f>"] = require("cmp").mapping.scroll_docs(4),
					["<C-Space>"] = require("cmp").mapping.complete(),
					["<C-e>"] = require("cmp").mapping.close(),
					["<CR>"] = require("cmp").mapping.confirm({
						behavior = require("cmp").ConfirmBehavior.Insert,
						select = true,
					}),
				},
				sources = {
					{ name = "nvim_lsp", blacklist = { "Text" } },
					{ name = "vsnip" },
					{ name = "calc" },
					-- { name = "buffer" },
					{ name = "path" },
					{ name = "git" },
				},
				completion = {
					completeopt = "menu,menuone,noinsert",
				},
				formatting = {
					format = function(entry, vim_item)
						-- Modify the kind icon based on source
						if custom_menu_icon[entry.source.name] then
							vim_item.kind = custom_menu_icon[entry.source.name] .. " " .. vim_item.kind
						else
							-- Use default icon if no custom icon is defined
							vim_item.kind = require("lspkind").presets.default[vim_item.kind] .. " " .. vim_item.kind
						end

						-- Set menu text based on source
						vim_item.menu = ({
							nvim_lsp = "[LSP]",
							vsnip = "[VSnip]",
							calc = "[Calc]",
							buffer = "[Buffer]",
							path = "[Path]",
							git = "[Git]",
						})[entry.source.name]

						return vim_item
					end,
				},
				sorting = {
					comparators = {
						require("cmp").config.compare.offset,
						require("cmp").config.compare.exact,
						require("cmp").config.compare.score,
						require("cmp-under-comparator").under,
						require("cmp").config.compare.kind,
						require("cmp").config.compare.sort_text,
						require("cmp").config.compare.length,
						require("cmp").config.compare.order,
					},
				},
				window = {
					completion = {
						winhighlight = "Normal:Pmenu,FloatBorder:Pmenu,Search:None",
						col_offset = -3,
						side_padding = 0,
					},
				},
				require("cmp").setup.filetype("gitcommit", {
					sources = require("cmp").config.sources({
						{ name = "git" },
					}, {
						{ name = "buffer" },
					}),
				}),
			})
		end,
	})
	use({
		"williamboman/mason.nvim",
		requires = {
			"williamboman/mason-lspconfig.nvim",
			"neovim/nvim-lspconfig",
		},
		config = function()
			require("mason").setup()
			require("mason-lspconfig").setup()
		end,
	})
	-- Notifications
	use({
		"j-hui/fidget.nvim",
		config = function()
			require("fidget").setup()
		end,
	})

	-- UI
	use({
		"folke/todo-comments.nvim",
		requires = { "nvim-lua/plenary.nvim" },
		config = function()
			require("todo-comments").setup({})
		end,
	})
	use({
		"nvim-telescope/telescope.nvim",
		requires = {
			"nvim-tree/nvim-web-devicons",
			"nvim-lua/plenary.nvim",
			"nvim-telescope/telescope-file-browser.nvim",
		},
		config = function()
			require("telescope").setup({})
			require("telescope").load_extension("file_browser")
		end,
	})
	use({
		"tamton-aquib/staline.nvim",
		requires = { "nvim-tree/nvim-web-devicons" },
		config = function()
			require("staline").setup({
				defaults = {
					expand_null_ls = false, -- This expands out all the null-ls sources to be shown
					full_path = vim.o.columns >= 128,
					line_column = "[%l/%L] :%c", -- `:h stl` to see all flags.

					inactive_color = "#303030",
					inactive_bgcolor = "none",
					true_colors = true, -- true lsp colors.
					font_active = "none", -- "bold", "italic", "bold,italic", etc
				},
				mode_colors = {
					n = "#83b28a",
					i = "#9e77bd",
					c = "#cd6169",
					ic = "#cd6169",
					v = "#e5bf79",
					vl = "#e5bf79",
					t = "#d2846d",
				},
				sections = {
					left = { " ", "mode", " ", "branch", " ", "lsp" },
					mid = { "file_name" },
					right = { "lsp_name", " ", "line_column" },
				},
				inactive_sections = {
					left = { "branch" },
					mid = { "file_name" },
					right = { "line_column" },
				},
				special_table = {
					packer = { "Packer", "📦 " }, -- etc
				},
				lsp_symbols = {
					Error = " ",
					Info = " ",
					Warn = " ",
					Hint = "󰌵 ",
				},
			})
			require("stabline").setup({
				-- style = "arrow",
				style = "bar",
				bg = "none",
				fg = "#ffffff",
				exclude_fts = { "Veil", "Packer" },
			})
		end,
	})
	use({
		"xiyaowong/transparent.nvim",
		require("transparent").setup({
			extra_groups = { "Pmenu", "PmenuSel" },
		}),
	})
	use({
		"daschw/leaf.nvim",
		config = function()
			require("leaf").setup({
				underlineStyle = "undercurl",
				commentStyle = "italic",
				functionStyle = "NONE",
				keywordStyle = "italic",
				statementStyle = "bold",
				typeStyle = "NONE",
				variablebuiltinStyle = "italic",
				transparent = vim.g.transparent_enabled,
				colors = {},
				overrides = {
					Normal = { bg = "none" },
					FloatBorder = { bg = "none" },
				},
				theme = "auto", -- default, based on vim.o.background, alternatives: "light", "dark"
				contrast = "high", -- default, alternatives: "medium", "high"
			})
			vim.cmd("colorscheme leaf")
		end,
	})
	use({
		"lukas-reineke/indent-blankline.nvim",
		config = function()
			require("ibl").setup({
				indent = { char = "┋" },
				scope = { char = "┃", enabled = true, show_exact_scope = true },
			})
			local hooks = require("ibl.hooks")
			hooks.register(hooks.type.ACTIVE, function(bufnr)
				return vim.api.nvim_buf_line_count(bufnr) < 5000
			end)
		end,
	})
	use({
		"willothy/veil.nvim",
		requires = {
			"nvim-telescope/telescope.nvim",
			"nvim-lua/plenary.nvim",
			"nvim-telescope/telescope-file-browser.nvim",
		},
		config = function()
			require("veil").setup()
		end,
	})
	use({
		"lewis6991/gitsigns.nvim",
		config = function()
			require("gitsigns").setup({
				signs = {
					add = { text = "┃" },
					change = { text = "┃" },
					delete = { text = "_" },
					topdelete = { text = "‾" },
					changedelete = { text = "~" },
					untracked = { text = "┆" },
				},
				signcolumn = true, -- Toggle with `:Gitsigns toggle_signs`
				numhl = false, -- Toggle with `:Gitsigns toggle_numhl`
				linehl = false, -- Toggle with `:Gitsigns toggle_linehl`
				word_diff = false, -- Toggle with `:Gitsigns toggle_word_diff`
				watch_gitdir = {
					follow_files = true,
				},
				auto_attach = true,
				attach_to_untracked = false,
				current_line_blame = false, -- Toggle with `:Gitsigns toggle_current_line_blame`
				current_line_blame_opts = {
					virt_text = true,
					virt_text_pos = "eol", -- 'eol' | 'overlay' | 'right_align'
					delay = 1000,
					ignore_whitespace = false,
					virt_text_priority = 100,
				},
				current_line_blame_formatter = "<author>, <author_time:%Y-%m-%d> - <summary>",
				sign_priority = 6,
				update_debounce = 100,
				status_formatter = nil, -- Use default
				max_file_length = 40000, -- Disable if file is longer than this (in lines)
				preview_config = {
					-- Options passed to nvim_open_win
					border = "single",
					style = "minimal",
					relative = "cursor",
					row = 0,
					col = 1,
				},
				yadm = {
					enable = false,
				},
			})
		end,
	})

	-- Additional plugins
	use({
		"nvim-treesitter/nvim-treesitter",
		requires = {
			"windwp/nvim-ts-autotag",
			"andymass/vim-matchup",
		},
		config = function()
			require("nvim-treesitter.configs").setup({
				-- A list of parser names, or "all" (the five listed parsers should always be installed)
				ensure_installed = "lua",

				-- Install parsers synchronously (only applied to `ensure_installed`)
				sync_install = false,

				-- Automatically install missing parsers when entering buffer
				-- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
				auto_install = true,

				highlight = { enable = true },
				indent = { enable = false },
				incremental_selection = { enable = false },
			})
			require("nvim-ts-autotag").setup()
			vim.g.matchup_matchparen_offscreen = { method = "popup" }
		end,
	})
	use({
		"akinsho/toggleterm.nvim",
		tag = "*",
		config = function()
			require("toggleterm").setup({
				size = function(term)
					if term.direction == "horizontal" then
						return 15
					elseif term.direction == "vertical" then
						return vim.o.columns * 0.4
					end
				end,
				autochdir = true,
				persist_size = false,
				persist_mode = false,
				direction = "vertical",
				close_on_exit = true,
			})
		end,
	})
	use({ "tpope/vim-fugitive" })
	use({ "tpope/vim-commentary" })
	use({
		"simrat39/rust-tools.nvim",
		config = function()
			local rt = require("rust-tools")

			rt.setup({
				server = {
					on_attach = function(_, bufnr)
						-- Hover actions
						vim.keymap.set("n", "<C-space>", rt.hover_actions.hover_actions, { buffer = bufnr })
						-- Code action groups
						vim.keymap.set("n", "<Leader>a", rt.code_action_group.code_action_group, { buffer = bufnr })
					end,
				},
				executor = "toggleterm",
			})
		end,
	})
	use({
		"p00f/clangd_extensions.nvim",
		config = function()
			require("clangd_extensions").setup()
		end,
	})
	use({
		"stevearc/conform.nvim",
		config = function()
			require("conform").setup({
				formatters = {
					clang_format = {
						inherit = false,
						command = "clang-format",
						-- args = { "-style=file", "-i", "$FILENAME" },
						args = { "-style={BasedOnStyle: llvm, IndentWidth: 4}", "-i", "$FILENAME" },
						stdin = false,
					},
					findent = {
						inherit = false,
						command = "wfindent",
						args = { "-i4", "$FILENAME" },
						stdin = false,
					},
				},
				formatters_by_ft = {
					c = { "clang_format" },
					cpp = { "clang_format" },
					asm = { "asmfmt" },
					go = { "gofmt" },
					javascript = { "prettier" },
					lua = { "stylua" },
					python = { "black" },
					rust = { "rustfmt" },
					fortran = { "findent" },
				},
			})
		end,
	})
	use({
		"chentoast/marks.nvim",
		config = function()
			require("marks").setup()
		end,
	})
	use({ "ThePrimeagen/vim-be-good" })
	use({
		"soulis-1256/eagle.nvim",
		config = function()
			require("eagle").setup()
		end,
	})
	use({ "Wansmer/binary-swap.nvim" })
	use({ "famiu/bufdelete.nvim" })
	use({ "wakatime/vim-wakatime" })
	use({
		"Saecki/crates.nvim",
		config = function()
			require("crates").setup()
		end,
	})
end)
