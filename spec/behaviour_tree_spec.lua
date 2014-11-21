require 'spec/custom_asserts'
local BehaviourTree = require 'lib/behaviour_tree'

describe('BehaviourTree', function()
  describe('can be constructed with', function()
    it("an object containing the tree key", function()
      local btree = BehaviourTree:new({tree = {}})
      assert.is_true(btree:isInstanceOf(BehaviourTree))
    end)
  end)

  it('has a register method', function()
    assert.is_function(BehaviourTree.register)
  end)

  it('has a getNode method', function()
    assert.is_function(BehaviourTree.getNode)
  end)

  describe('can save an object with register method', function()
    local node = BehaviourTree.Node:new({})
    before_each(function()
      BehaviourTree.register('myNode', node)
    end)
    it("and getNode returns it", function()
      assert.are.equal(BehaviourTree.getNode('myNode'), node)
    end)
  end)

  describe('an instance', function()
    local btree
    before_each(function()
      btree = BehaviourTree:new({
        tree = BehaviourTree.Task:new({})
      })
    end)

    it('has a run method', function()
      assert.is_function(btree.run)
    end)

    it('has a setObject method', function()
      assert.is_function(btree.setObject)
    end)
  end)

  describe('setup with a minimal tree', function()
    local btree, runCount, startCalled, endCalled

    before_each(function()
      runCount = 0
      beSuccess = false
      startCalled = false
      endCalled = false

      btree = BehaviourTree:new({
        tree = BehaviourTree.Task:new({
          start = function() startCalled = true end,
          finish = function() endCalled = true end,
          run = function(self)
            runCount = runCount + 1
            self:success()
          end
        })
      })
    end)

    it('the run method calls start of root node', function()
      btree:run()
      assert.is_true(startCalled)
    end)

    it('the run method calls run of root node', function()
      btree:run()
      assert.are.equal(runCount, 1)
    end)

    it('the run method calls end of root node on success', function()
      beSuccess = true
      btree:run()
      assert.is_true(endCalled)
    end)

    it('the run method calls end of root node on fail', function()
      btree:run()
      assert.is_true(endCalled)
    end)
  end)

  describe('when having a more complex tree', function()
    local runCount1, runCount2, beSuccess1, beSuccess2, stillRunning2

    before_each(function()
      runCount1 = 0
      runCount2 = 0
      beSuccess1 = false
      beSuccess2 = false
      stillRunning2 = false

      btree = BehaviourTree:new({
        tree = BehaviourTree.Sequence:new({
          nodes = {
            BehaviourTree.Task:new({
              run = function(self)
                runCount1 = runCount1 + 1
                if beSuccess1 then 
                  self:success()
                else 
                  self:fail()
                end
              end
            }),
            BehaviourTree.Task:new({
              run = function(self)
                runCount2 = runCount2 + 1
                if stillRunning2 then
                  self:running()
                elseif beSuccess2 then 
                  self:success()
                else 
                  self:fail()
                end
              end
            })
          }
        })
      })
    end)

    describe('if first task runs through immediately and the second says running', function()
      before_each(function()
        beSuccess1 = true
        stillRunning2 = true
      end)

      describe('and we call run once', function()
        before_each(function()
          btree:run()
        end)

        it('both run methods are called', function()
          assert.are.equal(runCount1, 1)
          assert.are.equal(runCount2, 1)
        end)

        it('the first node will not be called again on second run', function()
          btree:run()
          assert.are.equal(runCount1, 1)
        end)

        it('the second node will be called on second run', function()
          btree:run()
          assert.are.equal(runCount2, 2)
        end)

      end)
    end)
  end)

  describe('when setting setObject to the tree', function()
    local obj, runCount

    before_each(function()
      runCount = 0
      obj = { foo = 'bar' }
      btree = BehaviourTree:new({
        tree = BehaviourTree.Task:new({
          run = function(self,object) 
            assert.are.equal(object, obj)
            runCount = runCount + 1
          end
        })
      })
      btree:setObject(obj)
    end)

    it('the run method has the object as argument', function()
      btree:run()
      assert.are.equal(runCount, 1)
    end)
  end)

  describe('when setting object as config and having more then one node', function()
    local obj, runCount

    before_each(function()
      runCount = 0
      obj = { word = 'bird' }
      btree = BehaviourTree:new({
        object = obj,
        tree = BehaviourTree.Sequence:new({
          nodes = {
            BehaviourTree.Task:new({
              run = function(self,object)
                assert.are.equal(object, obj)
                runCount = runCount + 1
              end
            })
          }
        })
      })
    end)

    it('the run method has the object as argument', function()
      btree:run()
      assert.are.equal(runCount, 1)
    end)
  end)

  describe('a minimal tree with a lookup task as root note', function()
    local hasRunObj, testObj1, callSuccess

    before_each(function()
      hasRunObj = {}
      testObj1 = { sim = 'ba' }
      BehaviourTree.register('testtask', BehaviourTree.Task:new({
        run = function(self,obj)
          hasRunObj[#hasRunObj+1] = obj
          if (callSuccess) then
            self:success()
          end
        end
      }))
      btree = BehaviourTree:new({
        tree = 'testtask'
      })
    end)

    it('runs the registered task with right test obj', function()
      btree:setObject(testObj1)
      btree:run()
      assert.are.equal(hasRunObj[1], testObj1)
    end)

    describe('and looking up the same task in another tree', function()
      local btree2, testObj2

      before_each(function()
        testObj2 = { sim = 'babwe' }
        btree2 = BehaviourTree:new({
          tree = 'testtask'
        })
      end)

      it('also runs the registered task with right test obj', function()
        btree2:setObject(testObj2)
        btree2:run()
        assert.are.equal(hasRunObj[1], testObj2)
      end)

      describe('and setting up objects and calling both trees', function()
        before_each(function()
          btree2:setObject(testObj2)
          btree:setObject(testObj1)
          btree:run()
          btree2:run()
        end)

        it('gives the right objects', function()
          assert.are.equal(hasRunObj[1], testObj1)
          assert.are.equal(hasRunObj[2], testObj2)
        end)
      end)
    end)
  end)

  describe('register can also be called using the title instead with explicit name', function()
    local hasRunObj, testObj1

    before_each(function()
      hasRunObj = null
      testObj1 = { sim = 'ba' }

      BehaviourTree.register('testtask', BehaviourTree.Task:new({
        run = function(self,obj)
          hasRunObj = obj
          self:success()
        end
      }))
      btree = BehaviourTree:new({
        tree = 'testtask'
      })
      btree:setObject(testObj1)
      btree:run()
    end)

    it('runs the registered task with right test obj', function()
      assert.are.equal(hasRunObj, testObj1)
    end)
  end)

  describe('with several tasks to lookup', function()
    local hasRunObj1, hasRunObj2, testObj1, beSuccess

    before_each(function()
      beSuccess = true
      hasRunObj1 = {}
      hasRunObj2 = {}
      testObj1 = { sim = 'ba' }

      BehaviourTree.register('testtask', BehaviourTree.Task:new({
        run = function(self,obj)
          hasRunObj1[#hasRunObj1+1] = obj
          if beSuccess then
            self:success()
          else
            self:fail()
          end
        end
      }))
      BehaviourTree.register('testtask2', BehaviourTree.Task:new({
        run = function(self,obj) 
          hasRunObj2[#hasRunObj2+1] = obj
        end
      }))
      btree = BehaviourTree:new({
        tree = BehaviourTree.Sequence:new({
          nodes = {
            'testtask',
            'testtask2'
          }
        })
      })
    end)

    it('runs the registered tasks both with right test obj', function()
      btree:setObject(testObj1)
      btree:run()
      assert.are.equal(hasRunObj1[1], testObj1)
      assert.are.equal(hasRunObj2[1], testObj1)
    end)

    describe('and looking up the same tasks in another tree', function()
      local btree2, testObj2
      before_each(function()
        testObj2 = { sim = 'babwe' }
        btree2 = BehaviourTree:new({
          tree = BehaviourTree.Sequence:new({
            nodes = {
              'testtask',
              'testtask2'
            }
          })
        })
      end)

      it('also runs the registered tasks with right test obj', function()
        btree2:setObject(testObj2)
        btree2:run()
        assert.are.equal(hasRunObj1[1], testObj2)
        assert.are.equal(hasRunObj2[1], testObj2)
      end)

      describe('and setting up objects and calling both trees', function()
        before_each(function()
          btree2:setObject(testObj2)
          btree:setObject(testObj1)
          btree:run()
          btree2:run()
        end)

        it('gives the right objects', function()
          assert.are.equal(hasRunObj1[1], testObj1)
          assert.are.equal(hasRunObj1[2], testObj2)
          assert.are.equal(hasRunObj2[1], testObj1)
          assert.are.equal(hasRunObj2[2], testObj2)
        end)
      end)
    end)

    describe('and if the sequence also is looked up', function()
      local btree3
      local testObj3 = { sim = 'foo' }
      before_each(function()
        BehaviourTree.register('le sequence', BehaviourTree.Sequence:new({
          nodes = {
            'testtask',
            'testtask2'
          }
        }))
        btree3 = BehaviourTree:new({
          tree = 'le sequence'
        })
      end)

      it('also runs the registered tasks with right test obj', function()
        btree3:setObject(testObj3)
        btree3:run()
        assert.are.equal(hasRunObj1[1], testObj3)
        assert.are.equal(hasRunObj2[1], testObj3)
      end)

      describe('and we call the sequence with several trees', function()
        before_each(function()
          btree:setObject(testObj1)
          btree3:setObject(testObj3)
          btree:run()
          btree3:run()
        end)

        it('gives the right objects', function()
          assert.are.equal(hasRunObj1[1], testObj1)
          assert.are.equal(hasRunObj1[2], testObj3)
          assert.are.equal(hasRunObj2[1], testObj1)
          assert.are.equal(hasRunObj2[2], testObj3)
        end)
      end)
    end)

    describe('and if the priority selector also is looked up', function()
      local btree3, testObj3
      before_each(function()
        testObj3 = { sim = 'bar' }
        BehaviourTree.register('le selector', BehaviourTree.Priority:new({
          nodes = {
            'testtask',
            'testtask2'
          }
        }))
        btree3 = BehaviourTree:new({
          tree = 'le selector'
        })
      end)

      it('also runs the registered tasks with right test obj', function()
        beSuccess = false
        btree3:setObject(testObj3)
        btree3:run()
        assert.are.equal(hasRunObj1[1], testObj3)
        assert.are.equal(hasRunObj2[1], testObj3)
      end)

      describe('and we call the priority selector with several trees', function()
        before_each(function()
          btree:setObject(testObj1)
          btree3:setObject(testObj3)
          btree:run()
          beSuccess = false
          btree3:run()
        end)

        it('gives the right objects', function()
          assert.are.equal(hasRunObj1[1], testObj1)
          assert.are.equal(hasRunObj1[2], testObj3)
          assert.are.equal(hasRunObj2[1], testObj1)
          assert.are.equal(hasRunObj2[2], testObj3)
        end)
      end)
    end)
  end)

  describe('with a failing lookup task as root note', function()
    local hasRunObj, testObj1, callSuccess
    before_each(function()
      hasRunObj = {}
      testObj1 = { sim = 'ba' }
      BehaviourTree.register('testtask', BehaviourTree.Task:new({
        run = function(self,obj)
          hasRunObj[#hasRunObj+1] = obj
          self:fail()
        end
      }))
      btree = BehaviourTree:new({
        tree = 'testtask'
      })
    end)

    it('runs the registered task with right test obj', function()
      btree:setObject(testObj1)
      btree:run()
      assert.are.equal(hasRunObj[1], testObj1)
    end)
  end)

  describe('with a failing lookup sequence', function()
    local hasRunObj, testObj1, callSuccess
    before_each(function()
      hasRunObj = {}
      testObj1 = { sim = 'ba' }
      BehaviourTree.register('testtask', BehaviourTree.Task:new({
        run = function(self,obj)
          hasRunObj[#hasRunObj+1] = obj
          self:fail()
        end
      }))
      BehaviourTree.register('testseq', BehaviourTree.Sequence:new({
        nodes = {
          'testtask',
          BehaviourTree.Task:new({
            run = function(self,obj)
              assert.are.equal(true, false)-- self should not run 
            end
          })
        }
      }))
      btree = BehaviourTree:new({
        tree = 'testseq'
      })
    end)

    it('runs the first task in sequence with right test obj', function()
      btree:setObject(testObj1)
      btree:run()
      assert.are.equal(hasRunObj[1], testObj1)
    end)
  end)

  describe('with a task that is running and happens to be in another tree', function()
    local btree, btree2, hasRunObj, testObj1, testObj2
    before_each(function()
      hasRunObj = {}
      testObj1 = { foo = 'ba' }
      testObj2 = { foo = 'bar' }
      BehaviourTree.register('testtask', BehaviourTree.Task:new({
        run = function(self,obj)
          hasRunObj[#hasRunObj+1] = obj
          self:running()
        end
      }))
      BehaviourTree.register('testseq', BehaviourTree.Sequence:new({
        nodes = {
          'testtask'
        }
      }))
      btree = BehaviourTree:new({
        tree = 'testseq'
      })
      btree2 = BehaviourTree:new({
        tree = 'testseq'
      })
    end)

    it('has the right object when called twice in same tree', function()
      btree:setObject(testObj1)
      btree:run()
      btree:run()
      assert.are.equal(hasRunObj[1], testObj1)
      assert.are.equal(hasRunObj[2], testObj1)
    end)

    it('has the right object when called in both trees', function()
      btree2:setObject(testObj2)
      btree:setObject(testObj1)
      btree:run()
      btree2:run()
      btree2:run()
      btree:run()
      assert.are.equal(hasRunObj[1], testObj1)
      assert.are.equal(hasRunObj[2], testObj2)
      assert.are.equal(hasRunObj[3], testObj2)
      assert.are.equal(hasRunObj[4], testObj1)
    end)
  end)

  describe('the start method of root task', function()
    local node, runObj, btree, testObj
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
      btree = BehaviourTree:new({
        tree = node
      })
      btree:setObject(testObj)
      btree:run()
    end)

    it("gets the object as argument we passed in", function()
      assert.are.equal(runObj, testObj)
    end)
  end)

  describe('the end method of root task', function()
    local node, runObj, btree, testObj, beSuccess
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
      btree = BehaviourTree:new({
        tree = node
      })
      btree:setObject(testObj)
    end)

    describe('if success is called by task', function()
      before_each(function()
        beSuccess = true
      end)
      it("gets the object as argument we passed in", function()
        btree:run()
        assert.are.equal(runObj, testObj)
      end)
    end)

    describe('if fail is called by task', function()
      before_each(function()
        beSuccess = false
      end)
      it("gets the object as argument we passed in", function()
        btree:run()
        assert.are.equal(runObj, testObj)
      end)
    end)
  end)

  describe('having a running task under a Sequence', function()
    local node, runCount, runHighPrio, runFirstSeq, btree
    before_each(function()
      runCount = 0
      runHighPrio = 0
      runFirstSeq = 0
      node = BehaviourTree.Node:new({
        run = function(self)
          runCount = runCount + 1
          self:running()
        end,
        finish = function(arg)
          runObj = arg
        end
      })
      btree = BehaviourTree:new({
        tree = BehaviourTree.Priority:new({
          nodes = {
            BehaviourTree.Node:new({
              run = function(self)
                runHighPrio = runHighPrio + 1
                self:fail()
              end
            }),
            BehaviourTree.Sequence:new({
              nodes = {
                BehaviourTree.Node:new({
                  run = function(self)
                    runFirstSeq = runFirstSeq + 1
                    self:success()
                  end
                }),
                node
              }
            })
          }
        })
      })
      btree:run()
      btree:run()
    end)

    it('tries running task in first position of priority selector', function()
      assert.are.equal(runHighPrio, 2);
    end);

    it('does not run the task in sequence before the running task', function()
      assert.are.equal(runFirstSeq, 1);
    end);

    it('reruns the running task again', function()
      assert.are.equal(runCount, 2);
    end);

  end)
end)

