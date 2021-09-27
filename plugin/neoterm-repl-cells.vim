if !exists('g:neoterm_repl_cell_marker')
  let g:neoterm_repl_cell_marker = '# %%'
end

command! TREPLSendCell lua require'neoterm-repl-cells'.send_cell_to_repl(vim.g.neoterm_repl_cell_marker)
command! TREPLSendCellandJump lua require'neoterm-repl-cells'.send_cell_to_repl_and_jump(vim.g.neoterm_repl_cell_marker)
command! TREPLInsertCellAbove lua require'neoterm-repl-cells'.insert_cell_above(vim.g.neoterm_repl_cell_marker)
command! TREPLInsertCellBelow lua require'neoterm-repl-cells'.insert_cell_below(vim.g.neoterm_repl_cell_marker)
