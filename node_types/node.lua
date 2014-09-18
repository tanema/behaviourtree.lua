local _PACKAGE = (...):match("^(.+)[%./][^%./]+"):gsub("[%./]?node_types", "")
local class = require(_PACKAGE..'/middleclass')
local Node = class('Node')

function Node:initialize(config)
  self.config    = config or {}
  self.title     = self.config.title

  if self.config.nodes ~= nil then
    self.nodes = self.config.nodes;
  end
  if self.config.success ~= nil then
    self.success = self.config.success
  end
  if self.config.running then
    self.running = self.config.running
  end
  if self.config.fail then
    self.fail = self.config.fail
  end
  if self.config.start then 
    self.start = self.config.start
  end
  if self.config.finish then
    self.finish = self.config.finish
  end
  if self.config.run then
    self.run = self.config.run
  end
end

function Node:start()
end

function Node:finish()
end

function Node:run()
  print('warning: run of ' .. self.title .. ' not implemented!')
end

function Node:setControl(control)
  self.control = control
end

function Node:running()
  self.control:running(self)
end

function Node:success()
  self.control:success()
end

function Node:fail()
  self.control:fail()
end

return Node
