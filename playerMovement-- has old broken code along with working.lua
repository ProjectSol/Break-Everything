playerMovement = {}
rotate = {}
rotate.run = nil

function playerMovement:movement1()
  for i = 1,1 do
		local waypoint = waypoints[i]
		if waypoint then
			local angle = playerBody:getAngle()+math.pi
			local playerDx =  ships.player.speed * math.cos(angle)
			local playerDy = ships.player.speed * math.sin(angle)
      --print(playerDx, playerDy)
      ships.player.body:applyLinearImpulse(playerDx,playerDy)
    end
  end
end

function playerMovement:movement()
	local waypoint = waypoints[1]
	if waypoint then
		local angle = playerBody:getAngle() + math.pi/2
		local playerDx = player.speed * math.cos(angle)
		local playerDy = player.speed * math.sin(angle)
    --print(playerDx, playerDy)
    playerBody:setLinearVelocity(playerDx,playerDy)
  end
end

function playerMovement:rotate2()
  if waypoints[1] then
    waypoint:angle()
    local currAngle = playerBody:getAngle()+math.pi
    local targAngle = waypoint._angle
    local diff = targAngle - currAngle
    local turnRate = math.rad(1)
    print('currAngle '..currAngle..' targAngle '..targAngle..' diff '..diff..' turnRate '..turnRate)
    if currAngle == targAngle then
      rotate.run = false
    else
      rotate.run = true
    end
    if rotate.run == true then
      if currAngle == targAngle then
        currAngle = currAngle
        rotate.run = false
      elseif math.abs(diff) >= turnRate then
        if diff > 0 then
          currAngle = currAngle + turnRate*diff
        else
          currAngle = currAngle - turnRate*diff
        end
      else
        currAngle = currAngle + diff
      end
      playerBody:setAngle(currAngle)
    end
  end
end


--[[function playerMovement:rotate(dt)
  if waypoints[1] then
    waypoint:angle()
    local currAngle = playerBody:getAngle()
    waypoint:angle()
    local targAngle = waypoint.targAngle
    local diff = (targAngle - currAngle)*dt

    currAngle = currAngle+(change)
    print(targAngle, currAngle)
    playerBody:setAngle(currAngle)
  end
end

function playerMovement:rotate1()
  if waypoint.valid then
    local sA = waypoint.startAngle
    local sT = waypoint.startTime
    local tA = waypoint.targAngle+math.pi*2
    if sA == tA then

    else
      local rate = waypoint.turnRate
      local diff = tA - sA
      print( diff )
      --if diff > math.pi then diff = (diff-math.pi) end
      local p = math.min( (love.timer.getTime() - sT)/rate, 1 )
      playerBody:setAngle( sA + diff*p )
    end
  end
end]]
function closestToZero(a, b, c, d, e, f)
  local test = math.min(math.abs(a), math.abs(b), math.abs(c), math.abs(d))
  if math.abs(a) == test then
    return a
  elseif math.abs(b) == test then
    return b
  elseif math.abs(c) == test then
    return c
  elseif math.abs(d) == test then
    return d
  --[[elseif math.abs(e) == test then
    return e
  elseif math.abs(f) == test then
    return f]]
  end
end


function playerMovement:rotate()
  if waypoint.valid then
    local rotSpeed = player.turnSpeed/10

    local sA = playerBody:getAngle()
    local tA = waypoint:angle()+math.pi/2

    local diff1 = tA - sA
    local diff2 = tA - sA + math.pi*2
    local diff = nil

    local closest1 = diff2 - math.pi*2
    local closest2 = diff1 - math.pi*2
    local closest3 = diff2 - 0
    local closest4 = diff1 - 0
    --[[local closest5 = diff2 + math.pi*2
    local closest6 = diff1 + math.pi*2]]
    diff = closestToZero(closest1, closest2, closest3, closest4--[[, closest5, closest6]])

    if diff < 0 then
      direction = -1
    else
      direction = 1
    end

    if math.abs(diff) < rotSpeed then
      playerBody:setAngle(tA)
    else
      playerBody:setAngle(sA+(rotSpeed*direction))
    end

    print("StartAngle : "..sA)
    print("TargetAngle: "..tA)
    print("Difference: "..diff)

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

function playerMovement:calcPlayerVector()
  local playerVec = vector(shipsList.playerShip.x, shipsList.playerShip.y)
  return playerVec
end

return playerMovement
