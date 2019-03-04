lg = love.graphics
rasterizer = love.font.newRasterizer( "assets/Montserrat-Regular.ttf", 20 )
titleText = lg.newFont(rasterizer)
titleText:setFilter( 'nearest', 'nearest', 1 )
rasterizer = love.font.newRasterizer( "assets/Montserrat-Regular.ttf", 8 )
readingText = lg.newFont(rasterizer)
readingText:setFilter( 'nearest', 'nearest', 1 )
defaultFont = lg.newFont(20)

font = lg.newFont()
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
	harpoints = require "hardpoints"
	nav = require "navigation"
	stars = require "starfieldGeneration"
	UI = require "UI"

	--love.window.setFullscreen( true, "desktop" )
	local width, height = love.window.getDesktopDimensions()
	love.window.width = width
	love.window.height = height

	shipsList = {}
	love.physics.setMeter(64)
	world = love.physics.newWorld(0, 0, true)
	love.mouse.setGrabbed(true)

	Turquoise = {26/255,188/255,156/255} Blue = {41/255,128/255,185/255}
	Emerald = {241/255,196/255,15/255} Purple = {142/255,68/255,173/255}
	Asphalt = {56/255,75/255,97/255} Yellow = {241/255,196/255,15/255}
	Pumpkin = {211/255,84/255,0} Red = {232/255,77/255,63/255}
	Wheat = {139/255,126/255,102/255} Pink = {1,0,1}
	Green = {34/255,139/255,34/255} Brown = {139/255,90/255,0}
	Sepia = {94/255,38/255,18/255} UnknownShip = {189/255,195/255,199/255}
	Default = {1,1,1}

	starCols = {	{1, 229/255, 229/255}, {222/255, 246/255, 1},
								{222/255, 1, 228/255}, {249/255, 241/255, 222/255},
								{249/255, 248/255, 222/255}, {228/255, 219/255, 1},
								{1,1,1}, {188/255, 1, 231/255} }

	starRed = {1, 229/255, 229/255} starBlue = {222/255, 246/255, 1}
	starGreen = {222/255, 1, 228/255} starOrange = {249/255, 241/255, 222/255}
	starYellow = {249/255, 248/255, 222/255} starPurple = {228/255, 219/255, 1}
	starWhite = {1,1,1} starTeal = {188/255, 1, 231/255}



	usingMovement2 = false
	waypointResetTimer = 0

	stars:generateGrid()

	--basicWalls()
	allianceSys:newAlliance("Unaligned", UnknownShip)
	allianceSys:newAlliance("Pirates", Red)
	--allianceSys:newAlliance("SuperHappyFunLand", Purple)
	for i = 1,1 do
		shipBuilder:genLeviathanPlayerShip()
		shipBuilder:genGoliathPlayerShip()
		shipBuilder:genKestrelPlayerShip()
		shipBuilder:genPixiePlayerShip()
	end
	for i = 1,2 do
		shipBuilder:genPirateRaider()
		--shipBuilder:genPirateGoliath()
	end
	hardpoints.giveBasicWeapons()


	local player = shipBuilder:getSelectedPlayerShip()
	camera = Camera(player.x, player.y);

	love.window.setMode( 0, 0 )

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
		for i = 1,2 do
			if love.mouse.isDown(i) and shipsMouseRunBool then
				shipsThinkMouse(i)
			end
		end
	end
end

function love.keypressed( key, scancode, isrepeat )
	if key == 'escape' then
		love.event.push('quit')
	end
	if key == 'space' then
		systems:pause()
	end
	if key == 'p' then
		if usingMovement2 then
			usingMovement2 = false
		else
			usingMovement2 = true
		end
	end
	if key == 'y' and shipBuilder:getSelectedPlayerShip() then
		camControl:flickerLockSetting()
	end
	if key == 'tab' then
		--print("Now we should be changing ship")
		shipSelection:tabSwap()
	end

	local err = tonumber(key)
	if err ~= nil then
		if tonumber(key) >= 0 and tonumber(key) < 10 then
			shipSelection:cntrlGroupSelect(tonumber(key))
		end
	end

 end

clickedOnce = false

function love.mousepressed(x, y, button)
	shipsMouseRunBool = true
	clickedOnce = true
	gui.buttonCheck( x, y, button )
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

function errorPrint()
	for i =1,#debugErrors do
		lg.setFont(debugFont)
		lg.print(debugErrors[i], 100, 100)
	end
end

function closestToZero(a, b, c, d)
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
	camera:attach()
	stars:drawGrid()

	drawBasicShips()
	drawWaypoints()

	lg.setLineWidth(1)

	lg.setColor(1,1,1)
	local x,y = camera:worldCoords(love.mouse.getPosition())
	camControl:cameraMovement()
	camera:detach()

	gui.draw()
	--[[if x1 and y1 then
		lg.setColor(1,1,1)
		lg.line(x1, y1, love.mouse.getPosition())
	end]]

	errorPrint()

	if debug then
		lg.setColor(1,1,1)
		lg.setFont(font)
		fps = tostring(love.timer.getFPS())

		local mx, my = love.mouse.getPosition()
		local wmx, wmy = camera:worldCoords(mx, my)
		lg.print("Current FPS: "..fps.."\nScreen Position:"..mx.." "..my.."\nWorld Position: "..wmx.." "..wmy, 9, 10)

		bodies = world:getBodies( )

		local a, b = stars:mouseGridPosition()
		local c, d = love.mouse.getPosition()
		local e = stars:mouseGridLocation()
		lg.setFont(font)
		lg.print(a.." "..b.."\n"..e, c-35,d-35)
		--lg.points(camera:cameraCoords(a,b))
	end
end
