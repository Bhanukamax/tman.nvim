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
  is_term_open = not is_term_open
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
  is_term_open = not is_term_open
  if vim.api.nvim_call_function("win_gotoid", {win_id}) then
    return vim.api.nvim_win_close(win_id, {})
  else
    return nil
  end
end
local function toggle_last_term()
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
local function toggle_term_with_number(n)
  is_different_terminal = (M["current-term-number"] == n)
  M["current-term-number"] = n
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
local function toggle_term(n)
  if (nil == n) then
    return toggle_last_term()
  else
    return toggle_term_with_number(n)
  end
end
M.toggle = toggle_term
local function init(opt)
  local function _8_()
    return M.toggle(nil)
  end
  vim.keymap.set("n", opt.toggle, _8_)
  for i = 1, 9, 1 do
    local function _9_()
      return M.toggle(i)
    end
    vim.keymap.set("n", (opt.prefix .. i), _9_)
  end
  return nil
end
M.init = init
return M
