local ts = require("nvim-treesitter")
ts.install {
    "make", "bash", "desktop", "diff",
    "gitcommit", "gitignore", "git_config", "git_rebase",
    "printf",
    "cpp", "c", "asm",
    "latex",
    "python",
    -- "go",
    -- "gdscript", "gdshader",
    "lua", "vim", "vimdoc",
    -- "html", "css", "javascript", "typescript",
}
