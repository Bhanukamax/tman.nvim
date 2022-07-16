local tman = require("neotermman")
print(vim.inspect(tman))
print("test")
return vim.keymap.set("n", "<leader>tt", tman.toggle)
