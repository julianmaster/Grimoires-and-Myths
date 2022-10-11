Scale = Action:extend()


function Scale:new(value)
  self.value = value
end


function Scale:perform()
  if self.value > 0 then
    SCALE = SCALE + 1
    love.window.setMode(SCREEN_TILE_WDITH*Tileset.tileWidth*SCALE, SCREEN_TILE_HEIGHT*Tileset.tileHeight*SCALE)
  else
    if SCALE > 1 then
      SCALE = SCALE - 1
      love.window.setMode(SCREEN_TILE_WDITH*Tileset.tileWidth*SCALE, SCREEN_TILE_HEIGHT*Tileset.tileHeight*SCALE)
    end
  end
end