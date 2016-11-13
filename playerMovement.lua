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
		local angle = playerBody:getAngle() + math.pi
		local playerDx =  ships.player.speed * math.cos(angle)
		local playerDy = ships.player.speed * math.sin(angle)
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


function playerMovement:rotate()
  if waypoints[1] then
    waypoint:angle()
    local currAngle = playerBody:getAngle()
    local targAngle = waypoint._angle
    local diff = targAngle - currAngle
    local dur = 32
    local change = diff/dur
    currAngle = currAngle+(change)
    playerBody:setAngle(currAngle)
  end
end

function playerMovement:rotate1()
  if waypoint.valid then
    local sA = waypoint.startAngle
    local sT = waypoint.startTime
    local tA = waypoint.targAngle
    local rate = waypoint.turnRate
    local diff = tA - sA
    print( diff )
    --if diff > math.pi then diff = (diff-math.pi) end
    local p = math.min( (love.timer.getTime() - sT)/rate, 1 )
    playerBody:setAngle( sA + diff*p )
  end
end

return playerMovement
