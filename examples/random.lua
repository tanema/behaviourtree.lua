local BT = require 'behaviour_tree'

local Frank = BT:new({
  object = {name = 'test'},
  tree = BT.Sequence:new({
    nodes = {
      BT.Task:new({
        run = function(task, object)
          print(object.name .. " looking")
          task:success()
        end
      }),
      BT.Random:new({
        nodes = {
          BT.Task:new({
            run = function(task, object)
              print(object.name .. " walk left")
              task:success()
            end
          }),
          BT.Task:new({
            run = function(task, object)
              print(object.name .. " walk up")
              task:success()
            end
          }),
          BT.Task:new({
            run = function(task, object)
              print(object.name .. " walk right")
              task:success()
            end
          }),
          BT.Task:new({
            run = function(task, object)
              print(object.name .. " walk down")
              task:success()
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
