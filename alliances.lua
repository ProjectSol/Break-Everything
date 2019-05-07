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
  self.atWar = {}
  self.opinions = {}
  --self.opinionModifiers = {}
  --self:setBaseOpinion()
end

function alliances:setName(name)
  local setName = false
  for i = 1,#alliList do
    --print(name, alliList[i].name)
    if alliList[i].name == name then
      local error = "Invalid Name: Name Already Taken by Other Alliance"
      return error
    else
      setName = true
    end
  end
  if setName then
    self.name = name
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

--Government, MegaCorp, Piracy, Unaligned
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

function alliances:getAtWar(targetID)
  for i = 1,#self.atWar do
    if targetID == self.atWar[i].id then
      if status == 'War' then
        return true
      else
        return false
      end
    end
  end
end

function alliances:declareWar(targetID)
  print("The Alliance '"..self.name.." : "..self.id.."' is declaring war on '"..alliList[targetID].name.."'. ID: "..targetID)
  local allianceOne = alliList[targetID]
  local targetOne = {id = allianceOne:getID(), status = 'War'}
  local allianceTwo = alliList[self.id]
  local targetTwo = {id = allianceTwo:getID(), status = 'War'}

  table.insert(targetOne, alliList[self.id].atWar)
  table.insert(targetTwo, alliList[targetID].atWar)
end

function alliances:requestCeasefire(targetID)
  local numToRemove = nil
  for i = 1,#self.atWar do
    if targetID == self.atWar[i].id then
      --You'll need to update this later to actually query if the other alliance wants a cease fire
      numToRemove = i
      break
    end
  end
  if numToRemove ~= nil then
    table.remove(self.atWar, i)
  end
end

function alliances:setBaseOpinion()
  self.opinions = {}
  print("Running setBaseOpinion for new alliance")
  --So setting how much they like the player and iterating through all the existing alliances to see how they like each other
  for i = 1,#alliList do
    local updatingAlliance = alliList[i]
    local newAlliance = alliList[self.id]
    local bonus

    if self.name == "Unaligned" then

    elseif self.class == "Piracy" and updatingAlliance.class ~= "Piracy" and updatingAlliance.class ~= "Unaligned" then
      print("Pirate Organisation Declaring War")
      newAlliance:declareWar(updatingAlliance.id)
    elseif newAlliance.name ~= updatingAlliance.name then

    end


  end

  for i = 1,#alliList do
    local otherAlliance = alliList[i]
    local opinionTable = {id = otherAlliance.id, opinionModifiers = {}, bonus = {}}
    local bonus
    print("Self id: "..self.id, "Target Alliance id: "..otherAlliance.id.." Name : "..otherAlliance.name)
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
        if self.class == "Piracy" then
          bonus = {desc = "The criminal underbelly has to have some competition", mod = -10}
          table.insert(opinionTable.bonus, bonus)
          for k = 1,#opinionTable.bonus do
            print(k..": "..opinionTable.bonus[k].mod.." is the modifier of the opinion "..opinionTable.bonus[k].desc)
          end
          print(self.opinions, opinionTable)
          table.insert(self.opinions, opinionTable)
        else
          bonus = {desc = "We have some appreciable similarities", mod = 10}
          table.insert(opinionTable.bonus, bonus)
          for k = 1,#opinionTable.bonus do
            print(k..": "..opinionTable.bonus[k].mod.." is the modifier of the opinion "..opinionTable.bonus[k].desc)
          end
          print(self.opinions, opinionTable)
          table.insert(self.opinions, opinionTable)
        end


      elseif otherAlliance.class == "Piracy" then
        bonus = {desc = "Filthy Pirates", mod = -100}
        otherAlliance:declareWar(self.id)
        self:declareWar(otherAlliance.id)
        table.insert(opinionTable.bonus, bonus)
        for k = 1,#opinionTable.bonus do
          print(k..": "..opinionTable.bonus[k].mod.." is the modifier of the opinion "..opinionTable.bonus[k].desc)
        end
        table.insert(self.opinions, opinionTable)

      else
        print("There is no opinion change here")
        --Doing nothing as no opinion is changing
      end
    else
      print("This alliance has no need to set an opinion for itself")
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
      atWar = targetAlliance.atWar[i].status
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
  local ally = alliances:create()
  --print("ally name pre setup "..ally.name)
  table.insert(alliList, ally)
  --print(alliList[#alliList].name)
  local alli = alliList[#alliList]
  print(alli:setID(#alliList))
  print(alli:setName(name))
  print("Alliance ID for "..alli.name..": "..alli.id)
  print(alli:setColour(colour))
  print(alli:setClass(class))
  print(alli:setBaseOpinion())
end





return alliances
