local registeredNodes = {}

local Registry = {}

function Registry.register(name, node)
  registeredNodes[name] = node;
end

function Registry.getNode(name)
  if type(name) == 'string' then
    return registeredNodes[name]
  else
    return name
  end
end

return Registry
