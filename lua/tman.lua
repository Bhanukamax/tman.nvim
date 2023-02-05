local M = {}

local tman = {}

-- Goal is to drop harpoon as a dependency
M.debug = function ()
    vim.pretty_print(tman)
end

-- opens the bottom terminal
M.openTerm = function ()
    vim.cmd[[
    sp
    wincmd J
    term
    ]]
    tman.win = vim.api.nvim_get_current_win()
    tman.buf = vim.api.nvim_win_get_buf(tman.win)
end


M.closeTerm = function()
    for _,v in pairs(vim.api.nvim_list_wins()) do
        local cbuf = vim.api.nvim_win_get_buf(v)
        if tman.buf ==  cbuf then
            vim.api.nvim_win_close(v, false)
        end
    end
end

M.goToTerm = function ()
    local win_id = vim.api.nvim_get_current_win()
    if tman.buf == nil then
        vim.cmd[[
    term
    ]]
        tman.buf = vim.api.nvim_win_get_buf(win_id)
    else
        vim.api.nvim_win_set_buf(win_id, tman.buf)
    end
end

return M
