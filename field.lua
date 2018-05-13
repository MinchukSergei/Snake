local class = require('class')
local Drawer = require('drawer')
local FoodGenerator = require('foodGenerator')

local Field = class('Field')

function Field:initialize(maze, cellSize)
  self.maze = maze
  self.cellSize = cellSize
  self.drawer = Drawer(cellSize)
  self.snakes = nil
  self.foodPosition = _initFoodPosition(maze.height)
  self.food = FoodGenerator:generate(self, 100, 0.5, 10, 7, 13)
end

function _initFoodPosition(height)
  local fp = {}
  
  for i = 1, height do
    fp[i] = {}
  end
  
  return fp
end

function Field:update(dt)
  for i, v in ipairs(self.snakes) do
    v:update(dt)
  end
  
  for i, v in ipairs(self.food) do
    v:update(dt)
  end
end

function Field:draw()
  local drw = self.drawer
  
  self.maze:draw(drw)
  
  for i, v in ipairs(self.snakes) do
    v:draw(drw)
  end
  
  for i, v in ipairs(self.food) do
    v:draw(drw)
  end
end

return Field