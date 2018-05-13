local class = require('class')
local FoodGenerator = class('FoodGenerator')
local Food = Food or require('food')
local Color = require('color')
local Vector2 = require('vector2')

function FoodGenerator:generate(field, count, showTimeStart, showTimeEnd, hideTimeStart, hideTimeEnd)
  local foodArr = {}
  showTimeVariance = showTimeVariance or 0
  delayTimeVariance = delayTimeVariance or 0

  for i = 1, count do
    local showTime = math.random(showTimeStart, showTimeEnd)
    local hideTime = math.random(hideTimeStart, hideTimeEnd)
    local food = Food(field, Color(0, 255, 255), showTime, hideTime)
    foodArr[i] = food
  end

  return foodArr
end

return FoodGenerator