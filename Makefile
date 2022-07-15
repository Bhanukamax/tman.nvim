all: lua/test.lua

lua/%.lua: ./fnl/%.fnl
	fennel --compile $< > $@
