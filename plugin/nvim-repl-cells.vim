if !exists('g:nvim_repl_cell_marker')
  let g:nvim_repl_cell_marker = '# %%'
end
if !exists('g:nvim_repl_cell_highlight')
  let g:nvim_repl_cell_highlight = 1
end
if !exists('g:nvim_repl_auto_fold_cells')
  let g:nvim_repl_auto_fold_cells = 1
end
if !exists('g:nvim_repl_foldtext')
  let g:nvim_repl_foldtext = 1
end

command! CellVisualSelect lua require'nvim-repl-cells'.visual_select_cell(vim.g.nvim_repl_cell_marker)

command! CellInsertAbove lua require'nvim-repl-cells'.insert_cell_above(vim.g.nvim_repl_cell_marker)
command! CellInsertBelow lua require'nvim-repl-cells'.insert_cell_below(vim.g.nvim_repl_cell_marker)
command! CellInsertHere lua require'nvim-repl-cells'.insert_cell_here(vim.g.nvim_repl_cell_marker)
command! CellDelete lua require'nvim-repl-cells'.delete_cell(vim.g.nvim_repl_cell_marker)
command! CellSplit lua require'nvim-repl-cells'.split_cell(vim.g.nvim_repl_cell_marker)
command! CellMergeBelow lua require'nvim-repl-cells'.merge_cell_below(vim.g.nvim_repl_cell_marker)
command! CellMergeAbove lua require'nvim-repl-cells'.merge_cell_above(vim.g.nvim_repl_cell_marker)
command! CellJumpToNext lua require'nvim-repl-cells'.jump_to_next_cell(vim.g.nvim_repl_cell_marker)
command! CellJumpToPrevious lua require'nvim-repl-cells'.jump_to_previous_cell(vim.g.nvim_repl_cell_marker)
command! CellToggleFold lua require'nvim-repl-cells'.toggle_cell_fold(vim.g.nvim_repl_cell_marker)
command! CellFoldAll lua require'nvim-repl-cells'.fold_all_cells(vim.g.nvim_repl_cell_marker)
command! CellUnfoldAll lua require'nvim-repl-cells'.unfold_all_cells(vim.g.nvim_repl_cell_marker)

if g:nvim_repl_cell_highlight == 1
  autocmd BufWrite,BufEnter * lua require'nvim-repl-cells'.highlight_cells(vim.g.nvim_repl_cell_marker)
endif
if g:nvim_repl_auto_fold_cells == 1
  autocmd SessionLoadPost,BufReadPost * lua require'nvim-repl-cells'.fold_all_cells(vim.g.nvim_repl_cell_marker)
endif
if g:nvim_repl_foldtext == 1
  lua require'nvim-repl-cells'.set_foldtext()
endif
