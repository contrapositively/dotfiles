local ls = require('luasnip')

local M = {}
M.enabled = {}


local snippets_path = vim.fn.stdpath("config") .. "/snippets/"

local function get_all_packs()
    return vim.tbl_map(
        function(f) return vim.fn.fnamemodify(f, ":t:r") end,
        vim.fn.glob(snippets_path .. "toggle/*.lua", true, true)
    )
end

local function load_auto() require("luasnip.loaders.from_lua").lazy_load({ paths = snippets_path .. "auto/" }) end
local function load_ft() require("luasnip.loaders.from_lua").lazy_load({ paths = snippets_path .. "ft/" }) end
local function load_pack(pack)
    local file_path = snippets_path .. "toggle/" .. pack .. ".lua"
    local ok, result = pcall(dofile, file_path)
    if not ok then vim.notify("Failed to load snippet pack: " .. file_path, vim.log.levels.ERROR) return nil end
    return result
end

function M.disable(pack)
    if not M.enabled[pack] then return end
    if ls.snippets and ls.snippets.all then ls.snippets.all[pack] = nil end
    M.enabled[pack] = nil
end
function M.enable(pack)
    if M.enabled[pack] then return end
    local ok, snips = pcall(load_pack, pack)
    if not ok then vim.notify("Err snippet pack: " .. pack, vim.log.levels.ERROR) return end
    ls.add_snippets("all", snips, { key = pack })
    M.enabled[pack] = true
end
function M.toggle(pack) if M.enabled[pack] then M.disable(pack) else M.enable(pack) end end

function M.status()
    local packs = vim.tbl_keys(M.enabled)
    table.sort(packs)
    if #packs == 0 then vim.notify("No active snippets") return end
    vim.notify("Active snippets: " .. table.concat(packs, ", "))
end

function M.reload()
    local enabled_packs = vim.tbl_keys(M.enabled)
    ls.cleanup()
    M.enabled = {}
    for name, _ in pairs(package.loaded) do if name:match("^snippets%.") then package.loaded[name] = nil end end
    load_auto()
    load_ft()
    for _, pack in ipairs(enabled_packs) do M.enable(pack) end
    vim.notify("Snippets reloaded from " .. snippets_path)
end


local function for_each_pack(args, fn, status)
    local packs = {}
    if args == "*" or args == "" then packs = get_all_packs()
    else for pack in args:gmatch("%S+") do table.insert(packs, pack) end
    end
    for _, pack in ipairs(packs) do fn(pack) end
    if #packs > 0 and status then vim.notify(status .. ": " .. table.concat(packs, ", ")) end
end
vim.api.nvim_create_user_command("SnipEnable", function(opts) for_each_pack(opts.args, M.enable, "Enabled snippets") end, { nargs = "*", complete = get_all_packs, })
vim.api.nvim_create_user_command("SnipDisable", function(opts) for_each_pack(opts.args, M.disable, "Disabled snippets") end, { nargs = "*", complete = get_all_packs, })
vim.api.nvim_create_user_command("SnipToggle", function(opts) for_each_pack(opts.args, M.toggle, "Toggled snippets") end, { nargs = "*", complete = get_all_packs, })
vim.api.nvim_create_user_command("SnipStatus", function() M.status() end, {})
vim.api.nvim_create_user_command("SnipReload", function() M.reload() end, {})


vim.keymap.set({ "n", "i", "s" }, "<C-k>", function() ls.expand_or_jump() end, { silent = true })
vim.keymap.set({ "n", "i", "s" }, "<C-j>", function() ls.jump(-1) end, { silent = true })
vim.keymap.set("i", "<C-l>", function() if ls.choice_active() then ls.change_choice(1) end end, { silent = true })

load_auto()
load_ft()

return M
