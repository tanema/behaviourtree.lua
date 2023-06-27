rockspec_format = "3.0"

package = "behaviour_tree"
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
      ['behaviour_tree']                                     = 'behaviour_tree/init.lua',
      ['behaviour_tree.registry']                            = 'behaviour_tree/registry.lua',

      ['behaviour_tree.node_types.node']                     = 'behaviour_tree/node_types/node.lua',
      ['behaviour_tree.node_types.branch_node']              = 'behaviour_tree/node_types/branch_node.lua',
      ['behaviour_tree.node_types.priority']                 = 'behaviour_tree/node_types/priority.lua',
      ['behaviour_tree.node_types.active_priority']          = 'behaviour_tree/node_types/active_priority.lua',
      ['behaviour_tree.node_types.random']                   = 'behaviour_tree/node_types/random.lua',
      ['behaviour_tree.node_types.sequence']                 = 'behaviour_tree/node_types/sequence.lua',

      ['behaviour_tree.decorators.decorator']                = 'behaviour_tree/decorators/decorator.lua',
      ['behaviour_tree.decorators.invert']                   = 'behaviour_tree/decorators/invert.lua',
      ['behaviour_tree.decorators.always_fail']              = 'behaviour_tree/decorators/always_fail.lua',
      ['behaviour_tree.decorators.always_succeed']           = 'behaviour_tree/decorators/always_succeed.lua',
   }
}
