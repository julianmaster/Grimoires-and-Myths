Snow = Tile:extend()


SNOW_TYPE = {
  SNOW = {177, COLOR.LCYAN}
}


function Snow:new(tile, color)
  Snow.super.new(self, tile, color)
end