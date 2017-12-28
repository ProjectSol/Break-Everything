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
	playerMovement = require "playerMovement"
	shipBuilder = require "ships"

	--love.mouse.setGrabbed(true)

	shipsList = {}
	--table.insert(playerShip, shipsList)

	love.physics.setMeter(64)
	world = love.physics.newWorld(0, 0, true)

	basicObjects()
	shipBuilder:genBasicPlayerShip()
	shipBuilder:genBasicEnemyShip()

end

function love.update(dt)
	world:update(dt)
	playerVec = playerMovement:calcPlayerVector()
	playerMovement:rotate3(dt)
	--waypoint:place()
	--playerMovement:rotate1()
	--playerMovement:movement1()
	--playerMovement:rotate2()
	--playerMovement:movement()
	--[[
		None of that works
	]]

	if love.keyboard.isDown('escape') then
		love.event.push('quit')
	end
end

function love.mousepressed(x, y, button)
	waypoint:place()
	--waypoint:setTargetAngle()
end

function love.draw()

	local waypoint = waypoints[1]
	if waypoint ~= nil then
		love.graphics.setColor(255, 255, 255)
		love.graphics.circle("fill", waypoint.x, waypoint.y, 2)
	end

	love.graphics.setLineWidth(2)
	love.graphics.setColor(200,200,200)
	love.graphics.polygon("line", playerBody:getWorldPoints(playerShape:getPoints()))

	love.graphics.setColor(200, 200, 200)
	love.graphics.polygon("line", shipsList.basicEnemy.body:getWorldPoints(shipsList.basicEnemy.shape:getPoints()))

	love.graphics.setColor(50,50,255)
	local circleX = playerBody:getX()
	local circleY = playerBody:getY()
	love.graphics.circle("fill", circleX, circleY, 3, 20)

	love.graphics.setColor(193, 47, 14) --set the drawing color to red for the ball
	love.graphics.circle("fill", objects.ball.body:getX(), objects.ball.body:getY(), objects.ball.shape:getRadius())


	love.graphics.setLineWidth(1)

	for i = 1,1 do
		local waypoint = waypoints[i]
		if waypoint ~= nil then
			love.graphics.setColor(255, 255, 255)
			love.graphics.circle("fill", waypoint.x, waypoint.y, 2)
		end
	end

	if #waypoints > 0 then
		local waypoint = waypoints[1]
		local x = playerBody:getX()
		local y = playerBody:getY()
		local x2 = waypoint.x
		local y2 = waypoint.y
		love.graphics.setColor(255,255,255)
		love.graphics.line( x, y, x2, y2 )
	end

	if debug then
		love.graphics.setColor(255, 255, 255)
		fps = tostring(love.timer.getFPS())
		love.graphics.print("Current FPS: "..fps, 9, 10)
	end
end
