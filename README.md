# Neovim Terminal Manager


## Introduction


### Note:
- Tman.nvim is a simple light weight plugin to manage a terminal buffer in neovim

#### How to install

Add this to your packer or Lazy config

```lua
{
  'Bhanukamax/tman.nvim',
  branch = 'develop'
}
```


### Setup
#### Lua

```lua

local tman = require('neotermman')
tman.init({toggle = "<leader>gg", prefix = "<leader>t"})

-- setup how the terminal buffer is displayed
tman.setup {
  split = "bottom", -- supportd values: "bottom", "right"
  -- set width and height as a percentage of the terminal width and height
  -- shold be a integer between 1 to 100
  width = 50,
  height = 40,
}

```
### Useage

#### Toggle terminal
```lua
vim.keymap.set("n", "<A-;>", function ()
  tman.toggleTerm()
  vim.cmd "normal! i"
end)

vim.keymap.set("t", "<A-;>", function ()
  tman.toggleTerm()
end)

```
#### Send command


##### use gitk for the current file

```lua
local gitk_file = function()
  local filename = vim.fn.expand('%')
  local test_cmd = "gitk " .. filename .. "\r"
  vim.notify("Opennig gitk for file", "success", {
    timeout = 300,
    render = 'compact'
  })
  require("tman").sendCommand(test_cmd, {})
end
```

##### use as a vim-test stratergy
```lua

vim.cmd[[

function! Tman(cmd)

let g:cmd = a:cmd . "\n"
lua require("tman").sendCommand(vim.g.bmax_test_pefix .. vim.g.cmd, {open = true, split = "right"})
endfunction

let g:test#custom_strategies = {'tman': function('Tman')}
let g:test#strategy = 'tman'

]]

vim.keymap.set("n", "<leader>tf", ":TestFile<CR>")
vim.keymap.set("n", "<leader>ts", ":TestNearest<CR>")
vim.keymap.set("n", "<leader>tl", ":TestLast<CR>")

return {
  'vim-test/vim-test',
  cmd = {'TestNearest', 'TestFile', 'TestLast'},
  dependencies = {
    dir = 'Bhanukamax/tman.nvim',
  }
}
```

##### open magit for the current working directory using emacsclient
```lua
    local open_magit_status = function ()
      tman.sendCommand('emacsclient -cn  -e "(magit-status)" \r', {})
    end

    vim.keymap.set("n", "<leader>cgg", open_magit_status)
```

### Interacting with neovim terminal

- `neotermman` uses the neovim terminal,
- by defualt terminal buffer will open in the `terminal` mode which is similar to `normal` mode.
- to interact with the terminal you need to go into insert mode by pressing `i` key.

#### After using terminal
- to exit out of the insert mode in the terminal, you need to use the neovim terminal escape key sequence which is `<C-\><C-N>`.
- since above key sequence is not very easy, you can rebind it to something else.
- If you already haven't got a keybinding, I think using `C-w` and piping that to `wincmd` is a great way because you can use all the `C-w` prefix commands with that
- Add the following to your vim config be able to do `C-w` prefixed commands from your terminal buffer.

#### Lua

```lua
vim.keymap.set("t", "<C-x><C-w>", "<C-\\><C-N><C-w>", {})
vim.keymap.set("t", "<C-x><Esc>", "<C-\\><C-N>", {})
```

