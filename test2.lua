--Sequence is child of Node
--Selector is child of Node
--Task is child of Node
local BehaviorTree = require('behaviour_tree')

BehaviorTree.register('previouslyGeneratedTask', BehaviorTree.Task:new({
  -- Things to do on starting this task
  start = function()
  end,
  -- Things to do after finishing task
  finish = function()
  end,
  -- Things to do on each loop cycle
  run = function(self)
    self:success()
  end
}));

local tree = BehaviorTree:new({
  tree = BehaviorTree.Sequence:new({
    title = 'growing',
    nodes = {
      BehaviorTree.Task:new({
        title = 'leafing',
        run = function(self)
          self:fail()
        end
      }),
      'previouslyGeneratedTask',
      BehaviorTree.Priority:new({
        title = 'shrinking',
        nodes = {
          BehaviorTree.Decorator:new({task = 'loosingLeafes'})
        }
      }),
    }
  }),
})

-- Set object the behavior is meant to work on
tree.setObject({});

--[[
  In this Tree, we use registered Nodes for the Tasks
  Sequences and Selectors can be generated on the fly, using the given nodes and title
  Given nodes can also be decorators or filters
]]

local tree2 = BehaviorTree:new({
  tree = {
    title = 'planner',
    node_type = 'Sequence',
    nodes = {
      {
        title = 'fight',
        node_type = 'Random',
        nodes = {
          'sword',
          'bareHands'
        }
      },
      {
        title = 'idle',
        node_type = 'Random',
        nodes = {
          'walkAround',
          'standStill'
        }
      }
    }
  }
})

