shipBuilder = {}

ships = {}
ships_mt = {__index = ships}

shipIdCounter = 1

behave = {}
behave.Neutral = nil

behave.EnemyPreset1 = nil
behave.EnemyPreset2 = nil

behave.playerPreset1 = nil
behave.playerPreset2 = nil
behave.playerConfig1 = nil --customisable templates for automated action when the player ignores this ship.
behave.playerConfig2 = nil
behave.playerConfig3 = nil

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
  self.speed = 5
  self.turnSpeed = 5
  self.x = 30+50*(self.id-1)
  self.behaviour = Neutral
  print(self.x)
  self.y = 300
end

function ships:playerShipInit()
  self.speed = 15.5
  self.turnSpeed = 3
  self.selected = false
end

function ships:getShipPos()
  return self.x, self.y
end

function ships:placeWaypoint()
  local x, y = love.mouse.getPosition()
  waypointVec = vector(x,y)
  self.waypoint = { x=x, y=y }
  waypoints = {waypoint}
  --table.insert(waypoints, newWaypoint)
  self.validWaypoint = true
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


return shipBuilder
