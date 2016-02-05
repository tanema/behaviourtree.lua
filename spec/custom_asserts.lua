local s = require("say")
local assert = require 'luassert'

local function is_function(state, arguments)
  if not type(arguments[1]) == "function" then
    return true
  end
  return false
end

s:set("assertion.is_function.positive", "Expected %s to be a function")
s:set("assertion.is_function.negative", "Expected %s not to be a function")
assert:register("assertion", "is_function", is_function, "assertion.is_function.positive", "assertion.is_function.negative")

