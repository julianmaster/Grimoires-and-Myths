Entity = Tile:extend()


function Entity:new(x, y, tile, color)
  Entity.super.new(self, tile, color)
  self.x = x
  self.y = y
end


function Entity:update(dt)
end


function Entity:draw()
  love.graphics.setColor(Palette.colors[self.color])
  Tileset:draw(self.tile, self.x * Tileset.tileWidth, self.y * Tileset.tileHeight)
end

