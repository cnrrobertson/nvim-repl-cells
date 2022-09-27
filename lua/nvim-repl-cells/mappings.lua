local M = {}
local vim = vim
local send = require("nvim-repl-cells.send_cells")
local config = require("nvim-repl-cells.config")

function M.set_general_mappings()
  vim.keymap.set('n','<a-n>', ":ToggleBufTerm<cr>",{desc="Toggle buffer terminal"})
  vim.keymap.set('t','<a-n>', ":ToggleBufTerm<cr>",{desc="Toggle buffer terminal"})
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
  -- FIXME: Need to fix visual send so doesn't need this form
  vim.keymap.set('v','<localleader>r', ':lua require("nvim-repl-cells.send_cells").send_visual()<cr>',{desc="Send visual"})
  vim.keymap.set('n','<localleader>ee', ':CellSend<cr>',{desc="Send cell"})
  vim.keymap.set('n','<localleader>re', ':CellSendAndJump<cr>',{desc="Send cell and jump"})
    vim.keymap.set('n','<localleader>rf', ':CellSendFile<cr>', {desc="Send file"})
end

function M.set_filetype_send_mappings()
  local buf_type = vim.o.filetype
  local buf_info = config[buf_type]
  if (buf_info ~= nil) or (buf_info.repl ~= nil) then
    vim.keymap.set('n','<localleader>ri', function()send.send_command(buf_info.repl,true,true)end,{desc="Start REPL"})
  end
end

return M
