local _PACKAGE = (...):match("^(.+)[%./][^%./]+"):gsub("[%./]?node_types", "")
local class = require(_PACKAGE..'/middleclass')
local Registry = require(_PACKAGE..'/registry')
local Node  = require(_PACKAGE..'/node_types/node')
local BranchNode = class('BranchNode', Node)

function BranchNode:start()
  self.actualTask = 1
end

function BranchNode:run(object)
  self:setObject(object)
  self:start(object)
  if self.actualTask <= #self.nodes then
    self:_run(object)
  end
  self:finish(object)
end

function BranchNode:_run(object)
  local node = Registry.getNode(self.nodes[self.actualTask])
  self.runningNode = node
  node:setControl(self)
  node:start(object)
  node:run(object)
end

function BranchNode:running(node)
  self.nodeRunning = node
  self.control:running(node)
end

function BranchNode:success()
  self.nodeRunning = nil
  self.runningNode:finish(self.object)
  self.runningNode = nil
end

function BranchNode:fail()
  self.nodeRunning = nil
  self.runningNode:finish(self.object);
  self.runningNode = nil
end

return BranchNode
