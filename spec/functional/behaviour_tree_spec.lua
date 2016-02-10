local BehaviourTree = require 'lib/behaviour_tree'

describe('BehaviourTree', function()
  local subject
  before_each(function()
    subject = BehaviourTree:new({tree = BehaviourTree.Task:new()})
  end)

  it('should not be able to run in the middle of a step', function()
    stub(subject.tree, 'run')
    subject:run()
    subject:run()
    assert.stub(subject.tree.run).was.called(1)
  end)
  it('should be nestable', function()
    local count = 0
    BehaviourTree.Task:new({
      name = 'countup',
      run = function(self, object)
        count = count + 1
        self:success()
      end
    })
    BehaviourTree.Sequence:new({
      name = 'taskseq',
      nodes = {'countup', 'countup', 'countup'}
    })
    BehaviourTree:new({
      name = 'nestingtree',
      tree = 'taskseq',
    })
    BehaviourTree.Sequence:new({
      name = 'treeseq',
      nodes = {'nestingtree', 'nestingtree'},
    })

    BehaviourTree:new({name = 'root', tree = 'treeseq'}):run()
    assert.is_equal(count, 6)
  end)
end)

