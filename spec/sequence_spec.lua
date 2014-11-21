require 'spec/custom_asserts'
local BehaviourTree = require 'behaviour_tree'

describe('Sequence', function()
  local sequence
  describe('can be constructed with', function()
    describe("an object containing it's nodes", function()
      before_each(function()
        sequence = BehaviourTree.Sequence:new({ nodes = 'runAll' })
      end)

      it('and the nodes is saved on the instance', function()
        assert.are.equal(sequence.nodes, 'runAll')
      end)
    end)
  end)

  describe('instance', function()
    before_each(function()
      sequence = BehaviourTree.Sequence:new({ })
    end)

    it('has the same methods like a BranchNode instance', function()
      assert.is_function(sequence._run)
      assert.is_function(sequence.run)
      assert.is_function(sequence.start)
      assert.is_function(sequence.finish)
      assert.is_function(sequence.running)
      assert.is_function(sequence.success)
      assert.is_function(sequence.fail)
    end)
  end)

  describe('when having a Sequence with two nodes', function()
    local node, hasRun1, beSuccess1, startCalled1, endCalled1,
        hasRun2, startCalled2, endCalled2
    before_each(function()
      beSuccess1 = true
      hasRun1 = false
      startCalled1 = false
      endCalled1 = false
      hasRun2 = false
      startCalled2 = false
      endCalled2 = false
      node = BehaviourTree.Node:new({
        run = function(self)
          hasRun1 = true
          if beSuccess1 then
            self:success()
          else
            self:fail()
          end
        end,
        start = function() startCalled1 = true end,
        finish = function() endCalled1 = true end
      })
      selector = BehaviourTree.Sequence:new({
        nodes = {
          node,
          BehaviourTree.Node:new({
            run = function(self) hasRun2 = true self:success() end,
            start = function() startCalled2 = true end,
            finish = function() endCalled2 = true end
          })
        }
      })
      selector:setControl({
        success = function() end,
        fail = function() end
      })
    end)

    describe('if success is called by first task', function()
      before_each(function()
        beSuccess1 = true
        selector:run()
      end)

      it("calls start of the next task in line", function()
        assert.truthy(startCalled2)
      end)

      it("calls run of the next task in line", function()
        assert.truthy(hasRun2)
      end)
    end)

    describe('if fail is called by first task', function()
      before_each(function()
        beSuccess1 = false
        selector:run()
      end)

      it("does not call start of the next task in line", function()
        assert.falsy(startCalled2)
      end)

      it("does not call run of the next task in line", function()
        assert.falsy(hasRun2)
      end)
    end)
  end)

  describe('when in Sequence with two nodes', function()
    local node, parentSelector, beSuccess, parentSuccessCalled, parentFailCalled
    before_each(function()
      beSuccess = true
      parentSuccessCalled = false
      parentFailCalled = false
      selector = BehaviourTree.Sequence:new({
        nodes = {
          BehaviourTree.Node:new({
            run = function(self) 
              if beSuccess then 
                self:success()
              else
                self:fail()
              end
            end
          })
        }
      })

      parentSelector = BehaviourTree.Sequence:new({
        nodes = { selector },
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
  end)
end)

