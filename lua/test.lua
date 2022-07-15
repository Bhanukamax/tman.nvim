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
vim.keymap.set("n", "<leader>to", toggle_term)
vim.keymap.set("n", "<leader>tt", toggle_term)
local function run_term_command(command)
  local ctrl_c = "\3"
  return (require("harpoon.term")).sendCommand(1, (ctrl_c .. "\n" .. command .. "\n"))
end
local function run_build_command(cmd)
  local build_command = vim.api.nvim_get_var(cmd)
  local ctrl_c = "\3"
  do end (require("harpoon.term")).sendCommand(1, (ctrl_c .. "\n" .. build_command .. "\n"))
  return print("build done")
end
local function _4_()
  return run_build_command("buildCommand")
end
vim.keymap.set("n", "<leader>dd", _4_)
local function _5_()
  return run_build_command("testCommand")
end
vim.keymap.set("n", "<leader>de", _5_)
local function clear()
  nvim_cmd("set guicursor=a:block")
  nvim_cmd("noh")
  return nvim_cmd("diffupdate")
end
return vim.keymap.set("n", "<c-l>", clear)
