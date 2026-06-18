-- Clip diagnostic message
vim.keymap.set("n", "<leader>yd", function()
    local line = vim.api.nvim_win_get_cursor(0)[1]
    local msg = vim.diagnostic.get(0, { lnum = line - 1 })[1]
    if msg then
        vim.fn.setreg("+", msg.message)
        print("[" .. line .. "] Yanked diagnostic message")
    else
        print("[" .. line .. "] No diagnostic found")
    end
end, { desc = "Yank diagnostic to clipboard" })

-- Copy entire buffer to clipboard
vim.api.nvim_create_user_command("Clip", function(opts)
    vim.cmd(":normal ggVG\"+y<CR>``")
    print("Copied buffer to system clipboard")
end, { desc = "Copy entire buffer to clipboard." })
vim.keymap.set("n", "<leader>clip", ":Clip<CR>")

-- Space zipping
vim.api.nvim_create_user_command("UnzipSpaces", function()
    local row = vim.api.nvim_win_get_cursor(0)[1]
    local line = vim.api.nvim_get_current_line()
    if line:match("^%s*$") then return end  -- skip empty or whitespace-only lines
    line = line:gsub("^%s+", "")
    local parts = vim.split(line, "%s+", { trimempty = true })
    vim.api.nvim_buf_set_lines(0, row - 1, row, false, parts)

    print(string.format("%d lines unzipped", #parts))
end, { desc = "Unzip current line by spaces." })
vim.api.nvim_create_user_command("ZipSpaces", function()
  local row = vim.api.nvim_win_get_cursor(0)[1]
  local buf = 0
  local lines = vim.api.nvim_buf_get_lines(buf, row - 1, -1, false)

  local collected = {}
  local stop_idx = 0

  for i, l in ipairs(lines) do
    if l:match("^%s") or l=="" then -- Leading whitespace or empty line
      stop_idx = i - 1
      break
    end
    table.insert(collected, l)
  end

  if #collected == 0 then return end
  if stop_idx == 0 then stop_idx = #lines end

  local joined = table.concat(collected, " ")
  vim.api.nvim_buf_set_lines(buf, row - 1, row - 1 + stop_idx, false, { joined })


  print(string.format("%d lines zipped", #collected))
end, { desc = "Zip lines by spaces until a line with leading whitespace." })

vim.keymap.set("n", "<leader>zso", ":UnzipSpaces<CR>", { desc = "Split current line into words" })
vim.keymap.set("n", "<leader>zsc", ":ZipSpaces<CR>", { desc = "Join consecutive lines" })
