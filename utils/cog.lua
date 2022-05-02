local cog = { _version = "1.0.0" }


local getiter = function(x)
  if lume.isarray(x) then
    return ipairs
  elseif type(x) == "table" then
    return pairs
  end
  error("expected table", 3)
end


function cog.containsValue(t, x)
  local iter = getiter(t)
  for _, v in iter(t) do
    if v == x then
      return true
    end
  end
  return false
end

function cog.containsKey(t, x)
  local iter = getiter(t)
  for k, _ in iter(t) do
    if k == x then
      return true
    end
  end
  return false
end

return cog