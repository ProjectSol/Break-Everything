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

  self.name = "unnamedWeaponry"

  self.fireRate = 1
  self.heatThreshold = 100
  self.heatOnFire = 7
  self.coolOff = 4
  self.maxRange = 500
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
  gun = weaponry.create()
  gun:setName('basicBlaster')
  weaponry.setDamage(gun, 15)

  for i = 1,#shipsList do
    local ship = shipsList[i]
    ship:installHardpoint(gun)
  end
end



return hardpoints
