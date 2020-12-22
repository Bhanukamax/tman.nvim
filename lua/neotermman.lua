
local win, cb
local function set_mapping()
    local mappings = {
        q = 'close_window()',
        w = 'close_window()',
    }


    for k, v in pairs(mappings) do
        vim.api.nvim_buf_set_keymap(buf, 'n', k, ':lua require"bmax-test".'..v..'<cr>', {
            nowait = true, noremap = true, silent = true
        })
    end

end





local function close_window()
    --print("Trying to close")
    --vim.api.nvim_win_close(win, true)
    vim.cmd(":q")
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
    --print(vim.inspect(buf_list))
    return found_buf
end

local function open_bmax_term()
    --set_mapping()
    local term_buf =  get_existing_term_buf()

    if term_buf then
        win = vim.api.nvim_get_current_win()
        vim.api.nvim_win_set_buf(win, term_buf.number)
    else
        vim.cmd(":term")
        vim.cmd(":set nobuflisted")
    end
end

local function open_floating_term()
    local term_buf =  get_existing_term_buf()
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

    vim.api.nvim_open_win(term_buf.number, true, {
        relative = "win",
        width = win_width,
        height = win_height,
        row = 1,
        col = 2,
    })

    if is_new_term_buf then
        print("this is a new buf")
        vim.cmd(":term")
        vim.cmd(":set nobuflisted")
    else

        print("this NOT is a new buf")

    end

end



return {
    bmax_test = bmax_test,
    get_listed_bufs = get_listed_bufs,
    close_window = close_window,
    open_bmax_term = open_bmax_term,
    open_floating_term = open_floating_term,
}
