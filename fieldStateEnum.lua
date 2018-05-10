local class = require('class')

local FieldStateEnum = class('FieldStateEnum')

FieldStateEnum.EMPTY = 0
FieldStateEnum.WALL = 1

return FieldStateEnum