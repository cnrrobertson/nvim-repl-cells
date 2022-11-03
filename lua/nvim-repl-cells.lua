local M = {}
local config = require("nvim-repl-cells.config")
local cells = require("nvim-repl-cells.cells")
local vim = vim

M.config = {}

function M.setup(opts)
  -- Update config with user inputs
  M.config = vim.tbl_deep_extend("force", {}, config.defaults, opts or {})

  -- User commands
  if M.config.set_user_commands then
    config.set_user_commands()
  end
  if M.config.repl.enable then
    config.set_repl_user_commands()
  end

  -- Default keybinds
  if M.config.textobject then
    config.set_textobject_mappings(M.config.textobject)
  end
  if M.config.default_mappings then
    config.set_default_mappings()
  end
  if M.config.repl.default_mappings then
    config.set_default_repl_mappings()
    config.set_default_filetype_repl_mappings()
    config.set_default_filetype_env_mappings()
  end

  -- Autocommands
  vim.api.nvim_create_augroup("ReplCells",{clear=true})
  vim.api.nvim_create_autocmd({"BufEnter"}, {group="ReplCells",pattern={"*"},callback=config.set_default_filetype_repl_mappings})
  vim.api.nvim_create_autocmd({"BufEnter"}, {group="ReplCells",pattern={"*"},callback=config.set_default_filetype_env_mappings})
  if M.config.highlight_color then
    vim.api.nvim_create_autocmd({"BufModifiedSet","BufEnter"},{group="ReplCells",pattern={"*"},callback=function()cells.highlight_cells()end})
  end
  if M.config.repl.enable then
    vim.api.nvim_create_autocmd({"BufReadPost"}, {group="ReplCells",pattern={"*"},callback=config.set_repl_auto_user_commands})
    vim.api.nvim_create_autocmd({"BufReadPost"}, {group="ReplCells",pattern={"*"},callback=config.set_env_auto_user_commands})
  end

  -- Folds
  if M.config.autofold == true then
    vim.api.nvim_create_autocmd({"SessionLoadPost","BufReadPost"},{group="ReplCells",pattern={"*"},callback=function()cells.fold_all_cells()end})
  end
end

return M
