vim.opt.guicursor="n-v-c-sm:block,i-ci-ve:ver25,r-cr-o:hor20,t:block-blinkon500-blinkoff500-TermCursor"

vim.opt.nu=true
vim.opt.relativenumber=true

vim.opt.tabstop=4
vim.opt.softtabstop=4
vim.opt.shiftwidth=4
vim.opt.expandtab=true

vim.opt.smartindent=true

vim.opt.wrap=false

vim.opt.swapfile=false
vim.opt.backup=false
vim.opt.undodir=os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile=true

vim.opt.hlsearch=false
vim.opt.incsearch=true

vim.opt.termguicolors=true

vim.opt.scrolloff=8
vim.opt.signcolumn="yes"
vim.opt.isfname:append("@-@")

vim.opt.updatetime=50

-- Stops vim from hiding backticks in .md files (code blocks)
vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter" }, {
    pattern={ "*.md", "*.json" },
    callback=function()
        vim.cmd("set conceallevel=0")
    end,
})
vim.api.nvim_create_autocmd({ "BufLeave", "BufWinLeave" }, {
    pattern={ "*.md", "*.json" },
    callback=function()
        vim.cmd("set conceallevel=3")
    end,
})


-- File explorer tree style
vim.g.netrw_liststyle=3
vim.g.netrw_banner=0
