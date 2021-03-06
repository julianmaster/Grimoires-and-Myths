Entity = Tile:extend()


function Entity:new(x, y, tile, color, zLevel)
  Entity.super.new(self, tile, color, zLevel or 1)
  self.x = x
  self.y = y
end


function Entity:update(dt)
end


function Entity:draw()
  local color = Palette.colors[self.color]
  Tileset:draw(self.tile, self.x * Tileset.tileWidth, self.y * Tileset.tileHeight, color)
end

