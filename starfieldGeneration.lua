stars = {};

starGridSize = 3;
starGridLength = 2000;
numStars = 650;
displayStarGridTiles = false;

function stars:debugGrid()
  love.graphics.draw();
end

function stars:generateGrid()
  starGrid = {};
  for i = 1,starGridSize*starGridSize do
    local a = math.floor((i-1)/starGridSize);
    local c = math.floor(i-(a*starGridSize));
    local drawX = (i - starGridSize*a - 1)*starGridLength; --+ x*c;
    local drawY = starGridLength*a; --+ x*a this grants an offset of x pixels, mostly here as a reminder if I need a different grid sometime

    local randomStars = {}
    for j = 1,numStars do
      local xPos = love.math.random(1,starGridLength-1)
      local yPos = love.math.random(1,starGridLength-1)
      local rand = love.math.random(1,8)
      local colour = starCols[rand]
      local delay = love.math.random(4,10)
      local counter = 0
      --print(starCols[rand][1],starCols[rand][2],starCols[rand][3])
      local star = {x = xPos, y = yPos, colour = colour, counter = counter, delay = delay, size = 1}

      table.insert(randomStars, star)
    end
    print("Random starfield "..i.." fully populated with "..numStars.." stars")

    local mapSquare = {x = drawX, y = drawY, stars = randomStars};
    table.insert(starGrid, mapSquare);
  end
end

function stars:drawGrid()
  local ship;
  for i = 1,#shipsList do
    local chosenShip = shipsList[i];
    if chosenShip.selected == true then
      ship = chosenShip;
    end
  end

  --local shipX, shipY = ship.body:getPosition();
  local cameraX, cameraY = camera:position();
  local usedX = cameraX;
  local usedY = cameraY;

  for i = -1,1 do
    for j = -1,1 do
      local gridLoc = stars:getGridLocation(usedX+i*starGridLength, usedY+j*starGridLength);
      local centreTileX, centreTileY = stars:getClosestLocForGrid(usedX+i*starGridLength, usedY+j*starGridLength);
      starGrid[gridLoc].x = centreTileX
      starGrid[gridLoc].y = centreTileY

      if debug and displayStarGridTiles then
        love.graphics.setColor(0.1+0.05*(9-gridLoc%9),0.1+0.05*(9-gridLoc%9),0.1+0.05*(9-gridLoc%9),0.1);
        love.graphics.rectangle('fill', starGrid[gridLoc].x, starGrid[gridLoc].y, starGridLength, starGridLength)
      end

      local stars = starGrid[gridLoc].stars

      for k = 1,#stars do
        --print(unpack(stars[k].colour))
        --[[stars[k].counter = stars[k].counter + 1
        if stars[k].counter > stars[k].delay then
          stars[k].counter = 0;
          if stars[k].size == 1 then
            stars[k].size = 2
          else
            stars[k].size = 1;
          end
        end]]
        
        love.graphics.setColor(stars[k].colour)
        --love.graphics.points(centreTileX+stars[k].x, centreTileY+stars[k].y)
        love.graphics.circle('fill', centreTileX+stars[k].x, centreTileY+stars[k].y, stars[k].size)
      end
    end
  end

  --[[for i = 1,#starGrid do
    love.graphics.setColor(0.1+0.05*(9-i%9),0.1+0.05*(9-i%9),0.1+0.05*(9-i%9));
    love.graphics.rectangle('fill', starGrid[i].x, starGrid[i].y, starGridLength, starGridLength);
    love.graphics.setColor(1,1,1)
    love.graphics.print(i, starGrid[i].x+starGridLength/2, starGrid[i].y+starGridLength/2);
  end]]
end

function stars:getClosestLocForGrid(x, y)
  --Find the top right corner for our value
  local xLoc = x%starGridLength;
  local yLoc = y%starGridLength;

  --Referring to the origin of the particular grid tile we are within
  local originX = x-xLoc;
  local originY = y-yLoc;

  return originX, originY;
end

function stars:mouseGridPosition()
  --get the position of the mouse in world coords and use it to calculate where in our current tile we are and then print that shit to screen
  local x,y = camera:worldCoords(love.mouse.getPosition());
  local xLoc, yLoc = stars:getClosestLocForGrid(x,y);

  return xLoc, yLoc;
end

function stars:mouseGridLocation()
  --Get the position of the mouse in world coords compare it to the origin and calculate which of the nine tiles we are currently in and then print that shit to screen
  local x, y = camera:worldCoords(love.mouse.getPosition())
  local gridLoc = stars:getGridLocation(x,y)

  return gridLoc;
end

function stars:getGridLocation(x, y)
  --determines which tile we should be in via wizardry
  local xLoc = (math.floor(x/starGridLength)%3) +1
  local yLoc = (math.floor(y/starGridLength)%3) +1

  local gridLoc
  local possible = {{1,2,3},{4,5,6},{7,8,9}}
  gridLoc = possible[yLoc][xLoc]

  return gridLoc;
end

function stars:testGrid()
  local ship;
  for i = 1,#shipsList do
    local chosenShip = shipsList[i];
    if chosenShip.selected == true then
      ship = chosenShip;
    end
  end

  local shipX, shipY = ship.body:getPosition()

  for i = 1,starGridSize*starGridSize do
    love.graphics.setColor(0.3+0.3*(i%2),0.3+0.3*(i%2),0.3+0.3*(i%2));
    local a = math.floor((i-1)/starGridSize);
    local c = math.floor(i-(a*starGridSize));
    local drawX = (i - starGridSize*a - 1)*starGridLength + 3*c;
    local drawY = starGridLength*a + 3*a;
    love.graphics.rectangle('fill', drawX, drawY, starGridLength, starGridLength);
  end
end


return stars;
