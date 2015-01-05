bk-trees
=================================
Implementation of bk-trees with Levenshtein distance in Lua, inspired by an article:
* [Damn Cool Algorithms, Part 1: BK-Trees](http://blog.notdot.net/2007/4/Damn-Cool-Algorithms-Part-1-BK-Trees)

Most commonly used for fuzzy string matching, for spellcheckers or similar.

Requirements
------------

* Lua >= 5.1

Running one of the example programs (a small spellchecker)

	lua example/spelling.lua

Running the tests

	...

Downloading the source
------------
Either with git clone as below or by downloading a zipball of the [latest...](https://github.com/Profan/bk-tree/archive/master.zip)
		
		git clone https://github.com/Profan/bk-tree.git


[Documentation](http://profan.github.io/bk-tree/)
------------


Usage Example
------------

Gives you the words in the tree within 1 [edit distance](http://en.wikipedia.org/wiki/Edit_distance), in this case `beautiful`

```lua
bktree = require "bk-tree"

tree = bktree:new("book")

tree:insert("perceive")
tree:insert("original")
tree:insert("beautiful")

result = tree:query("beutiful", 1)

for k, v in pairs(result) do
	print (v)
end
```

Do inspect the bundled examples !

TODO
------------

 - [ ] ... write tests?

License
------------
See attached LICENSE file.
