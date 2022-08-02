call plug#begin()
Plug 'tpope/vim-sensible'
Plug 'neovim/nvim-lspconfig'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-cmdline'
Plug 'hrsh7th/nvim-cmp'

" For vsnip users.
Plug 'hrsh7th/cmp-vsnip'
Plug 'hrsh7th/vim-vsnip'

" For luasnip users.
" Plug 'L3MON4D3/LuaSnip'
" Plug 'saadparwaiz1/cmp_luasnip'

" For ultisnips users.
" Plug 'SirVer/ultisnips'
" Plug 'quangnguyen30192/cmp-nvim-ultisnips'

" For snippy users.
" Plug 'dcampos/nvim-snippy'
" Plug 'dcampos/cmp-snippy'

" solarized
Plug 'lifepillar/vim-solarized8'

" lualine
Plug 'nvim-lualine/lualine.nvim'

" fzf
" Plug 'junegunn/fzf'
" Plug 'junegunn/fzf.vim'

" telescope
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'

" telescope plugin terraform-doc
Plug 'ANGkeith/telescope-terraform-doc.nvim'

" editorconfig
Plug 'editorconfig/editorconfig-vim'

" null-ls
Plug 'jose-elias-alvarez/null-ls.nvim'

call plug#end()

" swith between light and dark theme
"set background=light
set background=dark
set completeopt=menu,menuone,noselect

" colors
set termguicolors
let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"

" silent! is needed because the theme is not available at the first startup
" and for the error to be acknowledged we would need a keyboard input
" https://stackoverflow.com/questions/54606581/ignore-all-errors-in-vimrc-at-vim-startup
silent! colorscheme solarized8

" swith between light and dark theme
set background=light
"set background=dark

" Terraform
autocmd BufNewFile,BufRead *.tf set ft=terraform syntax=terraform
autocmd BufNewFile,BufRead *.tfvars set ft=terraform syntax=terraform
autocmd BufNewFile,BufRead *.hcl set ft=terraform syntax=terraform
autocmd BufWritePre *.tfvars lua vim.lsp.buf.formatting_sync()
autocmd BufWritePre *.tf lua vim.lsp.buf.formatting_sync()

" Find files using Telescope command-line sugar.
nnoremap <leader>ff <cmd>Telescope find_files<cr>
nnoremap <leader>fg <cmd>Telescope live_grep<cr>
nnoremap <leader>fb <cmd>Telescope buffers<cr>
nnoremap <leader>fh <cmd>Telescope help_tags<cr>

" Telescope terraform-doc
nnoremap <space>ott :Telescope terraform_doc<cr>
nnoremap <space>otm :Telescope terraform_doc modules<cr>
nnoremap <space>ota :Telescope terraform_doc full_name=hashicorp/aws<cr>
nnoremap <space>otg :Telescope terraform_doc full_name=hashicorp/google<cr>
nnoremap <space>otk :Telescope terraform_doc full_name=hashicorp/kubernetes<cr>

lua <<EOF
  -- Setup nvim-cmp.
  local cmp = require'cmp'

  cmp.setup({
    snippet = {
      -- REQUIRED - you must specify a snippet engine
      expand = function(args)
        vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
        -- require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
        -- require('snippy').expand_snippet(args.body) -- For `snippy` users.
        -- vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
      end,
    },
    window = {
      -- completion = cmp.config.window.bordered(),
      -- documentation = cmp.config.window.bordered(),
    },
    mapping = cmp.mapping.preset.insert({
      ['<C-b>'] = cmp.mapping.scroll_docs(-4),
      ['<C-f>'] = cmp.mapping.scroll_docs(4),
      ['<C-Space>'] = cmp.mapping.complete(),
      ['<C-e>'] = cmp.mapping.abort(),
      ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
    }),
    sources = cmp.config.sources({
      { name = 'nvim_lsp' },
      { name = 'vsnip' }, -- For vsnip users.
      -- { name = 'luasnip' }, -- For luasnip users.
      -- { name = 'ultisnips' }, -- For ultisnips users.
      -- { name = 'snippy' }, -- For snippy users.
    }, {
      { name = 'buffer' },
    })
  })

  -- Set configuration for specific filetype.
  cmp.setup.filetype('gitcommit', {
    sources = cmp.config.sources({
      { name = 'cmp_git' }, -- You can specify the `cmp_git` source if you were installed it.
    }, {
      { name = 'buffer' },
    })
  })

  -- Use buffer source for `/` (if you enabled `native_menu`, this won't work anymore).
  cmp.setup.cmdline('/', {
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

  -- Setup lspconfig.
  local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())
  -- Replace <YOUR_LSP_SERVER> with each lsp server you've enabled.
  require('lspconfig')['terraformls'].setup {
    capabilities = capabilities
  }
  require('lspconfig')['bashls'].setup {
    capabilities = capabilities
  }
  require('lspconfig')['yamlls'].setup {
    capabilities = capabilities
  }

  -- lualine
  require('lualine').setup()

  -- null-ls
  --[[
  local augroup = vim.api.nvim_create_augroup("LspFormatting", {})
  require("null-ls").setup({
    sources = {},
    on_attach = function(client, bufnr)
        if client.supports_method("textDocument/formatting") then
            vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
            vim.api.nvim_create_autocmd("BufWritePre", {
                group = augroup,
                buffer = bufnr,
                callback = function()
                    -- on 0.8, you should use vim.lsp.buf.format({ bufnr = bufnr }) instead
                    vim.lsp.buf.formatting_sync()
                end,
            })
        end
    end,
  })
  --]]
  
  -- telescope
  require("telescope").setup({
  extensions = {
    terraform_doc = {
      url_open_command = "xdg-open",
    }
  }
  })
  require("telescope").load_extension("terraform_doc")
EOF
