local BehaviourTree = require 'lib/behaviour_tree'

describe('Sequence', function()
  local subject, control, task1, task2, task3
  before_each(function()
    control = {}
    task1 = BehaviourTree.Task:new()
    task2 = BehaviourTree.Task:new()
    task3 = BehaviourTree.Task:new()
    subject = BehaviourTree.Sequence:new({
      control = control,
      nodes = {task1, task2, task3} 
    })
    subject:start()
  end)

  it('should call success on control if all nodes succeed', function()
    stub(control, 'success')
    function task1:run()
      self:success()
    end
    function task2:run()
      self:success()
    end
    function task3:run()
      self:success()
    end
    subject:run()
    assert.stub(control.success).was.called()
  end)
  it('should call fail if a single node fails', function()
    stub(control, 'fail')
    function task1:run()
      self:success()
    end
    function task2:run()
      self:fail()
    end
    function task3:run()
      self:success()
    end
    subject:run()
    assert.stub(control.fail).was.called()
  end)
  it('should stop at a failing node', function()
    stub(control, 'fail')
    stub(task2, 'fail')
    stub(task3, 'success')
    function task1:run()
      self:success()
    end
    function task2:run()
      self:fail()
    end
    function task3:run()
      self:success()
    end
    subject:run()
    assert.stub(task2.fail).was.called()
    assert.stub(task3.success).was_not.called()
  end)

end)
