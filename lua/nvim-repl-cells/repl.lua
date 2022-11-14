local M = {}
local vim = vim
local tt = require('toggleterm')
local tterm = require('toggleterm.terminal')
local tui = require('toggleterm.ui')
local cells = require('nvim-repl-cells.cells')

-------------------------------------------------------------------------------
-- Utilities
-------------------------------------------------------------------------------
function M.get_filename()
  local filepath = vim.api.nvim_buf_get_name(0)
  local filename = string.match(filepath, "[^/]+$")
  return filename
end

function M.get_dir()
  local filepath = vim.api.nvim_buf_get_name(0)
  local filename = string.match(filepath, "[^/]+$")
  local dir = string.sub(filepath,1,-(string.len(filename)+1))
  return dir
end

function M.get_term_id()
  local bufname = vim.api.nvim_buf_get_name(0)
  local matches_itr = string.gmatch(bufname, "[^#]+")
  local matches = {}
  for match in matches_itr do
    table.insert(matches, match)
  end
  return tonumber(matches[#matches])
end

function M.toggle()
  local user_config = require("nvim-repl-cells").config
  local is_terminal = (vim.o.buftype == "terminal")
  local size = user_config.repl.size
  local direction = user_config.repl.direction
  local go_back = not user_config.repl.focus_repl_on_toggle

  local term_num = nil
  if is_terminal then term_num = M.get_term_id() else term_num = vim.fn.bufnr() end
  local term,_ = tterm.get_or_create_term(term_num,M.get_dir(),direction)
  term:toggle(size,direction)
  if go_back then
    tui.goto_previous()
    tui.stopinsert()
  end
end
-------------------------------------------------------------------------------
-- Send commands
-------------------------------------------------------------------------------
-- Send lines style
function M.send_line()
  local bufnum = vim.fn.bufnr()
  local b_line, _ = table.unpack(vim.api.nvim_win_get_cursor(0))
  local cmd = table.concat(vim.api.nvim_buf_get_lines(0,b_line-1,b_line,0))
  M.send_command(cmd,bufnum)
end

function M.send_lines(bufnum, top_row, bot_row)
  local lines = vim.api.nvim_buf_get_lines(0, top_row - 1, bot_row, 0)
  local no_empty = {}
  for _, v in ipairs(lines) do
    if (string.gsub(v, "%s+", "") ~= "") then
      no_empty[#no_empty+1] = v
    end
  end
  no_empty[#no_empty+1] = ""
  M.send_command(table.concat(no_empty,"\n"))
end

function M.send_file()
  local bufnum = vim.fn.bufnr()
  local top_row = 1
  local bot_row = vim.api.nvim_buf_line_count(0)
  M.send_lines(bufnum, top_row, bot_row)
end

function M.send_cell()
  local bufnum = vim.fn.bufnr()
  local b_line, _ = table.unpack(vim.api.nvim_win_get_cursor(0))
  local top_row, bot_row = cells.get_cell_bounds(b_line, cells.get_marker())
  M.send_lines(bufnum, top_row, bot_row)
end

function M.send_visual()
  local bufnum = vim.fn.bufnr()
  local start_line, _ = table.unpack(vim.fn.getpos("'<"), 2, 3)
  local end_line, _ = table.unpack(vim.fn.getpos("'>"), 2, 3)
  M.send_lines(bufnum, start_line, end_line)
end

function M.send_command(command,bufnum)
  local user_config = require("nvim-repl-cells").config
  local go_back = not user_config.repl.focus_repl_on_cmd
  local open = user_config.repl.open_on_cmd
  local size = user_config.repl.size
  local direction = user_config.repl.direction

  bufnum = bufnum or vim.fn.bufnr()
  local term,created = tterm.get_or_create_term(bufnum,M.get_dir(),direction)
  if created then
    term:open(size,direction)
    if not open then
      term:close()
      go_back = false
    end
  elseif not term:is_open() and open then
    term:open(size,direction)
  end
  if term:is_float() then go_back = false end
  term:send(command, go_back)
end

-- Yank and put style
function M.put_lines(bufnum,register)
  local user_config = require("nvim-repl-cells").config
  local open = user_config.repl.open_on_cmd
  local size = user_config.repl.size
  local direction = user_config.repl.direction
  local term = tterm.get_or_create_term(bufnum)
  tui.update_origin_window(term.window)
  local was_open = term:is_open()
  if not was_open then
    term:open(size,direction)
  else
    term:focus()
  end
  vim.cmd("put "..register)
  if not was_open and not open then
    term:close()
  end
  -- extra line (or two) to execute
  local reg_contents = vim.fn.getreginfo(register).regcontents
  if reg_contents[#reg_contents] == "" then
    M.send_command("",bufnum)
  else
    M.send_command("\n",bufnum)
  end
end

function M.put_line(register)
  local bufnum = vim.fn.bufnr()
  vim.cmd("yank "..register)
  M.put_lines(bufnum,register)
end

function M.put_cell(register)
  local bufnum = vim.fn.bufnr()
  local b_line, _ = table.unpack(vim.api.nvim_win_get_cursor(0))
  local top_row, bot_row = cells.get_cell_bounds(b_line, cells.get_marker())
  vim.cmd(tostring(top_row)..","..tostring(bot_row).."yank "..register)
  M.put_lines(bufnum,register)
end

function M.put_visual(register)
  local bufnum = vim.fn.bufnr()
  vim.cmd("'<,'>yank "..register)
  M.put_lines(bufnum, register)
end

function M.put_file(register)
  local bufnum = vim.fn.bufnr()
  local top_row = 1
  local bot_row = vim.api.nvim_buf_line_count(0)
  vim.cmd(tostring(top_row)..","..tostring(bot_row).."yank "..register)
  M.put_lines(bufnum, register)
end

return M
