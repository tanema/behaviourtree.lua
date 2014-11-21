local _PACKAGE = (...):match("^(.+)[%./][^%./]+") or ""
local class = require(_PACKAGE..'/middleclass')
local Registry = require(_PACKAGE..'/registry')
local BehaviourTree = class('BehaviourTree')
 
BehaviourTree.Node                    = require(_PACKAGE..'/node_types/node')
BehaviourTree.Task                    = require(_PACKAGE..'/node_types/node')
BehaviourTree.BranchNode              = require(_PACKAGE..'/node_types/branch_node', BehaviourTree)
BehaviourTree.Priority                = require(_PACKAGE..'/node_types/priority')
BehaviourTree.Random                  = require(_PACKAGE..'/node_types/Random')
BehaviourTree.Sequence                = require(_PACKAGE..'/node_types/sequence')
BehaviourTree.Decorator               = require(_PACKAGE..'/node_types/decorator')
BehaviourTree.InvertDecorator         = require(_PACKAGE..'/node_types/invert_decorator')
BehaviourTree.AlwaysFailDecorator     = require(_PACKAGE..'/node_types/always_fail_decorator')
BehaviourTree.AlwaysSucceedDecorator  = require(_PACKAGE..'/node_types/always_succeed_decorator')

BehaviourTree.register = Registry.register
BehaviourTree.getNode = Registry.getNode

function BehaviourTree:initialize(config)
  self.config    = config and config or {}
  self.rootNode = self.config.tree;
  self.object   = self.config.object;
end

function BehaviourTree:setObject(obj)
  self.object = obj
end

function BehaviourTree:step()
  if self.started then
    return --the previous step is still working
  end

  self.started = true
  local node = Registry.getNode(self.rootNode)
  self.actualNode = node
  node:setControl(self)
  node:start(self.object)
  node:run(self.object)
end

function BehaviourTree:running()
  self.started = false
end

function BehaviourTree:success()
  self.actualNode:finish(self.object);
  self.started = false
end

function BehaviourTree:fail()
  self.actualNode:finish(self.object);
  self.started = false
end

return BehaviourTree
