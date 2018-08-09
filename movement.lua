movement = {}

function movement:movement(ship)
	if ship.validWaypoint and ship.accel then
		local angle = ship.body:getAngle() + math.pi/2

		local playerDx = classModifier * ship.speed * math.cos(angle)
		local playerDy = 10 * ship.speed * math.sin(angle)

		ship.body:setLinearVelocity(playerDx,playerDy)
		--local currPlayer = shipBuilder:getSelectedPlayerShip()
		if ship.player and ship.selected and cameraLock == true then
			camera:lookAt(ship.body:getX(), ship.body:getY())
		end
		ship.shipVec = vector(ship.body:getX(), ship.body:getY())
  end
	if ship.wpVec then
		--print((ship.shipVec:dist(ship.wpVec)))
		if ship.shipVec:dist(ship.wpVec) < 5 then
			ship.wpVec = nil
			ship.waypoint = nil
			ship.validWaypoint = false
		end
	end
end

function movement:rotate(ship)
	--print(ship.name, ship.validWaypoint, ship.accel, ship.body:getAngle())
  if ship.validWaypoint and ship.accel then
    local rotSpeed = ship.turnSpeed/100

    local sA = ship.body:getAngle()
    local tA = getWpAngle(ship)+math.pi/2

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
      ship.body:setAngle(tA)
    else
    	ship.body:setAngle(sA+(rotSpeed*direction))
    end

-- stops it from looping endlessly and keeps the numbers looking reasonable

    if sA >= 2*math.pi then
      sA = sA-2*math.pi
      ship.body:setAngle(sA)
    end

    if sA <= -2*math.pi then
      sA = sA+2*math.pi
      ship.body:setAngle(sA)
    end
  end
end

function movement:rotate2(ship)
	--print(ship.name, ship.validWaypoint, ship.accel, ship.body:getAngle())
  if ship.validWaypoint and ship.accel then
    local rotSpeed = ship.turnSpeed/100

    local sA = ship.body:getAngle()
    local tA = ship.movement2Angle+math.pi/2--getWpAngle(ship)+math.pi/2
		--print(tA)

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
      ship.body:setAngle(tA)
    else
    	ship.body:setAngle(sA+(rotSpeed*direction))
    end

-- stops it from looping endlessly and keeps the numbers looking reasonable

    if sA >= 2*math.pi then
      sA = sA-2*math.pi
      ship.body:setAngle(sA)
    end

    if sA <= -2*math.pi then
      sA = sA+2*math.pi
      ship.body:setAngle(sA)
    end
  end
end

function movement:calcPlayerVector()
	for i = 1,#shipsList do
		if shipsList[i].selected == true then
	  	local playerVec = vector(shipsList[i].x, shipsList[i].y)
	  	return playerVec
		end
	end
end

function movement:movement2(ship)
	print(ship.movement2Angle, ship.validWaypoint)
	if ship.validWaypoint and ship.movement2Angle then
		local angle2 = ship.movement2Angle+math.pi
		local angle = ship.body:getAngle()+math.pi/2
		ship.currSpeed = movement:calcCurrSpeed(ship)
		local playerDx = 10 * ship.currSpeed * -math.cos(angle)
		local playerDy = 10 * ship.currSpeed * -math.sin(angle)

		ship.body:setLinearVelocity(playerDx,playerDy)
		--local currPlayer = shipBuilder:getSelectedPlayerShip()
		if ship.player and ship.selected and cameraLock == true then
			camera:lookAt(ship.body:getX(), ship.body:getY())
		end
		ship.shipVec = vector(ship.body:getX(), ship.body:getY())
  end
end

function movement:calcCurrSpeed(ship)
	local acceleration = ship.accel
	local current = ship.currSpeed
	local projected = 5
	--print(projected, ship.speedPercent)
	if ship.speedPercent > 0 then
			--print(projected, ship.speedPercent)
		projected = -ship.maxSpeed*ship.speedPercent
			--print(projected)
	else
		projected = -ship.reverseSpeed*ship.speedPercent
	end
	--print(projected)

	if current + acceleration < projected then
		current = current+acceleration
	else
		current = projected
	end
	return current
end

function movement:updateSpeedPercentange()

end

return movement
