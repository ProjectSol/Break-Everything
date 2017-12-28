shipBuilder = {}

ships = {}
ships_mt = {__index = ships}

counter = 1

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
  self.id = counter
  counter = counter+1
  self.name = "testShip"
  self.class = lightClass
  self.speed = 1
  self.turnSpeed = 1
  self.x = 300+40*(self.id-1)
  print(self.x)
  self.y = 300
end

function ships:getShipPos()
  return self.x, self.y
end

classes = {}
classes.lightClass = {-20, -20, 20, -20, 0, 20}

--[[local BaseClass = {}
BaseClass.__index = BaseClass

setmetatable(BaseClass, {
  __call = function (cls, ...)
    local self = setmetatable({}, cls)
    self:_init(...)
    return self
  end,
})

function BaseClass:_init(init)
  self.value = init
end

function BaseClass:set_value(newval)
  self.value = newval
end

function BaseClass:get_value()
  return self.value
end

---

local DerivedClass = {}
DerivedClass.__index = DerivedClass

setmetatable(DerivedClass, {
  __index = BaseClass, -- this is what makes the inheritance work
  __call = function (cls, ...)
    local self = setmetatable({}, cls)
    self:_init(...)
    return self
  end,
})

function DerivedClass:_init(init1, init2)
  BaseClass._init(self, init1) -- call the base class constructor
  self.value2 = init2
end

function DerivedClass:get_value()
  return self.value + self.value2
end

local i = DerivedClass(1, 2)
print(i:get_value()) --> 3
i:set_value(3)
print(i:get_value()) --> 5]]

function shipBuilder:genBasicPlayerShip()
  shipsList.playerShip = ships.create()
	shipsList.playerShip:_init()

	--table.insert(playerShip, shipsList)
  player = shipsList.playerShip

  local x,y = player:getShipPos()
  playerX = x
  playerY = y

	--shipsList.playerShip = { --[[speed = playerShip.speed, turnSpeed = playerShip.turnSpeed]] }
	shipsList.playerShip.body = love.physics.newBody( world, playerX, playerY, "dynamic")
    playerBody = shipsList.playerShip.body

	shipsList.playerShip.shape = love.physics.newPolygonShape(unpack(classes.lightClass))--love.physics.newRectangleShape( 30, 40 )
    playerShape = shipsList.playerShip.shape

  shipsList.playerShip.fixture = love.physics.newFixture(playerBody, playerShape)
    playerFixture = shipsList.playerShip.fixture

	playerBody:setAngle(0)
end

function shipBuilder:genBasicEnemyShip()
  shipsList.basicEnemy = ships.create()
	shipsList.basicEnemy:_init()

	--table.insert(basicEnemy, shipsList)
  basicEnemy = shipsList.basicEnemy

  local x,y = basicEnemy:getShipPos()
  basicEnemyX = x
  basicEnemyY = y

	--shipsList.basicEnemy = { --[[speed = basicEnemy.speed, turnSpeed = basicEnemy.turnSpeed]] }
	shipsList.basicEnemy.body = love.physics.newBody( world, basicEnemyX, basicEnemyY, "dynamic")
    basicEnemyBody = shipsList.basicEnemy.body

	shipsList.basicEnemy.shape = love.physics.newPolygonShape(unpack(classes.lightClass))--love.physics.newRectangleShape( 30, 40 )
    basicEnemyShape = shipsList.basicEnemy.shape

  shipsList.basicEnemy.fixture = love.physics.newFixture(basicEnemyBody, basicEnemyShape)
    basicEnemyFixture = shipsList.basicEnemy.fixture

	basicEnemyBody:setAngle(0)
end

function basicObjects()
  objects.ball = {}
	objects.ball.body = love.physics.newBody(world, 650/2, 200, "dynamic") --place the body in the center of the world and make it dynamic, so it can move around
	objects.ball.shape = love.physics.newCircleShape(20) --the ball's shape has a radius of 20
	objects.ball.fixture = love.physics.newFixture(objects.ball.body, objects.ball.shape, 1) -- Attach fixture to body and give it a density of 1.
	--[[objects.ball.fixture:setRestitution(0.8) --let the ball bounce
	objects.ball.body:setLinearDamping(0.05)]]

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


return shipBuilder
