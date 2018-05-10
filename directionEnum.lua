local class = require('class')

local DirectionEnum = class('DirectionEnum')

DirectionEnum.DOWN = 'down'
DirectionEnum.UP = 'up'
DirectionEnum.RIGHT = 'right'
DirectionEnum.LEFT = 'left'

return DirectionEnum