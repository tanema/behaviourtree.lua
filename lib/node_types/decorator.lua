local _PACKAGE = (...):match("^(.+)[%./][^%./]+"):gsub("[%./]?node_types", "")
local class = require(_PACKAGE..'/middleclass')
local Registry = require(_PACKAGE..'/registry')
local Node  = require(_PACKAGE..'/node_types/node')
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
