bk-trees
=================================
Implementation of bk-trees with Levenshtein distance in Lua, inspired by an article:
* [Damn Cool Algorithms, Part 1: BK-Trees](http://blog.notdot.net/2007/4/Damn-Cool-Algorithms-Part-1-BK-Trees)

Most commonly used for fuzzy string matching, for spellcheckers or similar.

Note that this is still horrifyingly slow due to the naive levenshtein edit distance implementation, but that will be fixed shortly.

Requirements
------------

* Lua >= 5.1

Running the tests

	...

Downloading the source
------------
Either with git clone as below or by downloading a zipball of the [latest...](https://github.com/Profan/bk-tree/archive/master.zip)
		
		git clone https://github.com/Profan/bk-tree.git

Usage
------------

### Function signatures:
```lua

-- distance function is levenshtein by default
obj = imported:new(rootword, distance_function) 
obj:insert(word)
obj:remove(word)
obj:query(word, maximum_distance)
-- returns all nodes with maximum_distance or less edit distance
```

### Working example
```lua
bktree = require "bk-tree"

tree = bktree:new("book")

tree:insert("bark")
tree:insert("car")
tree:insert("dog")
tree:insert("rhyme")
tree:insert("really")
tree:insert("beauty")
tree:insert("perceive")
tree:insert("original")
tree:insert("beautiful")

result = tree:query("beutiful", 1)
for k, v in pairs(result) do
	print (v)
end

-- will print beautiful
```

Do inspect the bundled `example.lua` !

TODO
------------

 - [ ] ... write tests?

License
------------
See attached LICENSE file.
