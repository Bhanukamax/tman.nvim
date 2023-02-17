# Neovim Terminal Manager


## Introduction


### Note:
- Tman.nvim is a simple light weight plugin to manage a terminal buffer in neovim.

#### How to install

Add this to your packer or Lazy config

```lua
{
  'Bhanukamax/tman.nvim',
}
```


### Setup
#### Lua

```lua

local tman = require('tman')

-- setup how the terminal buffer is displayed
-- Note: you don't need to do this if you are okay with using the defaults
tman.setup {
  split = "bottom", -- supported values: "bottom", "right"
  -- set width and height as a percentage of the terminal width and height
  -- should be a integer between 1 to 100
  width = 50, -- defualt is 50
  height = 40, -- defualt is 40
}

```
### Usage

#### Toggle terminal
```lua
vim.keymap.set("n", "<A-;>", function ()
  tman.toggleTerm()
  vim.cmd "normal! i" -- if you like to open terminal in insert mode
end)

vim.keymap.set("t", "<A-;>", function ()
  tman.toggleTerm()
end)

-- toggle terminal from a specific side
vim.keymap.set("n", "<leader>tr", tman.toggleRight)
vim.keymap.set("n", "<leader>tb", tman.toggleBottom)

-- toggle terminal from the last open side
vim.keymap.set("n", "<leader>tt", tman.toggleLast)
```

#### Send command

call to send some command to the terminal buffer

`require("tman").sendCommand(cmd, opts)`

cmd: string -> command to send

opts: table

- opts.spilt: "right" or "bottom":  pass a split possition to override default when the command is executed
- opts.open: bool -> if true, open the terminal buffer (always opens if there is no previous terminal buffer)
- opts.pre: string -> a command to excute before the currend `cmd`

##### use gitk for the current file

```lua
local gitk_file = function()
  local filename = vim.fn.expand('%')
  local cmd = "gitk " .. filename .. "\r"
  require("tman").sendCommand(cmd, {})
end
```

##### use as a vim-test stratergy
```lua

vim.cmd[[

function! Tman(cmd)
  let g:cmd = a:cmd . "\n"
  lua require("tman").sendCommand(vim.g.cmd, {open = true, split = "right", pre = "clear"})
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
    'Bhanukamax/tman.nvim',
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

