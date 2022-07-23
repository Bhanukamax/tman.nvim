# Neovim Terminal Manager


## Introduction

This plugin allows to easily manage terminal buffers within neovim.

### Note:
- Neotermman is a thin wrapper around `ThePrimeagen/harpoon` which is a more powerful plugin.

#### How to install

- If you are using `Plug` add the plug to your plugin list:
```
" Depndencies: don't forget to add these if you don't have it yet!
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


local function toggleTerm()
  return tman.toggle(nil)
end

local function toggleTerm1()
  return tman.toggle(1)
end

local function toggleTerm2()
  return tman.toggle(2)
end

vim.keymap.set("n", "<leader>tt", toggleTerm)
vim.keymap.set("n", "<leader>t1", toggleTerm1)
vim.keymap.set("n", "<leader>t2", toggleTerm2)

```

#### viml

```
nnoremap <leader>tt :lua require('neotermman').toggle(nil)<CR>
nnoremap <leader>t1 :lua require('neotermman').toggle(1)<CR>
nnoremap <leader>t2 :lua require('neotermman').toggle(2)<CR>
nnoremap <leader>t3 :lua require('neotermman').toggle(3)<CR>
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
