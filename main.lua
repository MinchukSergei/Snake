local Maze = require('maze')
local Vector2 = require('vector2')
local Field = require('field')
local Snake = require('snake')
local DirectionEnum = require('directionEnum')
local Color = require('color')
local tactile = require('tactile')

function love.load()
  if arg[#arg] == "-debug" then require("mobdebug").start() end

--  love.window.setFullscreen(true, "desktop")
  love.window.setMode(800, 600)
--  file = io.open("hui.txt", "w")
--  io.output(file)
--  math.randomseed(os.time())

  blockSize = 3
  alignCoef = 3
  scaleFactor = 30

  screenWidth = love.graphics.getWidth()
  screenHeight = love.graphics.getHeight()

  cellSize = math.floor(math.min(screenHeight, screenWidth) / scaleFactor * (alignCoef / blockSize))

  gridXCount = math.floor((screenWidth - 1) / (blockSize * cellSize + 1))
  gridYCount = math.floor((screenHeight - 1) / (blockSize * cellSize + 1))
  gridXCount = gridXCount * (blockSize + 1) + 1
  gridYCount = gridYCount * (blockSize + 1) + 1

  maze = Maze(gridXCount, gridYCount, blockSize)
  maze:carveMaze(Vector2(2, 2))
--  maze:showMaze()

  field = Field(maze, cellSize)
  
  snake1 = Snake(field, Color(255, 0, 0), Vector2(2, 2), DirectionEnum.DOWN, initControls('up', 'down', 'right', 'left'))
  snake2 = Snake(field, Color(0, 255, 0), Vector2(3, 2), DirectionEnum.DOWN, initControls('w', 's', 'd', 'a'))
  field.snakes = {snake1, snake2}
end

function love.update(dt)
  field:update(dt)
end

function love.draw()
  local scaleX = screenWidth / (gridXCount * cellSize)
  local scaleY = screenHeight / (gridYCount * cellSize)
  love.graphics.scale(scaleX, scaleY)
  
  field:draw()
end

function initControls(up, down, right, left)
  upCtrl = tactile.newControl():addButton(tactile.keys(up))
  downCtrl = tactile.newControl():addButton(tactile.keys(down))
  rightCtrl = tactile.newControl():addButton(tactile.keys(right))
  leftCtrl = tactile.newControl():addButton(tactile.keys(left))
  
  return {up = upCtrl, down = downCtrl, right = rightCtrl, left = leftCtrl}
end
