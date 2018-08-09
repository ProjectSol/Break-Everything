shipBuilder = {}

ships = {}
ships_mt = {__index = ships}

shipIdCounter = 1

behave = {}
behave.NeutralPreset1 = {aggression = 10, dfnd = 10,  player = false }

behave.EnemyPreset1 = {aggression = 10, dfnd = 2,  player = false }
behave.EnemyPreset2 = {aggression = 0, dfnd = 10,  player = false }

behave.PlayerPreset1 = {aggression = 0, dfnd = 10,  player = true }
behave.PlayerPreset2 = {aggression = 0, dfnd = 10,  player = true }
 --customisable templates for automated action when the player ignores this ship.
behave.PlayerConfig1 = {aggression = 0, dfnd = 10,  player = true }
behave.PlayerConfig2 = {aggression = 0, dfnd = 10,  player = true }
behave.PlayerConfig3 = {aggression = 0, dfnd = 10,  player = true }

setmetatable(ships, {
  __call = function (cls, ...)
    local self = setmetatable({}, cls)
    self:_init(...)
    return self
  end,
})

function ships.create()
  local new_inst = {}    -- the new instance
  setmetatable( new_inst, ships_mt ) -- all instances share the same metatable
  return new_inst
end

function ships:_init()
  self.id = shipIdCounter
  shipIdCounter = shipIdCounter+1
  self.name = "unnamedShip"
  self.class = classes.mediumClass
  self.alliance = alliances:getAlliance("Unaligned")
  self.speed = 5
  self.turnSpeed = 2
  self.accel = 2.5
  self.x = 30+50*(self.id-1)
  self.behaviour = behave.EnemyPreset1
  self.validWaypoint = false
  self.player = false
  self.selected = false
  self.y = 300
  self.shipVec = vector.new(self.x,self.y)
  self.waypoint = nil
  self.wpVec = nil
  self.movement2Angle = 0
  self.maxSpeed = self.speed
  self.currSpeed = 0
  self.speedPercent = 1
	self.reverseSpeed = self.speed/3
end

function ships:playerShipInit()
  self.player = true
  self:selectIndividual()
  print(self.name.." was unselected as part of the init function, the selected status has now been returned to "..tostring(self.selected))
end

function ships:setTypeKestrel()
  self.name = "Kestrel"
  self.speed = 10
  self.class = classes.mediumClass
  self.behaviour = behave.PlayerPreset1
  self.turnSpeed = 6
end

function ships:setTypePixie()
  self.name = "Pixie"
  self.speed = 15
  self.class = classes.lightClass
  self.behaviour = behave.PlayerPreset1
  self.turnSpeed = 10
end

function ships:pirateInit()
  self.name = "Pirate Raider"
  self.behaviour = behave.NeutralPreset1
  self.alliance = alliances:getAlliance("Pirates")
end

function ships:getShipPos()
  return self.x, self.y, self.vec
end

function placeNPCWP(NPCShip)
  local targets = {}
  for i = 1,#shipsList do
    local ship = shipsList[i]
    if ship.alliance ~= NPCShip.alliance then
      local x,y = ship.body:getPosition()
      local waypointVec = vector(x,y)
      local waypoint = { x=x, y=y, vec = waypointVec, ship = ship }
      table.insert(targets, waypoint)
    end
  end

  NPCShip.waypoint = targets[1]
  NPCShip.wpVec = targets[1].vec
  NPCShip.validWaypoint = true

  for i = 1,#targets do
    target = targets[i]
    local dist = (NPCShip.shipVec-target.vec):len()
    local dist2 = (NPCShip.shipVec-NPCShip.wpVec):len()
    if dist <= dist2 then
      NPCShip.waypoint = target
      NPCShip.wpVec = target.vec
      NPCShip.validWaypoint = true
    end
  end
end


function placeWaypoint()
  local setShip = {}

  for i = 1,#shipsList do
    local ship = shipsList[i]
    if ship.selected == true then
      setShip = ship
    end
  end

  local x,y = love.mouse.getPosition()
  x,y = camera:worldCoords(x,y)
  local waypointVec = vector(x,y)

  setShip.waypoint = { x=x, y=y, movement2Angle = 0, vec = waypointVec }
  setShip.wpVec = waypointVec
  setShip.validWaypoint = true

  if usingMovement2 then
    setShip.movement2Angle = getWpAngle(setShip)
    waypointVec = vector(setShip.movement2Angle,1)
    --[[waypointVec = vector(1,0)
    waypointVec.rotateInPlace(movement2Angle)]]
    setShip.waypoint.waypointVec = waypointVec
  end
end

function getWpAngle(ship)
  if ship.validWaypoint then
    local waypoint = ship.waypoint
    local pX = ship.body:getX()
    local pY = ship.body:getY()
    local wX,wY
    wX, wY = waypoint.vec:unpack()

    ship._angle = math.angle(wX, wY, pX, pY)
    return ship._angle
  else
    print("Ship lacks a waypoint")
  end
end

function ships:selectIndividual()
  shipBuilder:unselectSelectedShips()
  self.selected = true
end

function shipBuilder:getSelectedPlayerShip()
  for i = 1,#shipsList do
    --print("test")
    local ship = shipsList[i]
    if ship.player == true and ship.selected == true then
    --  print(ship.name)
      print('getSelectedPlayerShip ran and returned '..ship.name)
      return ship, i
    else
      print(ship.name.." is either not a player or not selected.     getSelectedPlayerShip")
    end
  end
  return -1
end

function shipBuilder:unselectSelectedShips()
  print("\n\nRunning unselectSelectedShips: "..#shipsList.." times")
  for i = 1,#shipsList do
    --print("test")
    local ship = shipsList[i]
    if ship.player == true and ship.selected == true then
    --  print(ship.name)
      ship.selected = false
      print(ship.name.." selected: "..tostring(ship.selected).."     unselectSelectedShips")
    else
      print(ship.name.." selected: "..tostring(ship.selected).."     unselectSelectedShips")
    end
  end
end

counter = 0
function ships:behave()
  if self.behaviour.aggression == 10 then
    placeNPCWP(self)
  else

  end
end

classes = {}
classes.lightClass = {-15, -15, 15, -15, 0, 15}
classes.mediumClass = {-20, -20, 20, -20, 0, 20}

function shipBuilder:genKestrelPlayerShip()
  local playerShip = ships.create()

  table.insert(shipsList, playerShip)
  --print(#shipsList)
  for i = 1,#shipsList do
    ship = shipsList[i]
  end

	ship:_init()

  ship:setTypeKestrel()
  ship:playerShipInit()

  player = ship

  local x,y = player:getShipPos()
  playerX = x
  playerY = y

	--shipsList.playerShip = { --[[speed = playerShip.speed, turnSpeed = playerShip.turnSpeed]] }
	ship.body = love.physics.newBody( world, playerX, playerY, "dynamic")
    playerBody = ship.body

	ship.shape = love.physics.newPolygonShape(unpack(ship.class))--love.physics.newRectangleShape( 30, 40 )
    playerShape = ship.shape

  ship.fixture = love.physics.newFixture(playerBody, playerShape)
    playerFixture = ship.fixture

	playerBody:setAngle(math.pi)
  playerFixture:setRestitution(2)
  playerFixture:setMask(1,2)
  playerBody:setAngularDamping(2)
  playerBody:setLinearDamping(2)
end

function shipBuilder:genPixiePlayerShip()
  local playerShip = ships.create()

  table.insert(shipsList, playerShip)
  --print(#shipsList)
  for i = 1,#shipsList do
    ship = shipsList[i]
  end

	ship:_init()

  ship:setTypePixie()
  ship:playerShipInit()

  player = ship

  local x,y = player:getShipPos()
  playerX = x
  playerY = y

	--shipsList.playerShip = { --[[speed = playerShip.speed, turnSpeed = playerShip.turnSpeed]] }
	ship.body = love.physics.newBody( world, playerX, playerY, "dynamic")
    playerBody = ship.body

	ship.shape = love.physics.newPolygonShape(unpack(classes.lightClass))--love.physics.newRectangleShape( 30, 40 )
    playerShape = ship.shape

  ship.fixture = love.physics.newFixture(playerBody, playerShape)
    playerFixture = ship.fixture

	playerBody:setAngle(math.pi)
  playerFixture:setRestitution(2)
  playerFixture:setMask(1,2)
  playerBody:setAngularDamping(2)
  playerBody:setLinearDamping(2)
end

function shipBuilder:genBasicEnemyShip()
  local basicShip = ships.create()

  table.insert(shipsList, basicShip)
  for i = 1,#shipsList do
    ship = shipsList[i]
  end

	ship:_init()
  ship:pirateInit()

	--table.insert(basicEnemy, shipsList)
  basicEnemy = ship

  local x,y = ship:getShipPos()
  basicEnemyX = x
  basicEnemyY = y

	--shipsList.basicEnemy = { --[[speed = basicEnemy.speed, turnSpeed = basicEnemy.turnSpeed]] }
	ship.body = love.physics.newBody( world, basicEnemyX, basicEnemyY, "dynamic")
    basicEnemyBody = ship.body

	ship.shape = love.physics.newPolygonShape(unpack(classes.lightClass))--love.physics.newRectangleShape( 30, 40 )
    basicEnemyShape = ship.shape

  ship.fixture = love.physics.newFixture(basicEnemyBody, basicEnemyShape)
    basicEnemyFixture = ship.fixture

	basicEnemyBody:setAngle(0)
  basicEnemyFixture:setRestitution(2)
  basicEnemyFixture:setMask(1,2)
  basicEnemyBody:setAngularDamping(0.1)
  basicEnemyBody:setLinearDamping(1)
end



function basicObject()
  objects.ball = {}
	objects.ball.body = love.physics.newBody(world, 650/2, 200, "dynamic") --place the body in the center of the world and make it dynamic, so it can move around
	objects.ball.shape = love.physics.newCircleShape(20) --the ball's shape has a radius of 20
	objects.ball.fixture = love.physics.newFixture(objects.ball.body, objects.ball.shape, 1) -- Attach fixture to body and give it a density of 1.
end

function drawBasicShips()
  for i = 1,#shipsList do
    local ship = shipsList[i]
    love.graphics.setLineWidth(2)
    love.graphics.setColor( unpack(ship.alliance.colour) )
    love.graphics.polygon("line", ship.body:getWorldPoints(ship.shape:getPoints()))
  end
end

function drawWaypoints()
  for i = 1,#shipsList do
		local ship = shipsList[i]
		local waypoint = shipsList[i].waypoint
    local x = ship.body:getX()
    local y = ship.body:getY()
    local wX,wY

		--[[if ship.validWaypoint and usingMovement2 and ship.player then
      local offsetX,offsetY = waypoint.globalVec:unpack()
      wX, wY = ship.x+offsetX, ship.y+offsetY
      --print(ship.name,wX,wY,offsetX,offsetY)
			love.graphics.setColor(255, 255, 255)
			love.graphics.circle("fill", wX, wY, 2)
      love.graphics.setColor(1,1,0)
      love.graphics.print(offsetX.." X, "..offsetY.." Y",wX+30,wY+30)
      love.graphics.print(wX.." X, "..wY.." Y",wX+30,wY)
      love.graphics.print(x.." X, "..y.." Y",x+30,y)
  		love.graphics.setColor(255,255,255)
  		love.graphics.line( wX, wY, x, y )
    elseif ship.validWaypoint then]]
    if ship.validWaypoint then
      love.graphics.setColor(255, 255, 255)
			love.graphics.circle("fill", waypoint.x, waypoint.y, 2)
  		love.graphics.setColor(255,255,255)
  		love.graphics.line( waypoint.x, waypoint.y, x, y )
    end

	end
end



function shipsThink()
  for i = 1,#shipsList do
    local ship = shipsList[i]

    ship.x = ship.body:getX()
    ship.y = ship.body:getY()
    ship.shipVec = vector.new(ship.x, ship.y)


    if usingMovement2 and ship.player then
      movement:rotate2(ship)
      movement:movement2(ship)
    else
      movement:rotate(ship)
      movement:movement(ship)
    end
    ship:behave()

  end
end

function shipsThinkMouse()
  placeWaypoint()
  for i = 1,#shipsList do
    local ship = shipsList[i]



  end
end


return shipBuilder
