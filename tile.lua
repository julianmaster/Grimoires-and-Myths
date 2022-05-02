Tile = Object:extend()


function Tile:new(tile, color)
  self.tile = tile
  self.color = color
end


function Tile:draw(x, y)
  love.graphics.setColor(Palette.colors[self.color])
  Tileset:draw(self.tile, x * Tileset.tileWidth, y * Tileset.tileHeight)
end
