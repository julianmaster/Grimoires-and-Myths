Event = Object:extend()


EventType = {
  -- a site event is when the point is a site
  SITE_EVENT = 0,
  -- a circle event is when the point is a vertex of the voronoi diagram/parabolas
  CIRCLE_EVENT = 1
}


-- an event is either a site or circle event for the sweep line to process
function Event:new(point, eventType)
  self.point = point
  self.type = eventType
  self.arc = nil
end


function compareEvent(event1, event2)
  return event1.point:compareTo(event2.point)
end