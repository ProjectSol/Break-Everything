enemyMovement = {}

function enemyMovement:movement()
	local waypoint = waypoints[1]
	if waypoint then
		local angle = playerBody:getAngle() + math.pi/2
		local playerDx = player.speed * math.cos(angle)
		local playerDy = player.speed * math.sin(angle)
    --print(playerDx, playerDy)
    playerBody:setLinearVelocity(playerDx,playerDy)
  end
end

function enemyMovement:rotate()
  if waypoint.valid then
    local rotSpeed = player.turnSpeed/100

    local sA = playerBody:getAngle()
    local tA = waypoint:getAngle()+math.pi/2

		-- checks which direction to rotate in by finding which direction has the least distance to travel

		local diff1 = tA - sA
    local diff2 = tA - sA + math.pi*2
    local diff = nil

    local closest1 = diff2 - math.pi*2
    local closest2 = diff1 - math.pi*2
		
    local closest3 = diff2
    local closest4 = diff1

    diff = closestToZero(closest1, closest2, closest3, closest4)

    if diff < 0 then
      direction = -1
    else
      direction = 1
    end

-- the actual rotation

    if math.abs(diff) < rotSpeed then
      playerBody:setAngle(tA)
    else
      playerBody:setAngle(sA+(rotSpeed*direction))
    end

-- stops it from looping endlessly

    if sA >= 2*math.pi then
      sA = sA-2*math.pi
      playerBody:setAngle(sA)
    end

    if sA <= -2*math.pi then
      sA = sA+2*math.pi
      playerBody:setAngle(sA)
    end
  end
end

function enemyMovement:calcPlayerVector()
	for i = 1,#shipsList do
		if shipsList[i].selected == true then
	  	local playerVec = vector(shipsList[i].x, shipsList[i].y)
	  	return playerVec
		end
	end
end

return enemyMovement
