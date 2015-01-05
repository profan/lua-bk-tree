---------------------------
-- bk-tree datastructure
--
-- http://en.wikipedia.org/wiki/BK-tree
-- @module bk-tree
-- @author Robin Hübner
-- robinhubner@gmail.com
-- @release version 1.0
-- @license MIT

local bk_tree = {}

local function min(...)

	local args = {...}
	local min_val = args[1]

	for i=1, #args do
		if min_val > args[i] then
			min_val = args[i]
		end
	end

	return min_val

end

----------------------------------
--- Levenshtein distance function.
-- @tparam string s1
-- @tparam string s2
-- @treturn number the levenshtein distance
-- @within Metrics
function bk_tree.levenshtein_dist(s1, s2)
	
	if s1 == s2 then return 0 end
	if s1:len() == 0 then return s2:len() end
	if s2:len() == 0 then return s1:len() end
	if s1:len() > s2:len() then s2, s1 = s1, s2 end

	t1, t2 = {}, {}

	for i=1, #s2+1 do
		t1[i] = i
	end

	local cost
	for i=1, #s1 do
		
		t2[1] = i + 1
		
		for j=1, #s2 do
			cost = (s1:sub(i,i) == s2:sub(j,j) and 0) or 1
			t2[j + 1] = min( 
				t2[j] + 1,
				t1[j + 1] + 1,
				t1[j] + cost)
		end

		for j=1, #t1 do
			t1[j] = t2[j]
		end

	end

	return t2[#s2]
	
end

function bk_tree.hook(param)

	local name, callee = debug.getlocal(2, 1)
	local f = debug.getinfo(2, "f").func
	local p = debug.getinfo(3, "f").func
	--[[ previous function in the callstack, if called from the same place,
			don't add to the insert/remove counters. ]]--

	if f == bk_tree.insert and p == bk_tree.insert then
		callee.stats.nodes = callee.stats.nodes + 1
	elseif f == bk_tree.remove and p ~= bk_tree.remove then
		callee.stats.nodes = callee.stats.nodes - 1
	elseif f == bk_tree.query and p == bk_tree.query then
		callee.stats.queries = callee.stats.queries + 1
	end

end

--- Hooks debugging into tree execution.
-- Keeps track of number of nodes created, queries made,
-- note that this must be run directly after tree is created
-- in order to get correct information.
-- @within Debug
--- @usage
-- bktree = require "bk-tree"
-- tree = bktree:new("word")
-- tree:debug()
-- tree:insert("perceive")
-- tree:insert("beautiful")
-- tree:insert("definitely")
-- local result = tree:query("definately", 3)
-- tree:print_stats()
--
-- -- output
-- Nodes: 4
-- Queries: 3
-- Nodes Queried: 75%
function bk_tree:debug()

	self.stats = { nodes = 1, queries = 0 }
	debug.sethook(self.hook, "c")

end

--- Print execution stats.
-- Prints nodes queried and total nodes, as well as a fraction of 
-- nodes visited to satisfy the query, resets the counter of nodes queried when called.
-- @within Debug
-- @see debug
function bk_tree:print_stats()

	print("\nNodes: " .. self.stats.nodes)
	print("Queries: " .. self.stats.queries)
	print("Nodes Queried: " .. self.stats.queries/self.stats.nodes*100 .. "%\n")
	self.stats.queries = 0

end

---------------------------
--- Creates a new bk-tree.
-- @constructor
-- @string root_word the root of the new tree
-- @tparam[opt=levenshtein_dist] function dist_func the distance function used
-- @see levenshtein_dist
-- @return the new bk-tree instance
--- @usage
-- bktree = require "bk-tree"
-- local tree = bktree:new("word")
function bk_tree:new(root_word, dist_func)

	local n_obj = {}
	n_obj.root = { str = root_word, children = {} }
	n_obj.dist_func = dist_func or self.levenshtein_dist

	setmetatable(n_obj, self)
	self.__index = self

	return n_obj

end

--------------------------------
--- Inserts word into the tree.
-- @string word
-- @treturn bool true if inserted, false if word already exists in tree
--- @usage
-- bktree = require "bk-tree"
-- local tree = bktree:new("root")
-- local success = tree:insert("other_word")
function bk_tree:insert(word, node)

	node = node or self.root

	local dist = self.dist_func(word, node.str)
	if dist == 0 then return false end

	local some_node = node.children[dist]

	if not some_node then
		node.children[dist] = { str = word, children = {} }
		return true
	end	

	return self:insert(word, some_node)

end

--------------------------------
--- Remove a word from the tree.
-- @string word
-- @treturn bool true if succeeded, false if word doesn't exist in tree.
--- @usage
-- bktree = require "bk-tree"
-- local tree = bktree:new("root")
-- local success = tree:remove("root")
function bk_tree:remove(word, node, parent, n)

	node = node or self.root

	local dist = self.dist_func(word, node.str)

	if dist == 0 then
		parent.children[n] = nil
		for k, child in pairs(node.children) do
			self:insert(child.str, parent)
		end
		return true
	end

	return self:remove(word, node.children[dist], node, dist)
	
end

--------------------------------
--- Query the tree for a word.
-- @string word
-- @tparam number n max edit distance to use when querying
-- @treturn {string,....} table with matching words, empty table if no matches
--- @usage
-- bktree = require "bk-tree"
-- local tree = bktree:new("word")
-- tree:insert("hello")
-- tree:insert("goodbye")
-- tree:insert("woop")
-- local result = tree:query("woop", 1)
function bk_tree:query(word, n, node, matches)

	node = node or self.root
	matches = matches or {}

	local dist = self.dist_func(word, node.str)
	if dist <= n then matches[#matches+1] = node.str end
	
	for k, child in pairs(node.children) do
		if child ~= nil then
			if k >= dist-n and k <= dist+n then
				self:query(word, n, child, matches)
			end
		end
	end

	return matches

end

return bk_tree
