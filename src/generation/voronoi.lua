Voronoi = Object:extend()


function Voronoi:new(sites)
  self.sites = sites
  self.edges = {}
  self.width = 1
  self.height = 1
  self:generateVoronoi()
end


function Voronoi:generateVoronoi()
  self.events = {}
  for _,p in ipairs(self.sites) do
    table.insert(self.events, Event(p, EventType.SITE_EVENT))
    table.sort(self.events, compareEvent)
  end

  -- process events (sweep line)
  local count = 0
  while #self.events > 0 do
    local e = self.events[1]
    table.remove(self.events, 1)
    self.yCurr = e.point.y
    count = count + 1
    if e.type == EventType.SITE_EVENT then
      self:handleSite(e.point)
    else
      self:handleCircle(e)
    end
  end

  self.yCurr = self.width + self.height

  self:endEdges(self.root) -- close off any dangling edges

  -- get rid of those crazy infinite lines
  for _,e in ipairs(self.edges) do
    if e.neighbor ~= nil then
      e.start = e.neighbor.endP
      e.neighbor = nil
    end
  end
end


-- end all unfinished edges
function Voronoi:endEdges(parabola)
  if parabola.type == ParabolaType.IS_FOCUS then
    parabola = nil
    return
  end

  local x = self:getXofEdge(parabola)
  parabola.edge.endP = Point(x, parabola.edge.slope * x + parabola.edge.yInt)
  table.insert(self.edges, parabola.edge)

  self:endEdges(parabola.childLeft)
  self:endEdges(parabola.childRight)

  parabola = nil
end


--  processes site event
function Voronoi:handleSite(point)
  -- base case
  if self.root == nil then
    self.root = Parabola(ParabolaType.IS_FOCUS, point)
    return
  end

  -- find parabola on beach line right above p
  local par = self:getParabolaByX(point.x)
  if par.event ~= nil then
    lume.remove(self.events, par.event)
    par.event = nil
  end

  -- create new dangling edge; bisects parabola focus and p
  local start = Point(point.x, self:getY(par.point, point.x))
  local el = Edge(start, par.point, point)
  local er = Edge(start, point, par.point)
  el.neighbor = er
  er.neighbor = el
  par.edge = el
  par.type = ParabolaType.IS_VERTEX

  -- replace original parabola par with p0, p1, p2
  local p0 = Parabola(ParabolaType.IS_FOCUS, par.point)
  local p1 = Parabola(ParabolaType.IS_FOCUS, point)
  local p2 = Parabola(ParabolaType.IS_FOCUS, par.point)

  par:setChildLeft(p0)
  par:setChildRight(Parabola(ParabolaType.IS_VERTEX))
  par.childRight.edge = er
  par.childRight:setChildLeft(p1)
  par.childRight:setChildRight(p2)

  self:checkCircleEvent(p0)
  self:checkCircleEvent(p2)
end


-- process circle event
function Voronoi:handleCircle(event)
  -- find p0, p1, p2 that generate this event from left to right
  local p1 = event.arc
  local xl = getLeftParent(p1)
  local xr = getRightParent(p1)
  local p0 = getLeftChild(xl)
  local p2 = getRightChild(xr)

  -- remove associated events since the points will be altered
  if p0.event ~= nil then
    lume.remove(self.events, p0.event)
    p0.event = nil
  end
  if p2.event ~= nil then
    lume.remove(self.events, p2.event)
    p2.event = nil
  end

  local p = Point(event.point.x, self:getY(p1.point, event.point.x)) -- new vertex

  -- end edges!
  xl.edge.endP = p
  xr.edge.endP = p
  table.insert(self.edges, xl.edge)
  table.insert(self.edges, xr.edge)

  -- start new bisector (edge) from this vertex on which ever original edge is higher in tree
  local higher = Parabola(ParabolaType.IS_VERTEX)
  local par = p1
  while par ~= self.root do
    par = par.parent
    if par == xl then
      higher = xl
    end
    if par == xr then
      higher = xr
    end
  end
  higher.edge = Edge(p, p0.point, p2.point)

  -- delete p1 and parent (boundary edge) from beach line
  local gparent = p1.parent.parent
  if p1.parent.childLeft == p1 then
    if gparent.childLeft == p1.parent then
      gparent:setChildLeft(p1.parent.childRight)
    end
    if gparent.childRight == p1.parent then
      gparent:setChildRight(p1.parent.childRight)
    end
  else
    if gparent.childLeft == p1.parent then
      gparent:setChildLeft(p1.parent.childLeft)
    end
    if gparent.childRight == p1.parent then
      gparent:setChildRight(p1.parent.childLeft)
    end
  end

  local op = p1.point
  p1.parent = nil
  p1 = nil

  self:checkCircleEvent(p0)
  self:checkCircleEvent(p2)
end


-- adds circle event if foci a, b, c lie on the same circle
function Voronoi:checkCircleEvent(parabola)
  local lp = getLeftParent(parabola)
  local rp = getRightParent(parabola)

  if lp == nil or rp == nil then
    return
  end

  local a = getLeftChild(lp)
  local c = getRightChild(rp)

  if a == nil or c == nil or a.point == c.point then
    return
  end

  if self:ccw(a.point, parabola.point, c.point) ~= 1 then
    return
  end

  -- edges will intersect to form a vertex for a circle event
  local start = self:getEdgeIntersection(lp.edge, rp.edge)
  if start == nil then
    return
  end

  -- compute radius
  local dx = parabola.point.x - start.x
  local dy = parabola.point.y - start.y
  local d = math.sqrt((dx * dx) + (dy * dy))
  if start.y + d < self.yCurr then --  must be after sweep line
    return
  end

  local ep = Point(start.x, start.y + d)

  -- add circle event
  local e = Event(ep, EventType.CIRCLE_EVENT)
  e.arc = parabola
  parabola.event = e
  table.insert(self.events, e)
  table.sort(self.events, compareEvent)
end


-- first thing we learned in this class :P
function Voronoi:ccw(pointA, pointB, pointC)
  local area2 = (pointB.x - pointA.x) * (pointC.y - pointA.y) - (pointB.y - pointA.y) * (pointC.x - pointA.x);
  if area2 < 0 then
    return -1
  elseif area2 > 0 then
    return 1
  else
    return 0
  end
end


-- returns intersection of the lines of with vectors a and b
function Voronoi:getEdgeIntersection(edgeA, edgeB)
  if edgeB.slope == edgeA.slope and edgeB.yInt ~= edgeA.yInt then
    return nil
  end

  local x = (edgeB.yInt - edgeA.yInt) / (edgeA.slope - edgeB.slope)
  local y = edgeA.slope * x + edgeA.yInt

  return Point(x, y)
end


-- returns current x-coordinate of an unfinished edge
function Voronoi:getXofEdge(parabola)
  -- find intersection of two parabolas
  local left = getLeftChild(parabola)
  local right = getRightChild(parabola)

  local p = left.point
  local r = right.point

  local dp = 2 * (p.y - self.yCurr)
  local a1 = 1 / dp
  local b1 = -2 * p.x / dp
  local c1 = (p.x * p.x + p.y * p.y - self.yCurr * self.yCurr) / dp

  local dp2 = 2 * (r.y - self.yCurr)
  local a2 = 1 / dp2
  local b2 = -2 * r.x / dp2
  local c2 = (r.x * r.x + r.y * r.y - self.yCurr * self.yCurr) / dp2

  local a = a1 - a2
  local b = b1 - b2
  local c = c1 - c2

  local disc = b * b - 4 * a * c
  local x1 = (-b + math.sqrt(disc)) / (2 * a)
  local x2 = (-b - math.sqrt(disc)) / (2 * a)

  local ry = nil
  if p.y > r.y then
    ry = math.max(x1, x2)
  else
    ry = math.min(x1, x2)
  end

  return ry
end


-- returns parabola above this x coordinate in the beach line
function Voronoi:getParabolaByX(xx)
  local par = self.root
  local x = 0
  while par.type == ParabolaType.IS_VERTEX do
    x = self:getXofEdge(par)
    if x > xx then
      par = par.childLeft
    else
      par = par.childRight
    end
  end
  return par
end


-- find corresponding y-coordinate to x on parabola with focus p
function Voronoi:getY(point, x)
  local dp = 2 * (point.y - self.yCurr)
  local a1 = 1 / dp
  local b1 = -2 * point.x / dp
  local c1 = (point.x * point.x + point.y * point.y - self.yCurr * self.yCurr) / dp
  return (a1 * x * x + b1 * x + c1)
end


function Voronoi:closestCoordinates(x, y)
  return self:closestPoint(Point(x, y))
end


function Voronoi:closestPoint(point)
  local closest = self.sites[1]
  local minDis = closest:distance(point)

  for _,p in ipairs(self.sites) do
    local dis = p:distance(point)
    if dis < minDis then
      closest = p
      minDis = dis
    end
  end

  return closest
end
