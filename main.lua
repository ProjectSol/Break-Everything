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
	vector = require "hump.vector"
	waypoint = require "waypoint"
	playerMovement = require "playerMovement"

	love.physics.setMeter(64)
	world = love.physics.newWorld(0, 0, true)

	objects.ball = {}
	objects.ball.body = love.physics.newBody(world, 650/2, 650/2, "dynamic") --place the body in the center of the world and make it dynamic, so it can move around
	objects.ball.shape = love.physics.newCircleShape(20) --the ball's shape has a radius of 20
	objects.ball.fixture = love.physics.newFixture(objects.ball.body, objects.ball.shape, 1) -- Attach fixture to body and give it a density of 1.
	objects.ball.fixture:setRestitution(0.8) --let the ball bounce
	objects.ball.body:setLinearDamping(0.05)

	edge1 = {}
	edge1.body = love.physics.newBody(world, 0, 0, "static")
	edge1.edge = love.physics.newEdgeShape( 0, 0, 0, love.graphics:getHeight())
	edge1.fixture = love.physics.newFixture(edge1.body, edge1.edge, 5)

	edge2 = {}
	edge2.body = love.physics.newBody(world, 0, 0, "static")
	edge2.edge = love.physics.newEdgeShape( love.graphics:getWidth(), 0, love.graphics:getWidth(), love.graphics:getHeight())
	edge2.fixture = love.physics.newFixture(edge2.body, edge2.edge, 5)

	edge3 = {}
	edge3.body = love.physics.newBody(world, 0, 0, "static")
	edge3.edge = love.physics.newEdgeShape( 0, 0, love.graphics:getWidth(), 0)
	edge3.fixture = love.physics.newFixture(edge3.body, edge3.edge, 5)

	edge4 = {}
	edge4.body = love.physics.newBody(world, 0, 0, "static")
	edge4.edge = love.physics.newEdgeShape( 0, love.graphics:getHeight(), love.graphics:getWidth(), love.graphics:getHeight())
	edge4.fixture = love.physics.newFixture(edge4.body, edge4.edge, 5)

	ships.player = { speed = 1, turnSpeed = 0.001 }
	ships.player.body = love.physics.newBody( world, love.graphics:getWidth()/2, love.graphics:getHeight()/2, "dynamic")
	ships.player.shape = love.physics.newRectangleShape( 30, 40 )
	ships.player.fixture = love.physics.newFixture(ships.player.body, ships.player.shape)
	ships.player.body:setLinearDamping(5)

	player = ships.player
	playerBody = ships.player.body
	playerShape = ships.player.shape
	playerFixture = ships.player.fixture

	playerBody:setAngle(0)
end

function love.update(dt)
	world:update(dt)
	--[[playerMovement:rotate1()
	playerMovement:movement1()]]
	playerMovement:rotate2()
	playerMovement:movement()
end

function love.mousepressed(x, y, button)
	waypoint:place()
end

function love.draw()

	for i = 1,1 do
		local waypoint = waypoints[i]
		if waypoint ~= nil then
			love.graphics.setColor(255, 255, 255)
			love.graphics.circle("fill", waypoint.x, waypoint.y, 2)
		end
	end

	love.graphics.setColor(72, 160, 14)
	love.graphics.polygon("fill", ships.player.body:getWorldPoints(ships.player.shape:getPoints()))
	love.graphics.setColor(50,50,255)
	local circleX = ships.player.body:getX()
	local circleY = ships.player.body:getY()
	love.graphics.circle("fill", circleX, circleY, 5, 20)

	love.graphics.setColor(193, 47, 14) --set the drawing color to red for the ball
	love.graphics.circle("fill", objects.ball.body:getX(), objects.ball.body:getY(), objects.ball.shape:getRadius())

	for i = 1,1 do
		local waypoint = waypoints[i]
		if waypoint ~= nil then
			love.graphics.setColor(255, 255, 255)
			love.graphics.circle("fill", waypoint.x, waypoint.y, 2)
		end
	end

	for i = 1,1 do
		if #waypoints > 0 then
			local waypoint = waypoints[i]
			local x = ships.player.body:getX()
			local y = ships.player.body:getY()
			local x2 = waypoint.x
			local y2 = waypoint.y
			love.graphics.setColor(255,255,255)
			love.graphics.line( x, y, x2, y2 )
		end
	end

	if debug then
		love.graphics.setColor(255, 255, 255)
		fps = tostring(love.timer.getFPS())
		love.graphics.print("Current FPS: "..fps, 9, 10)
	end
end
