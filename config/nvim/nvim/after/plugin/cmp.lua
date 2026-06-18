local cmp = require('cmp')
local luasnip = require('luasnip')

cmp.setup({
    snippet = { expand = function(args) luasnip.lsp_expand(args.body) end, },
    window = {
        completion = cmp.config.window.bordered(),
        documentation = cmp.config.window.bordered(),
    },
    mapping = cmp.mapping.preset.insert({
        ["<C-Space>"] = cmp.mapping.complete(),
        ["<Tab>"] = cmp.mapping(function(fallback) if cmp.visible() then cmp.select_next_item() else fallback() end end),
        ['<S-TAB>'] = cmp.mapping(function(fallback) if cmp.visible() then cmp.select_prev_item() else fallback() end end),
    }),
    sources = cmp.config.sources({
        { name = "nvim_lsp" },
        { name = "luasnip" },
        { name = "buffer" },
        { name = "path" },
    }),
    completion = {
        autocomplete = {
            cmp.TriggerEvent.TextChanged, -- On type
            cmp.TriggerEvent.InsertEnter, -- On Insert Mode
        },
    },
})

vim.o.completeopt = 'menu,menuone,noselect,preview'

-- menu: show popup
-- menuone: show popup even when there is only one item
-- noinsert: don't modify the buffer at all until I pick something
-- noselect: don’t even highlight anything until I move
-- preview: show documentation in another window

-- Adds buffer words to search completion
cmp.setup.cmdline('/', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = { { name = 'buffer' } }
})

-- Adds vim commands to CLI completion
cmp.setup.cmdline(':', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({ { name = 'cmdline' } }),
    matching = { disallow_symbol_nonprefix_matching = false }
})
