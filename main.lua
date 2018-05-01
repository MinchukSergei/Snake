function love.load()
  if arg[#arg] == "-debug" then require("mobdebug").start() end

  love.window.setFullscreen(true, "desktop")
--  love.window.setMode(400, 200, nil)

--  math.randomseed(os.time())
  file = io.open("hui.txt", "w")
  io.output(file)
  maze_module = require('maze')

  screenWidth = love.graphics.getWidth()
  screenHeight = love.graphics.getHeight()
  tunnelSize = 3
  alignCoef = 3
  scaleFactor = 21

  cellSize = math.floor(math.min(screenHeight, screenWidth) / scaleFactor * (alignCoef / tunnelSize))

  gridXCount = math.floor((screenWidth - 1) / (tunnelSize * cellSize + 1))
  gridYCount = math.floor((screenHeight - 1) / (tunnelSize * cellSize + 1))
  gridXCount = gridXCount * (tunnelSize + 1) + 1
  gridYCount = gridYCount * (tunnelSize + 1) + 1

  maze = maze_module.create_empty_maze(gridXCount, gridYCount)
  maze_module.carve_maze(maze, 2, 2, tunnelSize)
  maze_module.show_maze(maze)

  function reset()
    snakeSegments = {
      {x = 2, y = 2}
    }
    directionQueue = {'down'}
    snakeAlive = true
    canMove = true
    timer = 0
  end

  reset()

  function moveFood()
    local possibleFoodPositions = {}

    for foodX = 1, gridXCount do
      for foodY = 1, gridYCount do
        local possible = true

        for segmentIndex, segment in ipairs(snakeSegments) do
          if foodX == segment.x and foodY == segment.y or maze[foodY][foodX] == 1 then
            possible = false
          end
        end

        if possible then
          table.insert(possibleFoodPositions, {x = foodX, y = foodY})
        end
      end
    end

    foodPosition = possibleFoodPositions[love.math.random(#possibleFoodPositions)]
  end

  moveFood()
end

function love.update(dt)
  timer = timer + dt

  if snakeAlive then
    local timerLimit = 0.15
    if timer >= timerLimit then
      timer = timer - timerLimit

      if #directionQueue > 1 then
        table.remove(directionQueue, 1)
      end

      local nextXPosition = snakeSegments[1].x
      local nextYPosition = snakeSegments[1].y

      if directionQueue[1] == 'right' then
        nextXPosition = nextXPosition + 1
        if nextXPosition > gridXCount then
          nextXPosition = 1
        end
      elseif directionQueue[1] == 'left' then
        nextXPosition = nextXPosition - 1
        if nextXPosition < 1 then
          nextXPosition = gridXCount
        end
      elseif directionQueue[1] == 'down' then
        nextYPosition = nextYPosition + 1
        if nextYPosition > gridYCount then
          nextYPosition = 1
        end
      elseif directionQueue[1] == 'up' then
        nextYPosition = nextYPosition - 1
        if nextYPosition < 1 then
          nextYPosition = gridYCount
        end
      end

      for segmentIndex, segment in ipairs(snakeSegments) do
        if segmentIndex ~= #snakeSegments
        and nextXPosition == segment.x
        and nextYPosition == segment.y then
          snakeAlive = false
        end
      end

--      io.write('maze:' .. maze[nextXPosition - 1][nextYPosition - 1])
--      io.flush()
--      io.write('\n')
--      io.write('maze curr:' .. maze[snakeSegments[1].x][snakeSegments[1].y])
--      io.flush()
--      io.write('\n')
--      io.write('x:' .. snakeSegments[1].x)
--      io.write('\n')
--      io.write('y:' .. snakeSegments[1].y)
--      io.write('\n')
--      io.flush()



--      io.write('116x: ' .. nextXPosition)
--      io.write('\n')
--      io.write('118y: ' .. nextYPosition)
--      io.write('\n')

      if maze[nextYPosition][nextXPosition] == 1 then
        canMove = false
      else
        canMove = true
      end

      if canMove then
        table.insert(snakeSegments, 1, {x = nextXPosition, y = nextYPosition})

        if snakeSegments[1].x == foodPosition.x
        and snakeSegments[1].y == foodPosition.y then
          moveFood()
        else
          table.remove(snakeSegments)
        end
      end
    end
  elseif timer >= 2 then
    reset()
  end
end

function love.draw()
  love.graphics.setBackgroundColor(1, 1, 1)
  love.graphics.setColor(0, 0, 0)

  local scaleX = screenWidth / (gridXCount * cellSize);
  local scaleY = screenHeight / (gridYCount * cellSize);

  love.graphics.scale(scaleX, scaleY)

  love.graphics.rectangle(
    'fill',
    0,
    0,
    gridXCount * cellSize,
    gridYCount * cellSize
  )

  local function drawCell(x, y)
    love.graphics.rectangle(
      'fill',
      (x - 1) * cellSize,
      (y - 1) * cellSize,
      cellSize - 1,
      cellSize - 1
    )
  end

  for i = 1, gridYCount do
    for j = 1, gridXCount do
      if maze[i][j] == 0 then
        love.graphics.setColor(0, 0, 0)
      else
        love.graphics.setColor(150 / 255, 150 / 255, 150 / 255, 1)
      end
      drawCell(j, i)
    end
  end

  for segmentIndex, segment in ipairs(snakeSegments) do
    if snakeAlive then
      love.graphics.setColor(1, 0, 0)
    else
      love.graphics.setColor(50 / 255, 50 / 255, 50 / 255)
    end
    drawCell(segment.x, segment.y)
  end

--      io.write('maze curr:' .. maze[snakeSegments[1].x][snakeSegments[1].y])
--      io.flush()
--      io.write('\n')
--      io.write('x:' .. snakeSegments[1].x)
--      io.write('\n')
--      io.write('y:' .. snakeSegments[1].y)
--      io.write('\n')
--      io.flush()

  love.graphics.setColor(0, 1, 1)
  drawCell(foodPosition.x, foodPosition.y)
end

function love.keypressed(key)
  if key == 'right'
  and directionQueue[#directionQueue] ~= 'right'
  and directionQueue[#directionQueue] ~= 'left' then
    table.insert(directionQueue, 'right')

  elseif key == 'left'
  and directionQueue[#directionQueue] ~= 'left'
  and directionQueue[#directionQueue] ~= 'right' then
    table.insert(directionQueue, 'left')

  elseif key == 'up'
  and directionQueue[#directionQueue] ~= 'up'
  and directionQueue[#directionQueue] ~= 'down' then
    table.insert(directionQueue, 'up')

  elseif key == 'down'
  and directionQueue[#directionQueue] ~= 'down'
  and directionQueue[#directionQueue] ~= 'up' then
    table.insert(directionQueue, 'down')
  end
end
