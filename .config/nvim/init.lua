-- ~/.config/nvim/init.lua

-- ============================================================================
-- Leader
-- ============================================================================
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- ============================================================================
-- Options
-- ============================================================================
local opt = vim.opt

-- UI
opt.number = true
opt.relativenumber = true
opt.signcolumn = "yes"
opt.cursorline = true
opt.wrap = false
opt.scrolloff = 8
opt.termguicolors = true
opt.background = "light"
opt.mouse = "a"

-- Editing
opt.expandtab = true
opt.shiftwidth = 2
opt.tabstop = 2
opt.softtabstop = 2
opt.smartindent = true
opt.undofile = true
opt.swapfile = false
opt.updatetime = 250
opt.clipboard = "unnamedplus"

-- Splits
opt.splitright = true
opt.splitbelow = true

-- Search
opt.ignorecase = true
opt.smartcase = true

-- File navigation
opt.path:append("**")
opt.wildignore:append({ "*/.git/*", "*/node_modules/*" })

-- ============================================================================
-- Keymaps
-- ============================================================================
local map = vim.keymap.set

-- General
map("n", "<Esc>", "<cmd>nohlsearch<CR>", { desc = "Clear search highlight" })
map("n", "<leader>w", "<cmd>w<CR>", { desc = "Save" })

-- Files and buffers
map("n", "<leader>f", ":find ", { desc = "Find file" })
map("n", "<leader>b", ":buffer ", { desc = "Switch buffer" })
map("n", "<leader>l", "<cmd>ls<CR>", { desc = "List buffers" })
map("n", "<leader><Tab>", "<C-^>", { desc = "Last buffer" })

-- Splits
map("n", "<C-h>", "<C-w>h", { desc = "Left split" })
map("n", "<C-j>", "<C-w>j", { desc = "Lower split" })
map("n", "<C-k>", "<C-w>k", { desc = "Upper split" })
map("n", "<C-l>", "<C-w>l", { desc = "Right split" })

-- ============================================================================
-- Plugins
-- ============================================================================
vim.pack.add({
  "https://github.com/maxmx03/solarized.nvim",
  "https://github.com/nvim-mini/mini.pairs",
})

-- ============================================================================
-- Plugin setup
-- ============================================================================
require("solarized").setup({
  variant = "winter",
  styles = { comments = { italic = true } },
})
vim.cmd.colorscheme("solarized")

require("mini.pairs").setup()
