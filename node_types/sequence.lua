local _PACKAGE = (...):match("^(.+)[%./][^%./]+"):gsub("[%./]?node_types", "")
local class = require(_PACKAGE..'/middleclass')
local BranchNode  = require(_PACKAGE..'/node_types/branch_node')
local Sequence = class('Sequence', BranchNode)

function Sequence:_run()
  if self.nodeRunning then
    self.nodeRunning:run(self.object)
    self.nodeRunning = nil
  else
    BranchNode._run(self)
  end
end

function Sequence:success()
  BranchNode.success(self)
  self.actualTask = self.actualTask + 1
  if self.actualTask <= #self.nodes then
    self:_run(self.object)
  else
    self.control:success()
  end
end

function Sequence:fail()
  BranchNode.fail(self)
  self.control:fail()
end

return Sequence
