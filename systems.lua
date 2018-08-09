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

  local offset = (xPos+(width*currSpeedPercent))-mX
  local newWidth = xPos+offset
  --print(newWidth,width,currSpeedPercent)

  local speedPercent = newWidth/width

  ship.speedPercent = speedPercent
end

return systems