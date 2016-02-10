local BehaviourTree = require 'lib/behaviour_tree'
local Node = BehaviourTree.Node

describe('Node', function() 
  local subject
  before_each(function()
    subject = Node:new()
  end)

  describe(':initialize', function()
    it('should copy any attributes to the node', function()
      local node = Node:new({testfield = 'foobar'})
      assert.is_equal(node.testfield, 'foobar')
    end)
    it('should register the node if the name is set', function()
      local node = Node:new({name = 'foobar'})
      assert.is_equal(BehaviourTree.getNode('foobar'), node)
    end)
  end)

  describe(':start', function()
    it('has a start method', function()
      assert.is_function(subject.start)
    end)
  end)

  describe(':finish', function()
    it('has a finish method', function()
      assert.is_function(subject.finish)
    end)
  end)

  describe(':run', function()
    it('has a run method', function() 
      assert.is_function(subject.run)
    end)
  end)

  describe(':setObject', function()
    it('should set the object on the node', function()
      subject:setObject('foobar')
      assert.is_equal(subject.object, 'foobar')
    end)
  end)

  describe(':setControl', function()
    it('should set the controller on the node', function()
      subject:setControl('foobar')
      assert.is_equal(subject.control, 'foobar')
    end)
  end)

  describe(':running', function()
    it('should call running on the control if control defined', function()
      subject.control = {}
      stub(subject.control, 'running')
      subject:running()
      assert.stub(subject.control.running).was.called()
    end)
    it('should do nothing if has no control', function()
      -- testing no error here
      subject:running()
    end)
  end)

  describe(':success', function()
    it('should call success on the control if control defined', function()
      subject.control = {}
      stub(subject.control, 'success')
      subject:success()
      assert.stub(subject.control.success).was.called()
    end)
    it('should do nothing if has no control', function()
      subject:success()
    end)
  end)

  describe(':fail', function()
    it('should call fail on the control if control defined', function()
      subject.control = {}
      stub(subject.control, 'fail')
      subject:fail()
      assert.stub(subject.control.fail).was.called()
    end)
    it('should do nothing if has no control', function()
      subject:fail()
    end)
  end)

end)
