local M = {}

local tman = {}


local pprint = function (tbl)
    vim.pretty_print(tbl)
end

tman.split = "bottom"
tman.width = 50
tman.height =  40
tman.lastSide = "bottom"

M.setup = function (tbl)
    tbl = M.validateAndGetWithSplit(tbl)
    tman.split = tbl.split or "bottom"
    tman.width = tbl.width or 50
    tman.height= tbl.height or 40
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
M.openTerm = function (tbl)
    local split = tbl.split
    tman.last_buf_id = vim.api.nvim_get_current_buf()
    if split == "right" then
        vim.cmd[[
            sp
            wincmd L
            ]]
    elseif split == "bottom" then
        vim.cmd[[
            sp
            wincmd J
            ]]
    end

    if M.isTermValid() then
        vim.api.nvim_set_current_buf(tman.buf)
    else
        vim.cmd[[ term ]]
        tman.win = vim.api.nvim_get_current_win()
        tman.buf = vim.api.nvim_win_get_buf(tman.win)
        tman.term = vim.b.terminal_job_id
    end
    if tbl.insert then
        vim.cmd "normal! i"
    end
end

M.validateAndGetWithSplit = function (opt)
    if opt.split ~= nil then
        if not (opt.split == "right" or opt.split == "bottom") then
            vim.notify("Invalid split " .. opt.split, vim.log.levels.ERROR)
            opt.split = tman.split
        end
    end
    return opt
end

M.sendCommand = function(cmd, opt)
    opt = M.validateAndGetWithSplit(opt)
    local oldTbl = {
        split = tman.split,
        width = tman.width,
        height = tman.height,
    }
    local tbl = {
        split = opt.split or oldTbl.split,
        width = opt.width or oldTbl.width,
        height = opt.height or oldTbl.height,
    }
    M.setup(tbl)
    if not M.isTermValid() then
        M.openTerm({split = tbl.split})
    end
    if opt.pre then
        vim.api.nvim_chan_send(tman.term, opt.pre .. '\r')
    end
    vim.api.nvim_chan_send(tman.term, cmd)
    if opt.open then
        if not M.hasTermWin() then
            M.openTerm({split = tbl.split})
        end
    end
    tman.split = oldTbl.split
    tman.width = oldTbl.width
    tman.height = oldTbl.height
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

M.get_full_width = function ()
    local full_width = 0
    for _,v in pairs(vim.api.nvim_list_wins()) do
        full_width = full_width + vim.api.nvim_win_get_width(v)
    end
    return full_width
end

M.get_full_height = function ()
    local full_height = 0
    for _,v in pairs(vim.api.nvim_list_wins()) do
        full_height = full_height + vim.api.nvim_win_get_height(v)
    end
    return full_height
end

M.toggleBottom = function()
    M._toggleTerm({ split = "bottom" })
end

M.toggleRight = function()
    M._toggleTerm({ split = "right" })
end

M.toggleLast = function(tbl)
    local opt = {split = tman.lastSide}
    if tbl then
        opt.insert = tbl.insert or false
    end
    M._toggleTerm(opt)
end


M.toggleTerm = function ()
    local split = tman.split
    M._toggleTerm({ split = split })
end

M._toggleTerm = function (tbl)
    local split = tbl.split
    tman.lastSide = split
    if M.closeTermIfOpen() == false then
        M.openTerm({ split = split, insert = tbl.insert })

        local win = vim.api.nvim_get_current_win()
        if split == "right" then
            vim.api.nvim_win_set_width(win, math.floor(M.get_full_width() /100 * tman.width ))
        elseif split == "bottom" then
            vim.api.nvim_win_set_height(win, math.floor(M.get_full_height() /100 * tman.height ))
        end
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
