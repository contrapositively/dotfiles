local capabilities = require("cmp_nvim_lsp").default_capabilities()

-- Common config applied to all servers
vim.lsp.config("*", {
    on_attach = function(client, bufnr)
        vim.api.nvim_create_autocmd("BufWritePre", {
            buffer = bufnr,
            callback = function() vim.lsp.buf.format() end,
        })

        local opts = { buffer = bufnr, desc = "LSP" }
        -- vim.keymap.set("n", "<leader>hs", ":CclsSwitchSourceHeader<CR>", { desc = "Toggle source/header files", buffer = bufnr })
        vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
        vim.keymap.set("n", "gtd", vim.lsp.buf.type_definition, opts)
        vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
        vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
        vim.keymap.set("n", "<leader>vws", vim.lsp.buf.workspace_symbol, opts)
        vim.keymap.set("n", "<leader>vd", vim.diagnostic.open_float, opts)
        vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts)
        vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)
        vim.keymap.set("n", "<leader>vca", vim.lsp.buf.code_action, opts)
        vim.keymap.set("n", "<leader>vrr", vim.lsp.buf.references, opts)
        vim.keymap.set("n", "<leader>vrn", vim.lsp.buf.rename, opts)
        vim.keymap.set("i", "<C-h>", vim.lsp.buf.signature_help, opts)
    end,

    capabilities = capabilities,

    settings = {
        ["*"] = {
            -- formatOnSave = true,
            diagnostics = {
                enable = true,
                underline = true,
                update_in_insert = false,
                severity_sort = true,
                float = {
                    focusable = true,
                    style = "minimal",
                    border = "rounded",
                    source = "always",
                    header = "",
                    prefix = "",
                },
            },
        },
    },
})

-- Per-server overrides
vim.lsp.config("lua_ls", {
    settings = {
        Lua = {
            diagnostics = { globals = { "vim" } },
            workspace = {
                library = vim.api.nvim_get_runtime_file("", true),
                checkThirdParty = false,
            },
            telemetry = { enable = false },
        },
    },
})
vim.lsp.config("pyright", {})
vim.lsp.config("ccls", { filetypes = { "cpp" }, })
vim.lsp.config("texlab", {})
vim.lsp.config("gdscript", {
    cmd = vim.lsp.rpc.connect("127.0.0.1", tonumber(os.getenv("GDScript_Port") or "6005")),
    filetypes = { "gd", "gdscript", "gdscript3" },
    root_markers = { "project.godot", ".git" },
})
vim.lsp.config("clangd", {
    filetypes = { "c" }
})

-- Enable all servers
vim.lsp.enable({
    "lua_ls", -- Lua
    "pyright", -- Python
    "ccls", -- C++
    "texlab", -- LaTeX
    "go",
    "gdscript", -- GoDot Engine
    "clangd", -- C
})
