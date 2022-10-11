Ocean = Tile:extend()


OCEAN_TYPE = {
  OCEAN = {247, COLOR.BLUE}
}


function Ocean:new(tile, color)
  Ocean.super.new(self, tile, color)
end