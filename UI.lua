UI = {}

function UI:runDraw()

end

function UI:movementElements()
  local max = nil
  local min = nil
  local current = nil
  local speedPercent = nil
  local AccelPanelWidthConstant = lg.getWidth()/2

  local accelerationPanel1 = gui.create("label")
  function accelerationPanel1:paint(w,h)
    local max = nil
    local min = nil
    local current
    local speedPercent
    for i = 1,#shipsList do
      local ship = shipsList[i]
      if ship.player and ship.selected then
        max = ship.speed
        reverseOffset = ship.reverseSpeed/max
        current = ship.currSpeed
        speedPercent = ship.speedPercent
        break
      else
        max = nil
      end
    end

    if max ~= nil then
      accelerationPanel1:setPos( lg.getWidth()/2-lg.getWidth()/4, 20)
      accelerationPanel1:setSize( AccelPanelWidthConstant*(1+reverseOffset), 50 )
      accelerationPanel1:setTextColor( 0, 0, 0 )
      --lg.setLineWidth(3)
      lg.setColor(250,50,50)
      lg.rectangle('fill',0,0,w,h)
      --lg.setColor(0,200,200)
      --accelerationPanel1:setFont(titleText)
      --lg.setFont(defaultFont)
      --love.graphics.print(tonumber(string.format("%.3f", min)),-10,-10)
      accelerationPanel1:setText((speedPercent*100).."%")
    else
      accelerationPanel1:setText('')
    end
  end

  shipsMouseRunBool = true
  local accelerationPanel2 = gui.create("button")
  function accelerationPanel2:paint(w,h)
    local max = nil
    local min
    accelPanelNum = nil
    reverseOffset = nil
    local current
    local speedPercent
    for i = 1,#shipsList do
      local ship = shipsList[i]
      if ship.player and ship.selected then
        accelPanelNum = i
        max = ship.speed
        reverseOffset = ship.reverseSpeed/max
        current = ship.currSpeed
        speedPercent = ship.speedPercent
        break
      else
        max = nil
      end
    end
    if max ~= nil then
      if shipsMouseRunBool ~= true then
        systems:assignDesiredSpeedOnClick(accelerationPanel2:getPos(), AccelPanelWidthConstant, accelPanelNum,reverseOffset)
      end
      accelerationPanel2:setSize( AccelPanelWidthConstant, 50 )
      accelerationPanel2:setPos( (lg.getWidth()/2-lg.getWidth()/4)-reverseOffset, 20)
      accelerationPanel2:setTextColor( 0, 0, 0 )
      accelerationPanel2:setText("")
      lg.setLineWidth(3)
      lg.setColor(0.25,0.5,1)
      lg.rectangle('line',0,0,w*speedPercent+w*reverseOffset,h)
      lg.setColor(0,0.8,0.8)
    end
  end
  function accelerationPanel2:onReleased()
    shipsMouseRunBool = true
  end
  --[[function accelerationPanel2:think()
    if shipsMouseRunBool ~= true and max ~= nil then
      systems:assignDesiredSpeedOnClick(accelerationPanel2:getPos(), AccelPanelWidthConstant, accelPanelNum)
    end
  end]]
  function accelerationPanel2:doClick()
    shipsMouseRunBool = false
    --print("Well done you did it")
  end
end

function UI:basicUI()
  local width,height = love.graphics.getDimensions()
  shipSelectionWidthCalibration = 8
  shipSelectionHeightCalibration = 10
  shipSelectionPositionCalibration = 20

  local pausePanel = gui.create("label")
  pausePanel:setPos( width-width/shipSelectionWidthCalibration, 0)
  pausePanel:setSize( width/shipSelectionWidthCalibration, height/shipSelectionHeightCalibration )
  pausePanel:setTextColor( 200, 200, 200 )
  function pausePanel:paint(w,h)
    lg.setLineWidth(3)
    if paused == true then
      love.graphics.setColor(250,250,250)
      love.graphics.rectangle('line', 0, 0, w, h)
      pausePanel:setText("||")
    else
      love.graphics.setColor(250,250,250)
      love.graphics.rectangle('line', 0, 0, w, h)
      pausePanel:setText(">")
    end
  end
  shipSelection:drawSidebar(width,height)
end

function UI:defineTextBox()

end


return UI
