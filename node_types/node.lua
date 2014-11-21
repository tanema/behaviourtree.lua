local _PACKAGE = (...):match("^(.+)[%./][^%./]+"):gsub("[%./]?node_types", "")
local class = require(_PACKAGE..'/middleclass')
local Node = class('Node')

function Node:initialize(config)
  config = config or {}
  for k, v in pairs(config) do
    self[k] = v
  end
end

function Node:start() end
function Node:finish() end
function Node:run() end

function Node:setObject(object)
  self.object = object
end

function Node:setControl(control)
  self.control = control
end

function Node:running()
  if self.control then
    self.control:running(self)
  end
end

function Node:success()
  if self.control then
    self.control:success()
  end
end

function Node:fail()
  if self.control then
    self.control:fail()
  end
end

return Node
