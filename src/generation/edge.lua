Edge = Object:extend()

-- an edge on the Voronoi diagram
function Edge:new(firstPoint, leftPoint, rightPoint)
  self.start = firstPoint
  self.siteLeft = leftPoint
  self.siteRight = rightPoint
  self.direction = Point(rightPoint.y - leftPoint.y, -(rightPoint.x - leftPoint.x))
  self.endP = nil
  self.slope = (rightPoint.x - leftPoint.x) / (leftPoint.y - rightPoint.y)
  local mid = Point((rightPoint.x + leftPoint.x) / 2, (leftPoint.y + rightPoint.y) / 2)
  self.yInt = mid.y - self.slope * mid.x
end