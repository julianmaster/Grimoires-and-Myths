Quit = Action:extend()


function Quit:new()
  Quit.super.new(self)
end


function Quit:perform()
  love.event.quit()
end