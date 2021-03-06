systems = {}

function systems:pause()
  if paused == true then
    paused = false
  else
    paused = true
  end
end

function systems:assignDesiredSpeedOnClick(xPos,width,shipNo,revOffset)
  local ship = shipsList[shipNo]
  local currSpeedPercent = ship.speedPercent
  local mX,mY = love.mouse.getPosition()
  mX = mX--+(1-revOffset)
  ship.resetting = true

  local offset = mX-xPos
  local newWidth = offset

  local speedPercent = newWidth/width
  speedPercent = speedPercent-revOffset
  if speedPercent > 1 then
    speedPercent = 1
  elseif speedPercent < -revOffset then
    speedPercent = -revOffset
  end
  speedPercent = tostring(speedPercent)
  speedPercent = tonumber(string.format("%.3f", speedPercent))

  if math.abs(speedPercent) > 0.005 then
    ship.speedPercent = speedPercent
  else
    ship.speedPercent = 0
  end
end

return systems
