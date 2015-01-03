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


--[[
	Naive Recursive Levenshtein Distance 
	http://en.wikipedia.org/wiki/Levenshtein_distance#Recursive
]]--
function levenshtein_dist(s1, s2) 

	if (s1:len() == 0) then return s2:len() end
	if (s2:len() == 0) then return s1:len() end

	local cost
	if (s1:sub(#s1, #s1) == s2:sub(#s2, #s2)) then
		cost = 0
	else
		cost = 1
	end

	return min(levenshtein_dist(s1:sub(1, #s1-1), s2) + 1,
				levenshtein_dist(s1, s2:sub(1, #s2-1)) + 1,
				levenshtein_dist(s1:sub(1, #s1-1), s2:sub(1, #s2-1)) + cost)

end

--[[
	Levenshtein Distance
	Iterative with two matrix rows
	http://en.wikipedia.org/wiki/Levenshtein_distance#Iterative_with_two_matrix_rows
]]--
function fast_levenshtein_dist(s1, s2)

	if (s1:len() > s2:len()) then
		s2, s1 = s1, s2
	end
	
	if (s1 == s2) then return 0 end
	if (s1:len() == 0) then return s2:len() end
	if (s2:len() == 0) then return s1:len() end

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

function bk_tree:hook()

	local name, callee = debug.getlocal(2, 1)
	local f_name = debug.getinfo(2, "n").name
	local p_name = debug.getinfo(3, "n").name
	--[[ previous function in the callstack, if called from the same place,
			don't add to the insert/remove counters. ]]--

	if f_name == "insert" and p_name ~= "insert" then
			callee.stats.nodes = callee.stats.nodes + 1
	elseif f_name == "remove" and p_name ~= "remove" then
		callee.stats.nodes = callee.stats.nodes - 1
	elseif f_name == "query" then
		callee.stats.queries = callee.stats.queries + 1
	end

end

function bk_tree:debug()

	self.stats = { nodes = 1, queries = 0 }
	debug.sethook(self.hook, "c")

end

function bk_tree:print_stats()

	print("\nNodes: " .. self.stats.nodes)
	print("Queries: " .. self.stats.queries)
	print("Nodes Queried: " .. self.stats.queries/self.stats.nodes*100 .. "%\n")
	self.stats.queries = 0

end

function bk_tree:new(root_word, dist_func)

	local n_obj = {}
	n_obj.root = { str = root_word, children = {} }
	n_obj.dist_func = dist_func or fast_levenshtein_dist

	setmetatable(n_obj, self)
	self.__index = self

	return n_obj

end

function bk_tree:insert(word, node)

	node = node or self.root

	local dist = self.dist_func(word, node.str)
	if dist == 0 then return false end

	local some_node = node.children[dist]

	if not some_node then
		node.children[dist] = { str = word, children = {} }
		return true
	else
		self:insert(word, some_node)
	end	

end

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
