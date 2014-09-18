local registeredNodes = {}

local Registry = {}

function Registry.register(name, node)
  if type(name) == 'string' then
    registeredNodes[name] = node;
  else -- name is the node 
    registeredNodes[name.title] = name;
  end
end

function Registry.getNode(name)
  if type(name) == 'string' then
    return registeredNodes[name]
  else
    return name
  end
end

return Registry
