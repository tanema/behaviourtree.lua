local BehaviourTree = require 'lib/behaviour_tree'
local Task = BehaviourTree.Task

describe('Node', function() 
  local subject
  before_each(function()
    subject = Task:new() 
  end)

  it('should be able to call success', function()
    function subject:run(object)
      self:success()
    end
    subject:run()
  end)
  it('should be able to call fail', function()
    function subject:run(object)
      self:fail()
    end
    subject:run()
  end)
  it('should be able to call running', function()
    function subject:run(object)
      self:running()
    end
    subject:run()
  end)
end)
