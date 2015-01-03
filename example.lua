print ("\nSimple spellcheck example! \n")

bktree = require "bk-tree"

words = {
	"book", 
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

tree = bktree:new("book")

print("Available words:")
for k, word in pairs(words) do
	print(" - " .. word)
	tree:insert(word)
end

io.write("input an incorrectly spelled word to test: ")
io.flush()
word = io.read()

io.write("input edit distance(small numbers): ")
io.flush()
distance = io.read()

result = tree:query(word, tonumber(distance))

if result then

	print("candidates: ")
	for k, v in pairs(result) do
	    print (" - " .. v)
	end

else

	print("no results!")

end
