Event = Action:extend()


function Event:new(source)
  Event.super.new()
  self.source = source
end


function Event:perform()
end