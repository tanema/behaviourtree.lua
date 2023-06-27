local class = require('middleclass')
local Decorator = require('behaviour_tree.decorators.decorator')
local AlwaysSucceedDecorator = class('AlwaysSucceedDecorator', Decorator)

function AlwaysSucceedDecorator:success()
  self.control:success()
end

function AlwaysSucceedDecorator:fail()
  self.control:success()
end

return AlwaysSucceedDecorator
