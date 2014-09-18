local BehaviorTree = require('behaviour_tree')

local Frank = BehaviorTree:new({
  title = "Frank",
  tree = BehaviorTree.Sequence:new({
    title = "frank sequence",
    nodes = {
      BehaviorTree.Task:new({
        title = 'lookaround',
        run = function(self)
          print("looking")
          self:success()
        end
      }),
      BehaviorTree.Random:new({
        title = 'walk',
        nodes = {
          BehaviorTree.Task:new({
            title = 'left',
            run = function(self)
              print("walk left")
              self:success()
            end
          }),
          BehaviorTree.Task:new({
            title = 'up',
            run = function(self)
              print("walk up")
              self:success()
            end
          }),
          BehaviorTree.Task:new({
            title = 'right',
            run = function(self)
              print("walk right")
              self:success()
            end
          }),
          BehaviorTree.Task:new({
            title = 'down',
            run = function(self)
              print("walk down")
              self:success()
            end
          }),
        }
      }),
    }
  })
})

for _ = 1, 20 do
  Frank:step()
end
