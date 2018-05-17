lg = love.graphics
rasterizer = love.font.newRasterizer( "assets/Meteora - DEMO.ttf", 20 )
titleText = love.graphics.newFont(rasterizer)
titleText:setFilter( 'nearest', 'nearest', 1 )
rasterizer = love.font.newRasterizer( "assets/Meteora - DEMO.ttf", 8 )
readingText = love.graphics.newFont(rasterizer)
readingText:setFilter( 'nearest', 'nearest', 1 )

font = love.graphics.newFont()
bypass = false

function math.angle(x1,y1, x2,y2)
	return math.atan2(y2-y1, x2-x1)
end

function checkCollision(x1,y1,w1,h1, x2,y2,w2,h2)
	return x1 + w1 > x2 and
		y1 + h1 > y2 and
		x1 < x2 + w2 and
		y1 < y2 + h2
end

function love.load()
	util = {}
	function util.isInArea( x, y, x2, y2, w, h )
    if x >= x2 and x <= x2 + w and y >= y2 and y <= y2+h then
      return true
    end
    return false
	end
	require "UI/_table"
	require "UI/gui"
	loadFiles('UI/gui')
	vector = require "hump/vector"
	Camera = require "hump/camera"
	waypoint = require "waypoint"
	movement = require "movement"
	shipBuilder = require "ships"
	alliances = require "alliances"
	camControl = require "camControl"
	shipSelection = require "shipSelection"
	UI = require "UI"


	shipsList = {}
	love.physics.setMeter(64)
	world = love.physics.newWorld(0, 0, true)
	love.mouse.setGrabbed(true)

	Turquoise = {26,188,156} Blue = {41,128,185}
	Emerald = {241,196,15} Purple = {142,68,173}
	Asphalt = {56,75,97} Yellow = {241,196,15}
	Pumpkin = {211,84,0} Red = {232,77,63}
	Wheat = {139,126,102} Pink = {255,0,255}
	Green = {34,139,34} Brown = {139,90,0}
	Sepia = {94,38,18} UnknownShip = {189,195,199}
	Default = {250,250,250}

	--basicWalls()
	allianceSys:newAlliance("Unaligned", UnknownShip)
	allianceSys:newAlliance("Pirates", Red)
	allianceSys:newAlliance("SuperHappyFunLand", Purple)

	shipBuilder:genBasicPlayerShip()
	shipBuilder:genBasicPlayerShip()
	shipBuilder:genBasicEnemyShip()
	shipBuilder:genBasicEnemyShip()
	shipBuilder:genBasicEnemyShip()

	local player = shipBuilder:getSelectedPlayerShip()
	camera = Camera(player.x, player.y)
	camera.smoother = Camera.smooth.damped(10)
	camControl:setCameraLock(true)

	shipSelection:drawSidebar()
end

function loadFiles( dir )
	local objects = love.filesystem.getDirectoryItems( dir )
	local tbl = {}
	for i = 1,#objects do
		if love.filesystem.isDirectory( dir.."/"..objects[ i ] ) then
			tbl[ #tbl + 1 ] = dir.."/"..objects[ i ]
		else
			local name = dir.."/"..string.sub( objects[ i ], 0, string.len( objects[ i ] ) - 4 )
			require( name )
		end
	end

	for i = 1,#tbl do
		loadFiles( tbl[ i ] )
	end
end

function love.update(dt)
	if not paused then
		world:update(dt)
		gui.update()

		shipsThink()
	end
	if love.keyboard.isDown('escape') then
		love.event.push('quit')
	end
end

function love.mousepressed(x, y, button)
	gui.buttonCheck( x, y, button )
	shipsThinkMouse(button)
end

function love.mousereleased(x, y, button, isTouch)
	if not bypass then
		gui.buttonReleased( x, y, button, istouch )
	end
end

function love.wheelmoved(dx, dy)
	if not bypass then
		gui.wheelMoved( dx, dy )
	end
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
	gui.draw()
	camera:attach()
	local currPlayer = shipBuilder:getSelectedPlayerShip()
	drawBasicShips()

	love.graphics.setLineWidth(1)

	drawWaypoints()

	camControl:cameraMovement()
	camera:detach()

	UI:drawUI()

	if x1 and y1 then
		love.graphics.line(x1, y1, love.mouse.getPosition())
	end

	if debug then
		love.graphics.setColor(255, 255, 255)
		love.graphics.setFont(font)
		fps = tostring(love.timer.getFPS())
		love.graphics.print("Current FPS: "..fps, 9, 10)
		bodies = world:getBodyList( )
		--[[for i = 1,#bodies do
			print(bodies[i])
		end]]
	end
end
