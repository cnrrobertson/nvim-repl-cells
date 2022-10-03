config = {
  marker = '# %%',
  highlight = true,
  autofold = true,
  foldtext = true,
  default_mappings = true,
  activate_send_cells = true,
  python = {
    marker = '# %%',
    jupyter = true,
    repl = 'ipython --no-autoindent',
    kernel = 'python',
    file_send = 'python',
    env_cmd = 'conda activate',
    envs = '~/mambaforge/envs/',
  },
  julia = {
    marker = '# %%',
    jupyter = true,
    repl = 'julia',
    kernel = 'julia-1.8',
    file_send = 'julia',
  },
  matlab = {
    marker = '% %%',
    jupyter = true,
    repl = 'matlab -nosplash -nodesktop',
    kernel = 'imatlab',
    file_send = 'matlab -nosplash -nodesktop -batch',
  },
  markdown = {
    marker = '```',
  },
  lua = {
    marker = '-- %%',
    jupyter = false,
    repl = 'lua',
    kernel = 'ilua',
    file_send = 'lua',
  }
}

return config
