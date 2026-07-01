return {
    'hedyhli/outline.nvim',
    lazy = true,
    cmd = { "Outline", "OutlineOpen" },
    keys = {
        { "<leader>o", "<cmd>Outline<CR>", desc = "Toggle outline" },
    },
    opts = {
        show_numbers = false, -- speeds up rendering
        show_relative_numbers = false,
        symbols = {
            icons = {
                File          = { icon = "[File]", hl = "Identifier" },
                Module        = { icon = "[Mod]", hl = "Include" },
                Namespace     = { icon = "[Names]", hl = "Include" },
                Package       = { icon = "[Pack]", hl = "Include" },
                Class         = { icon = "[Class]", hl = "Type" },
                Method        = { icon = "[Meth]", hl = "Function" },
                Property      = { icon = "[prop]", hl = "Identifier" },
                Field         = { icon = "[field]", hl = "Identifier" },
                Constructor   = { icon = "[Constr]", hl = "Special" },
                Enum          = { icon = "[Enum]", hl = "Type" },
                Interface     = { icon = "[Inter]", hl = "Type" },
                Function      = { icon = "[Func]", hl = "Function" },
                Variable      = { icon = "[var]", hl = "Constant" },
                Constant      = { icon = "[const]", hl = "Constant" },
                String        = { icon = "[str]", hl = "String" },
                Number        = { icon = "[#]", hl = "Number" },
                Boolean       = { icon = "[bool]", hl = "Boolean" },
                Array         = { icon = "[Arr]", hl = "Constant" },
                Object        = { icon = "[Obj]", hl = "Type" },
                Key           = { icon = "[Key]", hl = "Type" },
                Null          = { icon = "[NULL]", hl = "Type" },
                EnumMember    = { icon = "[enm]", hl = "Identifier" },
                Struct        = { icon = "[Struc]", hl = "Structure" },
                Event         = { icon = "[Evnt]", hl = "Type" },
                Operator      = { icon = "[op]", hl = "Identifier" },
                TypeParameter = { icon = "[typeparam]", hl = "Identifier" },
                Component     = { icon = "[Compnt]", hl = "Function" },
                Fragment      = { icon = "[frag]", hl = "Constant" },
                -- ccls
                TypeAlias     = { icon = "[typedef]", hl = "Type" },
                Parameter     = { icon = "[param]", hl = "Identifier" },
                StaticMethod  = { icon = "[statMeth]", hl = "Function" },
                Macro         = { icon = "[MACRO]", hl = "Function" },
            }
        },
        symbol_folding = {
            markers = { '>', 'v' }
        },
        providers = {
          priority = { 'lsp', 'coc', 'markdown', 'norg', 'treesitter' },
        },
    },
    dependencies = {
      'epheien/outline-treesitter-provider.nvim'
    }
}
