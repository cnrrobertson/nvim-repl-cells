# nvim-repl-cells
Utility functions to add/remove/navigate/visual select "cells" of code in Neovim based on a marker between the cells.

## TODO:
- [x] Move to `init.lua`
- [x] Incorporate toggleterm buffer repl commands
- [x] Add language specific settings capability
  - [x] Different markers
  - [ ] `%paste -q` for ipython
    - [ ] Also pasting in other terminals, i.e. julia, in specific register
  - [x] language specific REPL commands and flags
- [ ] textobject support
  - [x] in cell
  - [x] around cell
  - [x] till cell
  - [x] to cell
- [ ] Options flush out
  - [ ] Colors for highlighting
  - [x] Default mappings
- [ ] Additional cell options
  - [x] Merge cells
  - [ ] Convert to markdown
- [ ] Fill out this README with overview of workflow that it supports and other alternative plugins
  - `jupytext.vim`: how it works well with this for jupyter notebooks
  - `vim-ipython-cell`: this was the inspiration. Doesn't depend on `vim-slime` and is `lua` only
  - `vim-jukit`: also an inspiration. Again, not buffer specific
  - `jupyter-vim`: complicated setup, not easy for remote work, etc.
  - `magma-nvim`: amazing plugin, complex, harder to debug because of hidden repl, images don't always work, lots of `python`
  - `nvim-ipy`: awesome, again, hard to access repl info, limited cell features, in `python`
  - `jupyter_ascending.vim`: separate process issues
  - `iron.nvim`: could work in combination with this but doesn't have buffer specific repls
  - `termwrapper.nvim`: same
  - `nvim-repl`: same
  - `nvim-python-repl`: same
  - `repl.nvim`: same
  - `neoterm`: same
  - `vimcmdline`: same
  - `vim-slime`: need to deal with separate process. Could work with the cell convenience commands
  - Example similar: https://www.maxwellrules.com/misc/nvim_jupyter.html
  - `vim-textobj-hydrogen`: text object for code cells, very similar to this, but not `lua`, inspiration
