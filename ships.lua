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
  self.class = shipClasses.mediumClass
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
  self.y = 100
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


  self.targetList = {}
  self.nearest = {}
  self.nearestInRange = {}

end

function ships:getShipPos()
  return self.x, self.y, self.vec
end

function ships:setName(name)
  self.name = name
end

function placeNPCWP(NPCShip)
  --The worst possible ai I could write, lets get this bread team
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

shipClasses = {}
shipClasses.lightClass = {-15, -15, 15, -15, 0, 15}
shipClasses.mediumClass = {-20, -20, 20, -20, 0, 20}
shipClasses.largeClass = {-30, -30, 30, -30, 0, 30}
shipClasses.hugeClass = {-55, -55, 55, -55, 0, 55}

function ships:setTargeting()
  --So many functions we have to make my god.
end

function ships:shipInit(alliance)
  self.behaviour = behave.NeutralPreset1
  self.player = false
  self.speedPercent = 1
  self.alliance = alliances:getAlliance(alliance)
  if self.alliance.class == "piracy" then
    self.behaviour = behave.EnemyPreset1
  end
end

function ships:playerShipInit(alliance)
  player = self
  self.player = true
  self:selectIndividual()
  self.behaviour = behave.PlayerPreset1
  if alliance then
    self.alliance = alliances:getAlliance(alliance)
  end
  print(self.name.." was unselected as part of the init function, the selected status has now been returned to "..tostring(self.selected))
end

function ships:pirateInit()
  self.behaviour = behave.EnemyPreset1
  self.player = false
  self.speedPercent = 1
  self.alliance = alliances:getAlliance("Renwight's Raiders")
end

function ships:setTypeLeviathan()
  if self.name == "unnamedShip" then
    self.name = "Leviathan"
  end
  self.speed = 5
  self.turnSpeed = 0.5
  self.accel = 0.5
  self.decel = 0.25
  self.class = shipClasses.hugeClass
  --self.x = self.x-(self.class[1]*self.id)
  self.behaviour = behave.NeutralPreset1
end


function ships:setTypeGoliath()
  if self.name == "unnamedShip" then
    self.name = "Goliath"
  end
  self.speed = 6
  self.turnSpeed = 1.5
  self.class = shipClasses.largeClass
  --self.x = self.x-(self.class[1]*self.id)
  self.behaviour = behave.NeutralPreset1
end

function ships:setTypeKestrel()
  if self.name == "unnamedShip" then
    self.name = "Kestrel"
  end
  self.speed = 10
  self.turnSpeed = 5
  self.class = shipClasses.mediumClass
  --self.x = self.x-(self.class[1]*self.id)
  self.behaviour = behave.NeutralPreset1
end

function ships:setTypePixie()
  if self.name == "unnamedShip" then
    self.name = "Pixie"
  end
  self.speed = 15
  self.turnSpeed = 7
  self.accel = 3
  self.decel = 2.75
  self.class = shipClasses.lightClass
  --self.x = self.x-(self.class[1]*self.id)
  self.behaviour = behave.NeutralPreset1
end

function ships:setTypeRaider()
  if self.name == "unnamedShip" then
    self.name = "Raider"
  end
  self.speed = 9.5
  self.turnSpeed = 4.5
  self.class = shipClasses.mediumClass
  --self.x = self.x-(self.class[1]*self.id)
  self.behaviour = behave.NeutralPreset1
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

function shipBuilder:genNewShip(type, alliance, hardpoints, player, name)
  --[[
  Types
  1: Pixie
  2: Kestrel
  3: Raider
  4: Goliath
  5: Leviathan
  Update this listing when you add more ship types
  ]]
  print("Order of setting is:\nType (Integer)\nAlliance (Name)\nHardpoints (Table of all hardpoints to install)\nplayer (boolean)\n")
  local ship = ships.create()
  table.insert(shipsList, ship)
  ship = shipsList[#shipsList]

  ship:_init()
  ship:selectNewShipType(type)
  ship:setName(name)
  if player == true then
    ship:playerShipInit(alliance)
  else
    ship:shipInit(alliance)
  end

  for i = 1,#hardpoints do
    print(hardpoints[i].name)
    ship:installHardpoint(hardpoints[i])
  end

  local x,y = ship:getShipPos()
  shipBuilder:defineBasicShipPhysics(ship,x,y)
  print('Ship created')
end


function ships:selectNewShipType(type)
  --self:typeList[type] put the type functions in a table and call them via that, but we don't quite know how to do that yet so come back to this
  --FUnction doesn't quite work, fix it later, make it workTM now
  --[[local typeList = {}
  typeList[1] = self:setTypePixie()
  typeList[2] = self:setTypeKestrel()
  typeList[3] = self:setTypeRaider()
  typeList[4] = self:setTypeGoliath()
  typeList[5] = self:setTypeLeviathan()]]
  --[[for k,v in pairs(typeList) do
    if v == type then
      k()
    end
  end]]

  if type == 1 then
    self:setTypePixie()
  elseif type == 2 then
    self:setTypeKestrel()
  elseif type == 3 then
    self:setTypeRaider()
  elseif type == 4 then
    self:setTypeGoliath()
  elseif type == 5 then
    self:setTypeLeviathan()
  end
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

function ships:checkRangeofWeapons()
  self.nearestInRange, self.targetList = {}
  --print("size of hardpoint table:"..#self.hardpoints)
  for i = 1,#self.hardpoints do
    local hardpoint = self.hardpoints[i]
    --print("Running check range for: "..self.name.." ID "..self.id.." "..hardpoint.name)
    --print(self.name)
    self.nearestInRange, self.targetList = self.hardpoints[i]:checkRange(self.alliance)
    --print(self.nearestInRange)
    print(self.name, self.id, #self.targetList)

    if self.targetList[1] then
      print(shipsList[self.targetList[1]].name)
    end
    if nearestInRange == -1 then
      local error = "ID system is misreferencing ships\nfor the hardpoints system"
      debugErrors = {}
      table.insert(debugErrors, error)
    end
  end
  --self.nearest = ships:calculateNearest()
  --print("ran CalculateNearest "..self.nearest())
end

function shipsThink()
  for i = 1,#shipsList do
    local ship = shipsList[i]
      --print('Name of the ship is: '..ship.name.." We're allowed to fire but we'll do it anyway without this requirement")
      ship:checkRangeofWeapons()
      print(ship.name)
      print(ship.name, ship.id, #ship.targetList)
      if #ship.targetList ~= nil then
        for k = 1,#ship.hardpoints do
          --print('\n'..k..' of '..i..'\n')
        --print("do a shoot")
        --targetList, Allied, Neutral, Enemy, 'Enemy / Indiscriminate / Hold'
          ship.hardpoints[k]:runFire(ship.targetList, {}, {alliances:getAlliance("Unaligned")}, {alliances:getAlliance("Renwight's Raiders")}, 'Indiscriminate')
        end
      end

    ship.x = ship.body:getX()
    ship.y = ship.body:getY()
    ship.shipVec = vector.new(ship.x, ship.y)

    if usingMovement2 then
      --Still need to untie movement from the framerate
      --if ship.alliance ~= alliances:getAlliance("Renwight's Raiders") then
        movement:rotate2(ship)
        movement:movement2(ship)
      --end
    else
      --if ship.alliance ~= alliances:getAlliance("Renwight's Raiders") then
        movement:rotate(ship)
        movement:movement(ship)
      --end
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
    --shipSelection:clickSetTarget()
  end
  for i = 1,#shipsList do
    local ship = shipsList[i]

  end
end

function ships:installHardpoint(weaponry)
  print('Inital num hardpoints on '..self.name..': '..#self.hardpoints)
  table.insert(self.hardpoints, weaponry)
  self.hardpoints[#self.hardpoints]:setID(#self.hardpoints)
  self.hardpoints[#self.hardpoints]:setShipID(self.id)
  print('End num hardpoints on '..self.name..': '..#self.hardpoints)
  print(self.hardpoints[#self.hardpoints].name.." added to "..self.name.."\nship ID: "..self.id.." weapon ID: "..self.hardpoints[#self.hardpoints].id.."ship ID: "..self.hardpoints[#self.hardpoints].shipID)
  --print(self.hardpoints[1].damage)
end


return shipBuilder
