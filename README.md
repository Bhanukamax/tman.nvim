# Neovim Terminal Manager


## Introduction

- Tman.nvim is a light weight plugin to manage a terminal buffer in neovim.

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
  width = 50, -- default is 50
  height = 40, -- default is 40
}

```
### Usage

Have a look at `:help tman.nvim` for complete API docs

#### Toggle terminal
```lua
-- pass insert true to open terminal in insert mode
-- useful when you just want the terminal for issuing a quick command interactively like `git push`, etc
vim.keymap.set("n", "<A-;>", function () tman.toggleLast({insert = true}) end)
vim.keymap.set("t", "<A-;>", tman.toggleLast)


-- toggle terminal from a specific side
vim.keymap.set("n", "<leader>tr", tman.toggleRight)
vim.keymap.set("n", "<leader>tb", tman.toggleBottom)

-- toggle terminal from the last open side
vim.keymap.set("n", "<leader>tt", tman.toggleLast)
```

#### Send commands interactively

##### Prompts to Send a command to the terminal

`:TmanCmd`

##### Resend the last command

`:TmanCmdLast`

These commands are useful when you want to run things like build commands, test runner commands, for example: `cargo build`, `go build`, etc.

##### How to use these
- When you run `:TmanCmd` it'll propmt for you to enter a command.
- Once you type in the command and press enter it'll open the Tman terminal and run the command you entered.
- You can also run `:TmanCmdLast` to resend the last command you ran.

One nice thing about using these commands is that you never have to go to insert mode in the terminal buffer, so you can just use these to run commands and navigate/visual select/yank text on terminal buffer without ever worrying about going between modes in the terminal buffer.

![tman-cargo-build](https://user-images.githubusercontent.com/8494781/222031447-6e44ef13-9075-4238-b6ec-05d41133094a.gif)

And they works best with a some nice remaps like these:

```lua
  vim.keymap.set("n", "<leader>tc", ":TmanCmd<CR>")
  vim.keymap.set("n", "<leader>tn", ":TmanCmdLast<CR>") -- <leader>tl or <leader>tr would be a better mnemonic binding
```

![tman-cargo-build-with-keybinds](https://user-images.githubusercontent.com/8494781/222031470-c239fd0f-4b51-4ee3-b17b-d08dbc7d0c71.gif)


#### Send commands programmatically

call to send some command to the terminal buffer


`require("tman").sendCommand(cmd, opts)`

cmd: string -> command to send

opts: table

- opts.split: "right" or "bottom":  pass a split possition to override default when the command is executed
- opts.open: bool -> if true, open the terminal buffer (always opens if there is no previous terminal buffer)
- opts.pre: string -> a command to excute before the currend `cmd`
- opts.scrollTop: bool (default: true) -> scroll the prompt to top before executing the currently sent command, this is works better than sending `clear` as the `pre` command.

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
- I have found that C-x works best for me for this.

##### Lua

```lua
vim.keymap.set("t", "<C-x>", "<C-\\><C-N>", {})
```


