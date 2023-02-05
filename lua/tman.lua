local M = {}

local tman = {}

local create_term_buffer = function()
    tman.buf = vim.api.nvim_create_buf(true, false)
end

M.debug = function ()
    vim.pretty_print(tman)
end

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

return M
