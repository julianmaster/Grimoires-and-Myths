WorldRenderer = Object:extend()

TILE_DURATION = 0.6
ANIMATION_DURATION = 0.2


function WorldRenderer:new(width, height, tiles)
  self.width = width
  self.height = height
  self.renderIndex = {}
  self.renderMap = tiles

  for x = 1, self.width do
    for y = 1, self.height do
      self.renderIndex[x] = self.renderIndex[x] or {}
      self.renderIndex[x][y] = {index = 1, currentTile = self.renderMap[x][y][1], timer = newTimer(self, x, y)}
    end
  end
end


function WorldRenderer:update(dt, tiles)
  self.renderMap = tiles

  for x = 1, self.width do
    for y = 1, self.height do
      if self.renderIndex[x][y].timer ~= nil then
        self.renderIndex[x][y].timer:update(dt)
      end
    end
  end
end


-- Callback method for animations
function WorldRenderer:callback_changeIndex(args)
  local x = args["x"]
  local y = args["y"]

  if #(self.renderMap[x][y]) > 1 then
    -- self.renderIndex[x][y].index = self.renderIndex[x][y].index + 1
    self.renderIndex[x][y].index = (self.renderIndex[x][y].index) % (#(self.renderMap[x][y]) * 2) + 1
  else
    self.renderIndex[x][y].index = 1
  end

  if self.renderIndex[x][y].index % 2 == 0 then
    local animation = newSwitchEntityAnimation(self, x, y)
    self.renderIndex[x][y].currentTile = animation
    self.renderIndex[x][y].timer = animation
  else
    local renderMapIndex = math.floor(self.renderIndex[x][y].index / 2) + 1
    self.renderIndex[x][y].currentTile = self.renderMap[x][y][renderMapIndex]
    self.renderIndex[x][y].timer = newTimer(self, x, y)
  end
end


function WorldRenderer:draw()
  for x = 1, self.width do
    for y = 1, self.height do
      self.renderIndex[x][y].currentTile:draw(x, y)
    end
  end
end


function newSwitchEntityAnimation(wr, x, y)
  local tiles = {}
  table.insert(tiles, Tile('/', COLOR.GREEN, LEVEL.ANIMATION))
  table.insert(tiles, Tile(196, COLOR.GREEN, LEVEL.ANIMATION))
  table.insert(tiles, Tile('\\', COLOR.GREEN, LEVEL.ANIMATION))
  table.insert(tiles, Tile('|', COLOR.GREEN, LEVEL.ANIMATION))

  return Animation(tiles, ANIMATION_DURATION, true, false, function(args) wr:callback_changeIndex(args) end, {x = x, y = y})
end


function newTimer(wr, x, y)
  return Timer(TILE_DURATION, true, false, function(args) wr:callback_changeIndex(args) end, {x = x, y = y})
end