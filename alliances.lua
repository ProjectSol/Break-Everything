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
  self.opinion = {}
  self:setBaseOpinions()
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
  return self.colour
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

function alliances:setBaseOpinion()
  --So setting how much they like the player and iterating through all the existing alliances to see how they like each other
  local opinionTable = {}
  for i = 1,#alliList do
    local otherAlliance = alliList[i]
    opinionTable = {id = otherAlliance.id, opinionModifiers = {}}
    if self.name == "unaligned" or otherAlliance.name == "unaligned" then
      opinionTable = {id = otherAlliance.id, opinionModifiers = {bonus = {desc = "This ship is not a part of an alliance"}, mod = 0}}
    end
    if otherAlliance.id ~= self.id then
      if otherAlliance.class == self.class then
        bonus = {desc = "We have some appreciable similarities", mod = 10}
      elseif otherAlliance.class == "Piracy" then
        bonus = {desc = "Filthy Pirates", mod = -70}
      else
        --Doing nothing as no opinion is changing
      end
    end
  end
end

function alliances:returnOpinion(targetAllianceId)
  local targetAlliance = self.opinions[i]
  local opinion = 0
  for i = 1,#targetAlliance.opinionModifiers do

  end
  print("Opinion of "..alliList[targetAllianceId].name..": "..opinion)

  return
end

function alliances:changeOpinions(targetAllianceId, opinionShift)
  for i = 1,#self.opinions do
    local targetAlliance = self.opinions[i]
    if targetAlliance.id == targetAllianceId then
      targetAlliance.opinion = targetAlliance.opinion - opinionShift
    end
  end
end

function allianceSys:newAlliance(name, colour, class)
  local ally = alliances.create()
  table.insert(alliList, ally)
  --print(alliList[#alliList].name)
  local alli = alliList[#alliList]
  print(alli:setName(name))
  print(alli:setColour(colour))
  print(alli:setClass(class))
end


return alliances
