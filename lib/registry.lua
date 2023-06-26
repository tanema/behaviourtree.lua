local registeredNodes = {}

local Registry = {}

function Registry.register(nodeTemplates)
  for name, template in pairs(nodeTemplates) do
    registeredNodes[name] = template;
  end
end

-- can be name of registered template, node template, or node object
function Registry.getNode(node)
  if type(node) == 'string' then
    local template = registeredNodes[node]
    return Registry.createNodeFromTemplate(template)
  elseif node.type then
    return Registry.createNodeFromTemplate(node)
  else
    return node
  end
end

function Registry.createNodeFromTemplate(template)
  if template.nodes then
    local nodes = {}
    for i, node in ipairs(template.nodes) do
      nodes[i] = Registry.getNode(node)
    end
    return template.type:new({
      nodes = nodes
    })
  end

  return template.type:new({
    start = template.start,
    finish = template.finish,
    run = template.run,
  })
end

return Registry
