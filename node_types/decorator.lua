local _PACKAGE = (...):match("^(.+)[%./][^%./]+"):gsub("[%./]?node_types", "")
local class = require(_PACKAGE..'/middleclass')
local Registry = require(_PACKAGE..'/registry')
local Node  = require(_PACKAGE..'/node_types/node')
local Decorator = class('Decorator', Node)

function Decorator:initialize(config)
  Node.initialize(self, config)
  if self.config.node ~= nil then
    self.node = Registry.getNode(self.config.node)
  end
end

function Decorator:setNode(node)
  self.node = Registry.getNode(node)
end

function Decorator:start()
  self.node:setControl(self);
  self.node:start();
end

function Decorator:finish()
  self.node:finish()
end

function Decorator:run(obj)
  self.node:run(obj)
end

return Decorator
