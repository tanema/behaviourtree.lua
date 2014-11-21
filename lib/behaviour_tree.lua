local _PACKAGE      = (...):match("^(.+)[%./][^%./]+") or ""
local class         = require(_PACKAGE..'/middleclass')
local Registry      = require(_PACKAGE..'/registry')
local Node          = require(_PACKAGE..'/node_types/node')
local BehaviourTree = class('BehaviourTree', Node)
 
BehaviourTree.Node                    = Node
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

function BehaviourTree:run(object)
  if self.started then
    self:running()
  else
    self.started = true
    self.object = object or self.object
    self.rootNode = Registry.getNode(self.tree)
    self.rootNode:setControl(self)
    self.rootNode:start(self.object)
    self.rootNode:run(self.object)
  end
end

function BehaviourTree:running()
  Node.running(self)
  self.started = false
end

function BehaviourTree:success()
  Node.success(self)
  self.rootNode:finish(self.object);
  self.started = false
end

function BehaviourTree:fail()
  Node.fail(self)
  self.rootNode:finish(self.object);
  self.started = false
end

return BehaviourTree
