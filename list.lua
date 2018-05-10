local class = require('class')
local List = class('List')

function List:initialize()
  self.first = 0
  self.last = -1
end

function List:pushLeft(value)
  local first = self.first - 1
  self.first = first
  self[first] = value
end

function List:pushRight(value)
  local last = self.last + 1
  self.last = last
  self[last] = value
end

function List:popLeft()
  local first = self.first
  if first > self.last then 
    return nil 
  end
  local value = self[first]
  self[first] = nil        -- to allow garbage collection
  self.first = first + 1
  return value
end

function List:getLeft()
  local first = self.first
  if first > self.last then 
    return nil 
  end
  return self[first]
end

function List:popRight()
  local last = self.last
  if self.first > last then
    return nil
  end
  local value = self[last]
  self[last] = nil         -- to allow garbage collection
  self.last = last - 1
  return value
end

function List:getRight()
  local last = self.last
  if self.first > last then
    return nil
  end
  return self[last]
end

function List:iterRight()
  local i = self.first - 1
  local n = self.last
  return function() 
    i = i + 1
    if i <= n then
      return self[i]
    end
  end  
end  

function List:iterLeft()
  local i = self.last + 1
  local n = self.first
  return function() 
    i = i - 1
    if i >= n then
      return self[i]
    end
  end  
end  

function List:isEmpty()
  return self[self.first] == nil and self[self.first] == nil
end

function List:getSize()
  return math.abs((self.first - self.last) - 1)
end

return List