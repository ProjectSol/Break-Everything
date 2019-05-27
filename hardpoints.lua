hardpoints = {}

weaponry = {}
weaponry_mt = {__index = weaponry}

setmetatable(weaponry, {
  __call = function (cls, ...)
    local self = setmetatable({}, cls)
    self:_init(...)
    return self
  end,
})

function weaponry.create()
  local new_inst = {}    -- the new instance
  setmetatable( new_inst, weaponry_mt ) -- all instances share the same metatable
  return new_inst
end

function weaponry:_init()
  self.damage = 1
  self.healing = 0
  self.weapon = true
  self.weaponType = laser --Projectile, Laser, Missle working on getting laser working first and we'll use it as a base line

  self.name = "unnamedWeaponry"
  self.id = nil
  self.shipID = nil
  --Update your id system to handle ships being deleted,
  --added should just be fineTM

  self.fireRate = 1
  self.heatThreshold = 100
  self.heatOnFire = 7
  self.coolOff = 4
  self.maxRange = 100
  self.minRange = 20
end

function weaponry:setName(name)
  self.name = name
end

function weaponry:setID(ID)
  self.id = ID
end

function weaponry:setShipID(ID)
  self.shipID = ID
end

function weaponry:setHealing(num)
  if num < 0 then
    print('Really. You want negative healing. Fix your numbers idiot\n')
  end

  self.healing = num

end

function weaponry:setDamage(num)
  print(num)
  if num < 0 then
    print('Why is your damage value negative idiot, just make the \'weapon\' heal instead\n')
  end

  self.damage = num

end

function weaponry:setRange(max, min)
  print("Setting maximum range as "..max)
  print("Setting minimum range as "..min)

  if max <= 0 or min < 0 then
    print("You can't have a maximum range of zero or a minimum below zero, cancelling setRange")
  else
    self.maxRange = max
    self.minRange = min
  end

end

function weaponry:getParentShipID()
  return self.shipID
end

function hardpoints.giveBasicWeapons()
  for i = 1,#shipsList do
    local ship = shipsList[i]

    local gun = weaponry.create()
    gun:setName('basicBlaster')
    gun:setDamage(15)
    gun:setRange(500, 20)
    gun:setID(#ship.hardpoints+1)
    gun:setShipID(i)

    ship:installHardpoint(gun)
  end
end

function weaponry:fire(enemyId)
  --local nearest, targetList = weaponry:checkRange()
  local enemyShip = shipsList[enemyId]
  local firingShip = shipsList[self.shipID]
  --print("Hello?")
  --love.graphics.print("wawawawawawwa", firingShip.body:getPosition())
  --if self.weaponType == laser then
    --love.graphics.print("wawawawawawwa", firingShip.body:getPosition())
    local x1,y1 = firingShip.body:getPosition()
    local x2,y2 = enemyShip.body:getPosition()
    local newLaser = {x1 = x1, y1 = y1, x2 = x2, y2 = y2, colour = firingShip.alliance.colour, attackerId = self.shipID, defenderId = enemyId}
    table.insert(lasTable, newLaser)
    -- /print(#lasTable)
  --end
end

--Legal Targets = Hold, notAlly, Enemy
function weaponry:runFire(targetList, Allied, Neutral, Enemy, legalTargets)
  --local parentShipID = self:getParentShipID()
  --print(shipsList[parentShipID].id, parentShipID, 'inside print')
  if legalTargets == 'Hold' then
    print('Holding fire')

  elseif legalTargets == 'notAlly' then
    --print("aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa")
    for i = 1,#targetList do
      local alliance = shipsList[targetList[i]].alliance
      for k = 1,#Neutral do

        if alliance == Neutral[k] and alliance ~= nil then
          --print(self.name.."Installed on: "..shipsList[parentShipID].name.."\nFiring at neutral ship: "..shipsList[targetList[i].name])
          --print("*nice*")
          self:fire(targetList[i])
        end
      end
      --print(#Enemy)
      for k = 1,#Enemy do
        if alliance == Enemy[k] and alliance ~= nil then
          --print("*italics*")
          --print("Hardpoint Installed on: "..shipsList[self:getParentShipID()].name.."\nFiring at enemy ship: "..shipsList[targetList[i].name])
          self:fire(targetList[i])
        end
      end
    end

  elseif legalTargets == 'Enemy' then
    for i = 1,#targetList do
      --print('one: '..#targetList)
      local alliance = shipsList[targetList[i]].alliance
      for k = 1,#Enemy do
        --print('two: '..#Enemy)
        --print(alliance:getName())
        if alliance == Enemy[k] and alliance ~= nil then
          --print("Hey look we're shooting at: "..shipsList[targetList[i]].name)
          --print(self.name.."Installed on: "..shipsList[self.getParentShipID()].name.."\nFiring at enemy ship: "..shipsList[targetList[i].name])
          self:fire(targetList[i])
        end
      end
    end
  end
end

function weaponry:checkRange(alliance)
  --You need to update this function to reference the shape of each ship
  --and calculate if they are close enough to be hit
  --based on their actual physical presence in the world
  local nearest = {}
  local targetList = {}
  local resetTableAtEnd = true
  local parentShip = shipsList[self.shipID]
  local x1,y1 = parentShip.body:getPosition()
  if self.shipID ~= parentShip.id then
    print("MAJOR ERROR: Weapon System ID referencing has broken and requires fixing, range check will be cancelled");
    return -1, -1
  end

  for i = 1,#shipsList do
    local ship = shipsList[i]
    if ship.id ~= self.shipID then
      if ship.alliance == alliance then

      else
        local x2, y2 = ship.body:getPosition()
        --print(x1, y1, x2, y2)
        local distance = math.sqrt((x1-x2)^2+(y1-y2)^2)
        --[[print("Should be the distance: "..distance)
        print(self.maxRange)
        print(self.minRange)]]
        if distance <= self.maxRange and distance >= self.minRange then
          --print('Weaponry in range of '..ship.name);
          table.insert(targetList, ship.id)
          for i = 1,#targetList do
            resetTableAtEnd = false
            --print(self.name, targetList[i])
          end
          for i = 1,#nearest do
            if distance <= nearest.distance then
              nearest = {id = ship.id, distance = distance}
            end
          end
          --print("assigning nearest for the first time")
          nearest = {id = ship.id, distance = distance}
        end
          --[[for i = 1,#targetList do
            print('Entry '..i..' in targetList is the id of the ship: '..shipsList[targetList[i]]--[[.name)
          end]]
        end
      end
    end

  if resetTableAtEnd == true then
    return {}, {}
  else
    return nearest, targetList
  end
end

function drawLas()
  --print(#lasTable)
  for i = 1,#lasTable do
    lg.setColor(unpack(lasTable[i].colour))
    lg.setLineWidth(1)
    --print(i)
    local x1 = lasTable[i].x1
    local x2 = lasTable[i].x2
    local y1 = lasTable[i].y1
    local y2 = lasTable[i].y2

    --[[love.graphics.line(x1, y1, x2, y2)
    love.graphics.print(""..lasTable[i].attackerId, x2+10*lasTable[i].attackerId,y2)]]
  end
  if #lasTable > 10 then
    lasTable = {}
  end
end

return hardpoints
