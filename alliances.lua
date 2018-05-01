allianceSys = {}
alliances = {}

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

alliColours = {
Turquoise = {26,188,156}, Blue = {41,128,185},
Emerald = {241,196,15}, Purple = {142,68,173},
Asphalt = {56,75,97}, Sun = {241,196,15},
Pumpkin = {211,84,0}, Red = {192,57,43},
Wheat = {139,126,102}, Pink = {255,0,255},
Green = {34,139,34}, Brown = {139,90,0},
Sepia = {94,38,18}, unknownShip = {189,195,199},
Default = {250,250,250}
}


function alliances:_init()
  self.id = alliIdCounter
  alliIdCounter = alliIdCounter+1
  self.name = "undefinedAlliance"
  self.class = "undefined"
  self.behaviour = nil
  self.colour = alliColours.Default
  self.opinion = defineOpinions()
end

function defineOpinions()
  --So setting how much they like the player and iterating through all the existing alliances to see how they like each other
end

function alliances:defaultAlliances()

end


return allianceSys
