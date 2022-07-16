local M = {}
local is_term_open = false
local win_id = nil
local harpoon = require("harpoon.term")
local function nvim_cmd(cmd)
  return vim.api.nvim_command(cmd)
end
local function api(cmd)
  return vim.api[cmd]
end
local function open_term()
  nvim_cmd("sp")
  nvim_cmd("wincmd J")
  local current_win = vim.api.nvim_get_current_win()
  win_id = current_win
  vim.api.nvim_win_set_height(current_win, 10)
  harpoon.gotoTerminal(1)
  return nvim_cmd("set nobuflisted")
end
local function close_term()
  if vim.api.nvim_call_function("win_gotoid", {win_id}) then
    return vim.api.nvim_win_close(win_id, {})
  else
    return nil
  end
end
local function toggle_term()
  is_term_open = not is_term_open
  if win_id then
    local has_term = vim.api.nvim_win_is_valid(win_id)
    if has_term then
      return close_term()
    else
      return open_term()
    end
  else
    return open_term()
  end
end
M.toggle = toggle_term
return M
