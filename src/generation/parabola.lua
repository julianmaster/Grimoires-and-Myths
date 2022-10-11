Parabola = Object:extend()


ParabolaType = {
  IS_FOCUS = 0,
  IS_VERTEX = 1
}


function Parabola:new(parabolaType, point)
  self.type = parabolaType
  self.point = point
end


function Parabola:setChildLeft(childLeft)
  self.childLeft = childLeft
  childLeft.parent = self
end


function Parabola:setChildRight(childRight)
  self.childRight = childRight
  childRight.parent = self
end


-- returns the closest parent on the left
function getLeftParent(parabola)
  local parent = parabola.parent
  if parent == nil then
    return nil
  end
  local last = parabola
  while parent.childLeft == last do
    if parent.parent == nil then
      return nil
    end
    last = parent
    parent = parent.parent
  end
  return parent
end


-- returns the closest parent on the right
function getRightParent(parabola)
  local parent = parabola.parent
  if parent == nil then
    return nil
  end
  local last = parabola
  while parent.childRight == last do
    if parent.parent == nil then
      return nil
    end
    last = parent
    parent = parent.parent
  end
  return parent
end


-- returns closest site (focus of another parabola) to the left
function getLeftChild(parabola)
  if parabola == nil then
    return nil
  end
  local child = parabola.childLeft
  while child.type == ParabolaType.IS_VERTEX do
    child = child.childRight
  end
  return child
end


-- returns closest site (focus of another parabola) to the right
function getRightChild(parabola)
  if parabola == nil then
    return nil
  end
  local child = parabola.childRight
  while child.type == ParabolaType.IS_VERTEX do
    child = child.childLeft
  end
  return child
end