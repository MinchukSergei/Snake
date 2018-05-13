local class = require('class')

local FieldStateEnum = class('FieldStateEnum')

FieldStateEnum.EMPTY = 0
FieldStateEnum.WALL = 1
FieldStateEnum.FOOD = 2
FieldStateEnum.SNAKE = 3

return FieldStateEnum