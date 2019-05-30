local waypoint = {}
NPCWaypoints = {}

--[[

Deprecated

]]

--[[function waypoint:place()
  local x = love.mouse.getX()
  local y = love.mouse.getY()
  local newWaypoint = { x=x, y=y }
  waypointVec = vector(x,y)
  print(waypointVec:unpack())
  waypoints = {}
  table.insert(waypoints, newWaypoint)
  self.startTime = love.timer.getTime()
  self.startAngle = playerBody:getAngle()
  self.targAngle = waypointVec:angleTo(playerVec)+math.pi/2
  self.turnRate = 0.7
  self.valid = true
end]]

function waypoint:placeNPCWP(enemyShip)
  local x = 400
  local y = 150
  local waypointVec = vector(x,y)
  local waypoint = { x=x, y=y, vec = waypointVec, ship = ship }
  table.insert(enemyWaypoints, waypoint)

  self.startTime = love.timer.getTime()
  self.startAngle = enemyShip:getAngle()
  self.targAngle = self:getAngle(enemyShip)-math.pi/2
  self.turnRate = 0.7
  self.valid = true
end

function waypoint:getAngleNPCWP(enemyShip)
  local waypoint = waypoints[1]
  local pX = enemyShip:getX()
  local pY = enemyShip:getY()
  local wX, wY = waypointVec:unpack()
--  self._angle = waypointVec:angleTo(playerVec)
  self._angle = math.angle(wX, wY, pX, pY)
  return self._angle
end


function waypoint:place()
  local x, y = love.mouse.getPosition()
  waypointVec = vector(x,y)
  local waypoint = { x=x, y=y }
  table.insert(waypoints, waypoint)--waypoints = {waypoint}

  --table.insert(waypoints, newWaypoint)

  self.startTime = love.timer.getTime()
  self.startAngle = playerBody:getAngle()
  self.targAngle = self:getAngle()-math.pi/2
  self.turnRate = 0.7
  self.valid = true
end

function waypoint:getAngle()
  local waypoint = waypoints[1]
  local pX = playerBody:getX()
  local pY = playerBody:getY()
  local wX, wY = waypointVec:unpack()
--  self._angle = waypointVec:angleTo(playerVec)
  self._angle = math.angle(wX, wY, pX, pY)
  return self._angle
end

return waypoint
