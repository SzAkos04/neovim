-- Define signs (Left to the line numbers)
vim.fn.sign_define("DiagnosticSignError", { text = "", texthl = "DiagnosticSignError", linehl = "", numhl = "" })
vim.fn.sign_define("DiagnosticSignWarn", { text = "", texthl = "DiagnosticSignWarn", linehl = "", numhl = "" })
vim.fn.sign_define("DiagnosticSignInfo", { text = "", texthl = "DiagnosticSignInfo", linehl = "", numhl = "" })
vim.fn.sign_define("DiagnosticSignHint", { text = "󰌵", texthl = "DiagnosticSignHint", linehl = "", numhl = "" })

-- Configure Neovim LSP to show errors underlined
vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
	underline = true,
	virtual_text = true,
	signs = true,
	update_in_insert = true,
	severity_sort = true,
})

-- Set up lspconfig.
local nvim_lsp = require("lspconfig")

local on_attach = function(client)
	require("completion").on_attach(client)
end

-- C Language Server (clangd) custom setup
nvim_lsp.clangd.setup({
	-- cmd = {'clangd', '--background-index', '--suggest-missing-includes'},
	filetypes = { "c", "cpp" },
	root_dir = nvim_lsp.util.root_pattern("compile_commands.json", "compile_flags.txt", ".git"),
	init_options = {
		clangdFileStatus = true,
		usePlaceholders = true,
		completeUnimported = true,
	},
})

-- Go Language Server (gopls) custom setup
nvim_lsp.gopls.setup({
	-- cmd = {'gopls', 'serve'},
	filetypes = { "go" },
	root_dir = nvim_lsp.util.root_pattern(".git", "go.mod"),
	init_options = {
		usePlaceholders = true,
		completeUnimported = true,
	},
})

-- Python Language Server (pylsp) custom setup
nvim_lsp.pylsp.setup({})

nvim_lsp.lua_ls.setup({
	settings = {
		Lua = {
			diagnostics = {
				globals = { "vim", "use" },
			},
			workspace = {
				library = {
					[vim.fn.expand("$VIMRUNTIME/lua")] = true,
					[vim.fn.expand("$VIMRUNTIME/lua/vim/nvim_lsp")] = true,
				},
			},
		},
	},
})

-- Rust Language Server (rust-analyzer) custom setup
nvim_lsp.rust_analyzer.setup({
	on_attach = on_attach,
	settings = {
		["rust-analyzer"] = {
			imports = {
				granularity = {
					group = "module",
				},
				prefix = "self",
			},
			cargo = {
				buildScripts = {
					enable = true,
				},
			},
			procMacro = {
				enable = true,
			},
			checkOnSave = {
				allTargets = false,
				command = "clippy",
			},
		},
	},
})

-- Zig Language Server (zls) custom setup
nvim_lsp.zls.setup({
	on_attach = on_attach,
})

-- TypeScript Language Server (tsserver) custom setup
nvim_lsp.tsserver.setup({
	on_attach = on_attach,
})

-- Java Language Server (jdtls) custom setup
nvim_lsp.jdtls.setup({
	on_attach = on_attach,
})

-- Bash Language Server (bashls) custom setup
nvim_lsp.bashls.setup({
	on_attach = on_attach,
})

-- Fortran Language Server (fortls) custom setup
nvim_lsp.fortls.setup({
	root_dir = nvim_lsp.util.root_pattern(".git", "Makefile"),
})
