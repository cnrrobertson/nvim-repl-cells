command! TREPLSendCell lua require('repl_cells').send_cell_to_repl("# %%")
command! TREPLSendCellandJump lua require('repl_cells').send_cell_to_repl_and_jump("# %%")
command! TREPLInsertCellAbove lua require('repl_cells').insert_cell_above("# %%")
command! TREPLInsertCellBelow lua require('repl_cells').insert_cell_below("# %%")
