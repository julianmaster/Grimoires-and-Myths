Move = Event:extend()


function Move:new(source, dx, dy)
  Move.super.new(self, source)
  self.dx = dx
  self.dy = dy
end


function Move:perform()
  self.source.x = self.source.x + self.dx
  self.source.y = self.source.y + self.dy
end