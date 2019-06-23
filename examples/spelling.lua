print ("\nSimple spellcheck example! \n")

local bktree = require "bk-tree"

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

local tree = bktree:new("book")
tree:debug()

local x = os.clock()

print("Available words: " .. #words)
for k, word in pairs(words) do
	print(" - " .. word)
	tree:insert(word)
end

local t = os.clock() - x
print("elapsed time: " .. t .. " s")
print(" - time per word: " .. (t/#words)+1 .. " s")

io.write("input an incorrectly spelled word to test: ")
io.flush()
local word = io.read()

io.write("input edit distance(small numbers): ")
io.flush()
local distance = io.read()

local result = tree:query_sorted(word, tonumber(distance))

if result then

	print("candidates: ")
	for k, v in pairs(result) do
	    print (v.str, v.distance)
	end

else

	print("no results!")

end

tree:print_stats()
