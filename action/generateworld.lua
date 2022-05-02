GenerateWorld = Action:extend()


function GenerateWorld:new()
  GenerateWorld.super.new(self)
end


function GenerateWorld:perform()
  World:generate()
end