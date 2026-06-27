return {
    "NeogitOrg/neogit",
    lazy = true,
    dependencies = {
        "sindrets/diffview.nvim",
        "akinsho/git-conflict.nvim"
    },
    cmd = "Neogit",
    keys = {
        { "<leader>gg", "<cmd>Neogit cwd=%:p:h<cr>", desc = "Show Neogit UI" }
    }
}
