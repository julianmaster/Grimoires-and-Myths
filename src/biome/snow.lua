Snow = Tile:extend()


SNOW_TYPE = {
  LIGHT_SNOW = {176, COLOR.LCYAN},
  SNOW = {177, COLOR.LCYAN},
  HEAVY_SNOW = {178, COLOR.LCYAN}
}


function Snow:new(tile, color)
  Snow.super.new(self, tile, color)
end