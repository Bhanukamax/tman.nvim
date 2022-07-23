(local tman (require :neotermman))
(print (vim.inspect tman))


(print "test")

(vim.keymap.set :n :<leader>tt #(tman.toggle nil))
(vim.keymap.set :n :<leader>t1 #(tman.toggle 1))
(vim.keymap.set :n :<leader>t2 #(tman.toggle 2))
