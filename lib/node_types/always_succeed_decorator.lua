local _PACKAGE = (...):match("^(.+)[%./][^%./]+"):gsub("[%./]?node_types", "")
local class = require(_PACKAGE..'/middleclass')
local Decorator  = require(_PACKAGE..'/node_types/decorator')
local AlwaysSucceedDecorator = class('AlwaysSucceedDecorator', Decorator)

function AlwaysSucceedDecorator:success()
  self.control:success()
end

function AlwaysSucceedDecorator:fail()
  self.control:success()
end

return AlwaysSucceedDecorator
