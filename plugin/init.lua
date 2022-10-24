local cells = require("nvim-repl-cells")
local send = require("nvim-repl-cells.send_cells")
local config = require("nvim-repl-cells.config")
local mappings = require("nvim-repl-cells.mappings")
-------------------------------------------------------------------------------
-- Commands
-------------------------------------------------------------------------------
vim.api.nvim_create_user_command("CellVisualSelect", function()cells.visual_select_cell(cells.get_marker())end, {})
vim.api.nvim_create_user_command("CellInsertAbove", function()cells.insert_cell_above(cells.get_marker())end, {})
vim.api.nvim_create_user_command("CellInsertBelow", function()cells.insert_cell_below(cells.get_marker())end, {})
vim.api.nvim_create_user_command("CellInsertHere", function()cells.insert_cell_here(cells.get_marker())end, {})
vim.api.nvim_create_user_command("CellDelete", function()cells.delete_cell(cells.get_marker())end, {})
vim.api.nvim_create_user_command("CellSplit", function()cells.split_cell(cells.get_marker())end, {})
vim.api.nvim_create_user_command("CellMergeAbove", function()cells.merge_cell_below(cells.get_marker())end, {})
vim.api.nvim_create_user_command("CellMergeBelow", function()cells.merge_cell_above(cells.get_marker())end, {})
vim.api.nvim_create_user_command("CellJumpToNext", function()cells.jump_to_next_cell(cells.get_marker())end, {})
vim.api.nvim_create_user_command("CellJumpToPrevious", function()cells.jump_to_previous_cell(cells.get_marker())end, {})
vim.api.nvim_create_user_command("CellToggleFold", function()cells.toggle_cell_fold(cells.get_marker())end, {})
vim.api.nvim_create_user_command("CellFoldAll", function()cells.fold_all_cells(cells.get_marker())end, {})
vim.api.nvim_create_user_command("CellUnfoldAll", function()cells.unfold_all_cells(cells.get_marker())end, {})

vim.api.nvim_create_user_command("CellSendLine", send.send_line, {})
vim.api.nvim_create_user_command("CellSendVisual", send.send_visual, {})
vim.api.nvim_create_user_command("CellSend", send.send_cell, {})
vim.api.nvim_create_user_command("CellSendAndJump", function()send.send_cell();cells.jump_to_next_cell(cells.get_marker())end, {})
vim.api.nvim_create_user_command("CellSendFile", send.send_file, {})

vim.api.nvim_create_user_command("ToggleBufTerm", send.toggle, {})

-------------------------------------------------------------------------------
-- Mappings
-------------------------------------------------------------------------------
mappings.set_general_mappings()
mappings.set_send_mappings()
mappings.set_textobject_mappings()
vim.api.nvim_create_augroup("ReplCells",{clear=true})
vim.api.nvim_create_autocmd({"BufEnter"}, {group="ReplCells",pattern={"*"},callback=mappings.set_filetype_send_mappings})
vim.api.nvim_create_autocmd({"BufEnter"}, {group="ReplCells",pattern={"*"},callback=mappings.set_filetype_env_mappings})

-------------------------------------------------------------------------------
-- Autocommands
-------------------------------------------------------------------------------
if config.highlight == true then
  vim.api.nvim_create_autocmd({"BufWrite","BufEnter"},{group="ReplCells",pattern={"*"},callback=function()cells.highlight_cells(cells.get_marker())end})
end
if config.autofold == true then
  vim.api.nvim_create_autocmd({"SessionLoadPost","BufReadPost"},{group="ReplCells",pattern={"*"},callback=function()cells.fold_all_cells(cells.get_marker())end})
end
if config.foldtext == true then
  cells.set_foldtext()
end
