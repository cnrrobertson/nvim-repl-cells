config = {
  marker = '# %%',
  highlight = true,
  autofold = false,
  foldtext = true,
  default_mappings = true,
  activate_send_cells = true,
  cell_register = "z",
  python = {
    marker = '# %%',
    repl = 'ipython --no-autoindent',
    -- repl = 'jupyter console --kernel=python --ZMQTerminalInteractiveShell.autoindent=False --ZMQTerminalInteractiveShell.true_color=True',
    file_send = 'python',
    env_cmd = 'conda activate',
    envs = '~/mambaforge/envs/',
  },
  julia = {
    marker = '# %%',
    repl = 'julia',
    -- repl = 'jupyter console --kernel=julia-1.8 --ZMQTerminalInteractiveShell.autoindent=False --ZMQTerminalInteractiveShell.true_color=True',
    file_send = 'julia',
  },
  matlab = {
    marker = '% %%',
    repl = 'matlab -nosplash -nodesktop',
    -- repl = 'jupyter console --kernel=imatlab --ZMQTerminalInteractiveShell.autoindent=False --ZMQTerminalInteractiveShell.true_color=True',
    file_send = 'matlab -nosplash -nodesktop -batch',
  },
  markdown = {
    marker = '```',
  },
  lua = {
    marker = '-- %%',
    repl = 'lua',
    -- repl = 'jupyter console --kernel=ilua --ZMQTerminalInteractiveShell.autoindent=False --ZMQTerminalInteractiveShell.true_color=True',
    file_send = 'lua',
  }
}

return config
