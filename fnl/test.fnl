(var is-term-open false)
(var win-id nil)

(local harpoon (require :harpoon.term))

(fn nvim-cmd [cmd]
  (vim.api.nvim_command cmd))

(fn api [cmd]
  (. vim.api cmd))

(fn open-term []
  (nvim-cmd :sp)
  (nvim-cmd "wincmd J")
  (let [current-win (vim.api.nvim_get_current_win)]
    (set win-id current-win)
    (vim.api.nvim_win_set_height current-win 10)
    (harpoon.gotoTerminal 1)
    (nvim-cmd "set nobuflisted")))

(fn close-term []
  (if
    (vim.api.nvim_call_function :win_gotoid {1 win-id})
    (vim.api.nvim_win_close win-id {})))

(fn toggle-term []
  (set is-term-open (not is-term-open))
  (if win-id
    (let [has-term (vim.api.nvim_win_is_valid win-id)]
      (if has-term
        (close-term)
        (open-term)))
    (open-term)))

(vim.keymap.set :n :<leader>to toggle-term)
(vim.keymap.set :n :<leader>tt toggle-term)


(fn run-term-command [command]
  (let [ctrl-c "\003"]
    ((. (require :harpoon.term) :sendCommand) 1
     (.. ctrl-c "\n" command "\n"))))



(fn run-build-command [cmd]
  (let [build-command (vim.api.nvim_get_var cmd)
        ctrl-c "\003"]
    ((. (require :harpoon.term) :sendCommand) 1
     (.. ctrl-c "\n" build-command "\n"))
    (print "build done")))


(vim.keymap.set :n :<leader>dd (fn [] (run-build-command "buildCommand")))
(vim.keymap.set :n :<leader>de (fn [] (run-build-command "testCommand")))

(fn clear []
	(nvim-cmd "set guicursor=a:block")
	(nvim-cmd "noh")
	(nvim-cmd "diffupdate"))

(vim.keymap.set :n :<c-l> clear)