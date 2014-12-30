local bk_tree = {}

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
