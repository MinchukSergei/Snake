local class = require('class')
local Vector2 = class('Vector2')

function Vector2:initialize(x, y)
    self.x = x
    self.y = y
end

return Vector2