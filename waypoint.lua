local waypoint = {}

function waypoint:place()
  local x = love.mouse.getX()
  local y = love.mouse.getY()
  local newWaypoint = { x=x, y=y }
  waypoints = {}
  table.insert(waypoints, newWaypoint)
  self.startTime = love.timer.getTime()
  self.startAngle = playerBody:getAngle()
  self.targAngle = self:angle()
  self.turnRate = 0.7
  self.valid = true
end

function waypoint:angle()
  for i = 1,1 do
    local waypoint = waypoints[i]
    local wX = waypoint.x
    local wY = waypoint.y
    local pX = ships.player.body:getX()
    local pY = ships.player.body:getY()
    self._angle = math.angle(wX, wY, pX, pY)
  end
  return self._angle
end

function waypoint:getAngle()
  return self._angle
end

return waypoint
