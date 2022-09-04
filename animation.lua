Animation = Object:extend()


function Animation:new(tiles, time, play, loop)
  self.tiles = tiles
  self.time = time
  self.play = play or false
  self.loop = loop or false
  self.currentTime = 0
  self.endCallback = nil
  self.args = nil
end


function Animation:update(dt)
  if self.play then
    self.currentTime = self.currentTime + dt
    if self.currentTime >= self.time and self.loop then
      self.currentTime = self.currentTime - self.time
    end
    if self.currentTime >= self.time and not self.loop then
      if self.endCallback then
        self.endCallback(self.args)
      end
    end
  end
end


function Animation:draw(x, y)
  local spriteNum = math.floor(self.currentTime / self.time * #self.tiles) + 1
  self.tiles[spriteNum]:draw(x, y)
end


function Animation:play()
  self.play = true
end


function Animation:reset()
  self.currentTime = 0
end


function Animation:setEndCallback(func, args)
  self.endCallback = func
  self.args = args
end


function newSwitchEntityAnimation()
  local tiles = {}
  table.insert(tiles, Tile('/', COLOR.GREEN, LEVEL.ANIMATION))
  table.insert(tiles, Tile(196, COLOR.GREEN, LEVEL.ANIMATION))
  table.insert(tiles, Tile('\\', COLOR.GREEN, LEVEL.ANIMATION))
  table.insert(tiles, Tile('|', COLOR.GREEN, LEVEL.ANIMATION))

  return Animation(tiles, 0.2, false, false)
end