local class = require('class')
local List = require('list')
local DirectionEnum = require('directionEnum')
local FieldStateEnum = require('fieldStateEnum')
local Vector2 = require('vector2')
local tactile = require('tactile')

local Snake = class('Snake')

local initialSettings = {
  speed = 7
}

function Snake:initialize(field, color, initPosition, direction, controls)
  self.field = field
  self.color = color
  self.initPosition = initPosition
  self.speed = initialSettings.speed
  self.direction = direction
  self.timer = 0
  self.body = List()
  self.body:pushRight(initPosition)
  self.controls = _initControls(self, controls)
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

    local nextFieldState = self.field.maze.maze[nextYPosition][nextXPosition]

    if nextFieldState == FieldStateEnum.FOOD then
      _eatCell(self, nextXPosition, nextYPosition)
    elseif nextFieldState == FieldStateEnum.EMPTY then
      _moveCell(self, nextXPosition, nextYPosition)
    elseif nextFieldState == FieldStateEnum.SNAKE then
      for v in self.body:iterRight() do
        if nextYPosition == v.y and nextXPosition == v.x then
          _moveCell(self, nextXPosition, nextYPosition)
        end  
      end
    end
  end
end

function _moveCell(self, nextXPosition, nextYPosition)
  self.body:pushLeft(Vector2(nextXPosition, nextYPosition))
  local prevPos = self.body:popRight()
  self.field.maze.maze[nextYPosition][nextXPosition] = FieldStateEnum.SNAKE
  self.field.maze.maze[prevPos.y][prevPos.x] = FieldStateEnum.EMPTY
end

function _eatCell(self, nextXPosition, nextYPosition)
  self.body:pushLeft(Vector2(nextXPosition, nextYPosition))
  self.field.maze.maze[nextYPosition][nextXPosition] = FieldStateEnum.SNAKE
  self.field.foodPosition[nextYPosition][nextXPosition]:eat()
  self.speed = self.speed + 1
end

function _initControls(self, controls)
  local upCtrl = tactile.newControl():addButton(tactile.keys(controls.up))
  local downCtrl = tactile.newControl():addButton(tactile.keys(controls.down))
  local rightCtrl = tactile.newControl():addButton(tactile.keys(controls.right))
  local leftCtrl = tactile.newControl():addButton(tactile.keys(controls.left))

  return {up = upCtrl, down = downCtrl, right = rightCtrl, left = leftCtrl}
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