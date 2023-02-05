local M = {}

local tman = {}

local pprint = function (tbl)
   vim.pretty_print(tbl)
end

-- Goal is to drop harpoon as a dependency
M.debug = function ()
    pprint(tman)
end

M.isTermValid = function ()
    for _,b in ipairs(vim.api.nvim_list_bufs()) do
        if b == tman.buf then
            return true
        end
    end
    return false
end

-- opens the bottom terminal
M.openTerm = function ()
    tman.last_buf_id = vim.api.nvim_get_current_buf()
    if M.isTermValid() then
    vim.cmd[[
    sp
    wincmd J
    ]]
        vim.api.nvim_set_current_buf(tman.buf)
        return
    end

    vim.cmd[[
    sp
    wincmd J
    term
    ]]
    tman.win = vim.api.nvim_get_current_win()
    tman.buf = vim.api.nvim_win_get_buf(tman.win)
    tman.term = vim.b.terminal_job_id
end

M.sendCommand = function(cmd, shouldOpen)
    if M.isTermValid() then
        vim.api.nvim_chan_send(tman.term, cmd)
    else
        M.openTerm()
        vim.api.nvim_chan_send(tman.term, cmd)
    end
    if shouldOpen then
        if not M.hasTermWin() then
            M.openTerm()
        end
    end
end

M.sendCommandLn = function(cmd, shouldOpen)
    M.sendCommand(cmd .. "\n", shouldOpen)
end

M.hasOnlyTermWins = function()
    for _,v in pairs(vim.api.nvim_list_wins()) do
        local cbuf_id = vim.api.nvim_win_get_buf(v)
        if cbuf_id ~= tman.buf then
            return false
        end
    end
    return true
end

M.hasTermWin = function()
    for _,v in pairs(vim.api.nvim_list_wins()) do
        local cbuf_id = vim.api.nvim_win_get_buf(v)
        if cbuf_id == tman.buf then
            return true
        end
    end
    return false
end

M.closeTermIfOpen = function()
    local hasTerm = M.hasTermWin()
    if M.hasOnlyTermWins() then
        if tman.last_buf_id then
            vim.api.nvim_win_set_buf(vim.api.nvim_get_current_win(), tman.last_buf_id)
        else
            vim.cmd[[bp]]
        end
    end

    for _,v in pairs(vim.api.nvim_list_wins()) do
        local cbuf = vim.api.nvim_win_get_buf(v)
        if tman.buf ==  cbuf then
            vim.api.nvim_win_close(v, false)
        end
    end
    return hasTerm
end

M.toggleTerm = function ()
  if M.closeTermIfOpen() == false then
        M.openTerm()
  end
end

M.goToTerm = function ()
    local win_id = vim.api.nvim_get_current_win()
    if tman.buf == nil then
        vim.cmd[[ term ]]
        tman.buf = vim.api.nvim_win_get_buf(win_id)
    else
        vim.api.nvim_win_set_buf(win_id, tman.buf)
    end
end

return M
