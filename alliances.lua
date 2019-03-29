allianceSys = {}

alliances = {}
alliances_mt = {__index = alliances}

alliList = {}
alliIdCounter = 1

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
  self.opinions = {}
  --self.opinionModifiers = {}
  --self:setBaseOpinion()
end

function alliances:setName(name)
  for i = 1,#alliList do
    if alliList[i].name == name then
      local error = "Invalid Name: Name Already Taken by Other Alliance"
      return error
    else
      self.name = name
    end
  end
  return self.name
end

function alliances:getName()
  return self.name
end

function alliances:setID(ID)
  self.id = ID
  return self.id
end

function alliances:getID()
  return self.id
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
  print("Running setBaseOpinion for new alliance")
  --So setting how much they like the player and iterating through all the existing alliances to see how they like each other
  for i = 1,#alliList do
    local updatingAlliance = alliList[i]
    local newAlliance = alliList[self.id]
    local bonus

    if self.name == "Unaligned" then

    elseif newAlliance.name ~= updatingAlliance.name then

    end


  end

  for i = 1,#alliList do
    local otherAlliance = alliList[i]
    local opinionTable = {id = otherAlliance.id, opinionModifiers = {}, bonus = {}}
    local bonus
    print("Self id: "..self.id, "Target Alliance id: "..otherAlliance.id)
    if self.name == "Unaligned" then
      bonus = {desc = "We aren't really swayed one way or another, not being a member of an alliance will do that to you", mod = 0}
      table.insert(opinionTable.bonus, bonus)
      for k = 1,#opinionTable.bonus do
        print(k..": "..opinionTable.bonus[k].mod.." is the modifier of the opinion "..opinionTable.bonus[k].desc)
      end
      print(self.opinions, opinionTable)
      table.insert(self.opinions, opinionTable)
    elseif otherAlliance.id ~= self.id then
      if otherAlliance.class == self.class then
        bonus = {desc = "We have some appreciable similarities", mod = 10}
        table.insert(opinionTable.bonus, bonus)
        for k = 1,#opinionTable.bonus do
          print(k..": "..opinionTable.bonus[k].mod.." is the modifier of the opinion "..opinionTable.bonus[k].desc)
        end
        print(self.opinions, opinionTable)
        table.insert(self.opinions, opinionTable)


      elseif otherAlliance.class == "Piracy" then
        bonus = {desc = "Filthy Pirates", mod = -100}
        table.insert(opinionTable.bonus, bonus)
        for k = 1,#opinionTable.bonus do
          print(k..": "..opinionTable.bonus[k].mod.." is the modifier of the opinion "..opinionTable.bonus[k].desc)
        end
        table.insert(self.opinions, opinionTable)

      else
        print("There is no opinion change here")
        --Doing nothing as no opinion is changing
      end
    end
  end
  return "no errors encountered"
end

function alliances:returnEnemies()

end

function alliances:returnAllies()
  local targetAlliance = self.opinions[targetAllianceId]
  local opinion = 0
  for i = 1,#targetAlliance.opinionModifiers do
    opinion = opinion+targetAlliance.opinionModifiers[i].mod
  end

  if opinion < 50 then
    print("Opinion of "..alliList[targetAllianceId].name..": "..opinion)

    return opinion
  end

  print('An error occured while calculating Opinion')
  return -1
end

function alliances:returnNeutral(targetAllianceId)
  local targetAlliance = self.opinions[targetAllianceId]
  local atWar
  for i = 1,#targetAlliance.atWar do
    if targetAlliance.atWar[i].id == self.id then
      atWar = targetAlliance.atWar[i]
    end
  end
  local opinion = 0
  for i = 1,#targetAlliance.opinionModifiers do
    opinion = opinion+targetAlliance.opinionModifiers[i].mod
  end
  if opinion > -50 or opinion < 50 and atWar == false then
    print("Opinion of "..alliList[targetAllianceId].name..": "..opinion)

    return opinion
  end
  print('An error occured while calculating Opinion')
  return -1
end

function alliances:returnOpinion(targetAllianceId)
  local targetAlliance = self.opinions[targetAllianceId]
  local opinion = 0
  for i = 1,#targetAlliance.opinionModifiers do
    opinion = opinion+targetAlliance.opinionModifiers[i].mod
  end
  print("Opinion of "..alliList[targetAllianceId].name..": "..opinion)

  return opinion
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
  print(alli:setID(#alliList))
  print("Alliance ID: "..alli.id)
  print(alli:setName(name))
  print(alli:setColour(colour))
  print(alli:setClass(class))
  print(alli:setBaseOpinion())
end


return alliances
