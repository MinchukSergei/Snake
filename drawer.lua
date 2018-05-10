local class = require('class')

local Drawer = class('Drawer')

function Drawer:initialize(cellSize)
  self.cellSize = cellSize
end

function Drawer:drawCell(x, y)
  love.graphics.rectangle(
    'fill',
    (x - 1) * self.cellSize,
    (y - 1) * self.cellSize,
    self.cellSize - 1,
    self.cellSize - 1
  )
end

return Drawer