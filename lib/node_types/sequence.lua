local _PACKAGE = (...):match("^(.+)[%./][^%./]+"):gsub("[%./]?node_types", "")
local class = require(_PACKAGE..'/middleclass')
local BranchNode  = require(_PACKAGE..'/node_types/branch_node')
local Sequence = class('Sequence', BranchNode)

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
