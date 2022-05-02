-- VSCode debugger
if os.getenv("LOCAL_LUA_DEBUGGER_VSCODE") == "1" then
  print("Debug mode (VSCode)")
  require("lldebugger").start()
end


function love.load(arg)
  -- Zerobrane debugger
  if arg[#arg] == "-debug" then
    print("Debug mode (Zerobrane)")
    require("mobdebug").start()
  end

  -- Utils
  Object = require "utils.classic"
  lume = require "utils.lume"
  cog = require "utils.cog"
  require "utils.dump"

  require "ui"
  require "eventhandler"
  require "color"
  require "tileset"
  require "palette"
  require "world"
  require "tile"

  -- Actions
  require "action.action"
  require "action.colorsui"
  require "action.event"
  require "action.move"
  require "action.quit"
  require "action.generateworld"
  require "action.scale"

  -- Generation
  require "worldgen"
  require "generation.edge"
  require "generation.event"
  require "generation.parabola"
  require "generation.point"
  require "generation.voronoi"

  -- Biomes
  require "biome.desert"
  require "biome.forest"
  require "biome.land"
  require "biome.mountain"
  require "biome.ocean"
  require "biome.swamp"
  require "biome.snow"

  -- Entities
  require "entity.entity"
  require "entity.player"

  SCALE = 2
  SCREEN_TILE_WDITH = 18
  SCREEN_TILE_HEIGHT = 18
  SHOW_COLORS = false

  love.graphics.setDefaultFilter("nearest", "nearest")

  Tileset = Tileset("RDE_8x8.png")
  love.window.setMode(SCREEN_TILE_WDITH*Tileset.tileWidth*SCALE, SCREEN_TILE_HEIGHT*Tileset.tileHeight*SCALE, {})
  Palette = Palette("colors.txt")

  EventHandler = EventHandler()
  UI = UI()
  World = World()
end


function love.update(dt)
  EventHandler:resolve()
  World:update(dt)
end


function love.keypressed(key, scancode, isrepeat)
  EventHandler:handleEvent(key, scancode, isrepeat)
end


function love.draw()
  -- Scale
  love.graphics.scale(SCALE)

  -- Background
  love.graphics.setBackgroundColor(Palette.colors[COLOR.BLACK])

  World:draw()
  UI:draw()
end
