require 'spec/custom_asserts'
local BehaviourTree = require 'behaviour_tree'

describe('Random', function()
  local random
  describe('can be constructed with', function()
    describe('an object containing it\'s nodes', function()
      before_each(function()
        random = BehaviourTree.Random:new({ nodes = 'runAny' })
      end)

      it('and the nodes is saved on the instance', function()
        assert.are.equal(random.nodes, 'runAny')
      end)
    end)
  end)

  describe('instance', function()
    before_each(function()
      random = BehaviourTree.Random:new({ })
    end)

    it('has the same methods like a BranchNode instance', function()
      assert.is_function(random._run)
      assert.is_function(random.run)
      assert.is_function(random.start)
      assert.is_function(random.finish)
      assert.is_function(random.running)
      assert.is_function(random.success)
      assert.is_function(random.fail)
    end)
  end)

  describe('when having a RandomSelector with two nodes', function()
    local node1, node2, hasRun1, beSuccess, willRun, startCalled1, endCalled1,
        hasRun2, startCalled2, endCalled2, selector

    before_each(function()
      beSuccess = true
      hasRun1 = 0
      hasRun2 = 0
      startCalled1 = false
      endCalled1 = false
      startCalled2 = false
      endCalled2 = false
      node1 = BehaviourTree.Node:new({
        run = function(self)
          hasRun1 = hasRun1 + 1
          if willRun then
            self:running()
          elseif beSuccess then
            self:success()
          else 
            self:fail()
          end
        end,
        start = function() startCalled1 = true end,
        finish = function() endCalled1 = true end
      })
      node2 = BehaviourTree.Node:new({
        run = function(self)
          hasRun2 = hasRun2 + 1
          if willRun then
            self:running()
          elseif beSuccess then
            self:success()
          else
            self:fail()
          end
        end,
        start = function() startCalled2 = true end,
        finish = function() endCalled2 = true end
      })
      selector = BehaviourTree.Random:new({
        nodes = {
          node1,
          node2
        }
      })
      selector:setControl({
        running = function() end,
        success = function() end,
        fail = function() end
      })
    end)

    describe('if task will be success', function()
      local old_rand = math.random
      before_each(function()
        beSuccess = true
        math.random = function() return 0.7 end
        selector:run()
      end)

      after_each(function()
        math.random = old_rand
      end)

      it('runs randomly one task', function()
        assert.are.equal(hasRun1, 0)
        assert.truthy(hasRun2)
      end)

      it('starts randomly only one task', function()
        assert.falsy(startCalled1)
        assert.truthy(startCalled2)
      end)
    end)

    describe('if task will fail', function()
      local old_rand = math.random
      before_each(function()
        beSuccess = false
        math.random = function() return 0.7 end
        selector:run()
      end)

      after_each(function()
        math.random = old_rand
      end)

      it('runs randomly only that one task', function()
        assert.are.equal(hasRun1, 0)
        assert.truthy(hasRun2)
      end)

      it('starts randomly only that one task', function()
        assert.falsy(startCalled1)
        assert.truthy(startCalled2)
      end)
    end)

    describe('if task will return running', function()
      local old_rand = math.random
      before_each(function()
        willRun = true
        math.random = function() return 0.7 end
        selector:run()
      end)

      after_each(function()
        math.random = old_rand
      end)

      it('will run that one again on run() and only start it once', function()
        assert.are.equal(hasRun1, 0)
        assert.are.equal(hasRun2, 1)
        assert.truthy(startCalled2)

        startCalled2 = false
        math.random = function() return 0.3 end
        selector:run()
        assert.are.equal(hasRun1, 0)
        assert.are.equal(hasRun2, 2)
        assert.falsy(startCalled2)

        math.random = function() return 0.1 end
        selector:run()
        assert.are.equal(hasRun1, 0)
        assert.are.equal(hasRun2, 3)
        assert.falsy(startCalled2)
      end)

      it('starts randomly only that one task', function()
        assert.falsy(startCalled1)
        assert.truthy(startCalled2)
      end)
    end)
  end)

  describe('when in RandomSelector with two nodes', function()
    local parentSelector, beSuccess, willRun, parentSuccessCalled, parentFailCalled, parentRunningCalled, selector
    before_each(function()
      beSuccess = true
      parentSuccessCalled = false
      parentFailCalled = false
      selector = BehaviourTree.Random:new({
        nodes = {
          BehaviourTree.Node:new({
            run = function(self)
              if willRun then
                self:running()
              elseif beSuccess then
                self:success()
              else
                self:fail()
              end
            end
          })
        }
      })

      parentSelector = BehaviourTree.Random:new({
        nodes = { selector },
        running = function()
          parentRunningCalled = true
        end,
        success = function()
          parentSuccessCalled = true
        end,
        fail = function()
          parentFailCalled = true
        end
      })
    end)

    describe('all task result in success', function()
      it('calls success also in parent node', function()
        beSuccess = true
        parentSelector:run()
        assert.truthy(parentSuccessCalled)
      end)
    end)

    describe('a task results in failure', function()
      it('calls fail also in parent node', function()
        beSuccess = false
        parentSelector:run()
        assert.truthy(parentFailCalled)
      end)
    end)

    describe('a task resulting in running', function()
      it('calls running also in parent node', function()
        willRun = true
        parentSelector:run()
        assert.truthy(parentRunningCalled)
      end)
    end)
  end)
end)
