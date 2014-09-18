local _PACKAGE = (...):match("^(.+)[%./][^%./]+"):gsub("[%./]?node_types", "")
local class = require(_PACKAGE..'/middleclass')
local Registry = require(_PACKAGE..'/registry')
local Node  = require(_PACKAGE..'/node_types/node')
local Decorator = class('Decorator', Node)

function Decorator:setNode(node)
  self.node = Registry.getNode(self.config.node)
end

function Decorator:start()
  if self.config.node ~= nil and self.node == nil then
    self.node = Registry.getNode(self.config.node)
  end
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
