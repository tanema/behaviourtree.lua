local BehaviorTree = require('behaviour_tree')
local count

local Frank = BehaviorTree:new({
  title = "Frank",
  tree = BehaviorTree.Sequence:new({
    title = "frank sequence",
    nodes = {
      BehaviorTree.Task:new({
        run = function(self)
          print("looking")
          self:success()
        end
      }),
      BehaviorTree.Task:new({
        run = function(self)
          print("running")
          if count == 10 then
            self:success()
          else
            self:running()
          end
        end
      }),
    }
  })
})

for i = 1, 20 do
  count = i
  Frank:step()
end

