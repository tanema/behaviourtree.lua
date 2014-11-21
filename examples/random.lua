local BT = require('behaviour_tree')

local Frank = BT:new({
  tree = BT.Sequence:new({
    nodes = {
      BT.Task:new({
        run = function(self)
          print("looking")
          self:success()
        end
      }),
      BT.Random:new({
        nodes = {
          BT.Task:new({
            run = function(self)
              print("walk left")
              self:success()
            end
          }),
          BT.Task:new({
            run = function(self)
              print("walk up")
              self:success()
            end
          }),
          BT.Task:new({
            run = function(self)
              print("walk right")
              self:success()
            end
          }),
          BT.Task:new({
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
