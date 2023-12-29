call plug#begin()

Plug 'neovim/nvim-lspconfig'
Plug 'tamago324/nlsp-settings.nvim'
Plug 'williamboman/nvim-lsp-installer'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-cmdline'
Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/cmp-vsnip'
Plug 'hrsh7th/vim-vsnip'
Plug 'hrsh7th/vim-vsnip-integ'

Plug 'rcarriga/nvim-notify'

Plug 'folke/noice.nvim'
Plug 'MunifTanjim/nui.nvim'

Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim', { 'tag': '0.1.5' }
Plug 'nvim-telescope/telescope-file-browser.nvim'

Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}

Plug 'numirias/semshi', { 'do': ':UpdateRemotePlugins' }

Plug 'github/copilot.vim'

Plug 'tpope/vim-fugitive'

Plug 'nvim-lualine/lualine.nvim'

Plug 'nvim-tree/nvim-web-devicons'

Plug 'jiangmiao/auto-pairs'

Plug 'andweeb/presence.nvim'

Plug 'rust-lang-nursery/rustfmt'

Plug 'morhetz/gruvbox'

Plug 'daschw/leaf.nvim'

Plug 'lukas-reineke/indent-blankline.nvim'

call plug#end()

set title
set encoding=utf-8
set scrolloff=5
set autoindent
set smartindent
set noshowmode
set hidden
set number
set relativenumber
set laststatus=2
set previewheight=20
set regexpengine=0
set background=dark
set tabstop=2
set shiftwidth=2
set softtabstop=2
set expandtab
set shiftround
set nowrap
set clipboard=unnamedplus

" set the title of the window to the name of the file
augroup TitleUpdate
  autocmd!
  autocmd BufEnter * let &titlestring = expand("%:t") . " - Neovim"
augroup END

autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o

autocmd InsertEnter * :set norelativenumber
autocmd InsertLeave * :set relativenumber

if has("gui_running")
  set t_Co=256
  set guioptions-=T " no toolbar
  set guioptions-=m " no menus
  set guioptions-=r " no scrollbar on the right
  set guioptions-=R " no scrollbar on the right
  set guioptions-=l " no scrollbar on the left
  set guioptions-=b " no scrollbar on the bottom
  set guioptions=aiA
  set guifont="CaskaydiaCove Nerd Font"
endif

if has("mouse")
  set mouse=a
endif

noremap <F4> :set hlsearch! hlsearch?<CR>
map ; <cmd>Telescope find_files<CR>
map <C-t> :terminal<CR>

" map F5 to run rust
autocmd FileType rust nnoremap <F5> :w<CR>:!cargo run<CR>

" map F5 to run python
autocmd FileType py * :semshi enable

" Discord Rich presence
let g:presence_main_image = 'neovim'
let g:presence_show_details = v:true
let g:presence_show_elapsed = v:true
let g:presence_show_buttons = v:true
let g:presence_auto_update = v:true
let g:presence_neovim_image_text = 'Neovim'
let g:presence_enable_line_number = v:true
let g:presence_enable_line_column = v:true
let g:presence_enable_filename = v:true
let g:presence_enable_coc = v:true
let g:presence_enable_ts = v:true
let g:presence_enable_semshi = v:true
let g:presence_enable_git = v:true
let g:presence_enable_rocket = v:true
let g:presence_enable_rust_analyzer = v:true
let g:presence_enable_vimls = v:true

lua << EOF

-- Leaf setup
require("leaf").setup({
    underlineStyle = "undercurl",
    commentStyle = "italic",
    functionStyle = "NONE",
    keywordStyle = "italic",
    statementStyle = "bold",
    typeStyle = "NONE",
    variablebuiltinStyle = "italic",
    transparent = false,
    colors = {},
    overrides = {},
    theme = "auto", -- default, based on vim.o.background, alternatives: "light", "dark"
    contrast = "low", -- default, alternatives: "medium", "high"
})

-- setup must be called before loading
vim.cmd("colorscheme leaf")

vim.api.nvim_set_hl(0, "Normal", {guibg=NONE, ctermbg=NONE})

-- setup indent indent-blankline
require("ibl").setup()

-- Noice setup
require("noice").setup({
  lsp = {
    -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
    override = {
      ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
      ["vim.lsp.util.stylize_markdown"] = true,
      ["cmp.entry.get_documentation"] = true,
    },
  },
  -- you can enable a preset for easier configuration
  presets = {
    bottom_search = true, -- use a classic bottom cmdline for search
    command_palette = true, -- position the cmdline and popupmenu together
    long_message_to_split = true, -- long messages will be sent to a split
    inc_rename = false, -- enables an input dialog for inc-rename.nvim
    lsp_doc_border = false, -- add a border to hover docs and signature help
  },
})

-- Set up vim-notify
require('notify').setup({
  stages = 'fade_in_slide_out',
  timeout = 5000,
  background_colour = '#1e222a',
  icons = {
    ERROR = '',
    WARN = '',
    INFO = '',
    DEBUG = '',
    TRACE = '✎',
  },
})

-- Set up telescope
-- You don't need to set any of these options.
-- IMPORTANT!: this is only a showcase of how you can set default options!
require("telescope").setup {
  extensions = {
    file_browser = {
      theme = "ivy",
      -- disables netrw and use telescope-file-browser in its place
      hijack_netrw = true,
      mappings = {
        ["i"] = {
          -- your custom insert mode mappings
        },
        ["n"] = {
          -- your custom normal mode mappings
        },
      },
    },
  },
}
-- To get telescope-file-browser loaded and working with telescope,
-- you need to call load_extension, somewhere after setup function:
require("telescope").load_extension "file_browser"

-- Lualine setup
require('lualine').setup{
  options = {
    theme = 'leaf',
    icons_enabled = true,
    section_separators = '', component_separators = '', -- no separators
  },
  sections = {
    lualine_a = {'mode'},
    lualine_b = {'branch', 'diff', 'diagnostics'},
    lualine_c = {
      'filename',
      function()
        return vim.fn['nvim_treesitter#statusline'](180)
      end},
    lualine_x = {'encoding', 'fileformat', 'filetype'},
    lualine_y = {'progress'},
    lualine_z = {'location'}
  }
}

-- Set up nvim-cmp
local cmp = require('cmp')

cmp.setup({
  snippet = {
    expand = function(args)
      vim.fn["vsnip#anonymous"](args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.abort(),
    ['<CR>'] = cmp.mapping.confirm({ select = true }),
  }),
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    { name = 'vsnip' },
  }, 
  {
    { name = 'buffer' },
  })
})

-- Set configuration for specific filetype.
cmp.setup.filetype('gitcommit', {
  sources = cmp.config.sources({
    { name = 'git' }, -- You can specify the `git` source if [you were installed it](https://github.com/petertriho/cmp-git).
  }, {
    { name = 'buffer' },
  })
})

-- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline({ '/', '?' }, {
  mapping = cmp.mapping.preset.cmdline(),
  sources = {
    { name = 'buffer' }
  }
})

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(':', {
  mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources({
    { name = 'path' }
  }, {
    { name = 'cmdline' }
  })
})

-- Set up lspconfig.
local capabilities = require('cmp_nvim_lsp').default_capabilities(vim.lsp.protocol.make_client_capabilities())

local nvim_lsp = require('lspconfig')

local on_attach = function(client)
    require'completion'.on_attach(client)
end

-- C Language Server (clangd) custom setup
nvim_lsp.clangd.setup{
  cmd = {'clangd', '--background-index', '--suggest-missing-includes'},
  filetypes = {'c', 'cpp'},
  root_dir = nvim_lsp.util.root_pattern('compile_commands.json', 'compile_flags.txt', '.git'),
  init_options = {
    clangdFileStatus = true,
    usePlaceholders = true,
    completeUnimported = true
  },
}

-- Go Language Server (gopls) custom setup
nvim_lsp.gopls.setup{
  cmd = {'gopls', 'serve'},
  filetypes = {'go'},
  root_dir = nvim_lsp.util.root_pattern('.git', 'go.mod'),
  init_options = {
    usePlaceholders = true,
    completeUnimported = true
  },
}

-- Python Language Server (pylsp) custom setup
nvim_lsp.pylsp.setup{}

-- Rust Language Server (rust-analyzer) custom setup
nvim_lsp.rust_analyzer.setup({
    on_attach=on_attach,
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
                enable = true
            },
        }
    }
})

-- Vim Language Server (vimls) custom setup
nvim_lsp.vimls.setup{
    on_attach=on_attach,
    settings = {
        vim = {
            diagnostics = {
                enable = true,
            },
        },
    },
}

EOF
