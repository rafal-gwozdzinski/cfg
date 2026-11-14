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
-- Plugins
-- ============================================================================
-- Build native plugins after install/update
vim.api.nvim_create_autocmd("PackChanged", {
  callback = function(ev)
    if ev.data.spec.name == "telescope-fzf-native.nvim" and ev.data.kind ~= "delete" then
      vim.system({ "make" }, { cwd = ev.data.path }):wait()
    end
  end,
})

vim.pack.add({
  "https://github.com/maxmx03/solarized.nvim",
  "https://github.com/nvim-mini/mini.pairs",
  "https://github.com/nvim-mini/mini.surround",
  "https://github.com/nvim-lua/plenary.nvim",
  "https://github.com/nvim-telescope/telescope-fzf-native.nvim",
  "https://github.com/nvim-telescope/telescope.nvim",
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
require("mini.surround").setup()

require("telescope").setup({
  extensions = {
    fzf = {
      fuzzy = true,
      override_generic_sorter = true,
      override_file_sorter = true,
      case_mode = "smart_case",
    },
  },
})
require("telescope").load_extension("fzf")

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
map("n", "<leader><Tab>", "<C-^>", { desc = "Last buffer" })

-- Splits
map("n", "<C-h>", "<C-w>h", { desc = "Left split" })
map("n", "<C-j>", "<C-w>j", { desc = "Lower split" })
map("n", "<C-k>", "<C-w>k", { desc = "Upper split" })
map("n", "<C-l>", "<C-w>l", { desc = "Right split" })

-- Terminal
map('t', '<Esc>', [[<C-\><C-n>]])

-- Telescope

local builtin = require("telescope.builtin")
map("n", "<C-p>", builtin.find_files, { desc = "Find files" })
map("n", "<leader>fh", function()
  builtin.find_files({ hidden = true })
end, { desc = "Find files (hidden)" })
map("n", "<leader>fg", builtin.live_grep, { desc = "Live grep" })
map("n", "<leader>l", builtin.buffers, { desc = "Buffers" })

-- Diagnostics
-- ]d / [d (all diagnostics) are built into Neovim; these are errors only.
map("n", "]e", function()
  vim.diagnostic.jump({ count = vim.v.count1, severity = vim.diagnostic.severity.ERROR })
end, { desc = "Next error" })
map("n", "[e", function()
  vim.diagnostic.jump({ count = -vim.v.count1, severity = vim.diagnostic.severity.ERROR })
end, { desc = "Previous error" })

-- ============================================================================
-- LSP (Go)
-- ============================================================================
-- Built-in LSP client, no plugin needed. Install the server with:
--   go install golang.org/x/tools/gopls@latest
vim.lsp.config("gopls", {
  cmd = { "gopls" },
  filetypes = { "go", "gomod", "gowork", "gotmpl" },
  root_markers = { "go.work", "go.mod", ".git" },
})
vim.lsp.enable("gopls")

-- Show the completion menu without preselecting; <C-y> confirms an item.
vim.opt.completeopt = { "menuone", "noselect" }

vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(ev)
    local function lsp_map(lhs, rhs, desc)
      vim.keymap.set("n", lhs, rhs, { buffer = ev.buf, desc = desc })
    end

    lsp_map("gd", vim.lsp.buf.definition, "Go to definition")
    lsp_map("gD", vim.lsp.buf.declaration, "Go to declaration")
    lsp_map("gr", vim.lsp.buf.references, "References")
    lsp_map("K", vim.lsp.buf.hover, "Hover docs")
    lsp_map("<leader>rn", vim.lsp.buf.rename, "Rename symbol")
    lsp_map("<leader>ca", vim.lsp.buf.code_action, "Code action")
    lsp_map("<leader>d", vim.diagnostic.open_float, "Line diagnostics")
    lsp_map("<leader>fm", function()
      vim.lsp.buf.format({ async = true })
    end, "Format buffer")

    -- Built-in LSP completion (no nvim-cmp needed). Manual trigger only:
    -- <C-Space> opens the menu; <C-n>/<C-p> move, <C-y> accepts.
    vim.lsp.completion.enable(true, ev.data.client_id, ev.buf, { autotrigger = false })
    vim.keymap.set("i", "<C-Space>", vim.lsp.completion.get,
      { buffer = ev.buf, desc = "Complete (LSP)" })

    -- <CR> accepts the highlighted item instead of accepting + newline.
    -- Without a highlighted item it delegates to mini.pairs, which splits an
    -- empty pair onto two lines (e.g. `func f() {|}` -> brace on its own line).
    vim.keymap.set("i", "<CR>", function()
      if vim.fn.pumvisible() == 1 and vim.fn.complete_info({ "selected" }).selected ~= -1 then
        return vim.keycode("<C-y>")
      end
      return require("mini.pairs").cr()
    end, { buffer = ev.buf, expr = true, desc = "Accept completion or split pair" })
  end,
})

