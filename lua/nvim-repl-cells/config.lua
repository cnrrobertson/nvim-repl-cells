config = {
  marker = '# %%',
  highlight = true,
  autofold = true,
  foldtext = true,
  default_mappings = true,
  activate_send_cells = true,
  python = {
    marker = '# %%',
    repl = 'ipython --no-autoindent',
    file_send = 'python',
  },
  julia = {
    marker = '# %%',
    repl = 'julia',
    file_send = 'julia',
  },
  matlab = {
    marker = '% %%',
    repl = 'matlab -nosplash -nodesktop',
    file_send = 'matlab -nosplash -nodesktop -batch',
  },
  markdown = {
    marker = '```',
  },
  lua = {
    marker = '-- %%',
    repl = 'lua',
    file_send = 'lua',
  }
}

return config
