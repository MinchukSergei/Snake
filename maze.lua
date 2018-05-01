local maze_matrix = {}
local List = require('user_list')

function maze_matrix.create_empty_maze(width, height)
  local result = {}

  for i = 1, height do
    result[i] = {}
    for j = 1, width do
      result[i][j] = 1
    end
  end

  return result
end

function maze_matrix.show_maze(maze)
  local height = #maze;
  local width = #maze[1] or 0;
  for i = 1, height do
    for j = 1, width do
      if maze[i][j] == 0 then
        io.write("  ")
      else
        io.write("[]")
      end
    end
    io.write("\n")
  end
  io.write("\n")
end

function outside_borders(maze, x, y)
  local height = #maze;
  local width = #maze[1] or 0;
  return x < 1 or y < 1 or x >= width - 1 or y >= height - 1
end

function dig_block(maze, x, y, block_size)
  for i = 0, block_size - 1 do
    for j = 0, block_size - 1 do
      maze[y + i][x + j] = 0
    end
  end
end

function dig_horizontal_block(maze, x, y, block_size)
  for j = 0, block_size - 1 do
    maze[y][x + j] = 0
  end
end

function dig_vertical_block(maze, x, y, block_size)
  for i = 0, block_size - 1 do
    maze[y + i][x] = 0
  end
end

function check_vertical_block(maze, x, y, block_size)
  local valid = true
  if outside_borders(maze, x, y) then
    return false
  end
  for i = 0, block_size - 1 do
    if maze[y + i][x] == 0 then
      valid = false
      break
    end
  end
  return valid
end

function check_horizontal_block(maze, x, y, block_size)
  local valid = true
  if outside_borders(maze, x, y) then
    return false
  end
  for j = 0, block_size - 1 do
    if maze[y][x + j] == 0 then
      valid = false
      break
    end
  end
  return valid
end

function check_block(maze, x, y, block_size)
  local valid = true
  if outside_borders(maze, x, y) then
    return false
  end
  for i = 0, block_size - 1 do
    for j = 0, block_size - 1 do
      if maze[y + i][x + j] == 0 then
        valid = false
        break
      end
    end
  end
  return valid
end

function maze_matrix.carve_maze(maze, x, y, tunnel_size)
  local queue = List.new()
  List.pushright(queue, {x = x, y = y})
  dig_block(maze, x, y, tunnel_size)

  while true do
    local q = List.popright(queue)
    if q == nil then
      break;
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
        dx = tunnel_size --right
        dx2 = 1
        right = true
      elseif d == 1 then
        dx = -1 --left
        dx2 = -tunnel_size
        left = true
      elseif d == 2 then
        dy = tunnel_size --down
        dy2 = 1
        down = true
      else
        dy = -1 --up
        dy2 = -tunnel_size
        up = true
      end

      local nx = q.x + dx
      local ny = q.y + dy
      local nx2 = nx + dx2
      local ny2 = ny + dy2

      if right or left then
        if check_vertical_block(maze, nx, ny, tunnel_size) and check_block(maze, nx2, ny2, tunnel_size) then
          dig_vertical_block(maze, nx, ny, tunnel_size)
          dig_block(maze, nx2, ny2, tunnel_size)
          List.pushright(queue, {x = nx2, y = ny2})
        end
      else
        if check_horizontal_block(maze, nx, ny, tunnel_size) and check_block(maze, nx2, ny2, tunnel_size) then
          dig_horizontal_block(maze, nx, ny, tunnel_size)
          dig_block(maze, nx2, ny2, tunnel_size)
          List.pushright(queue, {x = nx2, y = ny2})
        end
      end
    end
  end
end

return maze_matrix;

---- The size of the maze (must be odd).
--block_size = 3
--width = 16 * (block_size + 1) + 4 - 1
--height = 9 * (block_size + 1) + 4 - 1

---- Generate and display a random maze.
--maze = init_maze(width, height)
--carve_maze(maze, width, height, 2, 2)

--for i = 0, block_size - 1 do
--  maze[width + 2 + i] = 0
--  maze[(height - 2) * width + width - 3 - i] = 0
--end

--show_maze(maze, width, height)