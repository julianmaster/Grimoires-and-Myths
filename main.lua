
SCALE = 2
SCREEN_TILE_WDITH = 18
SCREEN_TILE_HEIGHT = 18
SHOW_COLORS = false


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

  -- import all files
  require "src.require"
  importAll()

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
