require 'spec/custom_asserts'
local BehaviourTree = require 'lib/behaviour_tree'
local AlwaysFailDecorator = BehaviourTree.AlwaysFailDecorator

describe('AlwaysFailDecorator', function()
  local alwaysDecorator, node, calledStart, calledEnd, calledRun
  before_each(function()
    calledStart = false
    calledEnd = false
    calledRun = false

    node = BehaviourTree.Node:new({
      start = function() calledStart = true end,
      finish = function() calledEnd = true end,
      run = function(self, cb) 
        calledRun = true
        cb(self) 
      end
    })

    alwaysDecorator = AlwaysFailDecorator:new({
      node = node
    })

  end)

  describe('always', function()
    local isRunning, hasFailed, didSucceed
    before_each(function()
      isRunning = false
      hasFailed = false
      didSucceed = false

      alwaysDecorator:setControl({
        running = function() isRunning = true end,
        fail = function() hasFailed = true end,
        success = function() didSucceed = true end
      })

      alwaysDecorator:start()
    end)

    it('returns fail on success state', function()
      node:run(function(self) 
        self:success()
      end)
      assert.is_true(hasFailed)
      assert.is_false(didSucceed)
    end)

    it('returns fail on fail state', function()
      node:run(function(self) 
        self:fail() 
      end)
      assert.is_true(hasFailed)
      assert.is_false(didSucceed)
    end)

    it('passes fail the running state', function()
      node:run(function(self) 
        self:running() 
      end)
      assert.is_true(isRunning)
    end)
  end)
end)

