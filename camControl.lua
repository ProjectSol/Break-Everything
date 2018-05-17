camControl = {}

--When the camera is locked it is handeled via the movement functions, while unlocked we will deal with it here

cameraLock = false



function camControl:setCameraLock(tf)
  cameraLock = tf
  return tf
end

function camControl:edgeScrolling()
  if cameraLock == false then
    local x,y = love.mouse.getPosition()
    local width,height = love.graphics.getDimensions()
    if x < width/50 then
      camera:move(-1,0)
      if y > height/5 then
        camera:move(-1,0)
      elseif y < height/5 then
        camera:move(-1,-1)
      elseif y > 4*height/5 then
        camera:move(-1,1)
      end
    elseif x > width-width/50 then
      camera:move(1,0)
    end
    if y < height/50 then
      if x > width/5 then
        camera:move(0,-1)
      elseif x < width/5 then
        camera:move(-1,-1)
      elseif x > width-width/5 then
        camera:move(1,-1)
      end
    elseif y > height-height/50 then
      camera:move(0,1)
    end
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
