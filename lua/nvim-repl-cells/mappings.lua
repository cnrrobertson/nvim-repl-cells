local M = {}
local vim = vim
local cells = require("nvim-repl-cells")
local send = require("nvim-repl-cells.send_cells")
local config = require("nvim-repl-cells.config")

function M.set_general_mappings()
  vim.keymap.set('n','<a-n>', ":ToggleBufTerm<cr>",{desc="Toggle buffer terminal"})
  vim.keymap.set('t','<a-n>', "<c-\\><c-n>:ToggleBufTerm<cr>",{desc="Toggle buffer terminal"})
  vim.keymap.set('n',']c', ":CellJumpToNext<cr>",{desc="Next cell"})
  vim.keymap.set('n','[c', ":CellJumpToPrevious<cr>",{desc="Previous cell"})
  vim.keymap.set('n','<localleader>x', ":CellDelete<cr>",{desc="Delete cell"})
  vim.keymap.set('n','<localleader>s', ":CellSplit<cr>",{desc="Split cell"})
  vim.keymap.set('n','<localleader>a', ":CellInsertAbove<cr>",{desc="Insert cell above"})
  vim.keymap.set('n','<localleader>b', ":CellInsertBelow<cr>",{desc="Insert cell below"})
  vim.keymap.set('n','<localleader>i', ":CellInsertHere<cr>",{desc="Insert cell here"})
  vim.keymap.set('n','<localleader>v', ':CellVisualSelect<cr>',{desc="Visual select cell"})
  vim.keymap.set('n','<localleader>ff', ':CellToggleFold<cr>',{desc="Toggle cell fold"})
  vim.keymap.set('n','<localleader>fc', ':CellFoldAll<cr>',{desc="Fold all cells"})
  vim.keymap.set('n','<localleader>fo', ':CellUnfoldAll<cr>',{desc="Unfold all cells"})
end

function M.set_send_mappings()
  vim.keymap.set('n','<localleader>rr', ':CellSendLine<cr>',{desc="Send line"})
  vim.keymap.set('v','<localleader>r',':<c-u>CellSendVisual<cr>',{desc="Send visual"})
  vim.keymap.set('n','<localleader>ee', ':CellSend<cr>',{desc="Send cell"})
  vim.keymap.set('n','<localleader>re', ':CellSendAndJump<cr>',{desc="Send cell and jump"})
    vim.keymap.set('n','<localleader>rf', ':CellSendFile<cr>', {desc="Send file"})
end

function M.get_repl(buf_info)
  local repl_str = ""
  if buf_info.jupyter then
    if buf_info.kernel ~= nil then
      repl_str = "jupyter console --kernel "..buf_info.kernel
    end
  else
    if buf_info.repl ~= nil then
      repl_str = buf_info.repl
    end
  end
  return repl_str
end

function M.set_filetype_send_mappings()
  local buf_type = vim.o.filetype
  local buf_info = config[buf_type]
  if buf_info ~= nil then
    local repl_str = M.get_repl(buf_info)
    vim.keymap.set('n','<localleader>ri', function()send.send_command(repl_str,true,true)end,{desc="Start REPL"})
  end
  if (buf_info ~= nil) and (buf_info.file_send ~= nil) then
    local command = buf_info.file_send.." "..vim.api.nvim_buf_get_name(0)
    vim.keymap.set('n','<localleader>rF', function()send.send_command(command,true,true)end,{desc="Run file in terminal"})
  end
end

function M.set_textobject_mappings()
  vim.keymap.set('x', 'ic', function()cells.visual_select_in_cell(cells.get_marker())end, {desc="inner cell"})
  vim.keymap.set('x', 'ac', function()cells.visual_select_around_cell(cells.get_marker())end, {desc="outer cell"})
  vim.keymap.set('o', 'ic', function()cells.visual_select_in_cell(cells.get_marker())end, {desc="inner cell"})
  vim.keymap.set('o', 'ac', function()cells.visual_select_around_cell(cells.get_marker())end, {desc="outer cell"})
end

return M
