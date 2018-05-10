local class = require('class')

local Color = class('Color')

function Color:initialize(r, g, b, convert, a)
  convert = convert == nil and true or convert
  a = a or 255
  self.r = (convert and r / 255 or r) or 0
  self.g = (convert and g / 255 or g) or 0
  self.b = (convert and b / 255 or b) or 0
  self.a = (convert and a / 255 or a) or 0
end

return Color