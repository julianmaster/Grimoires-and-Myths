EventHandler = Object:extend()

MOVE_KEYS = {
  -- Arrow keys
  ["up"] = {0, -1},
  ["down"] = {0, 1},
  ["left"] = {-1, 0},
  ["right"] = {1, 0},
  ["home"] = {-1, -1},
  ["end"] = {-1, 1},
  ["pageup"] = {1, -1},
  ["pagedown"] = {1, 1},

  -- Numpad keys
  ["kp1"] = {-1, 1},
  ["kp2"] = {0, 1},
  ["kp3"] = {1, 1},
  ["kp4"] = {-1, 0},
  ["kp6"] = {1, 0},
  ["kp7"] = {-1, -1},
  ["kp8"] = {0, -1},
  ["kp9"] = {1, -1},

  -- Vi keys
  ["h"] = {-1, 0},
  ["j"] = {0, 1},
  ["k"] = {0, -1},
  ["l"] = {1, 0},
  ["y"] = {-1, -1},
  ["u"] = {1, -1},
  ["b"] = {-1, 1},
  ["n"] = {1, 1},
}


function EventHandler:new()
  self.actions = {}
end


function EventHandler:handleEvent(key, scancode, isrepeat)
  if key == "escape" then
    self:addAction(Quit())
  elseif key == "f1" and os.getenv("LOCAL_LUA_DEBUGGER_VSCODE") == "1" then
    self:addAction(ColorsUI())
  elseif key == "f2" and os.getenv("LOCAL_LUA_DEBUGGER_VSCODE") == "1" then
    self:addAction(GenerateWorld())
  elseif key == "kp+" then
    self:addAction(Scale(1))
  elseif key == "kp-" then
    self:addAction(Scale(-1))
  end


  -- Player event
  if cog.containsKey(MOVE_KEYS, key) then
    local dxy = MOVE_KEYS[key]
    self:addAction(Move(World:getPlayer(), dxy[1], dxy[2]))
  end
end


function EventHandler:addAction(action)
  table.insert(self.actions, 1, action)
end


function EventHandler:resolve()
  while #self.actions > 0 do
    local action = self.actions[1]
    table.remove(self.actions, 1)

    action:perform()
  end
end