local class = require('class')
local List = require('list')
local DirectionEnum = require('directionEnum')
local FieldStateEnum = require('fieldStateEnum')
local Vector2 = require('vector2')

local Snake = class('Snake')

local initialSettings = {
  canMove = true,
  speed = 7
}

function Snake:initialize(field, color, initPosition, direction, controls)
  self.field = field
  self.color = color
  self.initPosition = initPosition
  self.canMove = initialSettings.canMove
  self.speed = initialSettings.speed
  self.controls = controls
  self.body = List()
  self.body:pushRight(initPosition)
  self.direction = direction
  self.timer = 0
end

function _getTimerLimit(self)
  return 1 / self.speed
end

function Snake:getHead()
  return self.body:getLeft()
end

function Snake:update(dt)
  self.timer = self.timer + dt
  _updateControls(self)

  if self.timer >= _getTimerLimit(self) then
    self.timer = self.timer - _getTimerLimit(self)

    local dir = self.direction

    local snakeHead = self:getHead()
    local nextXPosition = snakeHead.x
    local nextYPosition = snakeHead.y

    if dir == DirectionEnum.RIGHT then
      nextXPosition = nextXPosition + 1
    elseif dir == DirectionEnum.LEFT then
      nextXPosition = nextXPosition - 1
    elseif dir == DirectionEnum.DOWN then
      nextYPosition = nextYPosition + 1
    elseif dir == DirectionEnum.UP then
      nextYPosition = nextYPosition - 1
    end

    self.canMove = self.field.maze.maze[nextYPosition][nextXPosition] == FieldStateEnum.EMPTY
    
    for i, v in ipairs(self.field.snakes) do
      local h = v:getHead()
      if h.x == nextXPosition and h.y == nextYPosition then
        self.canMove = false
        break
      end
    end

    if self.canMove then
      self.body:pushLeft(Vector2(nextXPosition, nextYPosition))

      if field.maze.maze[nextYPosition][nextXPosition] == FieldStateEnum.EMPTY then
        self.body:popRight()
      end
    end
  end
end

function _updateControls(self)
  local up = self.controls.up
  local down = self.controls.down
  local right = self.controls.right
  local left = self.controls.left

  up:update()
  down:update()
  right:update()
  left:update()

  if up:isDown() then
    self.direction = DirectionEnum.UP
  elseif down:isDown() then
    self.direction = DirectionEnum.DOWN
  elseif right:isDown() then
    self.direction = DirectionEnum.RIGHT
  elseif left:isDown() then
    self.direction = DirectionEnum.LEFT
  end
end

function Snake:draw(drawer)
  local color = self.color
  love.graphics.setColor(color.r, color.g, color.b)

  for v in self.body:iterRight() do
    drawer:drawCell(v.x, v.y)
  end
end

return Snake