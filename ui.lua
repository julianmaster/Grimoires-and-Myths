UI = Object:extend()


function UI:new()
  self.showColors = false
end


function UI:draw()
  -- Screen bar
  local color = Palette.colors[COLOR.DGRAY]
  for i=0,SCREEN_TILE_WDITH do
    Tileset:draw(219, i*Tileset.tileWidth, 0, color)
    Tileset:draw(219, i*Tileset.tileWidth, (SCREEN_TILE_HEIGHT-1)*Tileset.tileHeight, color)
  end
  for i=1,SCREEN_TILE_HEIGHT-2 do
      Tileset:draw(219, 0, i*Tileset.tileHeight, color)
      Tileset:draw(219, (SCREEN_TILE_WDITH-1)*Tileset.tileWidth, i*Tileset.tileHeight, color)
  end

  -- Show color list
  if self.showColors then
    for _,color in pairs(COLOR) do
      color = Palette.colors[color]
      Tileset:draw(219, (color - 1) % 8 * Tileset.tileWidth, math.floor((color - 1) / 8) * Tileset.tileHeight, color)
    end
  end
end


function UI:toggleShowColors()
  self.showColors = not self.showColors
end