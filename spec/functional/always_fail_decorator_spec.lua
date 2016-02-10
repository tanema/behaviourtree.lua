local BehaviourTree = require 'lib/behaviour_tree'
local AlwaysFailDecorator = BehaviourTree.AlwaysFailDecorator

describe('AlwaysFailDecorator', function()
  local subject, task, control
  before_each(function()
    control = {}
    task    = BehaviourTree.Task:new()
    subject = AlwaysFailDecorator:new({control = control, node = task})
  end)
  
  it('should call fail when node calls success', function()
    stub(control, 'fail')
    function task:run()
      self:success()
    end
    subject:run()
    assert.stub(control.fail).was.called()
  end)
  it('should call fail when node calls fail', function()
    stub(control, 'fail')
    function task:run()
      self:fail()
    end
    subject:run()
    assert.stub(control.fail).was.called()
  end)

end)

