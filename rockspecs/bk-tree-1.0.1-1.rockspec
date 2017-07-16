package = "bk-tree"
version = "1.0.1-1"
source = {
	url = "https://github.com/profan/lua-bk-tree/archive/v1.0.1.tar.gz",
	dir = "lua-bk-tree-1.0.1"
}

description = {
	summary = "BK-trees, commonly used for finding near matches to strings.",
	detailed = [[
Burkhard-Keller Trees or bk-trees, a datastructure commonly used for fuzzy string matching, spell checking or similar, comes with a levenshtein distance metric for measuring similarity.
	]],
	homepage = "http://profan.github.io/lua-bk-tree/",
	license = "MIT/X11"
}

dependencies = {
	"lua >= 5.1"
}

build = {
	type = "builtin",
	modules = {
		["bk-tree"] = "bk-tree.lua"
	}
}
