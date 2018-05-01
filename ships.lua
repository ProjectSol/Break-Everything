shipBuilder = {}

ships = {}
ships_mt = {__index = ships}

shipIdCounter = 1

behave = {}
behave.Neutral = {aggression = 0, dfnd = 10,  player = false }

behave.EnemyPreset1 = {aggression = 8, dfnd = 2,  player = false }
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
  self.name = "testShip"
  self.class = lightClass
  self.alliance = unaligned
  self.colour = alliance.colour
  self.speed = 5
  self.turnSpeed = 5
  self.accel = true
  self.x = 30+50*(self.id-1)
  self.behaviour = behave.EnemyPreset1
  self.validWaypoint = false
  self.player = false
  self.selected = false
  self.y = 300
  self.vec = vector.new(self.x, self.y)
  self.wpVec = {}
end

function ships:playerShipInit()
  self.name = "The Kestrel"
  self.speed = 15.5
  self.behaviour = behave.PlayerPreset1
  self.turnSpeed = 3
  self.player = true
  self.selected = true
end

function ships:getShipPos()
  return self.x, self.y, self.vec
end

function placeNPCWP(NPCShip)
  for i = 1,#shipsList do
    local ship = shipsList[i]

    if ship.player then
      local x,y = player:getShipPos()
      local waypointVec = vector(x,y)
      local waypoint = { x=x, y=y, vec = waypointVec, ship = ship }
      --[[if NPCShip.waypoint then
        local dist = NPCShip:dist(waypointVec)
        local dist2 = NPCShip:dist(NPCShip.wpVec)
        if dist < dist2 then

        end
      else

      end]]
      waypointVec = vector(x,y)
      NPCShip.waypoint = waypoint
      NPCShip.validWaypoint = true
      --print(NPCShip.name, NPCShip.validWaypoint)
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

  local x, y = love.mouse.getPosition()
  local waypointVec = vector(x,y)
  setShip.waypoint = { x=x, y=y, vec = waypointVec }
  setShip.validWaypoint = true
end

function getWpAngle(ship)
  if ship.validWaypoint then
    local waypoint = ship.waypoint
    local pX = ship.body:getX()
    local pY = ship.body:getY()
    local wX, wY = waypoint.vec:unpack()

    ship._angle = math.angle(wX, wY, pX, pY)
    return ship._angle
  else
    print("Ship lacks a waypoint")
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
classes.lightClass = {-20, -20, 20, -20, 0, 20}

function shipBuilder:genBasicPlayerShip()
  local playerShip = ships.create()

  table.insert(shipsList, playerShip)
  print(#shipsList)
  for i = 1,#shipsList do
    ship = shipsList[i]
  end

	ship:_init()
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

	playerBody:setAngle(0)
  playerBody:setAngularDamping(0.1)
end

function shipBuilder:genBasicEnemyShip()
  local basicShip = ships.create()

  table.insert(shipsList, basicShip)
  print(#shipsList)
  for i = 1,#shipsList do
    ship = shipsList[i]
  end

	ship:_init()

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
    basicEnemyFixture = shipsList.ship

	basicEnemyBody:setAngle(0)
  basicEnemyBody:setAngularDamping(0.1)
end

function basicObject()
  objects.ball = {}
	objects.ball.body = love.physics.newBody(world, 650/2, 200, "dynamic") --place the body in the center of the world and make it dynamic, so it can move around
	objects.ball.shape = love.physics.newCircleShape(20) --the ball's shape has a radius of 20
	objects.ball.fixture = love.physics.newFixture(objects.ball.body, objects.ball.shape, 1) -- Attach fixture to body and give it a density of 1.
	--[[objects.ball.fixture:setRestitution(0.8) --let the ball bounce
	objects.ball.body:setLinearDamping(0.05)]]
end

function basicWalls()
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
end

function drawBasicShips()
  for i = 1,#shipsList do
    local ship = shipsList[i]
    love.graphics.setLineWidth(2)
    love.graphics.setColor(200,200,200)
    love.graphics.polygon("line", ship.body:getWorldPoints(ship.shape:getPoints()))

    --[[love.graphics.setColor(200, 200, 200)
    love.graphics.polygon("line", shipsList.basicEnemy.body:getWorldPoints(shipsList.basicEnemy.shape:getPoints()))]]
  end
end

function drawWaypoints()
  for i = 1,#shipsList do
		local ship = shipsList[i]
		local waypoint = shipsList[i].waypoint
    local x = ship.body:getX()
    local y = ship.body:getY()

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
  --  playerVec = movement:calcPlayerVector()
    movement:rotate(ship)
    movement:movement(ship)
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
