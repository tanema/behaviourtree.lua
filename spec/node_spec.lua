require 'spec/custom_asserts'
local BehaviourTree = require 'behaviour_tree'
local Node = BehaviourTree.Node

describe('Node', function() 
  describe('can be constructed with', function() 
    describe("an object containing", function() 

      local node

      describe("a title", function() 
        before_each(function() 
          node = Node:new({title = 'firstNode'})
        end)

        it('and the title is saved on the instance', function() 
          assert.are.equal(node.title, 'firstNode')
        end)
      end)

      describe("a run method", function()
        before_each(function()
          node = Node:new({
            run = function()
              return true
            end
          })
        end)

        it('and it is available on the instance', function()
          assert.is_true(node.run())
        end)
      end)
    end)
  end)

  describe('an instance', function()
    local  node

    before_each(function()
      node = Node:new({ title = 'node' })
    end)

    it('has a start method', function()
      assert.is_function(node.start)
    end)

    it('has a finish method', function()
      assert.is_function(node.finish)
    end)

    it('has a run method', function() 
      assert.is_function(node.run)
    end)
  end)

end)
