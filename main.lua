waypoints = {}
ships = {}
objects = {}

function math.angle(x1,y1, x2,y2)
	return math.atan2(y2-y1, x2-x1)
end

function checkCollision(x1,y1,w1,h1, x2,y2,w2,h2)
	return x1 + w1 > x2 and
		y1 + h1 > y2 and
		x1 < x2 + w2 and
		y1 < y2 + h2
end

function test()
	print('test')
end

function love.load()
	vector = require "hump/vector"
	waypoint = require "waypoint"
	movement = require "movement"
	shipBuilder = require "ships"
	alliances = require "alliances"

	shipsList = {}

	love.physics.setMeter(64)
	world = love.physics.newWorld(0, 0, true)

	--basicWalls()
	allianceSys:defaultAlliances()

	shipBuilder:genBasicPlayerShip()
	shipBuilder:genBasicEnemyShip()
	shipBuilder:genBasicEnemyShip()
	shipBuilder:genBasicEnemyShip()


end

function love.update(dt)
	world:update(dt)

	shipsThink()

	if love.keyboard.isDown('escape') then
		love.event.push('quit')
	end
end

function love.mousepressed(x, y, button)
	shipsThinkMouse()
end

function mouseGrabToggle()
	if love.mouse.isGrabbed() then
		love.mouse.setGrabbed(true)
	else
		love.mouse.setGrabbed(false)
	end
end

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
  end
end

function love.draw()

	local waypoint = waypoints[1]
	if waypoint ~= nil then
		love.graphics.setColor(255, 255, 255)
		love.graphics.circle("fill", waypoint.x, waypoint.y, 2)
	end

	--[[love.graphics.setLineWidth(2)
	love.graphics.setColor(200,200,200)
	love.graphics.polygon("line", playerBody:getWorldPoints(playerShape:getPoints()))

	love.graphics.setColor(200, 200, 200)
	love.graphics.polygon("line", shipsList.basicEnemy.body:getWorldPoints(shipsList.basicEnemy.shape:getPoints()))]]
	drawBasicShips()

	love.graphics.setColor(50,50,255)
	--[[local circleX = playerBody:getX()
	local circleY = playerBody:getY()
		love.graphics.circle("fill", circleX, circleY, 3, 20)]]

	if objects.ball then
		love.graphics.setColor(193, 47, 14) --set the drawing color to red for the ball
		love.graphics.circle("fill", objects.ball.body:getX(), objects.ball.body:getY(), objects.ball.shape:getRadius())
	end

	love.graphics.setLineWidth(1)

	drawWaypoints()

	--[[for i = 1,#enemyWaypoints do
		local waypoint = enemyWaypoints[i]
		local x = shipsList[i+1]:getX()
		local y = shipsList[i+1]:getY()
		local x2 = waypoint.x
		local y2 = waypoint.y
		love.graphics.setColor(255,255,255)
		love.graphics.line( x, y, x2, y2 )
	end]]

	if debug then
		love.graphics.setColor(255, 255, 255)
		fps = tostring(love.timer.getFPS())
		love.graphics.print("Current FPS: "..fps, 9, 10)
	end
end
