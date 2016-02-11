local BehaviourTree = require 'lib/behaviour_tree'

describe('Active priority', function()
  describe('with no child running', function()
    local subject, control, task1, task2, task3
    before_each(function()
      control = {}
      task1 = BehaviourTree.Task:new()
      task2 = BehaviourTree.Task:new()
      task3 = BehaviourTree.Task:new()
      subject = BehaviourTree.ActivePriority:new({
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
    it('should call running on control if one node calls running', function()
      stub(control, 'running')
      function task1:run()
        self:fail()
      end
      function task2:run()
        self:running()
      end
      function task3:run()
        self:fail()
      end
      subject:run()
      assert.stub(control.running).was.called()
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

  describe('with a child already running', function()
    local subject, control, task1, task2, task3
    before_each(function()
      control = { success = function() end,
                  fail = function() end,
                  running = function() end}

      task1 = BehaviourTree.Task:new()
      task2 = BehaviourTree.Task:new()
      task3 = BehaviourTree.Task:new()
      function task1:run()
        self:fail()
      end
      function task2:run()
        self:running()
      end
      function task3:run()
        self:fail()
      end

      subject = BehaviourTree.ActivePriority:new({
        control = control,
        nodes = {task1, task2, task3} 
      })
      subject:start()
      subject:run()
    end)

    it('should still start from its first task when run', function()
      stub(task1, 'run')
      subject:run()
      assert.stub(task1.run).was.called()
    end)

    it('should stop the running child if a higher-priority child succeeds', function()
      function task1:run()
        self:success()
      end
      stub(task2, 'finish')
      subject:run()
      assert.stub(task2.finish).was.called()
    end)

    it('should call control with success if a higher-priority child succeds', function()
      function task1:run()
        self:success()
      end
      stub(control, 'success')
      subject:run()
      assert.stub(control.success).was.called()
    end)

    it('should stop the running child if a higher-priority child enters running', function()
      function task1:run()
        self:running()
      end
      stub(task2, 'finish')
      subject:run()
      assert.stub(task2.finish).was.called()
    end)

    it('should call control with running if a higher-priority child succeds', function()
      function task1:run()
        self:running()
      end
      stub(control, 'running')
      subject:run()
      assert.stub(control.running).was.called()
    end)

    it('should set self.runningTask = nil when all tasks fail', function()
      function task2:run()
        self:fail()
      end
      subject:run()
      assert.is_nil(subject.runningTask)
    end)
  end)
end)
