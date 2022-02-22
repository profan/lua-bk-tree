bk-trees
=================================
Implementation of bk-trees with Levenshtein distance in Lua, inspired by an article:
* [Damn Cool Algorithms, Part 1: BK-Trees](http://blog.notdot.net/2007/4/Damn-Cool-Algorithms-Part-1-BK-Trees)

Most commonly used for fuzzy string matching, for spellcheckers or similar.

Requirements
------------

* Lua >= 5.1

### Running one of the example programs (a small spellchecker)

	lua example/spelling.lua

### Running the tests

Requires busted, simply run busted to run the tests in the spec folder.

	busted

Downloading
------------

### Archive

v1.0.3
* **zip** https://github.com/profan/lua-bk-tree/archive/v1.0.3.zip
* **tar.gz** https://github.com/profan/lua-bk-tree/archive/v1.0.3.tar.gz

### Git		
	git clone git@github.com:profan/lua-bk-tree.git

## LuaRocks
	luarocks install bk-tree


[Documentation](http://profan.github.io/lua-bk-tree/)
------------


Usage Example
------------

Gives you the words in the tree within 1 [edit distance](http://en.wikipedia.org/wiki/Edit_distance) to `beutiful`, in this case `beautiful`

```lua
local bktree = require "bk-tree"

local tree = bktree:new("book")

tree:insert("perceive")
tree:insert("original")
tree:insert("beautiful")

local result = tree:query("beutiful", 1)

for k, v in pairs(result) do
	print (v.str)
end
```

Do inspect the bundled examples !


License
------------
See attached LICENSE file.
