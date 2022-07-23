local M = {}
local is_term_open = false
local win_id = nil
local is_different_terminal = false
local harpoon = require("harpoon.term")
M["current-term-number"] = 1
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
  harpoon.gotoTerminal(M["current-term-number"])
  return nvim_cmd("set nobuflisted")
end
local function switch_to_term(n)
  vim.api.nvim_call_function("win_gotoid", {win_id})
  return harpoon.gotoTerminal(n)
end
local function close_term()
  if vim.api.nvim_call_function("win_gotoid", {win_id}) then
    return vim.api.nvim_win_close(win_id, {})
  else
    return nil
  end
end
local function toggle_term(n)
  is_different_terminal = (M["current-term-number"] == n)
  M["current-term-number"] = n
  is_term_open = not is_term_open
  if win_id then
    local has_term = vim.api.nvim_win_is_valid(win_id)
    if has_term then
      if is_different_terminal then
        return close_term()
      else
        return switch_to_term(n)
      end
    else
      return open_term()
    end
  else
    return open_term()
  end
end
M.toggle = toggle_term
return M
