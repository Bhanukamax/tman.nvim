# Neovim Terminal Manager


## Introduction

This plugin allows to easily manage a terminal buffer within neovim.

#### How to install

- If you are using `Plug` add the plug to your plugin list:
```
Plug 'nvim-lua/plenary.nvim' " don't forget to add this one if you don't have it yet!
Plug 'ThePrimeagen/harpoon'
Plug 'Bhanukamax/neotermman',  { 'branch': 'feat/toggle' }

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

### Methods

- OpenTerm() - opens the terminal buffer in the current window
- OpenFloatingTerm - opens the terminal buffer in a new floating window
- Pressing `q` will close the term buffer

```
nnoremap <leader>T :call OpenTerm()<CR>
nnoremap <leader>t :call OpenFloatingTerm()<CR>

nnoremap <leader>tt :lua require('neotermman').toggle_term()<CR>
```


### Interacting with neovim terminal

- `neotermman` uses the neovim terminal,
- by defualt terminal buffer will open in the `terminal` mode which is similar to `normal` mode.
- to interact with the terminal you need to go into insert mode by pressing `i` key.

#### After using terminal
- to exit out of the insert mode in the terminal, you need to use the neovim terminal escape key sequence which is `<C-\><C-N>`.
- since above key sequence is not very easy, you can rebind it to something else.
- If you already haven't got a keybinding, I think using `C-w` and piping that to `wincmd` is a great way because you can use all the `C-w` prefix commands with that
- Add the following to be able to do `C-w` prefixed commands from your terminal buffer.
```viml
:tnoremap <C-w> <C-\><C-N><C-w>
```
