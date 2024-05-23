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
local capabilities = require("cmp_nvim_lsp").default_capabilities()
local on_attach = function(client)
  require("completion").on_attach(client)
end

local servers = {
  "html",
  "tsserver",
  "bashls",
  "clangd",
  "rust_analyzer",
  "gopls",
  "pylsp",
  "zls",
  "jdtls",
  "fortls",
  "asm_lsp",
}

for _, server in pairs(servers) do
  local opts = {
    capabilities = capabilities,
    on_attach = on_attach,
  }

  local require_ok, conf_opts = pcall(require, "lsp-settings." .. server)
  if require_ok then
    opts = vim.tbl_deep_extend("force", conf_opts, opts)
  end

  nvim_lsp[server].setup(opts)
end
