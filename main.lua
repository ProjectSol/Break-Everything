lg = love.graphics
rasterizer = love.font.newRasterizer( "assets/Montserrat-Regular.ttf", 20 )
titleText = love.graphics.newFont(rasterizer)
titleText:setFilter( 'nearest', 'nearest', 1 )
rasterizer = love.font.newRasterizer( "assets/Montserrat-Regular.ttf", 8 )
readingText = love.graphics.newFont(rasterizer)
readingText:setFilter( 'nearest', 'nearest', 1 )
defaultFont = lg.newFont(20)

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
	systems = require "systems"
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

	Turquoise = {26/255,188/255,156/255} Blue = {41/255,128/255,185/255}
	Emerald = {241/255,196/255,15/255} Purple = {142/255,68/255,173/255}
	Asphalt = {56/255,75/255,97/255} Yellow = {241/255,196/255,15/255}
	Pumpkin = {211/255,84/255,0} Red = {232/255,77/255,63/255}
	Wheat = {139/255,126/255,102/255} Pink = {255/255,0,255/255}
	Green = {34/255,139/255,34/255} Brown = {139/255,90/255,0}
	Sepia = {94/255,38/255,18/255} UnknownShip = {189/255,195/255,199/255}
	Default = {1,1,1}


	usingMovement2 = true

	--basicWalls()
	allianceSys:newAlliance("Unaligned", UnknownShip)
	allianceSys:newAlliance("Pirates", Red)
	--allianceSys:newAlliance("SuperHappyFunLand", Purple)
	for i = 1,2 do
		shipBuilder:genKestrelPlayerShip()
		shipBuilder:genPixiePlayerShip()
	end
	for i = 1,3 do
		shipBuilder:genBasicEnemyShip()
	end


	--local player = shipBuilder:getSelectedPlayerShip()
	camera = Camera(player.x, player.y)
	camera.smoother = Camera.smooth.damped(10)
	camControl:setCameraLock(true)

	UI:basicUI()
	UI:movementElements()
end

function loadFiles( dir )
	local objects = love.filesystem.getDirectoryItems( dir )
	local tbl = {}
	for i = 1,#objects do
		info = love.filesystem.getInfo( dir.."/"..objects[ i ] )
		if info.fileType == 'directory' then
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
end

function love.keypressed( key, scancode, isrepeat )
	if key == 'escape' then
		love.event.push('quit')
	end
	if key == 'space' then
		systems:pause()
	end
	if key == 'tab' then
		--print("Now we should be changing ship")
		shipSelection:nextPlayerShip()
		for i = 1,#shipsList do
			print("DebugRun: "..tostring(shipsList[i].selected))
		end
	end

	local err = tonumber(key)
	if err ~= nil then
		if tonumber(key) >= 0 and tonumber(key) < 10 then
			shipSelection:cntrlGroupSelect(tonumber(key))
		end
	end

 end

function love.mousepressed(x, y, button)
	shipsMouseRunBool = true
	--print('This triggers before thing')
	gui.buttonCheck( x, y, button )
	--print('This triggers after thing')
	if shipsMouseRunBool == true then
		shipsThinkMouse(button)
	end
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
	--local currPlayer = shipBuilder:getSelectedPlayerShip()
	drawBasicShips()

	love.graphics.setLineWidth(1)

	drawWaypoints()
	local x,y = camera:worldCoords(love.mouse.getPosition())
	love.graphics.print(x.." X, "..y.." Y",x+30,y+60)

	camControl:cameraMovement()
	camera:detach()

	if x1 and y1 then
		love.graphics.line(x1, y1, love.mouse.getPosition())
	end

	if debug then
		love.graphics.setColor(255, 255, 255)
		love.graphics.setFont(font)
		fps = tostring(love.timer.getFPS())
		love.graphics.print("Current FPS: "..fps, 9, 10)
		bodies = world:getBodies( )
	end
end
