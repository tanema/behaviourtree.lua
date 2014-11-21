local BT = require('lib/behaviour_tree')
local count

local looking = BT.Task:new()
function looking:run()
  print("looking")
  self:success()
end
local running = BT.Task:new()
function running:run()
  print("running")
  if count == 10 then
    self:success()
  else
    self:running()
  end
end
 
BT.register('looking', looking)
BT.register('running', running)

local Frank = BT:new({
  tree = BT.Sequence:new({
    nodes = {
      'looking', 'running'
    }
  })
})

for i = 1, 20 do
  count = i
  Frank:step()
end

