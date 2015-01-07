local bktree = require "bk-tree"
local say = require "say"

local words = {
	"bark", 
	"car", 
	"dog", 
	"weird",
	"really",
	"beauty",
	"vehicle",
	"perceive",
	"presence",
	"original",
	"beautiful", 
	"definitely", 
	"immediately", 
	"accidentally"
}

local function fuzz_word(word, n)
	local new_str = word
	for i=1, n do
		pos = math.random(#word)
		r = string.char(math.random(127))
		new_str = new_str:sub(1, pos-1) .. r .. new_str:sub(pos+1)
	end
	return new_str
end

local function table_len(t)
	local len = 0
	for k, v in pairs(t) do len = len + 1 end
	return len
end

local function has_values(state, args)

	if not type(args[1]) == "table" and not type(args[2]) == "table" or #args ~= 2 then
		return false
	end

	local found_items = {}
	for key, value in pairs(args[2]) do
		for k, v in pairs(args[1]) do
			if value == v then 
				found_items[v] = true
			end
		end
	end

	if table_len(found_items) ~= table_len(args[2]) then return false end

	return true

end

say:set("assertion.has_values.positive", "Expected %s \nto have values: %s")
say:set("assertion.has_values.negative", "Expected %s \nto not have values: %s")
assert:register("assertion", "has_values", has_values, "assertion.has_values.positive", "assertion.has_values.negative")

describe("some tests", function()

	it("should make an instance", function()
	
		assert.truthy(bktree:new("word"))
	
	end)

	it("should fail creating an instance", function()

		assert.has_error(function() bktree:new() end)

	end)

	describe("tests querying", function()

		local tree
		local inserted_words
			
		before_each(function()

			tree = bktree:new("root")

			local wc = 0
			inserted_words = {}
			repeat
				local word = words[math.random(#words)]
				local success = tree:insert(word)
				if success then 
					inserted_words[#inserted_words+1] = word
					wc = wc + 1 
				end
			until wc == math.random(wc, #words)
		end)

		after_each(function()
			inserted_words = nil
			tree = nil
		end)

		it("queries for some inserted words", function()
			for k, word in pairs(inserted_words) do
				local result = tree:query(word, 0)
				assert.has_values(result, {word})
			end
		end)

		it("queries for some fuzzy matches", function()
			for k, word in pairs(inserted_words) do
				local rand_num = math.random(#word)
				local result = tree:query(fuzz_word(word, rand_num), rand_num)
				assert.has_values(result, {word})
			end
		end)

	end)

end)
