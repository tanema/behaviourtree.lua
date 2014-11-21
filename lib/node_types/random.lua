local _PACKAGE = (...):match("^(.+)[%./][^%./]+"):gsub("[%./]?node_types", "")
local class = require(_PACKAGE..'/middleclass')
local BranchNode  = require(_PACKAGE..'/node_types/branch_node')
local Random = class('Random', BranchNode)

function Random:start()
  BranchNode.start(self)
  if not self.nodeRunning then
    self.actualTask = math.floor(math.random() * #self.nodes+1)
  end
end

function Random:_run(object)
  if not self.runningNode then
    BranchNode._run(self, object)
  else 
    self.runningNode:run(object)
  end
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
