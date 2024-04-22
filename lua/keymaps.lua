vim.g.mapleader = " "

-- Movement in insert mode
vim.keymap.set("i", "<C-h>", "<Left>")
vim.keymap.set("i", "<C-j>", "<Down>")
vim.keymap.set("i", "<C-k>", "<Up>")
vim.keymap.set("i", "<C-l>", "<Right>")

-- Split navigation
vim.keymap.set("n", "<leader>h", "<C-w>h")
vim.keymap.set("n", "<leader>j", "<C-w>j")
vim.keymap.set("n", "<leader>k", "<C-w>k")
vim.keymap.set("n", "<leader>l", "<C-w>l")
-- Split creation
vim.keymap.set("n", "<C-s>", ":split<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<C-v>wv", ":vsplit<CR>", { noremap = true, silent = true })

-- Move lines up and down
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", { noremap = true, silent = true })
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", { noremap = true, silent = true })

-- Replace word under cursor
vim.keymap.set("n", "<leader>rw", [[:%s/<C-r><C-w>//g<Left><Left>]], { noremap = true, silent = true })

-- inc-rename
-- vim.keymap.set("n", "<leader>rn", function()
-- 	return ":IncRename " .. vim.fn.expand("<cword>")
-- end, { expr = true })

-- rename
vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, {})

-- Buffer navigation
vim.keymap.set("n", "<leader>,", ":bprevious<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<leader>.", ":bnext<CR>", { noremap = true, silent = true })
-- Close buffer
vim.keymap.set("n", "<leader>c", ':lua require("bufdelete").bufdelete(0)<CR>', { noremap = true, silent = true })

-- cmp
-- space space to hover
vim.keymap.set("n", "<leader><Space>", ":lua vim.lsp.buf.hover()<CR>", { noremap = true, silent = true })

-- Telescope
vim.keymap.set("n", "<leader>e", ":Telescope file_browser<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<leader>ff", ":Telescope find_files<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<leader>fw", ":Telescope live_grep<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<leader>fb", ":Telescope buffers<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<leader>fd", ":Telescope diagnostics<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<leader>fc", ":Telescope git_commits<CR>", { noremap = true, silent = true })

-- Terminal
vim.keymap.set("n", "<leader>t", ":ToggleTerm<CR>", { noremap = true, silent = true })
vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>", { noremap = true, silent = true })

vim.keymap.set("n", "<leader>sw", function()
	require("binary-swap").swap_operands()
end)
vim.keymap.set("n", "<leader>sv", function()
	require("binary-swap").swap_operands_with_operator()
end)
