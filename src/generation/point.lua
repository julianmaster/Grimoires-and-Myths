Point = Object:extend()


-- a point in 2D, sorted by y-coordinate
function Point:new(x, y)
  self.x = x
  self.y = y
end


function Point:compareTo(point)
  if self.y == point.y then
    if self.x > point.x then
      return false
    else
      return true
    end
  elseif self.y > point.y then
    return false
  else
    return true
  end
end


function Point:distance(point)
  return lume.distance(self.x, self.y, point.x, point.y, false)
end

function Point:__tostring()
  return "[" .. self.x .. ";" .. self.y .. "]"
end