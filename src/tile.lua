Tile = Object:extend()


function Tile:new(tile, color, zLevel)
  self.tile = tile
  self.color = color
  self.zLevel = zLevel or 0
end


function Tile:draw(x, y)
  local color = Palette.colors[self.color]
  Tileset:draw(self.tile, x * Tileset.tileWidth, y * Tileset.tileHeight, color)
end
