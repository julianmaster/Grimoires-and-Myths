UI = Object:extend()


function UI:new()
  self.showColors = false
end


function UI:draw()
  -- Screen bar
  for i=0,SCREEN_TILE_WDITH do
    love.graphics.setColor(Palette.colors[COLOR.DGRAY])
    Tileset:draw(219, i*Tileset.tileWidth, 0)
    Tileset:draw(219, i*Tileset.tileWidth, (SCREEN_TILE_HEIGHT-1)*Tileset.tileHeight)
  end
  for i=1,SCREEN_TILE_HEIGHT-2 do
      Tileset:draw(219, 0, i*Tileset.tileHeight)
      Tileset:draw(219, (SCREEN_TILE_WDITH-1)*Tileset.tileWidth, i*Tileset.tileHeight)
  end

  -- Show color list
  if self.showColors then
    for _,color in pairs(COLOR) do
      love.graphics.setColor(Palette.colors[color])
      Tileset:draw(219, (color - 1) % 8 * Tileset.tileWidth, math.floor((color - 1) / 8) * Tileset.tileHeight)
    end
  end
end


function UI:toggleShowColors()
  self.showColors = not self.showColors
end