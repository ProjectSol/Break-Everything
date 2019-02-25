nav = {}

function nav:calcGrid()

end

--An old example of my old code for reference
--[[

function createMap:genTilePos(i)
  local a = math.floor((map[i].id-1)/gridSize)
  local c = math.floor(map[i].id-(a*gridSize))
  drawY = squareSize*a + startY + (1*a)
  drawX = (map[i].id - (gridSize*a) - 1)*squareSize + startX + (1*c)
end

]]

function nav:drawGrid(shipX, shipY)
  local ship = nil
  for i = 1,#shipsList do
    local chosenShip = shipsList[i]
    if chosenShip.selected == true then
      ship = chosenShip
    end
  end
  local sideLen = 30
  local gridSize = 100
  local shipX = ship.body:getX()/2
  local shipY = ship.body:getY()/2
  lg.setLineWidth(1)
  for i = 1,gridSize*gridSize do
    love.graphics.setColor(0.3+0.3*(i%2),0.3+0.3*(i%2),0.3+0.3*(i%2))
    local a = math.floor((i-1)/gridSize)
    local c = math.floor(i-(a*gridSize))
    local drawX = (i - gridSize*a - 1)*sideLen + 3*c --+ shipX
    local drawY = sideLen*a + 3*a --+ shipY
    love.graphics.rectangle('fill', drawX, drawY, sideLen, sideLen)
  end
  local a = math.floor((gridSize-1)/gridSize)
  local c = math.floor(gridSize-(a*gridSize))
  width = ((gridSize - gridSize*a - 1)*sideLen + 3*c)*sideLen
end

return nav
