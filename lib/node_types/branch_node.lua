local _PACKAGE = (...):match("^(.+)[%./][^%./]+"):gsub("[%./]?node_types", "")
local class = require(_PACKAGE..'/middleclass')
local Registry = require(_PACKAGE..'/registry')
local Node  = require(_PACKAGE..'/node_types/node')
local BranchNode = class('BranchNode', Node)

function BranchNode:start(object)
  self:setObject(object)
  self.actualTask = 1
end

function BranchNode:run(object)
  if self.actualTask <= #self.nodes then
    self:_run(object)
  end
end

function BranchNode:_run(object)
  if not self.nodeRunning then
    self.node = Registry.getNode(self.nodes[self.actualTask]) 
    self.node:setControl(self)
    self.node:start(object)
  end
  self.node:run(object)
end

function BranchNode:running()
  self.nodeRunning = true
  self.control:running()
end

function BranchNode:success()
  self.nodeRunning = false
  self.node:finish(self.object)
  self.node = nil
end

function BranchNode:fail()
  self.nodeRunning = false
  self.node:finish(self.object);
  self.node = nil
end

return BranchNode
