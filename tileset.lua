Tileset = Object:extend()


function Tileset:new(img)
  self.tiles = {}

  local imgData = love.image.newImageData(img)
  local width, height = imgData:getDimensions()
  local originR, originG, originB, originA = imgData:getPixel(0, 0)

  self.tileWidth = width/16
  self.tileHeight = height/16

  local function mapFunction(x,y,r,g,b,a)
    if r == originR and g == originG and b == originB then
      a = 0
    end
    return r,g,b,a
  end

  imgData:mapPixel(mapFunction)

  self.img = love.graphics.newImage(imgData)

  width = self.img:getWidth()/self.tileWidth
  height = self.img:getHeight()/self.tileHeight
  for x = 0,width do
    for y = 0,height do
      self.tiles[x] = self.tiles[x] or {}
      self.tiles[x][y] = love.graphics.newQuad(x*self.tileWidth, y*self.tileHeight, self.tileWidth, self.tileHeight, self.img:getWidth(), self.img:getHeight())
    end
  end
end


function Tileset:draw(tile, x, y)
  if type(tile) == 'number' then
    love.graphics.draw(self.img, self.tiles[tile%16][math.floor(tile/16)], x, y)
  elseif type(tile) == "string" then
    local char = string.byte(tile)
    love.graphics.draw(self.img, self.tiles[char%16][math.floor(char/16)], x, y)
  end
end


function Tileset:print(str, x, y)
  local index = 0
  for char in string.gmatch(str, '[^%d]') do
    self:draw(string.byte(char), x+index*self.tileWidth, y)
    index = index + 1
  end
end
