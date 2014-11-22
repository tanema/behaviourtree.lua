local BT = require('lib/behaviour_tree')

local Frank = BT:new({
  object = {name = 'test'},
  tree = BT.Sequence:new({
    nodes = {
      BT.Task:new({
        run = function(self, object)
          print(object.name .. " looking")
          success()
        end
      }),
      BT.Random:new({
        nodes = {
          BT.Task:new({
            run = function(self, object)
              print(object.name .. " walk left")
              success()
            end
          }),
          BT.Task:new({
            run = function(self, object)
              print(object.name .. " walk up")
              success()
            end
          }),
          BT.Task:new({
            run = function(self, object)
              print(object.name .. " walk right")
              success()
            end
          }),
          BT.Task:new({
            run = function(self, object)
              print(object.name .. " walk down")
              success()
            end
          }),
        }
      }),
    }
  })
})

for _ = 1, 20 do
  Frank:run()
end
