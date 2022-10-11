Animation = Timer:extend()


function Animation:new(tiles, time, play, loop, func, args)
  Animation.super.new(self, time, play, loop, func, args)
  self.tiles = tiles
end


function Animation:draw(x, y)
  local spriteNum = math.floor(self.currentTime / self.time * #self.tiles) + 1
  self.tiles[spriteNum]:draw(x, y)
end