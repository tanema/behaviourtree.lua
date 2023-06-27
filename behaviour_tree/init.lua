local class         = require('middleclass')
local Registry      = require('behaviour_tree.registry')
local Node          = require('behaviour_tree.node_types.node')
local BehaviourTree = class('BehaviourTree', Node)

BehaviourTree.Node                    = Node
BehaviourTree.Registry                = Registry
BehaviourTree.Task                    = Node
BehaviourTree.BranchNode              = require('behaviour_tree.node_types.branch_node')
BehaviourTree.Priority                = require('behaviour_tree.node_types.priority')
BehaviourTree.ActivePriority          = require('behaviour_tree.node_types.active_priority')
BehaviourTree.Random                  = require('behaviour_tree.node_types.random')
BehaviourTree.Sequence                = require('behaviour_tree.node_types.sequence')

BehaviourTree.Decorator               = require('behaviour_tree.decorators.decorator')
BehaviourTree.InvertDecorator         = require('behaviour_tree.decorators.invert')
BehaviourTree.AlwaysFailDecorator     = require('behaviour_tree.decorators.always_fail')
BehaviourTree.AlwaysSucceedDecorator  = require('behaviour_tree.decorators.always_succeed')

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
