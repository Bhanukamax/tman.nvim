# Neovim Terminal Manager


## Introduction

This plugin allows to easily manage a terminal buffer within neovim.

### Note:
- Neotermman is just a thin wrapper around `ThePrimeagen/harpoon` which is a more powerful plugin.
- This is meant for only as a quick start method to get a toggleable terminal buffer going in your neovim as fast as possible.
- If you are a advanced vimmer you may not need this plugin, you can use something like `harpoon` directly according to your liking.

#### How to install

- If you are using `Plug` add the plug to your plugin list:
```
" Depndencies: don't forget to add these one if you don't have it yet!
Plug 'nvim-lua/plenary.nvim'
Plug 'ThePrimeagen/harpoon'

Plug 'Bhanukamax/neotermman'
```

- resource the vimrc
```
:source $MYVIMRC
```

- run plug install
```
:PlugInstall
```

### keybinding

#### Lua

```
local tman = require('neotermman')
vim.keymap.set("n", "<leader>tt", tman.toggle)

```

#### viml

```
nnoremap <leader>tt :lua require('neotermman').toggle()<CR>
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
```viml
:tnoremap <C-w> <C-\><C-N><C-w>
```

