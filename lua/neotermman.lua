local M = {}
M["is-term-open"] = false
M["win-id"] = nil
local harpoon = require("harpoon.term")
local function nvim_cmd(cmd)
  return vim.api.nvim_command(cmd)
end
local function api(cmd)
  return vim.api[cmd]
end
local function _1_()
  nvim_cmd("sp")
  nvim_cmd("wincmd J")
  local current_win = vim.api.nvim_get_current_win()
  M["win-id"] = current_win
  vim.api.nvim_win_set_height(current_win, 10)
  harpoon.gotoTerminal(1)
  return nvim_cmd("set nobuflisted")
end
M["open-term"] = _1_
local function _2_()
  if vim.api.nvim_call_function("win_gotoid", {M["win-id"]}) then
    return vim.api.nvim_win_close(M["win-id"], {})
  else
    return nil
  end
end
M["close-term"] = _2_
local function _4_()
  M["is-term-open"] = not M["is-term-open"]
  if __fnl_global__win_2did then
    local has_term = vim.api.nvim_win_is_valid(M["win-id"])
    if has_term then
      return __fnl_global__close_2dterm()
    else
      return __fnl_global__open_2dterm()
    end
  else
    return __fnl_global__open_2dterm()
  end
end
M["toggle-term"] = _4_
vim.keymap.set("n", "<leader>tt", M["toggle-term"])
M.test = 4
print("loaded neotermman")
return M
