local M = {}
local vim = vim
local cells = require("nvim-repl-cells")
local send = require("nvim-repl-cells.send_cells")
local config = require("nvim-repl-cells.config")

function M.set_general_mappings()
  vim.keymap.set('n','<a-n>', ":ToggleBufTerm<cr>",{desc="Toggle buffer terminal"})
  vim.keymap.set('t','<a-n>', "<c-\\><c-n>:ToggleBufTerm<cr>",{desc="Toggle buffer terminal"})
  vim.keymap.set('n',']c', ":CellJumpToNext<cr>",{desc="Next cell"})
  vim.keymap.set('n','[c', ":CellJumpToPrevious<cr>",{desc="Previous cell"})
  vim.keymap.set('n','<localleader>x', ":CellDelete<cr>",{desc="Delete cell"})
  vim.keymap.set('n','<localleader>s', ":CellSplit<cr>",{desc="Split cell"})
  vim.keymap.set('n','<localleader>a', ":CellInsertAbove<cr>",{desc="Insert cell above"})
  vim.keymap.set('n','<localleader>b', ":CellInsertBelow<cr>",{desc="Insert cell below"})
  vim.keymap.set('n','<localleader>i', ":CellInsertHere<cr>",{desc="Insert cell here"})
  vim.keymap.set('n','<localleader>v', ':CellVisualSelect<cr>',{desc="Visual select cell"})
  vim.keymap.set('n','<localleader>ff', ':CellToggleFold<cr>',{desc="Toggle cell fold"})
  vim.keymap.set('n','<localleader>fc', ':CellFoldAll<cr>',{desc="Fold all cells"})
  vim.keymap.set('n','<localleader>fo', ':CellUnfoldAll<cr>',{desc="Unfold all cells"})
end

function M.set_send_mappings()
  vim.keymap.set('n','<localleader>rsr', ':CellSendLine<cr>',{desc="Send line"})
  vim.keymap.set('v','<localleader>rs',':<c-u>CellSendVisual<cr>',{desc="Send visual"})
  vim.keymap.set('n','<localleader>ese', ':CellSend<cr>',{desc="Send cell"})
  vim.keymap.set('n','<localleader>rse', ':CellSendAndJump<cr>',{desc="Send cell and jump"})
  vim.keymap.set('n','<localleader>rsf', ':CellSendFile<cr>', {desc="Send file"})

  vim.keymap.set('n','<localleader>rr', ':CellPutLine<cr>',{desc="Yank and put line"})
  vim.keymap.set('v','<localleader>r',':<c-u>CellPutVisual<cr>',{desc="Yank and put visual"})
  vim.keymap.set('n','<localleader>ee', ':CellPut<cr>',{desc="Yank and put cell"})
  vim.keymap.set('n','<localleader>re', ':CellPutAndJump<cr>',{desc="Yank and put cell and jump"})
  vim.keymap.set('n','<localleader>rf', ':CellPutFile<cr>', {desc="Yank and put file"})
end

function M.set_filetype_send_mappings()
  local buf_type = vim.o.filetype
  local buf_info = config[buf_type]
  if (buf_info ~= nil) and (buf_info.repl ~= nil) then
    local repl_str = buf_info.repl
    vim.keymap.set('n','<localleader>ri', function()send.send_command(repl_str,true,true)end,{desc="Start REPL",buffer=true})
  end
  if (buf_info ~= nil) and (buf_info.file_send ~= nil) then
    local command = buf_info.file_send.." "..vim.api.nvim_buf_get_name(0)
    vim.keymap.set('n','<localleader>rF', function()send.send_command(command,true,true)end,{desc="Run file in terminal",buffer=true})
  end
end

function M.get_envs(buf_info)
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

function M.set_filetype_env_mappings()
  local buf_type = vim.o.filetype
  local buf_info = config[buf_type]
  if (buf_info ~= nil) and (buf_info.env_cmd ~= nil) then
    local envs = M.get_envs(buf_info)
    local env_syms = get_env_symbols(envs)
    for i,s in pairs(env_syms) do
      local env = envs[i]
      local env_str = buf_info.env_cmd.." "..env
      local env_func = function()
        send.send_command(env_str,true,true)
      end
      vim.keymap.set('n','<localleader>ra'..s, env_func,{desc="Env: activate "..env,buffer=true})
    end
  end
end

function M.set_textobject_mappings()
  vim.keymap.set('x', 'ic', function()cells.visual_select_in_cell(cells.get_marker())end, {desc="inner cell"})
  vim.keymap.set('x', 'ac', function()cells.visual_select_around_cell(cells.get_marker())end, {desc="outer cell"})
  vim.keymap.set('o', 'ic', function()cells.visual_select_in_cell(cells.get_marker())end, {desc="inner cell"})
  vim.keymap.set('o', 'ac', function()cells.visual_select_around_cell(cells.get_marker())end, {desc="outer cell"})
  vim.keymap.set('x', 'tc', function()cells.visual_select_till_cell(cells.get_marker())end, {desc="till cell"})
  vim.keymap.set('x', 'Tc', function()cells.visual_select_back_till_cell(cells.get_marker())end, {desc="back till cell"})
  vim.keymap.set('o', 'tc', function()cells.visual_select_till_cell(cells.get_marker())end, {desc="till cell"})
  vim.keymap.set('o', 'Tc', function()cells.visual_select_back_till_cell(cells.get_marker())end, {desc="back till cell"})
  vim.keymap.set('x', 'fc', function()cells.visual_select_to_cell(cells.get_marker())end, {desc="to cell"})
  vim.keymap.set('x', 'Fc', function()cells.visual_select_back_to_cell(cells.get_marker())end, {desc="back to cell"})
  vim.keymap.set('o', 'fc', function()cells.visual_select_to_cell(cells.get_marker())end, {desc="to cell"})
  vim.keymap.set('o', 'Fc', function()cells.visual_select_back_to_cell(cells.get_marker())end, {desc="back to cell"})
end

return M
