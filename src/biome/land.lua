Land = Tile:extend()


LAND_TYPE = {
  LOW_GRASS_LAND = {'n', COLOR.LGREEN},
  HIGH_GRASS_LAND = {239, COLOR.LGREEN}
}


function Land:new(tile, color)
  Land.super.new(self, tile, color)
end