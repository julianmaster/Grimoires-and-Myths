Animation = Object:extend()

function Animation:new(tiles, time, play, loop)
  self.tiles = tiles
  self.time = time
  self.play = play or false
  self.loop = loop or false
  self.currentTime = 0
end

function Animation:update(dt)
  if play then
    self.currentTime = self.currentTime + dt
    if self.currentTime >= self.time and self.loop then
      self.currentTime = self.currentTime - self.time
    end
  end
end

function Animation:draw(x, y)

end