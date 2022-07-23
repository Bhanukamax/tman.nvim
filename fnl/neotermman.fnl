(local M {})

(var is-term-open false)
(var win-id nil)
(var is-different-terminal false)

(local harpoon (require :harpoon.term))

(set M.current-term-number 1)

(fn nvim-cmd [cmd]
  (vim.api.nvim_command cmd))

(fn api [cmd]
  (. vim.api cmd))

(fn open-term []
  (set is-term-open (not is-term-open))
  (nvim-cmd :sp)
  (nvim-cmd "wincmd J")
  (let [current-win (vim.api.nvim_get_current_win)]
    (set win-id current-win)
    (vim.api.nvim_win_set_height current-win 10)
    (harpoon.gotoTerminal M.current-term-number)
    (nvim-cmd "set nobuflisted")))

(fn switch-to-term [n]
  (vim.api.nvim_call_function :win_gotoid {1 win-id})
  (harpoon.gotoTerminal n))

(fn close-term []
  (set is-term-open (not is-term-open))
  (if
    (vim.api.nvim_call_function :win_gotoid {1 win-id})
    (vim.api.nvim_win_close win-id {})))



(fn toggle-last-term []
  (set is-term-open (not is-term-open))
  (if win-id
    (let [has-term (vim.api.nvim_win_is_valid win-id)]
      (if has-term
        (close-term)
        (open-term)))
    (open-term)))

(fn toggle-term-with-number [n]
  (set is-different-terminal (= M.current-term-number n))
  (set M.current-term-number n)

  (if win-id
      (let [has-term (vim.api.nvim_win_is_valid win-id)]
        (if has-term
            (if is-different-terminal
                (close-term)
                (switch-to-term n))
            (open-term)))
      (open-term)))

(fn toggle-term [n]
  (if (= nil n)
      (toggle-last-term)
      (toggle-term-with-number n)))

(set M.toggle toggle-term)

M
