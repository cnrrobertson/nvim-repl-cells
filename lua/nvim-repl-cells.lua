local M = {}
local vim = vim
local config = require("nvim-repl-cells.config")

-----------------------------------
-- UTILITIES --
-----------------------------------
function M.get_marker()
  local buf_type = vim.o.filetype
  local buf_info = config[buf_type]
  if (buf_info == nil) or (buf_info.marker == nil) then
    return config.marker
  else
    return buf_info.marker
  end
end

function M.get_cell_top(start_row, marker)
  -- Change string to Lua regex pattern format
  local pattern = string.gsub(marker, "%%", "%%%%")
  
  local top_row = nil
  local row_num = start_row
  while(top_row == nil) do
    local temp_row = vim.api.nvim_buf_get_lines(0, row_num-1, row_num, false)[1]
    if(string.find(temp_row, pattern) == 1)
    then
      top_row = row_num+1
    else
      row_num = row_num - 1
      if(row_num <= 1)
      then
        top_row = 1
      end
    end
  end
  return top_row
end

function M.get_cell_bottom(start_row, marker)
  -- Change string to Lua regex pattern format
  local pattern = string.gsub(marker, "%%", "%%%%")

  local buf_len = vim.api.nvim_buf_line_count(0)
  local bot_row = nil
  local row_num = start_row
  if(start_row ~= buf_len)
  then
    row_num = start_row+1
  else
    row_num = start_row
  end
  while(bot_row == nil) do
    local temp_row = vim.api.nvim_buf_get_lines(0, row_num-1, row_num, false)[1]
    if(string.find(temp_row, pattern) == 1)
    then
      bot_row = row_num-1
    else
      row_num = row_num + 1
      if(row_num >= buf_len)
      then
        bot_row = buf_len
      end
    end
  end
  return bot_row
end

function M.get_cell_bounds(start_row, marker)
  local top_row = M.get_cell_top(start_row, marker)
  local bot_row = M.get_cell_bottom(start_row, marker)
  return top_row, bot_row
end

-----------------------------------
-- TEXTOBJECT SELECTIONS --
-----------------------------------
function M.visual_select_in_cell(marker)
  local start_row = vim.api.nvim_win_get_cursor(0)[1]
  local top_row, bot_row = M.get_cell_bounds(start_row, marker)
  vim.cmd("normal! ")
  vim.fn.setpos(".", { '.', top_row, 0, 0 })
  vim.cmd("normal! V")
  vim.fn.setpos(".", { '.', bot_row, 0, 0 })
end

function M.visual_select_around_cell(marker)
  local start_row = vim.api.nvim_win_get_cursor(0)[1]
  local top_row, bot_row = M.get_cell_bounds(start_row, marker)
  vim.cmd("normal! ")
  vim.fn.setpos(".", { '.', math.max(top_row-1,1), 0, 0 })
  vim.cmd("normal! V")
  vim.fn.setpos(".", { '.', bot_row, 0, 0 })
end

function M.visual_select_till_cell(marker)
  local start_row = vim.api.nvim_win_get_cursor(0)[1]
  local bot_row = M.get_cell_bottom(start_row, marker)
  vim.cmd("normal! ")
  vim.fn.setpos(".", { '.', start_row, 0, 0 })
  vim.cmd("normal! V")
  vim.fn.setpos(".", { '.', bot_row, 0, 0 })
end

function M.visual_select_back_till_cell(marker)
  local start_row = vim.api.nvim_win_get_cursor(0)[1]
  local top_row = M.get_cell_top(start_row, marker)
  vim.cmd("normal! ")
  vim.fn.setpos(".", { '.', start_row, 0, 0 })
  vim.cmd("normal! V")
  vim.fn.setpos(".", { '.', math.max(top_row,1), 0, 0 })
end

function M.visual_select_to_cell(marker)
  local start_row = vim.api.nvim_win_get_cursor(0)[1]
  local bot_row = M.get_cell_bottom(start_row, marker)
  vim.cmd("normal! ")
  vim.fn.setpos(".", { '.', start_row, 0, 0 })
  vim.cmd("normal! V")
  vim.fn.setpos(".", { '.', bot_row+1, 0, 0 })
end

function M.visual_select_back_to_cell(marker)
  local start_row = vim.api.nvim_win_get_cursor(0)[1]
  local top_row = M.get_cell_top(start_row, marker)
  vim.cmd("normal! ")
  vim.fn.setpos(".", { '.', start_row, 0, 0 })
  vim.cmd("normal! V")
  vim.fn.setpos(".", { '.', math.max(top_row-1,1), 0, 0 })
end

-----------------------------------
-- ADDING/REMOVING CELLS --
-----------------------------------
function M.insert_cell_here(marker)
  local start_row = vim.api.nvim_win_get_cursor(0)[1]
  vim.api.nvim_buf_set_lines(0, start_row-1, start_row-1, false, {marker})
  vim.api.nvim_win_set_cursor(0, {start_row+1, 0})
  M.highlight_cells(marker)
end

function M.insert_cell_above(marker)
  local start_row = vim.api.nvim_win_get_cursor(0)[1]
  local top_row = M.get_cell_top(start_row, marker)
  vim.api.nvim_buf_set_lines(0, top_row-1, top_row-1, false, {"", "", marker})
  vim.api.nvim_win_set_cursor(0, {top_row, 0})
  M.highlight_cells(marker)
end

function M.insert_cell_below(marker)
  local start_row = vim.api.nvim_win_get_cursor(0)[1]
  local bot_row = M.get_cell_bottom(start_row, marker)
  vim.api.nvim_buf_set_lines(0, bot_row, bot_row, false, {"", marker, "", ""})
  vim.api.nvim_win_set_cursor(0, {bot_row+3, 0})
  M.highlight_cells(marker)
end

function M.delete_cell(marker)
  local start_row = vim.api.nvim_win_get_cursor(0)[1]
  local top_row, bot_row = M.get_cell_bounds(start_row, marker)
  if(top_row ~= 1)
  then
    top_row = top_row - 1
  end
  vim.api.nvim_buf_set_lines(0, top_row-1, bot_row, false, {})
  M.highlight_cells(marker)
end

function M.split_cell(marker)
  local start_row = vim.api.nvim_win_get_cursor(0)[1]
  vim.api.nvim_buf_set_lines(0, start_row, start_row, false, { "", marker, ""})
  vim.api.nvim_win_set_cursor(0, {start_row+3, 0})
  M.highlight_cells(marker)
end

function M.merge_cell_below(marker)
  local buf_len = vim.api.nvim_buf_line_count(0)
  local start_row = vim.api.nvim_win_get_cursor(0)[1]
  local bot_row = M.get_cell_bottom(start_row, marker)
  if bot_row == buf_len then
    return
  end
  vim.api.nvim_buf_set_lines(0, bot_row, bot_row+1, false, {})
  M.highlight_cells(marker)
end

function M.merge_cell_above(marker)
  local start_row = vim.api.nvim_win_get_cursor(0)[1]
  local top_row = M.get_cell_top(start_row, marker)
  if top_row == 1 then
    return
  end
  vim.api.nvim_buf_set_lines(0, top_row-2, top_row-1, false, {})
  M.highlight_cells(marker)
end

-----------------------------------
-- NAVIGATING CELLS --
-----------------------------------
function M.jump_to_next_cell(marker)
  local start_row = vim.api.nvim_win_get_cursor(0)[1]
  local bot_row = M.get_cell_bottom(start_row, marker)
  local buf_len = vim.api.nvim_buf_line_count(0)
  if(bot_row ~= buf_len)
  then
    vim.api.nvim_win_set_cursor(0, {bot_row+2, 0})
  end
end

function M.jump_to_previous_cell(marker)
  local start_row = vim.api.nvim_win_get_cursor(0)[1]
  local top_row = M.get_cell_top(start_row, marker)
  if(top_row ~= 1)
  then
    local new_top_row = M.get_cell_top(top_row-2, marker)
    vim.api.nvim_win_set_cursor(0, {new_top_row, 0})
  end
end

-----------------------------------
-- MOVING CELLS --
-----------------------------------
function M.move_cell_down(marker)
  local start_row = vim.api.nvim_win_get_cursor(0)[1]
  local buf_len = vim.api.nvim_buf_line_count(0)
  local top_row1, bot_row1 = M.get_cell_bounds(start_row, marker)
  local start_pos = start_row-top_row1
  if(bot_row1 ~= buf_len) then
    local top_row2, bot_row2 = M.get_cell_bounds(bot_row1+1, marker)
    local cell1 = vim.api.nvim_buf_get_lines(0,top_row1-1,bot_row1,false)
    local cells = vim.api.nvim_buf_get_lines(0,top_row2-1,bot_row2,false)
    local len_cell2 = #cells
    table.insert(cells, marker)
    for _,line in ipairs(cell1) do
      table.insert(cells, line)
    end
    vim.api.nvim_buf_set_lines(0,top_row1-1,bot_row2,false,cells)
    vim.api.nvim_win_set_cursor(0, {top_row1+1+len_cell2+start_pos, 0})
  end
  M.highlight_cells(marker)
end

function M.move_cell_up(marker)
  local start_row = vim.api.nvim_win_get_cursor(0)[1]
  local top_row2, bot_row2 = M.get_cell_bounds(start_row, marker)
  local start_pos = start_row-top_row2
  if(top_row2 ~= 1) then
    local top_row1, bot_row1 = M.get_cell_bounds(top_row2-2, marker)
    local cell1 = vim.api.nvim_buf_get_lines(0,top_row1-1,bot_row1,false)
    local cells = vim.api.nvim_buf_get_lines(0,top_row2-1,bot_row2,false)
    table.insert(cells, marker)
    for _,line in ipairs(cell1) do
      table.insert(cells, line)
    end
    vim.api.nvim_buf_set_lines(0,top_row1-1,bot_row2,false,cells)
    vim.api.nvim_win_set_cursor(0, {top_row1+start_pos, 0})
  end
  M.highlight_cells(marker)
end

-----------------------------------
-- VISUALIZING CELLS --
-----------------------------------

function M.highlight_cells(marker)
  local buf_len = vim.api.nvim_buf_line_count(0)
  local current_row = 1
  local ns_id = vim.api.nvim_create_namespace('cells')
  vim.api.nvim_buf_clear_namespace(0,ns_id,0,-1)
  local top_row, bot_row = M.get_cell_bounds(current_row, marker)
  if top_row ~= 1
  then
    vim.api.nvim_buf_set_extmark(0,ns_id,0,-1,{hl_eol=true,line_hl_group="ColorColumn"})
  end
  while bot_row ~= buf_len
  do
    vim.api.nvim_buf_set_extmark(0,ns_id,bot_row,-1,{hl_eol=true,line_hl_group="ColorColumn"})
    -- vim.api.nvim_buf_add_highlight(0,-1,"Beacon",k-1,0,-1)
    current_row = bot_row + 2
    top_row, bot_row = M.get_cell_bounds(current_row, marker)
  end
end

function M.toggle_cell_fold(marker)
  local start_row = vim.api.nvim_win_get_cursor(0)[1]
  local bot_row = M.get_cell_bottom(start_row, marker)
  if vim.fn.foldclosed(bot_row) == -1
  then
    M.fold_cell(start_row, marker)
  else
    M.unfold_cell(start_row, marker)
  end
end

function M.fold_cell(row,marker)
  local top_row, bot_row = M.get_cell_bounds(row, marker)
  if vim.fn.foldlevel(row) == 0
  then
    if top_row ~= 1
    then
      vim.api.nvim_command(":"..tostring(top_row-1)..","..tostring(bot_row).."fold")
    else
      vim.api.nvim_command(":"..tostring(top_row)..","..tostring(bot_row).."fold")
    end
  else
    vim.api.nvim_command(":"..tostring(bot_row).."foldclose")
  end
end

function M.unfold_cell(row,marker)
  -- Use bottom row of cell to determine fold status as it is often a blank line
  local bot_row = M.get_cell_bottom(row, marker)
  vim.api.nvim_command(":"..tostring(bot_row).."foldopen")
end

function M.fold_all_cells(marker)
  local buf_len = vim.api.nvim_buf_line_count(0)
  local current_row = 1
  local top_row, bot_row = M.get_cell_bounds(current_row, marker)
  while bot_row ~= buf_len
  do
    M.fold_cell(top_row, marker)
    current_row = bot_row + 1
    top_row, bot_row = M.get_cell_bounds(current_row, marker)
  end
  if (top_row ~= 1) -- Case of no cell
  then
    M.fold_cell(top_row, marker)
  end
end

function M.unfold_all_cells(marker)
  local buf_len = vim.api.nvim_buf_line_count(0)
  local current_row = 1
  local top_row, bot_row = M.get_cell_bounds(current_row, marker)
  while bot_row ~= buf_len
  do
    M.unfold_cell(top_row, marker)
    current_row = bot_row + 2
    top_row, bot_row = M.get_cell_bounds(current_row, marker)
  end
  if (top_row ~= 1) -- Case of no cell
  then
    M.unfold_cell(top_row, marker)
  end
end

function M.set_foldtext()
  function _G.custom_foldtext()
    local foldstart = vim.v.foldstart
    local line1 = vim.fn.getline(foldstart)
    local line2 = vim.fn.getline(foldstart+1)
    local line_count = vim.v.foldend - foldstart + 1
    return " ⚡ "..line_count.." lines: "..line1.." // "..line2
  end
  vim.opt.foldtext = "v:lua.custom_foldtext()"
end

return M
