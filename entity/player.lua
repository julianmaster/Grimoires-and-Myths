Player = Entity:extend()


PLAYER_TILE = "@"
PLAYER_COLOR = COLOR.WHITE


function Player:new(x, y)
  Player.super.new(self, x, y, PLAYER_TILE, PLAYER_COLOR)
end