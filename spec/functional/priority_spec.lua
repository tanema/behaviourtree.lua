local BehaviourTree = require 'lib/behaviour_tree'

describe('Priority selector', function()
  local subject, control, task1, task2, task3
  before_each(function()
    control = {}
    task1 = BehaviourTree.Task:new()
    task2 = BehaviourTree.Task:new()
    task3 = BehaviourTree.Task:new()
    subject = BehaviourTree.Priority:new({
      control = control,
      nodes = {task1, task2, task3} 
    })
    subject:start()
  end)

  it('should call success on control if one node calls success', function()
    stub(control, 'success')
    function task1:run()
      self:fail()
    end
    function task2:run()
      self:success()
    end
    function task3:run()
      self:fail()
    end
    subject:run()
    assert.stub(control.success).was.called()
  end)
  it('should call fail if all nodes fail', function()
    stub(control, 'fail')
    function task1:run()
      self:fail()
    end
    function task2:run()
      self:fail()
    end
    function task3:run()
      self:fail()
    end
    subject:run()
    assert.stub(control.fail).was.called()
  end)
  it('should stop at a sucessful node', function()
    stub(control, 'success')
    stub(task2, 'success')
    stub(task3, 'success')
    function task1:run()
      self:fail()
    end
    function task2:run()
      self:success()
    end
    function task3:run()
      self:success()
    end
    subject:run()
    assert.stub(task2.success).was.called()
    assert.stub(task3.success).was_not.called()
  end)

end)

