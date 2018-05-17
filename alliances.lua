allianceSys = {}

alliances = {}
alliances_mt = {__index = alliances}

alliList = {}

setmetatable(alliances, {
  __call = function (cls, ...)
    local self = setmetatable({}, cls)
    self:_init(...)
    return self
  end,
})

function alliances.create()
  local new_inst = {}    -- the new instance
  setmetatable( new_inst, alliances_mt ) -- all instances share the same metatable
  return new_inst
end

function alliances:_init()
  self.id = alliIdCounter
  alliIdCounter = alliIdCounter+1
  self.name = "undefinedAlliance"
  self.class = "undefined"
  self.behaviour = nil
  self.colour = Default
  self.opinion = defineOpinions()
end

function alliances:setName(name)
  self.name = name
  return self.name
end

function alliances:setClass(class)
  self.class = class
  return self.class
end

function alliances:setBehaviour(behave)
  self.behaviour = behave
  return self.behaviour
end

function alliances:setColour(colour)
  self.colour = colour
  --return self.colour
end

function alliances:getAlliance(name)
  for i = 1,#alliList do
    local alli = alliList[i]
    if alli.name == name then
      alliance = alliList[i]
      return alliance
    end
  end
end

function alliances:defineOpinions()
  --So setting how much they like the player and iterating through all the existing alliances to see how they like each other
  return -1
end

function allianceSys:newAlliance(name, colour)
  local ally = alliances.create()
  table.insert(alliList, ally)
  --print(alliList[#alliList].name)
  local alli = alliList[#alliList]
  print(alli:setName(name))
  print(alli:setColour(colour))
end


return alliances
