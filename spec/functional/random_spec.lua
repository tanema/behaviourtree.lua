local BehaviourTree = require 'lib/behaviour_tree'

describe('Random', function()
  local subject, control, task1, task2, task3
  before_each(function()
    control = {}
    task1 = BehaviourTree.Task:new()
    task2 = BehaviourTree.Task:new()
    task3 = BehaviourTree.Task:new()
    subject = BehaviourTree.Random:new({
      control = control,
      nodes = {task1, task2, task3} 
    })
    subject:start()
  end)

  it('should pick a random task', function()
    local s = spy.on(math, 'random')
    subject:start()
    assert.spy(s).was.called()
    math.random:revert()
  end)
  it('should call only one node', function()
    local count = 1
    stub(control, 'success')
    function task1:run()
      self:success()
      count = count + 1
    end
    function task2:run()
      self:success()
      count = count + 1
    end
    function task3:run()
      self:success()
      count = count + 1
    end
    subject:run()
    assert.is_equal(count, 2)
  end)
  it('should call success on control if the node succeeds', function()
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
  it('should call fail if the node fails', function()
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

end)
