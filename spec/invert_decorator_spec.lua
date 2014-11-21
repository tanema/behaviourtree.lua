local BehaviourTree = require 'lib/behaviour_tree'

describe('InvertDecorator', function()
  local invertDecorator, node, calledStart, calledEnd, calledRun;
  before_each(function()
    calledStart = false
    calledEnd = false
    calledRun = false
    node = BehaviourTree.Node:new({
      start = function() calledStart = true; end,
      finish = function() calledEnd = true; end,
      run = function(self, cb) calledRun = true; cb(self); end
    });
    invertDecorator = BehaviourTree.InvertDecorator:new({
      node = node
    });
  end);

  describe('just', function()
    local isRunning, hasFailed, didSucceed;
    before_each(function()
      isRunning = false
      hasFailed = false
      didSucceed = false

      invertDecorator:setControl({
        running = function() isRunning = true; end,
        fail = function() hasFailed = true; end,
        success = function() didSucceed = true; end
      });

      invertDecorator:start();
    end);

    it('inverts the success state', function()
      node:run(function(self) self:success(); end)
      assert.is_false(didSucceed)
      assert.is_true(hasFailed)
    end);

    it('inverts the fail state', function()
      node:run(function(self) self:fail(); end)
      assert.is_true(didSucceed)
      assert.is_false(hasFailed)
    end);

    it('passes through the running state', function()
      node:run(function(self) self:running(); end)
      assert.is_true(isRunning)
    end)
  end)
end)


