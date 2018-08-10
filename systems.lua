systems = {}

function systems:pause()
  if paused == true then
    paused = false
  else
    paused = true
  end
end

function systems:assignDesiredSpeedOnClick(xPos,width,shipNo)
  local ship = shipsList[shipNo]
  local currSpeedPercent = ship.speedPercent
  local mX,mY = love.mouse.getPosition()

  local offset = mX-xPos
  local newWidth = offset
  --print(newWidth,width,currSpeedPercent)

  local speedPercent = newWidth/width
  speedPercent = tostring(speedPercent)
  speedPercent = tonumber(string.format("%.3f", speedPercent))

  ship.speedPercent = speedPercent
end

return systems
