return {
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
            completion = {
                callSnippet = "Replace",
            },
        },
    },
}
