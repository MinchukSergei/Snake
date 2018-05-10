local class = require('class')
local List = require('list')
local FieldStateEnum = require('fieldStateEnum')
local Color = require('color')

local Maze = class('Maze')

function Maze:initialize(width, height, blockSize)
  self.width = width
  self.height = height
  self.blockSize = blockSize
  self.wallColor = Color(150, 150, 150)
  self.emptyColor = Color(0, 0, 0)
  Maze.reset(self, width, height)
end

function Maze:reset(width, height)
  local result = {}

  for i = 1, height do
    result[i] = {}
    for j = 1, width do
      result[i][j] = 1
    end
  end

  self.maze = result
end

function Maze:showMaze()
  for i = 1, self.height do
    for j = 1, self.width do
      if self.maze[i][j] == 0 then
        io.write("  ")
      else
        io.write("[]")
      end
    end
    io.write("\n")
  end
  io.write("\n")
end

function _outsideBorders(self, x, y)
  return x < 1 or y < 1 or x >= self.width - 1 or y >= self.height - 1
end

function _digBlock(self, x, y)
  for i = 0, self.blockSize - 1 do
    for j = 0, self.blockSize - 1 do
      self.maze[y + i][x + j] = 0
    end
  end
end

function _digHorizontalBlock(self, x, y)
  for j = 0, self.blockSize - 1 do
    self.maze[y][x + j] = 0
  end
end

function _digVerticalBlock(self, x, y)
  for i = 0, self.blockSize - 1 do
    self.maze[y + i][x] = 0
  end
end

function _checkVerticalBlock(self, x, y)
  local valid = true
  
  if _outsideBorders(self, x, y) then
    return not valid
  end
  
  for i = 0, self.blockSize - 1 do
    if self.maze[y + i][x] == 0 then
      valid = false
      break
    end
  end
  
  return valid
end

function _checkHorizontalBlock(self, x, y)
  local valid = true
  
  if _outsideBorders(self, x, y) then
    return not valid
  end
  
  for j = 0, self.blockSize - 1 do
    if self.maze[y][x + j] == 0 then
      valid = false
      break
    end
  end
  
  return valid
end

function _checkBlock(self, x, y)
  local valid = true
  
  if _outsideBorders(self, x, y) then
    return not valid
  end
  
  for i = 0, self.blockSize - 1 do
    for j = 0, self.blockSize - 1 do
      if self.maze[y + i][x + j] == 0 then
        valid = false
        break
      end
    end
  end
  
  return valid
end

function Maze:carveMaze(initPosition)
  local queue = List()
  
  queue:pushRight({x = initPosition.x, y = initPosition.y})
  _digBlock(self, initPosition.x, initPosition.y)

  while true do
    local q = queue:popRight()
    if not q then
      break
    end
    
--    maze_matrix.show_maze(maze)

    local r = math.random(0, 3)
    for i = 0, 3 do
      local d = (i + r) % 4
      local dx = 0
      local dy = 0
      local dx2 = 0
      local dy2 = 0
      local right = false
      local left = false
      local down = false
      local up = false

      if d == 0 then
        dx = self.blockSize
        dx2 = 1
        right = true
      elseif d == 1 then
        dx = -1
        dx2 = -self.blockSize
        left = true
      elseif d == 2 then
        dy = self.blockSize
        dy2 = 1
        down = true
      else
        dy = -1
        dy2 = -self.blockSize
        up = true
      end

      local nx = q.x + dx
      local ny = q.y + dy
      local nx2 = nx + dx2
      local ny2 = ny + dy2

      if right or left then
        if _checkVerticalBlock(self, nx, ny) and _checkBlock(self, nx2, ny2) then
          _digVerticalBlock(self, nx, ny)
          _digBlock(self, nx2, ny2)
          queue:pushRight({x = nx2, y = ny2})
        end
      else
        if _checkHorizontalBlock(self, nx, ny) and _checkBlock(self, nx2, ny2) then
          _digHorizontalBlock(self, nx, ny)
          _digBlock(self, nx2, ny2)
          queue:pushRight({x = nx2, y = ny2})
        end
      end
    end
  end
end

function Maze:draw(drawer)
  local wC = self.wallColor
  local eC = self.emptyColor
  
  for i = 1, self.height do
    for j = 1, self.width do
      if self.maze[i][j] == FieldStateEnum.EMPTY then
        love.graphics.setColor(eC.r, eC.g, eC.b)
      elseif self.maze[i][j] == FieldStateEnum.WALL then
        love.graphics.setColor(wC.r, wC.g, wC.b)
      end
      drawer:drawCell(j, i)
    end
  end
end

return Maze