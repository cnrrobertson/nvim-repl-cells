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
  local is_terminal = (vim.o.buftype == "terminal")
  if is_terminal==false then
    tt.toggle(vim.fn.bufnr(),nil,M.get_dir())
  else
    tt.toggle(M.get_term_id(),nil,M.get_dir())
  end
end
-------------------------------------------------------------------------------
-- Send commands
-------------------------------------------------------------------------------
-- Send lines style
function M.send_line()
  local id = {args=vim.fn.bufnr()}
  tt.send_lines_to_terminal("single_line",true,id)
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
  tt.exec(table.concat(no_empty,"\n"),bufnum,nil,nil,nil,true)
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

function M.send_command(command,go_back,display)
  tt.exec(command,vim.fn.bufnr(),nil,M.get_dir(),nil,go_back,display)
end

-- Yank and put style
function M.put_lines(bufnum,register)
  local term = tterm.get_or_create_term(bufnum,nil,M.get_dir())
  tui.update_origin_window(term.window)
  if term:is_open() == false then
    term:open(vim.o.lines*0.4,term.direction) -- TODO: Need to get correct config for size
  else
    term:focus()
  end
  vim.cmd("put "..register)
  -- extra line (or two) to execute
  tt.exec("",bufnum,nil,M.get_dir())
  local reg_contents = vim.fn.getreginfo(register).regcontents
  if reg_contents[#reg_contents] ~= "" then
    tt.exec("",bufnum,nil,M.get_dir())
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