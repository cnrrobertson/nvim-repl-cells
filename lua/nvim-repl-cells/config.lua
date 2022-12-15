local M = {}
local cells = require("nvim-repl-cells.cells")
local repl = require("nvim-repl-cells.repl")
local vim = vim

M.defaults = {
  -- Cells
  marker = '# %%', -- Used when filtype marker is unspecified
  highlight_color = "ColorColumn",
  autofold = false,
  textobject = "c",
  default_mappings = false,

  -- REPL
  repl = {
    enable = false,
    default_mappings = {
      enable = false,
      style = "put", -- or "send"
      cell_register = "z",
    },
    size = 0.4*vim.o.lines,
    direction = "horizontal",
    open_on_cmd = true,
    focus_repl_on_cmd = false,
    focus_repl_on_toggle = true,
  },

  -- Filetype specific
  python = {
    marker = '# %%',
    repl = 'ipython --no-autoindent',
    file_send = 'python',
    env_cmd = 'conda activate',
    envs = '~/mambaforge/envs/',
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

-------------------------------------------------------------------------------
-- Commands
-------------------------------------------------------------------------------
function M.set_user_commands()
  vim.api.nvim_create_user_command("CellVisualSelect", function()cells.visual_select_in_cell()end, {})
  vim.api.nvim_create_user_command("CellVisualSelectIn", function()cells.visual_select_in_cell()end, {})
  vim.api.nvim_create_user_command("CellVisualSelectAround", function()cells.visual_select_around_cell()end, {})
  vim.api.nvim_create_user_command("CellInsertAbove", function()cells.insert_cell_above()end, {})
  vim.api.nvim_create_user_command("CellInsertBelow", function()cells.insert_cell_below()end, {})
  vim.api.nvim_create_user_command("CellInsertHere", function()cells.insert_cell_here()end, {})
  vim.api.nvim_create_user_command("CellDelete", function()cells.delete_cell()end, {})
  vim.api.nvim_create_user_command("CellSplit", function()cells.split_cell()end, {})
  vim.api.nvim_create_user_command("CellMergeAbove", function()cells.merge_cell_above()end, {})
  vim.api.nvim_create_user_command("CellMergeBelow", function()cells.merge_cell_below()end, {})
  vim.api.nvim_create_user_command("CellJumpToNext", function()cells.jump_to_next_cell()end, {})
  vim.api.nvim_create_user_command("CellJumpToPrevious", function()cells.jump_to_previous_cell()end, {})
  vim.api.nvim_create_user_command("CellToggleFold", function()cells.toggle_cell_fold()end, {})
  vim.api.nvim_create_user_command("CellFoldAll", function()cells.fold_all_cells()end, {})
  vim.api.nvim_create_user_command("CellUnfoldAll", function()cells.unfold_all_cells()end, {})
end

function M.set_repl_user_commands()
  local user_config = require("nvim-repl-cells").config
  local cell_register = user_config.repl.cell_register
  vim.api.nvim_create_user_command("CellSendLine", function()repl.send_line()end, {})
  vim.api.nvim_create_user_command("CellSendVisual", function()repl.send_visual()end, {range=true})
  vim.api.nvim_create_user_command("CellSend", function()repl.send_cell()end, {})
  vim.api.nvim_create_user_command("CellSendAndJump", function()repl.send_cell();cells.jump_to_next_cell()end, {})
  vim.api.nvim_create_user_command("CellSendFile", function()repl.send_file()end, {})

  vim.api.nvim_create_user_command("CellPutLine", function()repl.put_line(cell_register)end, {})
  vim.api.nvim_create_user_command("CellPutVisual", function()repl.put_visual(cell_register)end, {range=true})
  vim.api.nvim_create_user_command("CellPut", function()repl.put_cell(cell_register)end, {})
  vim.api.nvim_create_user_command("CellPutAndJump", function()repl.put_cell(cell_register);cells.jump_to_next_cell()end, {})
  vim.api.nvim_create_user_command("CellPutFile", function()repl.put_file(cell_register)end, {})

  vim.api.nvim_create_user_command("ToggleBufTerm", function()repl.toggle()end, {})
end

function M.set_repl_auto_user_commands()
  -- Activating repl and sending file
  local user_config = require("nvim-repl-cells").config
  local buf_type = vim.o.filetype
  local buf_info = user_config[buf_type]
  if (buf_info ~= nil) and (buf_info.repl ~= nil) then
    local repl_str = buf_info.repl
    vim.api.nvim_buf_create_user_command(0,"StartRepl", function()repl.send_command(repl_str)end,{})
  end
  if (buf_info ~= nil) and (buf_info.file_send ~= nil) then
    local command = buf_info.file_send.." "..vim.api.nvim_buf_get_name(0)
    vim.api.nvim_buf_create_user_command(0,"RunFile", function()repl.send_command(command)end,{})
  end
end

function M.set_env_auto_user_commands()
  -- Activate some env
  local user_config = require("nvim-repl-cells").config
  local buf_type = vim.o.filetype
  local buf_info = user_config[buf_type]
  if (buf_info ~= nil) and (buf_info.env_cmd ~= nil) then
    local envs = get_envs(buf_info)
    local env_syms = get_env_symbols(envs)
    local env_strs = {}
    for i,s in pairs(env_syms) do
      local env = envs[i]
      local env_str = buf_info.env_cmd.." "..env
      -- env_strs[env] = env_str
      table.insert(env_strs,env)
    end
    local activate_func = function(opt)
      repl.send_command(buf_info.env_cmd.." "..opt.args)
    end
    local complete_func = function()
      return env_strs
    end
    vim.api.nvim_buf_create_user_command(0,"ActivateEnv",activate_func,{complete=complete_func,nargs=1})
  end
end

-------------------------------------------------------------------------------
-- Mappings
-------------------------------------------------------------------------------
function M.set_default_mappings()
  vim.keymap.set('n',']c', cells.jump_to_next_cell,{desc="Next cell"})
  vim.keymap.set('n','[c', cells.jump_to_previous_cell,{desc="Previous cell"})
  vim.keymap.set('n','<localleader>x', cells.delete_cell,{desc="Delete cell"})
  vim.keymap.set('n','<localleader>s', cells.split_cell,{desc="Split cell"})
  vim.keymap.set('n','<localleader>a', cells.insert_cell_above,{desc="Insert cell above"})
  vim.keymap.set('n','<localleader>b', cells.insert_cell_below,{desc="Insert cell below"})
  vim.keymap.set('n','<localleader>i', cells.insert_cell_here,{desc="Insert cell here"})
  vim.keymap.set('n','<localleader>v', cells.visual_select_in_cell,{desc="Visual select cell"})
  vim.keymap.set('n','<localleader>f', function()end,{desc="Cell folds"})
  vim.keymap.set('n','<localleader>ff', cells.toggle_cell_fold,{desc="Toggle cell fold"})
  vim.keymap.set('n','<localleader>fc', cells.fold_all_cells,{desc="Fold all cells"})
  vim.keymap.set('n','<localleader>fo', cells.unfold_all_cells,{desc="Unfold all cells"})
end

function M.set_default_repl_mappings()
  local user_config = require("nvim-repl-cells").config
  local cell_register = user_config.repl.default_mappings

  vim.keymap.set('n','<a-n>',repl.toggle,{desc="Toggle buffer terminal"})
  vim.keymap.set('t','<a-n>',repl.toggle,{desc="Toggle buffer terminal"})
  if user_config.repl.default_mappings.style == "put" then
    vim.keymap.set('n','<localleader>rr',function()repl.put_line(cell_register)end,{desc="Yank-Put line"})
    -- vim.keymap.set('v','<localleader>r',function()repl.put_visual(cell_register)end,{desc="Yank-Put visual"}) -- FIXME: Delayed for some reason. Puts last yank
    vim.keymap.set('v','<localleader>r',':<c-w>CellPutVisual<cr>',{desc="Yank-Put visual"})
    vim.keymap.set('n','<localleader>rE',function()repl.put_cell(cell_register)end,{desc="Yank-Put cell"})
    vim.keymap.set('n','<localleader>re',function()repl.put_cell(cell_register);cells.jump_to_next_cell()end,{desc="Yank-Put cell and jump"})
    vim.keymap.set('n','<localleader>rf',function()repl.put_file(cell_register)end, {desc="Yank-Put file"})
  else
    vim.keymap.set('n','<localleader>rr',repl.send_line,{desc="Send line"})
    vim.keymap.set('v','<localleader>r',repl.send_visual,{desc="Send visual"})
    vim.keymap.set('n','<localleader>rE',repl.send_cell,{desc="Send cell"})
    vim.keymap.set('n','<localleader>re',function()repl.send_cell();cells.jump_to_next_cell()end,{desc="Send cell and jump"})
    vim.keymap.set('n','<localleader>rf',repl.send_file, {desc="Send file"})
  end
end

function M.set_default_filetype_repl_mappings()
  local user_config = require("nvim-repl-cells").config
  local buf_type = vim.o.filetype
  local buf_info = user_config[buf_type]
  if (buf_info ~= nil) and (buf_info.repl ~= nil) then
    local repl_str = buf_info.repl
    vim.keymap.set('n','<localleader>ri', function()repl.send_command(repl_str)end,{desc="Start REPL",buffer=true})
  end
  if (buf_info ~= nil) and (buf_info.file_send ~= nil) then
    local command = buf_info.file_send.." "..vim.api.nvim_buf_get_name(0)
    vim.keymap.set('n','<localleader>rF', function()repl.send_command(command)end,{desc="Run file in terminal",buffer=true})
  end
end

function get_envs(buf_info)
  local envs = {}
  if buf_info.envs ~= nil then
    for dirs in io.popen("dir "..buf_info.envs):lines() do
      for dir in string.gmatch(dirs, "[^%s]+") do
        table.insert(envs, dir)
      end
    end
    return envs
  else
    vim.api.nvim_err_writeln("ERROR: No environment directory set")
  end
end

function get_env_symbols(envs)
  local env_syms = {}
  -- Check matching first letters, if so, move to length 2 symbols, etc.
  for i,env1 in pairs(envs) do
    local sym_len = 1
    local matches = false
    local sym1 = ""
    while matches == false do
      sym1 = string.sub(env1,1,sym_len)
      for j,env2 in pairs(envs) do
        if i ~= j then
          sym2 = string.sub(env2,1,sym_len)
          if sym1 == sym2 then
            matches = true
          end
        end
      end
      if matches == true then
        sym_len = sym_len + 1
        matches = false
      else
        matches = true
      end
    end
    table.insert(env_syms, sym1)
  end
  return env_syms
end

function M.set_default_filetype_env_mappings()
  local user_config = require("nvim-repl-cells").config
  local buf_type = vim.o.filetype
  local buf_info = user_config[buf_type]
  vim.keymap.set('n','<localleader>ra',function()end,{desc="Env",buffer=true})
  if (buf_info ~= nil) and (buf_info.env_cmd ~= nil) then
    local envs = get_envs(buf_info)
    local env_syms = get_env_symbols(envs)
    for i,s in pairs(env_syms) do
      local env = envs[i]
      local env_str = buf_info.env_cmd.." "..env
      local env_func = function()
        repl.send_command(env_str)
      end
      vim.keymap.set('n','<localleader>ra'..s, env_func,{desc="Activate "..env,buffer=true})
    end
  end
end

-------------------------------------------------------------------------------
-- Textobjects
-------------------------------------------------------------------------------
function M.set_textobject_mappings(key)
  vim.keymap.set('x', 'i'..key, cells.visual_select_in_cell, {desc="inner cell"})
  vim.keymap.set('x', 'a'..key, cells.visual_select_around_cell, {desc="outer cell"})
  vim.keymap.set('o', 'i'..key, cells.visual_select_in_cell, {desc="inner cell"})
  vim.keymap.set('o', 'a'..key, cells.visual_select_around_cell, {desc="outer cell"})
  vim.keymap.set('x', 't'..key, cells.visual_select_till_cell, {desc="till cell"})
  vim.keymap.set('x', 'T'..key, cells.visual_select_back_till_cell, {desc="back till cell"})
  vim.keymap.set('o', 't'..key, cells.visual_select_till_cell, {desc="till cell"})
  vim.keymap.set('o', 'T'..key, cells.visual_select_back_till_cell, {desc="back till cell"})
  vim.keymap.set('x', 'f'..key, cells.visual_select_to_cell, {desc="to cell"})
  vim.keymap.set('x', 'F'..key, cells.visual_select_back_to_cell, {desc="back to cell"})
  vim.keymap.set('o', 'f'..key, cells.visual_select_to_cell, {desc="to cell"})
  vim.keymap.set('o', 'F'..key, cells.visual_select_back_to_cell, {desc="back to cell"})
end

return M
