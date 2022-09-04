Timer = Object:extend()


function Timer:new(time, play, func, loop)
  self.time = time
  self.play = play
  self.func = func
  self.loop = loop
end