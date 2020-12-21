fun! OpenTerm()
    " remove after development
    lua for k in pairs(package.loaded) do if k:match("^bmax%-test") then package.loaded[k] = nill end end
    "lua require("bmax-test").bmax_test()
    ":sp
    ":execute("normal \<C-w>J")
    lua require("bmax-test").open_bmax_term()
endfun

fun! OpenFloatingTerm()
    " remove after development
    lua for k in pairs(package.loaded) do if k:match("^bmax%-test") then package.loaded[k] = nill end end
    "lua require("bmax-test").bmax_test()
    lua require("bmax-test").open_floating_term()
endfun

