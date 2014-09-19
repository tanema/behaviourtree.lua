require 'spec/custom_asserts'
local BehaviourTree = require 'behaviour_tree'

describe('BranchNode', function()
  local selector
  describe('can be constructed with', function()
    describe("an object containing it's title", function()
      before_each(function()
        selector = BehaviourTree.BranchNode:new({ title = 'choose' })
      end)

      it('and the title is saved on the instance', function()
        assert.are.equal(selector.title, 'choose')
      end)
    end)
  end)

  describe('instance', function()
    before_each(function()
      selector = BehaviourTree.BranchNode:new({ title = 'selector' })
    end)

    it('has the same methods like a Node instance', function()
      assert.is_function(selector.run)
      assert.is_function(selector.start)
      assert.is_function(selector.finish)
      assert.is_function(selector.running)
      assert.is_function(selector.success)
      assert.is_function(selector.fail)
    end)
  end)

  describe('the run method', function()
    local node, hasRun, beSuccess, startCalled, endCalled, canObj, runObj
    before_each(function()
      hasRun = false
      startCalled = 0
      endCalled = 0
      node = BehaviourTree.Node:new({
        run = function(self, arg)
          runObj = arg
          hasRun = true
          if beSuccess then
            self:success()
          else
            self:fail()
          end
        end,
        start = function() startCalled = startCalled + 1 end,
        finish = function() endCalled = endCalled + 1 end
      })
      selector = BehaviourTree.BranchNode:new({
        title = 'call it selector',
        nodes = { node }
      })
    end)

    it("run of task gets the object as argument we passed in", function()
      local testObj = 23
      selector:run(testObj)
      assert.are.equal(runObj, testObj)
    end)

    it('calls first the start method of next node before calling the run method', function()
      selector:run()
      assert.are.equal(startCalled, 1)
    end)

    describe('if success is called by task', function()
      it("calls the end method of task", function()
        beSuccess = true
        selector:run()
        assert.are.equal(endCalled, 1)
      end)
    end)

    describe('if fail is called by task', function()
      it("it still calls the end method of task", function()
        beSuccess = false
        selector:run()
        assert.are.equal(endCalled, 1)
      end)
    end)
  end)

  describe('the start method', function()
    local node, runObj, testObj
    before_each(function()
      testObj = 123
      node = BehaviourTree.Node:new({
        run = function(self)
          self:success()
        end,
        start = function(self, arg)
          runObj = arg
        end
      })
      selector = BehaviourTree.BranchNode:new({
        title = 'test me',
        nodes = { node }
      })
      selector:run(testObj)
    end)

    it("gets the object as argument we passed in", function()
      assert.are.equal(runObj,testObj)
    end)
  end)

  describe('the end method', function()
    local node, runObj, testObj, beSuccess
    before_each(function()
      testObj = 123
      node = BehaviourTree.Node:new({
        run = function(self)
          if beSuccess then
            self:success()
          else 
            self:fail()
          end
        end,
        finish = function(self, arg)
          runObj = arg
        end
      })
      selector = BehaviourTree.BranchNode:new({
        title = 'test me twice',
        nodes = { node }
      })
    end)

    describe('if success is called by task', function()
      before_each(function()
        beSuccess = true
        selector:run(testObj)
      end)

      it("gets the object as argument we passed in", function()
        assert.are.equal(runObj, testObj)
      end)
    end)

    describe('if fail is called by task', function()
      before_each(function()
        beSuccess = false
        selector:run(testObj)
      end)

      it("gets the object as argument we passed in", function()
        assert.are.equal(runObj, testObj)
      end)
    end)
  end)
end)

