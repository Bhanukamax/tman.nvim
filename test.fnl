(local tman (require :neotermman))
(print (vim.inspect tman))


(print "test")
(vim.keymap.set :n :<leader>tt tman.toggle)
