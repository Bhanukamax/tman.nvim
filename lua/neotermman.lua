
local win, term_buf, floating_term_buf
--local function set_mapping()
    --local mappings = {
        --q = 'close_window()',
        --w = 'close_window()',
    --}


    --for k, v in pairs(mappings) do
        --vim.api.nvim_buf_set_keymap(term_buf, 'n', k, ':lua require"neotermman".'..v..'<cr>', {
            --nowait = true, noremap = true, silent = true
        --})
    --end

--end
local function go_back()
    vim.cmd(":bp")
end

local function set_mapping()
    local mappings = {
        q = 'go_back()',
    }

    for k, v in pairs(mappings) do
        vim.api.nvim_buf_set_keymap(term_buf, 'n', k, ':lua require"neotermman".'..v..'<cr>', {
            nowait = true, noremap = true, silent = true
        })
    end
end

local function set_float_mapping()
    local mappings = {
        q = 'close_window()',
    }


    for k, v in pairs(mappings) do
        vim.api.nvim_buf_set_keymap(floating_term_buf, 'n', k, ':lua require"neotermman".'..v..'<cr>', {
            nowait = true, noremap = true, silent = true
        })
    end
end


local function close_window()
    --print("Trying to close")
    --vim.api.nvim_win_close(win, true)
    vim.api.nvim_win_close(win, true)
end

local function get_existing_term_buf()
    local found_buf = nil
    local buf_list = vim.api.nvim_list_bufs()
    for k,v in pairs(buf_list) do
        local buf_name = vim.api.nvim_buf_get_name(v)
        --print(buf_name)
        if string.match(buf_name, "term://") then
            found_buf = {number = v, name = buf_name}
            
        end
    end
    return found_buf
end

local function attach_term()
    term_buf =  get_existing_term_buf()
    if term_buf then
        win = vim.api.nvim_get_current_win()
        vim.api.nvim_win_set_buf(win, term_buf.number)
    else
        vim.cmd(":term")
        vim.cmd(":set nobuflisted")
    end
    set_mapping()
end

local function open_floating_term()
    term_buf =  get_existing_term_buf()
    local is_new_term_buf = false

    if not term_buf then
        is_new_term_buf = true
        term_buf = {
            number = vim.api.nvim_create_buf("nobufliste", true)
        } 
    end

    local main_win = vim.api.nvim_list_uis()[1]

    local win_width = main_win.width - 4
    local win_height = main_win.height - 4

    local _options ={
        relative = "cursor",
        width = 20,
        height = 20,
        row = 0,
        col = 1,
        style= 'minimal'

    }
    local options = {
        relative = "win",
        width = win_width,
        height = win_height,
        row = 1,
        col = 2,
    }

    term_buf = term_buf.number
    --term_buf = vim.api.nvim_create_buf(false, true)
    --term_buf = vim.api.nvim_create_buf(false, true);

    win = vim.api.nvim_open_win(term_buf, true, options)

    if is_new_term_buf then
        print("this is a new buf")
        vim.cmd(":term")
        vim.cmd(":set nobuflisted")
    else

        print("this NOT is a new buf")

    end

    set_float_mapping()
end



return {
    close_window = close_window,
    go_back = go_back,
    attach_term = attach_term,
    open_floating_term = open_floating_term,
}
