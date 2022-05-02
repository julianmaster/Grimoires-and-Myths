Mountain = Tile:extend()


MOUNTAIN_TYPE = {
  LOW_MOUNTAIN = {127, COLOR.LGRAY},
  MEDIUM_MOUNTAIN = {30, COLOR.LGRAY},
  HIGH_MOUNTAIN = {30, COLOR.DGRAY}
}


function Mountain:new(tile, color)
  Mountain.super.new(self, tile, color)
end