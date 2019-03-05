camControl = {}

--When the camera is locked it is handeled via the movement functions, while unlocked we will deal with it here

cameraLock = false

function camControl:swapLockSetting()
  if cameraLock == true then
    camControl:setCameraLock(false)
  else
    camControl:setCameraLock(true)
  end
end

function camControl:setCameraLock(tf)
  cameraLock = tf
  return tf
end

function camControl:edgeScrolling()
    local x,y = love.mouse.getPosition()
    local width,height = love.graphics.getDimensions()
    local sensitivityX = 5
    local sensitivityY = 5
    if x < width/50 then
      camera:move(-sensitivityX, 0)
    elseif x > width-width/50 then
      camera:move(sensitivityX,0)
    end

    if y < height/50 then
      camera:move(0,-sensitivityY)
    elseif y > height-height/50 then
      camera:move(0,sensitivityY)
    end
end

function camControl:cameraMovement()
  if cameraLock then
		for i = 1,#shipsList do
      local ship = shipsList[i]
      if ship.player and ship.selected then
  		  local x,y = ship.body:getPosition()
        camera:lookAt(x,y)
        x1,y1 = camera:cameraCoords(x,y)
      end
    end
	else
		camControl:edgeScrolling()
	end
end

return camControl
