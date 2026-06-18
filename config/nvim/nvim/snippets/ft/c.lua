local ls = require("luasnip")
local s = ls.snippet       -- snippet constructor
local t = ls.text_node     -- plain text node
local i = ls.insert_node   -- insertable placeholder
local f = ls.function_node -- dynamic content node
local c = ls.choice_node   -- choose between options
local fmt = require("luasnip.extras.fmt").fmt
local rep = require("luasnip.extras").rep

ls.add_snippets("c", {
    s("include-guard", fmt([[
    #ifndef {}_H
    #define {}_H
    {}
    #endif]], {
        d(1, function()
            local filename = vim.fn.expand("%:t:r")
            :upper()
            :gsub("[^A-Z0-9]", "_")
            return sn(nil, { i(1, filename) })
        end),
        f(function(args) return args[1][1] end, { 1 }), i(0)
    }) ),
})
