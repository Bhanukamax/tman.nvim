(local M {})
(set M.is-term-open false)
(set M.win-id nil)

(local harpoon (require :harpoon.term))

(fn nvim-cmd [cmd]
  (vim.api.nvim_command cmd))

(fn api [cmd]
  (. vim.api cmd))
(set M.open-term
     (fn []
       (nvim-cmd :sp)
       (nvim-cmd "wincmd J")
       (let [current-win (vim.api.nvim_get_current_win)]
         (set M.win-id current-win)
         (vim.api.nvim_win_set_height current-win 10)
         (harpoon.gotoTerminal 1)
         (nvim-cmd "set nobuflisted"))))

(set M.close-term
     (fn []
       (if
        (vim.api.nvim_call_function :win_gotoid {1 M.win-id})
        (vim.api.nvim_win_close M.win-id {}))))

(set M.toggle-term
     (fn []
       (set M.is-term-open (not M.is-term-open))
       (if win-id
           (let [has-term (vim.api.nvim_win_is_valid M.win-id)]
             (if has-term
                 (close-term)
                 (open-term)))
           (open-term))))
(vim.keymap.set :n :<leader>tt M.toggle-term)
(set M.test 4)
M
