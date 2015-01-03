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

function lehvenshtein_dist(s1, s2) 
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

function bk_tree:new()
	local n_obj = {}
	setmetatable(n_obj, self)
	self.__index = self
	return n_obj
end

function bk_tree:insert(val)
	
end

function bk_tree:remove()
	
end

function bk_tree:query(str)
	
end

return bk_tree
