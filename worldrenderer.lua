WorldRenderer = Object:extend()

function WorldRenderer:new(groundTiles)
  self.width = #groundTiles
  self.height = #groundTiles[0]
  self.times = nil
  self.renderIndexes = {}

  for x = 1, self.width do
    for y = 1, self.height do
      self.renderIndexes[x] = self.renderIndexes[x] or {}
      self.renderIndexes[x][y] = self.renderIndexes[x][y] or {}
    end
  end
end

function WorldRenderer:update(dt)
  self.times = dt
  
end

-- Callback method for animations
function WorldRenderer:callback_changeIndex(x, y)
  self.renderIndexes[x][y] = self.renderIndexes[x][y]+1
end

function WorldRenderer:draw(groundTiles, entities)

end