movement = {}

function movement:movement(ship)
	--Deprecated, see movement2
	if ship.validWaypoint and ship.accel then
		local angle = ship.body:getAngle() + math.pi/2
		ship.currSpeed = movement:calcCurrSpeed(ship)
		local playerDx = 10 * ship.currSpeed * math.cos(angle)
		local playerDy = 10 * ship.currSpeed * math.sin(angle)


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
	--print(ship.movement2Angle, ship.validWaypoint)
	if ship.validWaypoint and ship.movement2Angle then
		local angle2 = ship.movement2Angle+math.pi
		local angle = ship.body:getAngle()+math.pi/2
		ship.currSpeed = movement:calcCurrSpeed(ship)
		local playerDx = 10 * ship.currSpeed * math.cos(angle)
		local playerDy = 10 * ship.currSpeed * math.sin(angle)


		ship.body:setLinearVelocity(playerDx,playerDy)
		--ship.body:applyLinearImpulse(playerDx,playerDy)
		--local currPlayer = shipBuilder:getSelectedPlayerShip()
		if ship.player and ship.selected and cameraLock == true then
			camera:lookAt(ship.body:getX(), ship.body:getY())
		end
		ship.shipVec = vector(ship.body:getX(), ship.body:getY())
		directionVec = ship.shipVec:normalized()
		--print(unpack(directionVec))
		vecX,vecY = ship.waypoint.vec:unpack()
		ship.waypoint.x,ship.waypoint.y = vecX,vecY

		--ship.waypoint.y = ship.body:getY()+ship.waypoint.y

  end
end

function movement:calcCurrSpeed(ship)
	local acceleration = ship.accel/10
	local deceleration = ship.decel/10
	local current = ship.currSpeed
	projected = ship.speed*ship.speedPercent

	if current + acceleration < projected and projected > current then
		current = current+acceleration
	elseif current - deceleration > projected and projected < current then
		current = current-deceleration
	else
		current = projected
	end
	return current
end

return movement
