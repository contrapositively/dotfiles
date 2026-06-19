local ls = require("luasnip")
local s = ls.snippet       -- snippet constructor
local sn = ls.snippet_node -- snippet_node constructor
local t = ls.text_node     -- plain text node
local i = ls.insert_node   -- insertable placeholder
local f = ls.function_node -- dynamic content node
local c = ls.choice_node   -- choose between options
local d = ls.dynamic_node  -- dynamically generated snippet

ls.add_snippets("tex", {
    s("beg", { -- Begin-End Environment
        t("\\begin{"),
        i(1, "name"),
        t({ "}", "" }),
        i(0),
        t({ "", "\\end{" }),
        f(function(args) return args[1][1] end, { 1 }),
        t("}")
    }),
    s("init", { -- Initialize Document
        t({
            "\\documentclass{article}",
            "\\usepackage{graphicx} % Required for inserting images",
            "\\usepackage{listings, amsmath, amssymb}",
            "\\usepackage[utf8]{inputenc}",
            "\\usepackage[T1]{fontenc}",
            "\\usepackage{amsthm,thmtools,graphicx,etoolbox,fancyhdr}",
            "\\usepackage{listings, xcolor}",
            "\\usepackage[margin=1in]{geometry}",
            "",
            "\\newtheorem{theorem}{Theorem}[section]",
            "\\AtBeginEnvironment{proof}{\\setcounter{equation}{0}}",
            "",
            "\\pagestyle{fancy}",
            ""
        }),
        t("\\fancyhead[L]{"), i(1, "FirstTitle"), t("}"), t({ "", "" }),
        t("\\fancyhead[C]{"), i(2, "James Kim"), t("}"), t({ "", "" }),
        t("\\fancyhead[R]{"), i(3, "SecondTitle"), t("}"), t({ "", "", "" }),
        t("\\title{"),
        f(function(args)
            return args[1][1] .. ": " .. args[2][1]
        end, { 1, 3 }),
        t({ "}", "" }),
        t("\\author{"), f(function(args) return args[1][1] end, { 2 }), t({ "}", "" }),
        t("\\date{"),
        d(4, function()
            return sn(nil, { i(1, os.date("%B %Y")) }) -- editable default (e.g. "October 2025")
        end, {}),
        t({ "}", "" }),
        t({ "", "\\begin{document}" }),
        i(0),
        t({ "", "\\end{document}" })
    }),
    -- s("init_linalg", {
    --     t({
    --         "\\DeclareMathOperator{\\col}{col}",
    --         "\\DeclareMathOperator{\\spn}{span}",
    --         "\\DeclareMathOperator{\\nll}{null}"
    --     })
    -- }),
    s("\\begin", { -- Environment
        t("\\begin{"), i(1, "env"), t("}"), t({ "", "" }),
        t("\\end{"), f(function(args) return args[1][1] end, { 1 }), t("}"),
    }),
    s("braces", { -- Braces
        t("\\{"), i(0), t("\\}")
    }), 
    s("\\frac", { -- Fraction
        t("\\frac{"), i(1, "numer"), t("}{"), i(2,"denom"), t("}"), i(0)
    }),
    s("\\left", { -- Scaled Wrap
        t("\\left"), i(1, "."), t(" "), i(0), t(" \\right"), i(2, ".")
    }),
    s("\\left_parens", { -- Scaled Parens
        t("\\left( "), i(0), t(" \\right)")
    }),
    s("\\left_abs", { -- Scaled Abs
        t("\\left| "), i(0), t(" \\right|")
    }),
    s("\\left_brack", { -- Scaled Abs
        t("\\left[ "), i(0), t(" \\right]")
    }),
    s("\\left_brace", { -- Scaled Abs
        t("\\left\\{ "), i(0), t(" \\right\\}")
    }),
    s("\\sum", { -- Sum
        t("\\sum_{"), i(1, "i"), t("="), i(2, "1"), t("}"), -- init
        t("^{"), i(3, "n"), t("}"), -- end
        t(" {"), i(4, "i"), t("}"), -- body
        i(0)
    }),
    s("\\product", { -- Product
        t("\\prod_{"), i(1, "i"), t("="), i(2, "1"), t("}"), -- init
        t("^{"), i(3, "n"), t("}"), -- end
        t(" {"), i(4, "i"), t("}"), -- body
        i(0)
    }),
    s("\\integral", { -- Integral
        t("\\int_{"), i(1, "a"), t("}"), -- lower
        t("^{"), i(2, "b"), t("}"), -- upper
        t(" {"), i(3, "f(x)"), t("} "), -- body
        t("d{"), i(4, "x"), t("}"), -- variable
        i(0)
    }),
    s("\\ointegral_line", { -- Contour Integral
        t("\\int_{"), i(1, "\\gamma"), t("}"), -- lower
        t(" {"), i(2, "f(t)"), t("} "), -- body
        t("d{"), i(3, "t"), t("}"), -- variable
        i(0)
    }),
    s("\\iintegral_area", { -- Area Integral
        t("\\int_{"), i(1, "D"), t("}"), -- lower
        t(" {"), i(2, "f(x,y)"), t("} "), -- body
        t("d{"), i(3, "x"), t("}"), -- variable
        i(0)
    }),
    s("\\iiintegral_surface", { -- Surface Integral
        t("\\int_{"), i(1, "S"), t("}"), -- lower
        t(" {"), i(2, "f(x,y,z)"), t("} "), -- body
        t("d{"), i(3, "x"), t("}"), -- variable
        i(0)
    }),
    s("\\left_def_int", { -- Expanded Definite Integral
        t("\\left. "), i(1, "F(x)"), t(" \\right|"), -- body
        t("_{"), i(2, "a"), t("}"), -- lower
        t("^{"), i(3, "b"), t("}"), -- upper
        i(0)
    }),
    s("\\text", { -- Text
        t("\\text{"), i(1, "ipsum"), t("}"), -- body
        i(0)
    }),
    s("\\figure", fmt([[
    \begin{{figure}}[{}]
    \centering
    \caption{{{}}}
    \label{{{}}}
    \end{{figure}}
    ]], { i(1, "!ht"), i(2, "Caption"), i(3, "fig:ref_label") })),
    s("\\matrix", { t("\\begin{bmatrix}"), i(0), t({"", "\\end{bmatrix}"}) }),
})
