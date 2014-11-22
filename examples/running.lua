local BT = require('lib/behaviour_tree')
local count

local looking = BT.Task:new()
function looking:run()
  print("looking")
  success()
end
local runningTask = BT.Task:new()
function runningTask:run()
  print("running")
  if count == 10 then
    success()
  else
    running()
  end
end
 
BT.register('looking', looking)
BT.register('running', runningTask)

local Frank = BT:new({
  tree = BT.Sequence:new({
    nodes = {
      'looking', 'running'
    }
  })
})

for i = 1, 20 do
  count = i
  Frank:run()
end

