local Maze = require('maze')
local Vector2 = require('vector2')
local Field = require('field')
local Snake = require('snake')
local DirectionEnum = require('directionEnum')
local Color = require('color')

local field = nil
local config = {
  blockSize = 4,
  alignCoef = 3,
  scaleFactor = 35,
  scaleX = 1,
  scaleY = 1
}

function love.load()
  if arg[#arg] == "-debug" then require("mobdebug").start() end

  love.window.setFullscreen(true, "desktop")
--  love.window.setMode(800, 600)
--  file = io.open("hui.txt", "w")
--  io.output(file)
  math.randomseed(os.time())

  local screenWidth = love.graphics.getWidth()
  local screenHeight = love.graphics.getHeight()

  local cellSize = math.floor(math.min(screenHeight, screenWidth) / config.scaleFactor * (config.alignCoef / config.blockSize))

  local gridXCount = math.floor((screenWidth - 1) / (config.blockSize * cellSize + 1))
  local gridYCount = math.floor((screenHeight - 1) / (config.blockSize * cellSize + 1))
  gridXCount = gridXCount * (config.blockSize + 1) + 1
  gridYCount = gridYCount * (config.blockSize + 1) + 1

  config.scaleX = screenWidth / (gridXCount * cellSize)
  config.scaleY = screenHeight / (gridYCount * cellSize)

  maze = Maze(gridXCount, gridYCount, config.blockSize)
  maze:carveMaze(Vector2(2, 2))
--  maze:showMaze()

  field = Field(maze, cellSize)

  local snake1 = Snake(field, Color(255, 0, 0), Vector2(2, 2), DirectionEnum.DOWN, 
    {up = 'up', down = 'down', right = 'right', left = 'left'})
  local snake2 = Snake(field, Color(0, 255, 0), Vector2(3, 2), DirectionEnum.DOWN, 
    {up = 'w', down = 's', right = 'd', left = 'a'})
  field.snakes = {snake1, snake2}
end

function love.update(dt)
  if dt > 0.05 then
    return
  end
  field:update(dt)
end

function love.draw()
  love.graphics.scale(config.scaleX, config.scaleY)

  field:draw()
end
