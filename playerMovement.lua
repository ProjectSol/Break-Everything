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
		local angle = playerBody:getAngle() --+ math.pi
		local playerDx = 0--ships.player.speed * math.cos(angle)
		local playerDy = ships.player.speed/100 * math.cos(angle)
    --print(playerDx, playerDy)
    ships.player.body:applyLinearImpulse(playerDx,playerDy)
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


function playerMovement:rotate(dt)
  if waypoints[1] then
    waypoint:angle()
    local currAngle = playerBody:getAngle()
    local targAngle = waypoint:angle()+math.pi/2
    local diff = (targAngle - currAngle)*dt
    --[[local dur = 32
    local change = diff/dur]]

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
end

function playerMovement:rotate3()
  if waypoint.valid then
    local rotSpeed = player.turnSpeed/100
    local sA = playerBody:getAngle()
    local tA = waypoint:angle()
    local diff = tA - sA
    --[[if tA < sA then
      direction = -1
    else
      direction = 1
    end]]
    if diff == 0 then
      --playerBody:setAngle(sA)
    elseif math.abs(diff) < rotSpeed then
      playerBody:setAngle(sA+diff)
    else
      playerBody:setAngle(sA+rotSpeed)
    end
    print("StartAngle : "..sA)
    print("TargetAngle: "..tA)
    --playerBody:setAngle(sA+0.10)
    --[[if sA >= 2*math.pi then
      sA = sA-2*math.pi
      playerBody:setAngle(sA)
    end]]

  end
end

function playerMovement:calcPlayerVector()
  local playerVec = vector(shipsList.playerShip.x, shipsList.playerShip.y)
  return playerVec
end

return playerMovement
