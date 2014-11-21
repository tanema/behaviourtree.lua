require 'spec/custom_asserts'
local BehaviourTree = require 'behaviour_tree'
local AlwaysSucceedDecorator = BehaviourTree.AlwaysSucceedDecorator

describe('AlwaysSucceedDecorator', function()
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

    alwaysDecorator = AlwaysSucceedDecorator:new({
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

    it('returns success on success state', function()
      node:run(function(self) 
        self:success()
      end)
      assert.is_false(hasFailed)
      assert.is_true(didSucceed)
    end)

    it('returns success on fail state', function()
      node:run(function(self) 
        self:fail() 
      end)
      assert.is_false(hasFailed)
      assert.is_true(didSucceed)
    end)

    it('passes through the running state', function()
      node:run(function(self) 
        self:running() 
      end)
      assert.is_true(isRunning)
    end)
  end)
end)


