if !exists('g:nvim_repl_cell_marker')
  let g:nvim_repl_cell_marker = '# %%'
end

command! TREPLVisualSelectCell lua require'nvim-repl-cells'.visual_select_cell(vim.g.nvim_repl_cell_marker)
" command! TREPLSendCell lua require'nvim-repl-cells'.send_cell_to_repl(vim.g.nvim_repl_cell_marker)
" command! TREPLSendCellandJump lua require'nvim-repl-cells'.send_cell_to_repl_and_jump(vim.g.nvim_repl_cell_marker)

command! TREPLInsertCellAbove lua require'nvim-repl-cells'.insert_cell_above(vim.g.nvim_repl_cell_marker)
command! TREPLInsertCellBelow lua require'nvim-repl-cells'.insert_cell_below(vim.g.nvim_repl_cell_marker)
command! TREPLDeleteCell lua require'nvim-repl-cells'.delete_cell(vim.g.nvim_repl_cell_marker)
command! TREPLSplitCell lua require'nvim-repl-cells'.split_cell(vim.g.nvim_repl_cell_marker)
command! TREPLMergeCellBelow lua require'nvim-repl-cells'.merge_cell_below(vim.g.nvim_repl_cell_marker)
command! TREPLMergeCellAbove lua require'nvim-repl-cells'.merge_cell_above(vim.g.nvim_repl_cell_marker)

command! TREPLJumpToNextCell lua require'nvim-repl-cells'.jump_to_next_cell(vim.g.nvim_repl_cell_marker)
command! TREPLJumpToPreviousCell lua require'nvim-repl-cells'.jump_to_previous_cell(vim.g.nvim_repl_cell_marker)
