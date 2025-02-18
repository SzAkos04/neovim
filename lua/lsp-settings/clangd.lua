local nvim_lsp = require("lspconfig")
return {
    filetypes = { "c", "cpp" },
    root_dir = nvim_lsp.util.root_pattern("compile_commands.json", "compile_flags.txt", ".git"),
    init_options = {
        clangdFileStatus = true,
        usePlaceholders = true,
        completeUnimported = true,
    },
}
