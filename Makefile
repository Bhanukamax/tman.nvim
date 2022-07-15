all: lua/neotermman.lua

lua/%.lua: ./fnl/%.fnl
	fennel --compile $< > $@
