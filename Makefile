all: **/*.lua

lua/%.lua: ./fnl/%.fnl
	fennel --compile $< > $@

test: test.lua

test.lua: ./test.fnl
	fennel --compile test.fnl > test.lua
