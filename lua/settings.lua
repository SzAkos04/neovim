vim.o.title = true
vim.o.encoding = "utf-8"
vim.o.scrolloff = 5
vim.o.autoindent = true
vim.o.smartindent = true
vim.o.showmode = false
vim.o.hidden = true
vim.o.number = true
vim.o.relativenumber = true
vim.o.laststatus = 2
vim.o.previewheight = 20
vim.o.regexpengine = 0
vim.o.background = "dark"
vim.o.tabstop = 4
vim.o.shiftwidth = 4
vim.o.softtabstop = 4
vim.o.expandtab = true
vim.o.shiftround = true
vim.o.wrap = false
vim.o.clipboard = "unnamedplus"
vim.o.t_Co = 256
vim.o.mouse = "a"
vim.o.termguicolors = true
vim.o.swapfile = false
vim.o.backup = false
vim.o.undofile = true
vim.o.updatetime = 50
vim.o.hlsearch = false
vim.o.incsearch = true
vim.o.showtabline = 2
vim.o.showcmd = false
vim.o.ruler = false
vim.o.spell = true
-- this is teh default value for this wow this is underlineing the wrong thign
vim.o.spelllang = "en_us"
vim.o.cmdheight = 1
vim.o.shell = "/bin/zsh"
if vim.bo.filetype == "c" or vim.bo.filetype == "cpp" then
	vim.o.cindent = true
end

-- Set relative number in normal mode and no relative number in insert mode
vim.cmd([[
    augroup NumberToggle
        autocmd!
        autocmd InsertEnter * set norelativenumber
        autocmd InsertLeave * set relativenumber
    augroup END
]])

-- Disable auto comment on newline
vim.cmd("autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o")

-- Autoformat on save
vim.api.nvim_create_autocmd("BufWritePre", {
	pattern = "*",
	callback = function()
		require("conform").format()
	end,
})

-- Disable spell check for terminal windows
vim.api.nvim_create_autocmd("TermOpen", {
	pattern = "*",
	callback = function()
		vim.wo.spell = false
	end,
})
