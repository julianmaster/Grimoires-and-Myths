Timer = Object:extend()


function Timer:new(time, play, loop, func, args)
  self.time = time
  self.play = play
  self.loop = loop
  self.func = func
  self.args = args
  self.currentTime = 0
end


function Timer:update(dt)
  if self.play then
    self.currentTime = self.currentTime + dt
    if self.currentTime >= self.time then
      if self.loop then
        self.currentTime = self.currentTime - self.time
      end
      if self.func then
        self.func(self.args)
      end
    end
  end
end


function Timer:play()
  self.play = true
end


function Timer:reset()
  self.currentTime = 0
end