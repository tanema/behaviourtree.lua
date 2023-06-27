local BehaviourTree = require 'behaviour_tree'
local AlwaysSucceedDecorator = BehaviourTree.AlwaysSucceedDecorator

describe('AlwaysSucceedDecorator', function()
  local subject, task, control
  before_each(function()
    control = {}
    task    = BehaviourTree.Task:new()
    subject = AlwaysSucceedDecorator:new({control = control, node = task})
  end)

  it('should call success when node calls success', function()
    stub(control, 'success')
    function task:run()
      self:success()
    end
    subject:run()
    assert.stub(control.success).was.called()
  end)
  it('should call success when node calls fail', function()
    stub(control, 'success')
    function task:run()
      self:fail()
    end
    subject:run()
    assert.stub(control.success).was.called()
  end)
end)

