vim.pack.add({
  "https://github.com/maxmx03/solarized.nvim",
  "https://github.com/nvim-mini/mini.pairs",
})

-- Options
local opt = vim.opt
opt.termguicolors = true
opt.background = "light"
opt.signcolumn = "yes"
opt.cursorline = true
opt.wrap = false
opt.scrolloff = 8
opt.expandtab = true
opt.shiftwidth = 2
opt.tabstop = 2
opt.softtabstop = 2
opt.smartindent = true
opt.undofile = true
opt.swapfile = false
opt.updatetime = 250
opt.splitright = true
opt.splitbelow = true

-- Keymaps
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>", { desc = "Clear search highlight" })

-- Auto-close pairs: () [] {} and quotes
local ok_pairs, mini_pairs = pcall(require, "mini.pairs")
if ok_pairs then
  mini_pairs.setup()
end

-- Solarized light
local ok, solarized = pcall(require, "solarized")
if ok then
  solarized.setup({
    variant = "winter",
    styles = { comments = { italic = true } },
  })
  vim.cmd.colorscheme("solarized")
end

-- General
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.mouse = "a"
vim.opt.clipboard = "unnamedplus"
vim.opt.hidden = true

-- Search
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.incsearch = true

-- File navigation
vim.opt.path:append("**")
vim.opt.wildmenu = true
vim.opt.wildignore:append({ "*/.git/*", "*/node_modules/*" })

-- Keymaps
vim.g.mapleader = " "

local map = vim.keymap.set

map("n", "<leader>f", ":find ", { desc = "Find file" })
map("n", "<leader>b", ":buffer ", { desc = "Switch buffer" })
map("n", "<leader>l", "<cmd>ls<CR>", { desc = "List buffers" })

-- Switch between last two files
map("n", "<leader><Tab>", "<C-^>")

-- Navigate splits
map("n", "<C-h>", "<C-w>h")
map("n", "<C-j>", "<C-w>j")
map("n", "<C-k>", "<C-w>k")
map("n", "<C-l>", "<C-w>l")

-- Save
map("n", "<leader>w", "<cmd>w<CR>")

