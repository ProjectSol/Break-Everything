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
  self.wType = laser --Projectile, Laser, Missle working on getting laser working first and we'll use it as a base line

  self.name = "unnamedWeaponry"

  self.fireRate = 1
  self.heatThreshold = 100
  self.heatOnFire = 7
  self.coolOff = 4
  self.maxRange = 500
  self.minRange = 20
end

function weaponry:setName(name)
  self.name = name
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

function hardpoints.giveBasicWeapons()
  local gun = weaponry.create()
  gun:setName('basicBlaster')
  weaponry.setDamage(gun, 15)

  for i = 1,#shipsList do
    local ship = shipsList[i]
    ship:installHardpoint(gun)
  end
end

function weaponry:fire(Allied, Neutral, Enemy)
  local nearest, targetList = weaponry:checkRange()

end

function weaponry:checkRange()
  local nearest, targetList
  for i = 1,#shipsList do
    local ship = shipsList[i]
    local distance = math.sqrt((x2-x1)*2+(y2-y1)*2)
    if distance <= self.maxRange() and distance >= self.minRange() then
      print('Weaponry in range of '..ship.name)
    end
  end

  return nearest, targetList
end



return hardpoints
