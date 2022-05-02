Palette = Object:extend()


function Palette:new(file)
  self.colors = {}

  local colorsInfos = {}
  for line in love.filesystem.lines(file) do
    local color, component, value = string.match(line, "(%a*)_(%a*):(%d*)")
    if color ~= nil then
      if colorsInfos[color] ~= nil then
        colorsInfos[color][component] = value
      else
        local colorInfos = {[component] = value}
        colorsInfos[color] = colorInfos
      end
    end
  end

  for name,value in pairs(COLOR) do
    self.colors[value] = {colorsInfos[name]["R"]/255, colorsInfos[name]["G"]/255, colorsInfos[name]["B"]/255}
  end
end
