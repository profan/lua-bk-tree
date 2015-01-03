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

local function lehvenshtein_dist(s1, s2) 

	if (s1:len() == 0) then return s2:len() end
	if (s2:len() == 0) then return s1:len() end

	local cost
	if (s1:sub(#s1, #s1) == s2:sub(#s2, #s2)) then
		cost = 0
	else
		cost = 1
	end

	return min(lehvenshtein_dist(s1:sub(1, #s1-1), s2) + 1,
				lehvenshtein_dist(s1, s2:sub(1, #s2-1)) + 1,
				lehvenshtein_dist(s1:sub(1, #s1-1), s2:sub(1, #s2-1)) + cost)

end

function bk_tree:new(root_word)

	local n_obj = {}
	n_obj.root = { str = root_word, children = {} }

	setmetatable(n_obj, self)
	self.__index = self

	return n_obj

end

function bk_tree:insert(word, node)

	node = node or self.root

	local dist = lehvenshtein_dist(word, node.str)
	local some_node = node.children[dist]

	if not some_node then
		node.children[dist] = {str = word, children = {}}
	else
		self:insert(word, some_node)
	end	

end

function bk_tree:remove()
	
end

function bk_tree:query(word, n, node, matches)

	matches = matches or {}
	node = node or self.root

	local dist = lehvenshtein_dist(word, node.str)
	if dist <= n then matches[#matches+1] = node.str end
	
	for i=1, #node.children do
		if i >= dist-n and i <= dist+n and node.children[i] then
			self:query(word, n, node.children[i], matches)
		end
	end

	return matches

end

return bk_tree
