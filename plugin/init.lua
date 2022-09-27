-------------------------------------------------------------------------------
-- Config
-------------------------------------------------------------------------------
if vim.g.cell_marker == nil then
  vim.g.cell_marker = '# %%'
end
if vim.g.cell_highlight == nil then
  vim.g.cell_highlight = true
end
if vim.g.cell_autofold == nil then
  vim.g.cell_autofold = true
end
if vim.g.cell_foldtext == nil then
  vim.g.cell_foldtext = true
end

-------------------------------------------------------------------------------
-- Commands
-------------------------------------------------------------------------------
vim.api.nvim_create_user_command("CellVisualSelect", "lua require('nvim-repl-cells').visual_select_cell(vim.g.cell_marker)", {})
vim.api.nvim_create_user_command("CellInsertAbove", "lua require('nvim-repl-cells').insert_cell_above(vim.g.cell_marker)", {})
vim.api.nvim_create_user_command("CellInsertBelow", "lua require('nvim-repl-cells').insert_cell_below(vim.g.cell_marker)", {})
vim.api.nvim_create_user_command("CellInsertHere", "lua require('nvim-repl-cells').insert_cell_here(vim.g.cell_marker)", {})
vim.api.nvim_create_user_command("CellDelete", "lua require('nvim-repl-cells').delete_cell(vim.g.cell_marker)", {})
vim.api.nvim_create_user_command("CellSplit", "lua require('nvim-repl-cells').split_cell(vim.g.cell_marker)", {})
vim.api.nvim_create_user_command("CellMergeAbove", "lua require('nvim-repl-cells').merge_cell_below(vim.g.cell_marker)", {})
vim.api.nvim_create_user_command("CellMergeBelow", "lua require('nvim-repl-cells').merge_cell_above(vim.g.cell_marker)", {})
vim.api.nvim_create_user_command("CellJumpToNext", "lua require('nvim-repl-cells').jump_to_next_cell(vim.g.cell_marker)", {})
vim.api.nvim_create_user_command("CellJumpToPrevious", "lua require('nvim-repl-cells').jump_to_previous_cell(vim.g.cell_marker)", {})
vim.api.nvim_create_user_command("CellToggleFold", "lua require('nvim-repl-cells').toggle_cell_fold(vim.g.cell_marker)", {})
vim.api.nvim_create_user_command("CellFoldAll", "lua require('nvim-repl-cells').fold_all_cells(vim.g.cell_marker)", {})
vim.api.nvim_create_user_command("CellUnfoldAll", "lua require('nvim-repl-cells').unfold_all_cells(vim.g.cell_marker)", {})

-------------------------------------------------------------------------------
-- Autocommands
-------------------------------------------------------------------------------
local cells = require("nvim-repl-cells")
if vim.g.cell_highlight == true then
  vim.api.nvim_create_autocmd({"BufWrite","BufEnter"}, {pattern={"*"}, callback=function()cells.highlight_cells(vim.g.cell_marker)end})
end
if vim.g.cell_autofold == true then
  vim.api.nvim_create_autocmd({"SessionLoadPost","BufReadPost"}, {pattern={"*"}, callback=function()cells.fold_all_cells(vim.g.cell_marker)end})
end
if vim.g.cell_foldtext == true then
  cells.set_foldtext()
end
