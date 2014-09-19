require 'spec/custom_asserts'
local BehaviourTree = require 'behaviour_tree'

describe('Decorator', function()
  local decorator, node, lastBlackboard, calledStart, calledEnd, calledRun
  before_each(function()
    lastBlackboard = false
    calledStart = false
    calledEnd = false
    calledRun = false
    node = BehaviourTree.Node:new({
      title = 'aNode',
      start = function() calledStart = true end,
      finish = function() calledEnd = true end,
      run = function(self, blackboard, cb)
        lastBlackboard = blackboard 
        calledRun = true 
        if cb ~= nil then
          cb(self) 
        end
      end 
    })
  end)

  describe('can be constructed with', function()
    describe('an object containing it\'s title and the node', function()
      before_each(function()
        decorator = BehaviourTree.Decorator:new({
          title = 'defaultDecorator',
          node = node
        })
      end)

      it('and the title is saved on the instance', function()
        assert.are.equal(decorator.title, 'defaultDecorator')
      end)

      it('and the node is saved on the instance', function()
        assert.are.equal(decorator.node, node)
      end)
    end)

    describe('an object containing it\'s title, but no node', function()
      before_each(function()
        BehaviourTree.register(node)
        decorator = BehaviourTree.Decorator:new({
          title = 'defaultDecorator'
        })
      end)

      it('and the title is saved on the instance', function()
        assert.are.equal(decorator.title, 'defaultDecorator')
      end)

      it('and the node is null', function()
        assert.are.equal(decorator.node, undefined)
      end)

      it('and we can set the node afterwards', function()
        decorator:setNode(node)
        assert.are.equal(decorator.node, node)
      end)

      it('and we can set the node afterwards by its title', function()
        decorator:setNode('aNode')
        assert.are.equal(decorator.node, node)
      end)
    end)

    describe('an object containing it\'s title and the title of the node', function()
      before_each(function()
        decorator = BehaviourTree.Decorator:new({
          title = 'defaultDecorator',
          node = 'aNode'
        })
      end)

      it('and the title is saved on the instance', function()
        assert.are.equal(decorator.title, 'defaultDecorator')
      end)

      it('and the node is saved on the instance', function()
        assert.are.equal(decorator.node.title, node.title)
        assert.are.equal(decorator.node:isInstanceOf(BehaviourTree.Node), true)
      end)
    end)
  end)

  describe('when having a default Decorator', function()
    before_each(function()
      isRunning = false
      hasFailed = false
      didSucceed = false
      decorator = BehaviourTree.Decorator:new({
        title = 'defaultDecorator',
        node = node
      })
    end)

    it('it just passes on start method', function()
      decorator:start()
      assert.are.equal(calledStart, true)
    end)

    it('it just passes on finish method', function()
      decorator:finish()
      assert.are.equal(calledEnd, true)
    end)

    it('it just passes on run method (with the blackboard object)', function()
      local blackboard = 42
      decorator:run(blackboard, function() end)
      assert.are.equal(calledRun, true)
      assert.are.equal(lastBlackboard, blackboard)
    end)

    describe('it just passes through the', function()
      local isRunning, hasFailed, didSucceed
      before_each(function()
        decorator:setControl({
          running = function() isRunning = true end,
          fail = function() hasFailed = true end,
          success = function() didSucceed = true end
        })
        decorator:start()
      end)

      it('success state', function()
        node:run(null, function(self) self:success() end)
        assert.are.equal(didSucceed, true)
      end)

      it('fail state', function()
        node:run(null, function(self) self:fail() end)
        assert.are.equal(hasFailed, true)
      end)

      it('running state', function()
        node:run(null, function(self) self:running() end)
        assert.are.equal(isRunning, true)
      end)
    end)

  end)
end)

