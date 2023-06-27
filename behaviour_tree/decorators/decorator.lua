local class = require('middleclass')
local Registry = require('behaviour_tree.registry')
local Node     = require('behaviour_tree.decorators.node')
local Decorator = class('Decorator', Node)

function Decorator:initialize(config)
  Node.initialize(self, config)
  self.node = Registry.getNode(self.node)
end

function Decorator:setNode(node)
  self.node = Registry.getNode(node)
end

function Decorator:start(object)
  self.node:start(object)
end

function Decorator:finish(object)
  self.node:finish(object)
end

function Decorator:run(object)
  self.node:setControl(self)
  self.node:call_run(object)
end

return Decorator
