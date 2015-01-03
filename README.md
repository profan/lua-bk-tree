bk-trees
=================================
Implementation of bk-trees with Levenshtein distance in Lua, inspired by an article:
* [Damn Cool Algorithms, Part 1: BK-Trees](http://blog.notdot.net/2007/4/Damn-Cool-Algorithms-Part-1-BK-Trees)

Most commonly used for fuzzy string matching, for spellcheckers or similar.

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

	function signatures:
	
	new(rootword, distance_function) -- distance function is levenshtein by default
	insert(word)
	remove(word)
	query(word, maximum_distance)
	-- returns all nodes with maximum_distance or less edit distance

	bktree = require "bk-tree"
	new_tree = bktree:new("root")
	new_tree:insert("root1")
	new_tree:insert("root2")
	new_tree:insert("root3")

	result = new_tree:query("root4", 1)
	for k, v in pairs(result) do
		print (v)
	end
	
	-- output
	root
	root1
	root2
	root3

TODO
------------

 - [ ] ... write tests?

License
------------
See attached LICENSE file.
