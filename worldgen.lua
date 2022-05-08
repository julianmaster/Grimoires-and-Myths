WorldGen = Object:extend()


function WorldGen:new(width, height, noiseMultiplier)
  self.width = width
  self.height = height
  self.noiseMultiplier = noiseMultiplier
  self.groundTiles = {}
end


function WorldGen:generate()
  -- init
  self.groundTiles = {}

  local points = {}
  for i = 1, SITES do
    table.insert(points, Point(love.math.random() * self.width, love.math.random() * self.height))
  end

  local elevationOffsetX = love.math.random(0, 10000)
  local elevationOffsetY = love.math.random(0, 10000)
  local moistureOffsetX = love.math.random(10000, 20000)
  local moistureOffsetY = love.math.random(10000, 20000)
  local snowNorth = love.math.random(1, 2) > 1

  -- Generate world
  local voronoiDiagram = Voronoi(points);
  for x = 1, self.width do
    for y = 1, self.height do
      local nx = x + 0.5
      local ny = y + 0.5

      local site = voronoiDiagram:closestCoordinates(nx, ny)
      local elevation = love.math.noise(nx * self.noiseMultiplier, ny * self.noiseMultiplier)
      local elevationSite = love.math.noise(site.x * self.noiseMultiplier + elevationOffsetX, site.y * self.noiseMultiplier + elevationOffsetY)
      local moistureSite = love.math.noise(site.x * self.noiseMultiplier + moistureOffsetX, site.y * self.noiseMultiplier + moistureOffsetY)

      self.groundTiles[x] = self.groundTiles[x] or {}
      self.groundTiles[x][y] = self:biome(elevation, elevationSite, moistureSite)
    end
  end
  -- Fix world
  self:fix(voronoiDiagram, snowNorth)

  -- Generate Player
  local player = Player(love.math.random(1, self.width), love.math.random(1, self.height))

  return self.groundTiles, player, {}
end


function WorldGen:biome(elevation, elevationSite, moistureSite)
  -- Mountain [0.85-1.00]
  if elevationSite > 0.85 then
    if elevation > 0.80 then
      return self:generateTile(MOUNTAIN_TYPE.HIGH_MOUNTAIN, Mountain)
    elseif elevation > 0.30 then
      return self:generateTile(MOUNTAIN_TYPE.MEDIUM_MOUNTAIN, Mountain)
    else
      return self:generateTile(MOUNTAIN_TYPE.LOW_MOUNTAIN, Mountain)
    end
  end

  -- swamp [0.95-1.00]
  if moistureSite > 0.95 then
    return self:generateTile(SWAMP_TYPE.SWAMP, Swamp)
  end

  -- Forest [0.50-0.95]
  if moistureSite > 0.5 then
    if elevationSite > 0.5 then
      return self:generateTile(FOREST_TYPE.DENSE_FOREST, Forest)
    else
      return self:generateTile(FOREST_TYPE.SPARSE_FOREST, Forest)
    end
  end

  -- Land [0.05-0.50]
  if moistureSite > 0.05 then
    if elevationSite > 0.5 then
      return self:generateTile(LAND_TYPE.LOW_GRASS_LAND, Land)
    else
      return self:generateTile(LAND_TYPE.HIGH_GRASS_LAND, Land)
    end
  end

  -- desert [0.00-0.05]
  return self:generateTile(DESERT_TYPE.DESERT, Desert)
end


function WorldGen:fix(voronoiDiagram, snowNorth)
  -- Mountain fix
  for x = 1, self.width do
    for y = 1, self.height do
      if self.groundTiles[x][y]:is(Mountain) and self.groundTiles[x][y].tile == 127 and
      x > 1 and y > 1 and x < self.width and y < self.height then
        if self.groundTiles[x+1][y]:is(Mountain) and
        self.groundTiles[x][y+1]:is(Mountain) and
        self.groundTiles[x-1][y]:is(Mountain) and
        self.groundTiles[x][y-1]:is(Mountain) then
          self.groundTiles[x][y].tile = 30
        end
      end
    end
  end

  -- Adding ocean
  local borderSiteList = {}
  local oceanSite = {}
  for x = 1, self.width do
    table.insert(borderSiteList, voronoiDiagram:closestCoordinates(x + 0.5, 1 + 0.5))
    table.insert(borderSiteList, voronoiDiagram:closestCoordinates(x + 0.5, self.height + 0.5))
  end

  for y = 1, self.height do
    table.insert(borderSiteList, voronoiDiagram:closestCoordinates(1 + 0.5, y + 0.5))
    table.insert(borderSiteList, voronoiDiagram:closestCoordinates(self.width + 0.5, y + 0.5))
  end
  borderSiteList = lume.unique(borderSiteList) -- Remove duplicate

  for _,s in ipairs(borderSiteList) do
    if love.math.random() < 0.80 then
      table.insert(oceanSite, s)
    end
  end

  -- Change tile ocean
  for x = 1, self.width do
    for y = 1, self.height do
      local nx = x + 0.5
      local ny = y + 0.5

      local site = voronoiDiagram:closestCoordinates(nx, ny)
      if cog.containsValue(oceanSite, site) then
        self.groundTiles[x][y] = self:generateTile(OCEAN_TYPE.OCEAN, Ocean)
      end
    end
  end

  -- Adding snow
  local snowSiteList = {}
  for x = 1, self.width do
    local y = snowNorth and 1 or self.height -- North or South
    table.insert(snowSiteList, voronoiDiagram:closestCoordinates(x + 0.5, y + 0.5))
  end
  snowSiteList = lume.unique(snowSiteList) -- Remove duplicate
  
  -- Change tile to snow
  for x = 1, self.width do
    for y = 1, self.height do
      local nx = x + 0.5
      local ny = y + 0.5

      local nearestSite = voronoiDiagram:closestCoordinates(nx, ny)
      if cog.containsValue(snowSiteList, nearestSite) then
        local value = love.math.random()
        if value < 0.10 then
          self.groundTiles[x][y] = self:generateTile(SNOW_TYPE.LIGHT_SNOW, Snow)
        elseif value < 0.90 then
          self.groundTiles[x][y] = self:generateTile(SNOW_TYPE.SNOW, Snow)
        else
          self.groundTiles[x][y] = self:generateTile(SNOW_TYPE.HEAVY_SNOW, Snow)
        end
      end
    end
  end

end


function WorldGen:generateTile(tileType, obj)
  return obj(tileType[1], tileType[2])
end