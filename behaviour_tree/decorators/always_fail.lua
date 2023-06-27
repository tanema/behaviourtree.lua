local class = require('middleclass')
local Decorator  = require('behaviour_tree.decorators.decorator')
local AlwaysFailDecorator = class('AlwaysFailDecorator', Decorator)

function AlwaysFailDecorator:success()
  self.control:fail()
end

function AlwaysFailDecorator:fail()
  self.control:fail()
end

return AlwaysFailDecorator

