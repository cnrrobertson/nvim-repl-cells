local cells = require("nvim-repl-cells")
local send = require("nvim-repl-cells.send_cells")
local config = require("nvim-repl-cells.config")
local mappings = require("nvim-repl-cells.mappings")
local vim = vim
-------------------------------------------------------------------------------
-- Commands
-------------------------------------------------------------------------------
vim.api.nvim_create_user_command("CellVisualSelect", function()cells.visual_select_in_cell()end, {})
vim.api.nvim_create_user_command("CellVisualSelectIn", function()cells.visual_select_in_cell()end, {})
vim.api.nvim_create_user_command("CellVisualSelectAround", function()cells.visual_select_around_cell()end, {})
vim.api.nvim_create_user_command("CellInsertAbove", function()cells.insert_cell_above()end, {})
vim.api.nvim_create_user_command("CellInsertBelow", function()cells.insert_cell_below()end, {})
vim.api.nvim_create_user_command("CellInsertHere", function()cells.insert_cell_here()end, {})
vim.api.nvim_create_user_command("CellDelete", function()cells.delete_cell()end, {})
vim.api.nvim_create_user_command("CellSplit", function()cells.split_cell()end, {})
vim.api.nvim_create_user_command("CellMergeAbove", function()cells.merge_cell_above()end, {})
vim.api.nvim_create_user_command("CellMergeBelow", function()cells.merge_cell_below()end, {})
vim.api.nvim_create_user_command("CellJumpToNext", function()cells.jump_to_next_cell()end, {})
vim.api.nvim_create_user_command("CellJumpToPrevious", function()cells.jump_to_previous_cell()end, {})
vim.api.nvim_create_user_command("CellToggleFold", function()cells.toggle_cell_fold()end, {})
vim.api.nvim_create_user_command("CellFoldAll", function()cells.fold_all_cells()end, {})
vim.api.nvim_create_user_command("CellUnfoldAll", function()cells.unfold_all_cells()end, {})

vim.api.nvim_create_user_command("CellSendLine", function()send.send_line()end, {})
vim.api.nvim_create_user_command("CellSendVisual", function()send.send_visual()end, {range=true})
vim.api.nvim_create_user_command("CellSend", function()send.send_cell()end, {})
vim.api.nvim_create_user_command("CellSendAndJump", function()send.send_cell();cells.jump_to_next_cell()end, {})
vim.api.nvim_create_user_command("CellSendFile", function()send.send_file()end, {})

vim.api.nvim_create_user_command("CellPutLine", function()send.put_line(config.cell_register)end, {})
vim.api.nvim_create_user_command("CellPutVisual", function()send.put_visual(config.cell_register)end, {range=true})
vim.api.nvim_create_user_command("CellPut", function()send.put_cell(config.cell_register)end, {})
vim.api.nvim_create_user_command("CellPutAndJump", function()send.put_cell(config.cell_register);cells.jump_to_next_cell()end, {})
vim.api.nvim_create_user_command("CellPutFile", function()send.put_file(config.cell_register)end, {})

vim.api.nvim_create_user_command("ToggleBufTerm", function()send.toggle()end, {})

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
  vim.api.nvim_create_autocmd({"BufWrite","BufEnter"},{group="ReplCells",pattern={"*"},callback=function()cells.highlight_cells()end})
end
if config.autofold == true then
  vim.api.nvim_create_autocmd({"SessionLoadPost","BufReadPost"},{group="ReplCells",pattern={"*"},callback=function()cells.fold_all_cells()end})
end
if config.foldtext == true then
  cells.set_foldtext()
end
