World = Object:extend()


SITES = 120
NOISE_MULTIPLIER = 0.7
WORLD_WIDTH = 16
WORLD_HEIGHT = 16


function World:new()
  self.width = WORLD_WIDTH
  self.height = WORLD_HEIGHT
  self.groundTiles = nil
  self.player = nil
  self.entities = nil
  self.worldRenderer = nil

  self.worldgen = WorldGen(self.width, self.height, NOISE_MULTIPLIER)
  self:generate()
end


function World:generate()
  self.groundTiles, self.player, self.entities = self.worldgen:generate()
  self.worldRenderer = WorldRenderer(self.width, self.height)
end


function World:update(dt)
  local tiles = {}

  for x = 1, self.width do
    for y = 1, self.height do
      tiles[x] = tiles[x] or {}
      tiles[x][y] = tiles[x][y] or {}
      table.insert(tiles[x][y], self.groundTiles[x][y])
    end
  end

  for _, entity in ipairs(self.entities) do
    table.insert(tiles[entity.x][entity.y], entity)
  end
  table.insert(tiles[self.player.x][self.player.y], self.player)

  for x = 1, self.width do
    for y = 1, self.height do
      lume.sort(tiles[x][y], function(a, b) return a.zLevel < b.zLevel end)
    end
  end

  self.worldRenderer:update(dt, tiles)
end


function World:draw()
  


  for x = 1, self.width do
    for y = 1, self.height do
      local groundTile = self.groundTiles[x][y]
      groundTile:draw(x, y)
    end
  end

  for _, entity in ipairs(self.entities) do
    entity:draw()
  end

  self.player:draw()
end


function World:getPlayer()
  return self.player
end