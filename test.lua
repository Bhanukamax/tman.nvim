local tman = require("neotermman")
print(vim.inspect(tman))
print("test")
local function _1_()
  return tman.toggle(1)
end
vim.keymap.set("n", "<leader>tt", _1_)
local function _2_()
  return tman.toggle(2)
end
return vim.keymap.set("n", "<leader>t2", _2_)
