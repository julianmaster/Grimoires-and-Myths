WorldRenderer = Object:extend()


function WorldRenderer:new(width, height)
  self.width = width
  self.height = height
  self.renderMap = nil
  self.renderIndexes = {}

  for x = 1, self.width do
    for y = 1, self.height do
      self.renderIndexes[x] = self.renderIndexes[x] or {}
      self.renderIndexes[x][y] = {index = 0, currentTile = nil}
    end
  end
end


function WorldRenderer:update(dt, tiles)
  self.renderMap = tiles

  for x = 1, self.width do
    for y = 1, self.height do
      if self.renderIndexes[x][y].animation ~= nil then
        self.renderIndexes[x][y].animation:update(dt)
      end
    end
  end
end


-- Callback method for animations
function WorldRenderer:callback_changeIndex(args)
  local x = args["x"]
  local y = args["y"]
  self.renderIndexes[x][y].index = (self.renderIndexes[x][y].index) % #(self.renderMap[x][y] * 2) + 1
  if self.renderIndexes[x][y].index % 2 == 0 then
    self.renderIndexes[x][y].currentTile = newSwitchEntityAnimation()
  else
    
  end
end


function WorldRenderer:draw(groundTiles, entitiesMap)
  for x = 1, self.width do
    for y = 1, self.height do
      
    end
  end
end