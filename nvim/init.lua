local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
    { "neovim/nvim-lspconfig" },
    { "hrsh7th/nvim-cmp" },
    { "hrsh7th/cmp-nvim-lsp" },

    { "akinsho/bufferline.nvim", version = "*", dependencies = "nvim-tree/nvim-web-devicons" },

    { "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },

    { "nvim-tree/nvim-tree.lua" },
    { "nvim-tree/nvim-web-devicons" },

    { "nvim-lualine/lualine.nvim" },

    { "catppuccin/nvim", name = "catppuccin" },

    { "nvim-telescope/telescope.nvim", tag = "0.1.6", dependencies = { "nvim-lua/plenary.nvim" } },

    {
        "folke/todo-comments.nvim",
        dependencies = { "nvim-lua/plenary.nvim" },
        opts = {}
    },

    {
        'windwp/nvim-autopairs',
        event = "InsertEnter",
        config = true
    }
})


vim.opt.termguicolors = true
vim.cmd.colorscheme "catppuccin-mocha"

require'nvim-treesitter.configs'.setup {
    highlight = { enable = true },
    indent = { enable = true }
}

-- LSP
local lspconfig = require("lspconfig")
local capabilities = require("cmp_nvim_lsp").default_capabilities()

local telescope = require('telescope.builtin')

require("bufferline").setup{}
vim.keymap.set('n', '<Tab>', ':bnext<CR>')
vim.keymap.set('n', '<S-Tab>', ':bprevious<CR>')
vim.keymap.set('n', '<leader>bd', ':bdelete<CR>')

lspconfig.pyright.setup{ capabilities = capabilities }
lspconfig.clangd.setup{ 
    capabilities = capabilities
}
lspconfig.ts_ls.setup{ capabilities = capabilities }

local cmp = require'cmp'
cmp.setup({
    mapping = cmp.mapping.preset.insert({
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<CR>'] = cmp.mapping.confirm { select = true },
        ['<Tab>'] = cmp.mapping.select_next_item(),
        ['<S-Tab>'] = cmp.mapping.select_prev_item(),
    }),
    sources = cmp.config.sources({
        { name = 'nvim_lsp' },
    }),
})

require('lualine').setup {
    options = {
        theme = 'catppuccin',
        section_separators = '',
        component_separators = ''
    }
}

vim.api.nvim_create_user_command("TodoGrep", function()
  local search_cmd = "vimgrep /\\<TODO\\>/j %"
  vim.cmd(search_cmd)
  vim.cmd("copen")
end, {})


vim.cmd [[
  highlight! Function gui=italic cterm=italic
]]

require('nvim-treesitter.configs').setup {
  highlight = { enable = true },
}

require("nvim-tree").setup()
vim.keymap.set('n', '<C-n>', ':NvimTreeToggle<CR>')

local builtin = require('telescope.builtin')
vim.keymap.set('n', '<C-p>', builtin.find_files, {})
vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})

vim.cmd [[
  syntax match TodoKeyword /\v<(TODO|FIXME|NOTE|BUG)>/
  highlight TodoKeyword guifg=#FF5555 gui=bold,italic
]]


-- General settings
vim.opt.number = true
vim.opt.relativenumber = false
vim.opt.expandtab = true
vim.opt.shiftwidth = 4
vim.opt.tabstop = 4
vim.opt.clipboard = "unnamedplus"

vim.diagnostic.config({
  virtual_text = true,
  signs = true,
  update_in_insert = false,
  severity_sort = true,
})

vim.keymap.set('n', '<C-p>', ':NvimTreeToggle<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<C-k>', ':TodoTelescope<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<C-m>', ':!make<CR>', { noremap = true, silent = true })
vim.keymap.set('n', 'S', telescope.find_files, { noremap = true, silent = true })
