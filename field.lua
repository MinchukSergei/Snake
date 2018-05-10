local class = require('class')
local Drawer = require('drawer')

local Field = class('Field')

function Field:initialize(maze, cellSize)
  self.maze = maze
  self.cellSize = cellSize
  self.drawer = Drawer(cellSize)
  self.snakes = nil
end

function Field:update(dt)
  for i, v in ipairs(self.snakes) do
    v:update(dt)
  end
end

function Field:draw()
  local drw = self.drawer
  
  self.maze:draw(drw)
  
  for i, v in ipairs(self.snakes) do
    v:draw(drw)
  end
end

return Field