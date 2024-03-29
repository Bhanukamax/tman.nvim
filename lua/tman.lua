---@toc tman.nvim

---@divider
---@mod tman.introduction Introduction
---@brief [[
--- Tman.nvim is a light weight plugin to manage a terminal buffer in neovim.
---@brief ]]
local M = {}

local tman = {}


tman.split = "bottom"
tman.width = 50
tman.height =  40
tman.lastSide = "bottom"
tman.cmdSplit = "bottom"
tman.wo = {
    nu = false,
    rnu = false,
    scl = 'no'
}

---@mod tman.setup Setup
---Trigger a rebuild of one or more projects.
---@param opts table optional configuration options:
---  * {cmdSplit} (string) optional
---    "right", "bottom", "last" defaults to ""
---    used determing the split position of the terminal buffer when running a :TmanCmd and :TmanCmdLast
---
---  * {split} (string) optional
---    "right" or "bottom" defaults to "bottom"
---
---  * {width} (number) 1 to 100 width of the terminal window
---    consdered as a percentage
---      defaults to 50
---
---  * {height} (number) 1 to 100 height of the terminal window
---    consdered as a percentage
---      defaults to 40
---
---  * {wo} (table) optional
---    window options for the terminal window
---      defaults to {nu = false, rnu = false, scl = 'no'}
---      no numbers and no sign column for simple look
---      you may override these with the wo table
---@usage `require"tman".setup { split = "right", height = 40, wo = { nu = true } }`
M.setup = function (opts)
    tman.lastSide = opts.split or "bottom"
    M._setup(opts)
end

---@private
---Setup tman but does not change tman.lastSide
---The main M.setup function should never be used inside the plugin code
M._setup = function (opts)
    opts = M.validateAndGetWithSplit(opts)
    tman.split = opts.split or "bottom"
    tman.width = opts.width or 50
    tman.height= opts.height or 40
    tman.cmdSplit = opts.cmdSplit or "bottom"

    if rawget(opts, 'wo') == nil then
        opts.wo = {}
    end
    for k,v in pairs(opts.wo) do
        tman.wo[k] = v
    end
end

---@private
M._debug = function ()
    vim.pretty_print(tman)
end

---@mod tman.toggleTerm Toggling Terminals
---Toggle terminal from the last side toggled
---Depends on the last call to tman.toggleRight or tman.toggleBottom
---Defaults to whatever is set at the time of setup as 'split'
---also callable as tman.toggleLast
M.toggleTerm = function(tbl)
    local opt = {split = tman.lastSide}
    if tbl then
        opt.insert = tbl.insert or false
    end
    M._toggleTerm(opt)
end

---@tag tman.toggleLast
---Same as toggleTerm
M.toggleLast = M.toggleTerm

---@tag tman.toggleDefault
---Previously called toggleTerm
---Toggles the terminal window from the side set as 'split' at the time of setup.
M.toggleDefault = function ()
    local split = tman.split
    M._toggleTerm({ split = split })
end

---@private
M._isTermValid = function ()
    for _,b in ipairs(vim.api.nvim_list_bufs()) do
        if b == tman.buf then
            return true
        end
    end
    return false
end

---opens the bottom terminal
---@private
M._openTerm = function (tbl)
    local split = tbl.split
    tman.last_buf_id = vim.api.nvim_get_current_buf()

    -- Create a split and move to the correct position
    vim.cmd.sp()
    local winDir = "J"
    if split == "right" then winDir = "L" end
    vim.cmd.wincmd(winDir)

    M._set_term_buffer()

    if tbl.insert then vim.cmd "normal! i" end

    M._set_dimensions(vim.api.nvim_get_current_win(), split)
end

---@private
M._set_term_buffer = function ()
    if M._isTermValid() then
        vim.api.nvim_set_current_buf(tman.buf)
    else
        vim.cmd.term()
        tman.win = vim.api.nvim_get_current_win()
        tman.buf = vim.api.nvim_win_get_buf(tman.win)
        tman.term = vim.b.terminal_job_id
        M._set_window_options()
    end
end

---@private
M._set_dimensions = function (win, split)
    if split == "right" then
        vim.api.nvim_win_set_width(win, math.floor(vim.o.columns / 100 * tman.width ))
    elseif split == "bottom" then
        vim.api.nvim_win_set_height(win, math.floor(vim.o.lines / 100 * tman.height ))
    end
end

---@private
M._set_window_options = function ()
    for k,v in pairs(tman.wo) do
        vim.api.nvim_win_set_option(tman.win, k, v)
    end
end

---@private
M.validateAndGetWithSplit = function (opt)
    if opt.split == "last" then
        opt.split = tman.lastSide
        return opt
    end
    if opt.split ~= nil then
        if not (opt.split == "right" or opt.split == "bottom") then
            vim.notify("Invalid split " .. opt.split, vim.log.levels.ERROR)
            opt.split = tman.split
        end
    else
        opt.split = tman.split
    end
    return opt
end

---@private
M.debug = function ()
    vim.pretty_print(tman)
end

---@private
M.hasOnlyTermWins = function()
    for _,v in pairs(vim.api.nvim_list_wins()) do
        local cbuf_id = vim.api.nvim_win_get_buf(v)
        if cbuf_id ~= tman.buf then
            return false
        end
    end
    return true
end

---@private
M.hasTermWin = function()
    for _,v in pairs(vim.api.nvim_list_wins()) do
        local cbuf_id = vim.api.nvim_win_get_buf(v)
        if cbuf_id == tman.buf then
            return true
        end
    end
    return false
end

---@private
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

---@tag tman.toggleBottom
---Toggle terminal from bottom
M.toggleBottom = function()
    M._toggleTerm({ split = "bottom" })
end

---@tag tman.toggleRight
---Toggle terminal from right
M.toggleRight = function()
    M._toggleTerm({ split = "right" })
end



---@private
M._toggleTerm = function (tbl)
    local split = tbl.split
    tman.lastSide = split

    if M.closeTermIfOpen() == false then
        M._openTerm({ split = split, insert = tbl.insert })
    end
end

---@private
M.goToTerm = function ()
    local win_id = vim.api.nvim_get_current_win()
    if tman.buf == nil then
        vim.cmd[[ term ]]
        tman.buf = vim.api.nvim_win_get_buf(win_id)
    else
        vim.api.nvim_win_set_buf(win_id, tman.buf)
    end
end

---@mod tman.sendCommand Sending Commands
---@param cmd string command to be sent to the terminal
---       end with '\r' to send a carriage return
---@param options table optional configuration options:
---  * {split} (string) optional "right", "bottom" or "last"
---    defaults to the value set at the time of setup
---    "last" opens the terminal from last open side
---  * {pre} (string) optional command to run before sending the command
---  * {scrollTop} (boolean} optional scroll the terminal prompt to top before executing command
---                 defaults to true
M.sendCommand = function(cmd, options)
    if rawget (options, "scrollTop") == nil then
        options.scrollTop = true
    end

    options = M.validateAndGetWithSplit(options)

    local oldTbl = {
        split = tman.split,
        width = tman.width,
        height = tman.height,
        cmdSplit = tman.cmdSplit,
    }
    local tbl = {
        split = options.split or oldTbl.split,
        width = options.width or oldTbl.width,
        height = options.height or oldTbl.height,
        cmdSplit = options.cmdSplit or oldTbl.cmdSplit,
    }
    M._setup(tbl)
    if not M._isTermValid() then
        M._openTerm({split = tbl.split})
        M.closeTermIfOpen()
    end
    if options.pre then
        vim.api.nvim_chan_send(tman.term, options.pre .. '\r')
    end
    if options.open and not M.hasTermWin() then
        M._openTerm({split = tbl.split})
        if options.scrollTop then
            vim.api.nvim_chan_send(tman.term, 'clear \r')
            vim.cmd "normal! G"
        end
    end
    vim.api.nvim_chan_send(tman.term, cmd)
    M._setup(oldTbl)
end

---@tag TmanCmd
---Send command interactively to terminal
vim.api.nvim_create_user_command("TmanCmd",
    function()
        local cmd = ""
        local status = pcall(function ()
             cmd = vim.fn.input({ prompt = "Command: "})
        end)
        if not status then return end
        if not cmd or cmd == "" then return end
        vim.g.tman_last_cmd = cmd
        M.sendCommand(cmd .. "\r", { open = true, split = tman.cmdSplit })
    end,
    {}
)

vim.api.nvim_create_user_command("TmanCmdLast",
    function()
        local cmd = vim.g.tman_last_cmd
        if not cmd or cmd == "" then return end
        M.sendCommand(cmd .. "\r", { open = true, split = tman.cmdSplit })
    end,
    {}
)

return M
