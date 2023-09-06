local M = {}
local vim = vim
local cells = require('nvim-repl-cells.cells')
local nuiterm = require('nuiterm')

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

-------------------------------------------------------------------------------
-- Send commands
-------------------------------------------------------------------------------
function M.send_cell()
  local b_line, _ = unpack(vim.api.nvim_win_get_cursor(0))
  local top_row, bot_row = cells.get_cell_bounds(b_line, cells.get_marker())
  nuiterm.send_lines(top_row, bot_row)
end

return M
