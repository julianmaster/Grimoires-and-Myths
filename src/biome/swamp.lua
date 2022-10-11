Swamp = Tile:extend()


SWAMP_TYPE = {
  SWAMP = {244, COLOR.MAGENTA}
}


function Swamp:new(tile, color)
  Swamp.super.new(self, tile, color)
end