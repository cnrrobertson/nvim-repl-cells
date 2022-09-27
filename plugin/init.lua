local cells = require("nvim-repl-cells")
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

-------------------------------------------------------------------------------
-- Autocommands
-------------------------------------------------------------------------------
if cells.config.highlight == true then
  vim.api.nvim_create_autocmd({"BufWrite","BufEnter"}, {pattern={"*"}, callback=function()cells.highlight_cells(cells.get_marker())end})
end
if cells.config.autofold == true then
  vim.api.nvim_create_autocmd({"SessionLoadPost","BufReadPost"}, {pattern={"*"}, callback=function()cells.fold_all_cells(cells.get_marker())end})
end
if cells.config.foldtext == true then
  cells.set_foldtext()
end
