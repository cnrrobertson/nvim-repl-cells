local M = {}

function M.get_cell_bounds(marker)
    local start_row = vim.api.nvim_win_get_cursor(0)[1]
    local buf_len = vim.api.nvim_buf_line_count(0)

    local top_row = nil
    local row_num = start_row
    while(top_row == nil)
    do
        local temp_row = vim.api.nvim_buf_get_lines(0, row_num-1, row_num, false)[1]
        if(string.find(temp_row, marker) ~= nil)
        then
            top_row = row_num+1
        end
        row_num = row_num - 1
        if(row_num == 1)
        then
            top_row = 1
        end
    end
    local bot_row = nil
    row_num = start_row
    while(bot_row == nil)
    do
        local temp_row = vim.api.nvim_buf_get_lines(0, row_num-1, row_num, false)[1]
        if(string.find(temp_row, marker) ~= nil)
        then
            bot_row = row_num-1
        end
        row_num = row_num + 1
        if(row_num == buf_len)
        then
            bot_row = buf_len
        end
    end
    return top_row, bot_row
end

function M.send_cell_to_repl(marker)
    local top_row, bot_row = get_cell_bounds(marker)
    vim.fn["neoterm#repl#line"](top_row, bot_row)
end

function M.send_cell_to_repl_and_jump(marker)
    local top_row, bot_row = get_cell_bounds(marker)
    vim.fn["neoterm#repl#line"](top_row, bot_row)
    local buf_len = vim.api.nvim_buf_line_count(0)
    if(bot_row ~= buf_len)
    then
        vim.api.nvim_win_set_cursor(0, {bot_row+2, 1})
    end
end

function M.insert_cell_above(marker)
    local top_row, _ = get_cell_bounds(marker)
    vim.api.nvim_buf_set_lines(0, top_row, top_row, false, {marker, "", ""})
end

function M.insert_cell_below(marker)
    local _, bot_row = get_cell_bounds(marker)
    vim.api.nvim_buf_set_lines(0, bot_row, bot_row, false, {"", marker, ""})
end
