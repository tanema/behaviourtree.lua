rockspec_format = "3.0"

package = "behaviourtree"
version = "0-0"
source = {
   url = "git+ssh://git@github.com/tanema/behaviourtree.lua.git"
}

description = {
   summary = "Behaviour Tree Library",
   detailed = [[
A Lua implementation of Behavior Trees which are useful for implementing behavior
for video games or more complex systems.]],
   homepage = "https://github.com/tanema/behaviourtree.lua",
   license = "MIT"
}

dependencies = {
   "lua >= 5.1, <= 5.4",
   "busted >= 2.1.2",
   "middleclass >= 4.1.1-0",
   "luacov",
   "luacov-reporter-lcov",
}

build = {
   type = "builtin",
   modules = {
      behaviour_tree = "lib/behaviour_tree.lua",
      init = "lib/init.lua",
      registry = "lib/registry.lua"
   }
}
