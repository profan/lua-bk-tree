package = "regexulon"
version = "1.0-1"
source = {
	url = "https://github.com/profan/lua-bk-tree/archive/lua-bk-tree-1.0.0.tar.gz"
}

description = {
	summary = "bk-tree datastructure",
	detailed = [[
		Burkhard-Keller Trees or bk-trees, 
		a datastructure commonly used for fuzzy
		string matching, spell checkign or similar.
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
