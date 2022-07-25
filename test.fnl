(local tman (require :neotermman))
(print (vim.inspect tman))


(tman.init {:toggle :<leader>gg :prefix :<leader>t})
