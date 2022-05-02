Forest = Tile:extend()


FOREST_TYPE = {
  SPARSE_FOREST = {24, COLOR.GREEN},
  DENSE_FOREST = {6, COLOR.GREEN}
}


function Forest:new(tile, color)
  Forest.super.new(self, tile, color)
end