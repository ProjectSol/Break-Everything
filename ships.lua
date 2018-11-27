shipBuilder = {}

ships = {}
ships_mt = {__index = ships}

shipIdCounter = 1

behave = {}
behave.NeutralPreset1 = {aggression = 0, dfnd = 0,  player = false }

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


  self.hardpoints = {}
  self.systems = {}
  self.inventorySize = 15
  self.inventory = {}
  self.docking = false
  self.dockingSize = nil
  self.docked = {}


  self.behaviour = behave.EnemyPreset1
  self.validWaypoint = false
  self.player = false
  self.selected = false


  self.x = 30+50*(self.id-1)
  self.y = 300
  self.shipVec = vector.new(self.x,self.y)
  self.waypoint = nil
  self.wpVec = nil


  self.speed = 6
  self.turnSpeed = 2
  self.accel = 1
  self.decel = 0.75
  self.movement2Angle = 0
  self.currSpeed = 0
  self.speedPercent = 0
	self.reverseSpeed = self.speed/3


  self.waypointResetTimer = 0
  self.resetting = true
  self.targeting = nil

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

  if usingMovement2 then
    NPCShip.movement2Angle = getWpAngle(NPCShip)
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

  setShip.resetting = false
  setShip.waypoint = { x=x, y=y, movement2Angle = 0, vec = waypointVec }
  setShip.wpVec = waypointVec
  setShip.validWaypoint = true

  if usingMovement2 then
    setShip.movement2Angle = getWpAngle(setShip)
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

function ships:setTarget()

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
classes.largeClass = {-30, -30, 30, -30, 0, 30}
classes.hugeClass = {-55, -55, 55, -55, 0, 55}

function ships:setTargeting()

end

function ships:playerShipInit()
  player = self
  self.player = true
  self:selectIndividual()
  self.behaviour = behave.PlayerPreset1
  print(self.name.." was unselected as part of the init function, the selected status has now been returned to "..tostring(self.selected))
end

function ships:setTypeLeviathan()
  self.name = "Leviathan"
  self.speed = 5
  self.turnSpeed = 0.5
  self.accel = 0.5
  self.decel = 0.25
  self.class = classes.hugeClass
  self.x = self.x-(self.class[1]*self.id)
  self.behaviour = behave.NeutralPreset1
end


function ships:setTypeGoliath()
  self.name = "Goliath"
  self.speed = 6
  self.turnSpeed = 1.5
  self.class = classes.largeClass
  self.x = self.x-(self.class[1]*self.id)
  self.behaviour = behave.NeutralPreset1
end

function ships:setTypeKestrel()
  self.name = "Kestrel"
  self.speed = 10
  self.turnSpeed = 5
  self.class = classes.mediumClass
  self.x = self.x-(self.class[1]*self.id)
  self.behaviour = behave.NeutralPreset1
end

function ships:setTypePixie()
  self.name = "Pixie"
  self.speed = 15
  self.turnSpeed = 7
  self.accel = 3
  self.decel = 2.75
  self.class = classes.lightClass
  self.x = self.x-(self.class[1]*self.id)
  self.behaviour = behave.NeutralPreset1
end

function ships:setTypeRaider()
  self.name = "Raider"
  self.speed = 9.5
  self.turnSpeed = 4.5
  self.class = classes.mediumClass
  self.x = self.x-(self.class[1]*self.id)
  self.behaviour = behave.NeutralPreset1
end

function ships:pirateInit()
  self.behaviour = behave.EnemyPreset1
  self.player = false
  self.speedPercent = 1
  self.alliance = alliances:getAlliance("Pirates")
end

function shipBuilder:genLeviathanPlayerShip()
  local ship = ships.create()
  table.insert(shipsList, ship)
  ship = shipsList[#shipsList]

	ship:_init()
  ship:setTypeLeviathan()
  ship:playerShipInit()

  local x,y = ship:getShipPos()
  shipBuilder:defineBasicShipPhysics(ship,x,y)
  ship.body:setLinearDamping(30)
end

function shipBuilder:genGoliathPlayerShip()
  local ship = ships.create()
  table.insert(shipsList, ship)
  ship = shipsList[#shipsList]

	ship:_init()
  ship:setTypeGoliath()
  ship:playerShipInit()

  local x,y = ship:getShipPos()
  shipBuilder:defineBasicShipPhysics(ship,x,y)
end

function shipBuilder:genKestrelPlayerShip()
  local ship = ships.create()
  table.insert(shipsList, ship)
  ship = shipsList[#shipsList]

	ship:_init()
  ship:setTypeKestrel()
  ship:playerShipInit()

  local x,y = ship:getShipPos()
  shipBuilder:defineBasicShipPhysics(ship,x,y)
end

function shipBuilder:genPixiePlayerShip()
  local ship = ships.create()
  table.insert(shipsList, ship)
  ship = shipsList[#shipsList]

	ship:_init()
  ship:setTypePixie()
  ship:playerShipInit()

  local x,y = ship:getShipPos()
  shipBuilder:defineBasicShipPhysics(ship,x,y)
end

function shipBuilder:genPirateRaider()
  local ship = ships.create()
  table.insert(shipsList, ship)
  ship = shipsList[#shipsList]

	ship:_init()
  ship:setTypeRaider()
  ship:pirateInit()

  local x,y = ship:getShipPos()
  shipBuilder:defineBasicShipPhysics(ship,x,y)
end

function shipBuilder:genPirateLeviathan()
  local ship = ships.create()
  table.insert(shipsList, ship)
  ship = shipsList[#shipsList]

	ship:_init()
  ship:setTypeLeviathan()
  ship:pirateInit()

  local x,y = ship:getShipPos()
  shipBuilder:defineBasicShipPhysics(ship,x,y)
end

function shipBuilder:genPirateGoliath()
  local ship = ships.create()
  table.insert(shipsList, ship)
  ship = shipsList[#shipsList]

	ship:_init()
  ship:setTypeGoliath()
  ship:pirateInit()

  local x,y = ship:getShipPos()
  shipBuilder:defineBasicShipPhysics(ship,x,y)
end

function shipBuilder:genPirateGoliath()
  local ship = ships.create()
  table.insert(shipsList, ship)
  ship = shipsList[#shipsList]

	ship:_init()
  ship:setTypeGoliath()
  ship:pirateInit()

  local x,y = ship:getShipPos()
  shipBuilder:defineBasicShipPhysics(ship,x,y)
end

function shipBuilder:genPiratePixie()
  local ship = ships.create()
  table.insert(shipsList, ship)
  ship = shipsList[#shipsList]

	ship:_init()
  ship:setTypePixie()
  ship:pirateInit()

  local x,y = ship:getShipPos()
  shipBuilder:defineBasicShipPhysics(ship,x,y)
end

function shipBuilder:defineBasicShipPhysics(ship,x,y)
  ship.body = love.physics.newBody( world, x, y, "dynamic")
	ship.shape = love.physics.newPolygonShape(unpack(ship.class))
  ship.fixture = love.physics.newFixture(ship.body, ship.shape)

	ship.body:setAngle(math.pi)
  ship.fixture:setRestitution(1)
  ship.fixture:setMask(1,2)
  ship.body:setAngularDamping(2)
  ship.body:setLinearDamping(2)
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
  if usingMovement2 then
    for i = 1,#shipsList do
		  local ship = shipsList[i]
  		local waypoint = shipsList[i].waypoint
      local x = ship.body:getX()
      local y = ship.body:getY()
      local angle = shipsList[i].movement2Angle
      local vectorLen = 40
      local vecX,vecY = -vectorLen*math.cos(angle), -vectorLen*math.sin(angle)



      if ship.validWaypoint then
        love.graphics.setColor(1,1,1)
  			love.graphics.circle("fill", vecX+x, vecY+y, 2)
    		love.graphics.setColor(1,1,1)
    		love.graphics.line( vecX+x, vecY+y, x, y )
      end
	 end
  else
    for i = 1,#shipsList do
		  local ship = shipsList[i]
  		local waypoint = shipsList[i].waypoint
      local x = ship.body:getX()
      local y = ship.body:getY()
      local wX,wY

      if ship.validWaypoint then
        love.graphics.setColor(1,1,1)
  			love.graphics.circle("fill", waypoint.x, waypoint.y, 2)
    		love.graphics.setColor(1,1,1)
    		love.graphics.line( waypoint.x, waypoint.y, x, y )
      end
	 end
  end
end

function shipsThink()
  for i = 1,#shipsList do
    local ship = shipsList[i]

    ship.x = ship.body:getX()
    ship.y = ship.body:getY()
    ship.shipVec = vector.new(ship.x, ship.y)

    if usingMovement2 then
      movement:rotate2(ship)
      movement:movement2(ship)
    else
      movement:rotate(ship)
      movement:movement(ship)
    end

    ship:behave()

    if ship.waypointResetTimer > 100 and ship.speedPercent == 0 and ship.resetting == true then
      ship.waypoint = nil
      ship.validWaypoint = nil
      ship.waypointResetTimer = 0
    elseif ship.resetting == true and ship.speedPercent == 0 then
      ship.waypointResetTimer = ship.waypointResetTimer+1
    else
      ship.waypointResetTimer = 0
    end
  end
end

function shipsThinkMouse(button)
  if button == 2 then
    placeWaypoint()
  elseif button == 1 then
    --bandBoxSelection()
    shipSelection:clickSetTarget()
  end
  for i = 1,#shipsList do
    local ship = shipsList[i]

  end
end

function ships:installHardpoint(weaponry)
  table.insert(self.hardpoints, weaponry)
  print(weaponry.name.." added to "..self.name)
end


return shipBuilder
