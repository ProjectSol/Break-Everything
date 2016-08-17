playerMovement = {}

function playerMovement:movement()
  for i = 1,1 do
		local waypoint = waypoints[i]
		if waypoint ~= nil then
      test()
			local angle = playerBody:getAngle()+math.pi*1.5
			local playerDx =  ships.player.speed * math.cos(angle)
			local playerDy = ships.player.speed * math.sin(angle)
      print(playerDx, playerDy)
      ships.player.body:applyLinearImpulse(playerDx,playerDy)
    end
  end
end

function playerMovement:rotate()
  for i = 1,1 do
		local waypoint = waypoints[i]
		if waypoint ~= nil then
      test()
      local currAngle = playerBody:getAngle()
      local targAngle = angle
      local diff = targAngle - currAngle
      local currTime = love.timer.getTime()
      local dur = 2
      if run == true then
        print('test2')
        local p = (currTime - startTime)/dur
        local c = p*( startAngle - targAngle )
    		--local p = math.min( (love.timer.getTime()-startTime/dur), 1 )
    		currAngle = currAngle + diff*p
        playerBody:setAngle(currAngle+math.pi*1.5)
    		--[[if currAngle == targAngle then
    			run = false
    		end]]
    	end
    end
  end
end

return playerMovement
