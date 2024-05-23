local nvim_lsp = require("lspconfig")
return {
    filetypes = { "go" },
    root_dir = nvim_lsp.util.root_pattern(".git", "go.mod"),
    init_options = {
        usePlaceholders = true,
        completeUnimported = true,
    },
}
