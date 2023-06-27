local class = require('middleclass')
local BranchNode  = require('behaviour_tree.node_types.branch_node')
local Random = class('Random', BranchNode)

function Random:start(object)
  BranchNode.start(self, object)
  self.actualTask = math.floor(math.random() * #self.nodes+1)
end

function Random:success()
  BranchNode.success(self)
  self.control:success()
end

function Random:fail()
  BranchNode.fail(self)
  self.control:fail()
end

return Random
