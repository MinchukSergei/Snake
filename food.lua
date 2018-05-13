local class = require('class')
local FieldStateEnum = require('fieldStateEnum')
local cron = require('cron')
local Vector2 = require('vector2')

local Food = class('Food')

function Food:initialize(field, color, showTime, hideTime)
  self.field = field
  self.color = color
  self.timer = 0
  self.showTime = showTime
  self.hideTime = hideTime
  self.visible = false
end


function Food:update(dt)
  self.timer = self.timer + dt

  if self.cron then
    self.cron:update(dt)
  end

  if not self.cron then
    local show
    local hide
    
    show = function()
      self.visible = true
      
      _setPosition(self)
      local x = self.position.x
      local y = self.position.y
      self.field.maze.maze[y][x] = FieldStateEnum.FOOD
      self.field.foodPosition[y][x] = self
      self.cron = cron.after(self.showTime, hide)
    end
    
    hide = function()
      self.visible = false
      self.timer = 0
      local x = self.position.x
      local y = self.position.y
      self.field.maze.maze[y][x] = FieldStateEnum.EMPTY
      self.field.foodPosition[y][x] = nil
      self.cron = cron.after(self.hideTime, show)
    end
    
    self.cron = cron.after(self.showTime, show)
  end
end

function _setPosition(self)
  local maze = self.field.maze
  local w = maze.width
  local h = maze.height
  local emptyCells = {}
  local ecIndex = 1

  for i = 1, h do
    for j = 1, w do
      if maze.maze[i][j] == FieldStateEnum.EMPTY then
        emptyCells[ecIndex] = {y = i, x = j}
        ecIndex = ecIndex + 1
      end
    end
  end

  local randomFoodPosition = emptyCells[math.random(ecIndex - 1)]
  self.position = Vector2(randomFoodPosition.x, randomFoodPosition.y)
end  

function Food:eat()
  if self.cron then
    self.cron:reset()
  end
  self.timer = 0
  self.visible = false
  
  local x = self.position.x
  local y = self.position.y
  self.field.maze.maze[y][x] = FieldStateEnum.EMPTY
  self.field.foodPosition[y][x] = nil
end

function Food:draw(drawer)
  if self.visible then
    local color = self.color
    local x = self.position.x
    local y = self.position.y

    love.graphics.setColor(color.r, color.g, color.b)

    drawer:drawCell(x, y)
  end
end

return Food