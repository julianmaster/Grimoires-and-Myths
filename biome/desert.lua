Desert = Tile:extend()


DESERT_TYPE = {
  DESERT = {'^', COLOR.YELLOW}
}


function Desert:new(tile, color)
  Desert.super.new(self, tile, color)
end