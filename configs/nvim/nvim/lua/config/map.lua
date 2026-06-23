vim.keymap.set("n", "<leader>pv", vim.cmd.Explore)

-- Move Selected Lines
vim.keymap.set("x", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("x", "K", ":m '<-2<CR>gv=gv")

-- Move lower line while maintining cursor
vim.keymap.set("n", "J", "mzJ`z")

-- Maintain cursor while pgdwn and pdup
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")

-- Maintain cursor while searching
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

-- Paste without overwriting clipboard
vim.keymap.set("v", "<leader>p", "\"_dP")

-- Yank to clipboard
vim.keymap.set("v", "<leader>y", "\"+y")
vim.keymap.set("n", "<leader>Y", "\"+Y")

-- Delete without overwriting clipboard
vim.keymap.set("n", "<leader>d", "\"_d")
vim.keymap.set("v", "<leader>d", "\"_d")

-- Normalize Exit Commands
vim.keymap.set("i", "<C-c>", "<Esc>")

-- Remove "Q"
vim.keymap.set("n", "Q", "<nop>")

-- Find and Replace current word
vim.keymap.set("n", "<leader>ss", ":%s/\\<<C-r><C-w>\\>//gI<Left><Left><Left>")

-- Indent and write current buffer
vim.keymap.set("n", "<leader>id", ":normal gg=G:w<CR>``")
vim.keymap.set("n", "<leader>w", ":w<CR>``")

-- Select entire buffer
vim.keymap.set("n", "<leader>vvV", "ggVG")

-- Close all other windows
vim.keymap.set("n", "<C-w>o", ":only<CR>")


vim.keymap.set("n", "<TAB>", ":tabnext<CR>")
vim.keymap.set("n", "<S-TAB>", ":tabprevious<CR>")
vim.keymap.set("n", "<leader><C-t>", ":tabnew<CR>:Ex<CR>")
