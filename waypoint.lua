local waypoint = {}

function waypoint:place()
  local x = love.mouse.getX()
  local y = love.mouse.getY()
  local newWaypoint = { x=x, y=y }
  waypoints = {}
  table.insert(waypoints, newWaypoint)
  startTime = love.timer.getTime()
  startAngle = playerBody:getAngle()
end

function waypoint:angle()
  for i = 1,1 do
    local waypoint = waypoints[i]
    local wX = waypoint.x
    local wY = waypoint.y
    local pX = ships.player.body:getX()
    local pY = ships.player.body:getY()
    angle = math.angle(wX, wY, pX, pY)
  end
end

return waypoint
