local waypoint = {}

function waypoint:place()
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
end

function waypoint:place2()
  local x, y = love.mouse.getPosition()
  local waypoint = { x=x, y=y }
  waypoints = {waypoint}
  --table.insert(waypoints, newWaypoint)
  self.startTime = love.timer.getTime()
  self.startAngle = playerBody:getAngle()
  self.targAngle = self:angle()+math.pi/2
  self.turnRate = 0.7
  self.valid = true
end

function waypoint:angle()
  local waypoint = waypoints[1]
  local wX = waypoint.x
  local wY = waypoint.y
  local pX = playerBody:getX()
  local pY = playerBody:getY()

  self._angle = waypointVec:angleTo(playerVec)
   --math.angle(wX, wY, pX, pY)
  return self._angle
end

function waypoint:setTargetAngle()

end

function waypoint:getAngle()
  return self._angle
end

return waypoint
