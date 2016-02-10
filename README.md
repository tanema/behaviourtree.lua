# BehaviourTree.lua 
[![Build history](https://secure.travis-ci.org/tanema/behaviourtree.lua.svg)](http://travis-ci.org/#!/tanema/behaviourtree.lua)
[![Coverage Status](https://coveralls.io/repos/github/tanema/behaviourtree.lua/badge.svg?branch=master)](https://coveralls.io/github/tanema/behaviourtree.lua?branch=master)

A Lua implementation of Behavior Trees ported from javascript [here](http://github.com/Calamari/BehaviorTree.js). They are useful for implementing AIs. If you need more information about Behavior Trees, look on [GameDevAI](http://aigamedev.com), there is a nice [video about Behavior Trees from Alex Champandard](http://aigamedev.com/open/article/behavior-trees-part1/). There is also a nice read of [Björn Knafla](http://www.altdevblogaday.com/author/bjoern-knafla/) explaining how [explaining how Behavior Trees work](http://www.altdevblogaday.com/2011/02/24/introduction-to-behavior-trees/).

## Installation

Just copy the lib folder into your project folder, rename it (example: 'behaviourtree') 

####For Plain Lua
`BehaviourTree = require('behaviourtree/behaviour_tree')`
####For Love 2D
`BehaviourTree = require('behaviourtree') --uses init.lua file`

## How to use

### Creating a simple task

A task is a simple `Node` (to be precise a leafnode), which takes care of all the dirty work in it's `run` method, which calls `success()`, `fail()` or `running()` in the end.

``` lua
local mytask = BehaviourTree.Task:new({
  -- (optional) this function is called directly before the run method
  -- is called. It allows you to setup things before starting to run
  -- Beware: if task is resumed after calling running(), start is not called.
  start = function(task, obj)
    obj.isStarted = true
  end,

  -- (optional) this function is called directly after the run method
  -- is completed with either success() or fail(). It allows you to clean up
  -- things, after you run the task.
  finish = function(task, obj)
    obj.isStarted = false
  end,

  -- This is the meat of your task. The run method does everything you want it to do.
  -- Finish it with one of these method calls:
  -- success() - The task did run successfully
  -- fail()    - The task did fail
  -- running() - The task is still running and will be called directly from parent node
  run = function(task, obj)
    success()
  end
});

--you can also declare a task like this
local myothertask = BehaviourTree.Task:new()
function myothertask:start(obj)
  obj.isStarted = true
end
function myothertask:finish(obj)
  obj.isStarted = false
end
function myothertask:run(obj)
  success()
end
--however the other syntax better lends itself to building an inline table
```

The methods:

* `start`  - Called before run is called. But not if task is resuming after ending with running().
* `finish` - Called after run is called. But not if task finished with running().
* `run`    - Contains the main things you want the task is doing.

The interesting part:

* the argument for all this methods is the object you pass in into the instance of `BehaviourTree` with the `setObject` method. This could be the object you want the behavior tree to control.

### Creating a sequence

A `Sequence` will call every one of it's subnodes one after each other until one node calls `fail()` or all nodes were called. If one node calls `fail()` the `Sequence` will call `fail()` too, else it will call `success()`.

``` lua
local mysequence = BehaviourTree.Sequence:new({
  nodes = {
    -- here comes in a list of nodes (Tasks, Sequences or Priorities)
    -- as objects or as registered strings
  }
})
```

### Creating a priority selector

A `Priority` calls every node in it's list until one node calls `success()`, then itself calls success internally. If none subnode calls `success()` the priority selector itself calls `fail()`.

``` lua
local myselector = BehaviourTree.Priority:new({
  nodes = {
    -- here comes in a list of nodes (Tasks, Sequences or Priorities)
    -- as objects or as registered strings
  }
})
```

### Creating a random selector

A `Random` selector calls randomly one node in it's list, if it returns running, it will be called again on next run.

``` lua
local myselector = BehaviourTree.Random:new({
  nodes = {
    -- here comes in a list of nodes (Tasks, Sequences or Priorities)
    -- as objects or as registered strings
  }
})
```

### Creating a behavior tree

Creating a behavior tree is fairly simple. Just instantiate the `BehaviourTree` class and put in a `Node` (or more probably a `BranchingNode` or `Priority`, like a `Sequence` or `Priority`) in the `tree` parameter.

``` lua
local mytree = BehaviourTree:new({
  tree = 'a selector' -- the value of tree can be either string (which is the registered name of a node), or any node
})
```

### Run through the behavior tree

Before you let the tree do it's work you can add an object to the tree. This object will be passed into every `start()`, `finish()` and `run()` method as first argument. You can use it, to let the Behavior tree know, on which object (e.g. artificial player) it is running. After this just call `run()` whenever you have time for some AI calculations in your game loop.

``` lua
mytree:setObject(someBot);
// do this in a loop:
mytree:run();
```

### Using a lookup table for your tasks

If you need the same nodes multiple times in a tree (or even in different trees), there is an easy method to register this nodes, so you can simply reference it by given name.

``` lua
-- register a tree node using the registry
BehaviourTree.register('testtask', mytask)
-- or register anything automatically by giving it a name
BehaviourTree.Task:new({
  name = 'registered task'
  -- run impl.
})

```

Now you can simply use it by name

### Now putting it all together

And now an example of how all could work together.

``` lua
BehaviourTree.Task:new({
  name = 'bark',
  run = function(self, dog)
    dog:bark()
    success()
  end
})

local btree = BehaviourTree:new({
  tree = BehaviourTree.Sequence:new({
    nodes: {
      'bark',
      BehaviourTree.Task:new({
        run = function(self, dog)
          dog:randomlyWalk()
          success()
        end
      }),
      'bark',
      BehaviourTree.Task:new({
        run = function(self, dog) 
          if dog:standBesideATree() then
            dog:liftALeg()
            dog:pee()
            success()
          else
            fail()
          end
        end
      }),

    }
  })
});

local dog = Dog:new(--[[..]]) -- the nasty details of a dog are omitted

btree:setObject(dog)
for _ = 1, 20 do
  btree:run()
end
```

In this example the following happens: each pass on the for loop (our game loop), the dog barks – we implemented this with a registered node, because we do this twice – then it walks randomly around, then it barks again and then if it find's itself standing beside a tree it pees on the tree.

### Decorators

Instead of a simple `Node` or any `BranchingNode` (like any selector), you can always pass in a `Decorator` instead, which decorates that node. Decorators wrap a node, and either control if they can be used, or do something with their returned state. (Just now) Implemented is the base class (or a transparent) `Decorator` which just does nothing but passing on all calls to the decorated node and passes through all states.

But it is useful as base class for new implementations, like the implemented `InvertDecorator` which flips success and fail states, the `AlwaysSucceedDecorator` which inverts the fail state, and the `AlwaysFailDecorator` which inverts the success state.

``` lua
local mysequence = BehaviourTree.Sequence:new({
  nodes = {
    -- here comes in a list of nodes (Tasks, Sequences or Priorities)
    -- as objects or as registered strings
  }
})
local decoratedSequence = BehaviourTree.InvertDecorator:new({
  node: mysequence
})
```

*Those three decorators are useful, but the most useful decorators are those you build for your project, that do stuff with your objects. Just [check out the code](https://github.com/tanema/behaviourtree.lua/blob/master/node_types/invert_decorator.lua), to see how simple it is, to create your decorator.*

## Contributing

If you want to contribute? If you have some ideas or critics, just open an issue, here on github. If you want to get your hands dirty, you can fork this repo. But note: If you write code, don't forget to write tests. And then make a pull request. I'll be happy to see what's coming.

##Specs

This project uses [busted](http://olivinelabs.com/busted/) for its specs. If you want to run the specs, you will have to install it first. Then just execute the following:

```bash
cd /folder/where/the/spec/folder/is
busted
```

## MIT License

Copyright (C) 2013 Georg Tavonius
Copyright (C) 2014 Tim Anema

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
