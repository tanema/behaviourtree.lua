local _PACKAGE      = (...):match("^(.+)[%./][^%./]+") or ""
local class         = require(_PACKAGE..'/middleclass')
local Registry      = require(_PACKAGE..'/registry')
local Node          = require(_PACKAGE..'/node_types/node')
local BehaviourTree = class('BehaviourTree', Node)
 
BehaviourTree.Node                    = Node
BehaviourTree.Registry                = Registry
BehaviourTree.Task                    = Node
BehaviourTree.BranchNode              = require(_PACKAGE..'/node_types/branch_node')
BehaviourTree.Priority                = require(_PACKAGE..'/node_types/priority')
BehaviourTree.ActivePriority          = require(_PACKAGE..'/node_types/active_priority')
BehaviourTree.Random                  = require(_PACKAGE..'/node_types/random')
BehaviourTree.Sequence                = require(_PACKAGE..'/node_types/sequence')
BehaviourTree.Decorator               = require(_PACKAGE..'/node_types/decorator')
BehaviourTree.InvertDecorator         = require(_PACKAGE..'/node_types/invert_decorator')
BehaviourTree.AlwaysFailDecorator     = require(_PACKAGE..'/node_types/always_fail_decorator')
BehaviourTree.AlwaysSucceedDecorator  = require(_PACKAGE..'/node_types/always_succeed_decorator')

BehaviourTree.register = Registry.register
BehaviourTree.getNode = Registry.getNode

function BehaviourTree:run(object)
  if self.started then
    Node.running(self) --call running if we have control
  else
    self.started = true
    self.object = object or self.object
    self.rootNode = Registry.getNode(self.tree)
    self.rootNode:setControl(self)
    self.rootNode:start(self.object)
    self.rootNode:call_run(self.object)
  end
end

function BehaviourTree:running()
  Node.running(self)
  self.started = false
end

function BehaviourTree:success()
  self.rootNode:finish(self.object);
  self.started = false
  Node.success(self)
end

function BehaviourTree:fail()
  self.rootNode:finish(self.object);
  self.started = false
  Node.fail(self)
end

return BehaviourTree
