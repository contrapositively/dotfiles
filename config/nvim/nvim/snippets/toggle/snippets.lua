local ls = require("luasnip")
local s = ls.snippet       -- snippet constructor
local t = ls.text_node     -- plain text node
local i = ls.insert_node   -- insertable placeholder
local f = ls.function_node -- dynamic content node
local c = ls.choice_node   -- choose between options
local d = ls.dynamic_node  -- dynamically generated snippet
local fmt = require("luasnip.extras.fmt").fmt
local rep = require("luasnip.extras").rep

return {
    s({ trig="init", name="Snippet File Initialization" }, fmt([[
local ls = require("luasnip")
local s = ls.snippet       -- snippet constructor
local t = ls.text_node     -- plain text node
local i = ls.insert_node   -- insertable placeholder
local f = ls.function_node -- dynamic content node
local c = ls.choice_node   -- choose between options
local fmt = require("luasnip.extras.fmt").fmt
local rep = require("luasnip.extras").rep

return {{
    {}
}}]], { i(0) })),
    s("parens"      ,{ t("t(\""), i(1, "("), t("\"), "), i(0), t(", t(\""), i(2, ")"), t("\")") }),
    s("curly_braces",{ t("t(\""), i(1, "{"), t("\"), "), i(0), t(", t(\""), i(2, "}"), t("\")") }),
    s("brackets"    ,{ t("t(\""), i(1, "["), t("\"), "), i(0), t(", t(\""), i(2, "]"), t("\")") }),
    s("quotes", { t("t(\"\\\""), i(0), t("\\\"\")") }),
    s("splice", { t("\"), "), i(0), t(", t(\"") }),
    s("arg", { t("f(function(args) return args[1][1] end, { "), i(0), t(" })") }),
    s("splice-input", { t("\"), i("), i(0), t("), t(\"") }),
    s("splice-arg", { t("\"), f(function(args) return args[1][1] end, { "), i(0), t(" }), t(\"") }),
}
