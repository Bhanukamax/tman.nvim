# Neovim Terminal Manager


## Introduction

This plugin allows to easily manage terminal buffers within neovim.

### Note:
- Neotermman is a thin wrapper around `ThePrimeagen/harpoon` which is a more powerful plugin.

#### How to install

- If you are using `Plug` add the plug to your plugin list:

```viml
" Depndencies: don't forget to add these if you don't have it yet!
Plug 'nvim-lua/plenary.nvim'
Plug 'ThePrimeagen/harpoon'

Plug 'Bhanukamax/neotermman'
```

- resource the vimrc

```viml
:source $MYVIMRC
```

- run plug install

```viml
:PlugInstall
```

### Setup
#### Lua

```lua

local tman = require('neotermman')
tman.init({toggle = "<leader>gg", prefix = "<leader>t"})
```

#### viml

```viml
:lua require('neotermman').init({toggle = "<leader>gg", prefix = "<leader>t"})
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
vim.keymap.set("t", "<C-w>", "<C-\\><C-N><C-w>", {})
vim.keymap.set("t", "<Esc>", "<C-\\><C-N>", {})
```

#### Viml

```viml
:tnoremap <C-w> <C-\><C-N><C-w>
:tnoremap <Esc> <C-\><C-N>
```



