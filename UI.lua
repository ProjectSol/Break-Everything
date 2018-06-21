UI = {}

function UI:runDraw()

end

function UI:movementElements()
  local max = nil
  local min = nil
  local current = nil
  local speedPercent = nil


  local accelerationPanel1 = gui.create("button")
  function accelerationPanel1:paint(w,h)

    local max = nil
    local min
    local current
    local speedPercent
    for i = 1,#shipsList do
      local ship = shipsList[i]
      if ship.player and ship.selected then
        max = ship.maxSpeed
        min = ship.reverseSpeed
        current = ship.currSpeed
        speedPercent = ship.speedPercent
        break
      else
        max = nil
      end
    end

    if max then
      accelerationPanel1:setPos( lg.getWidth()/2-lg.getWidth()/4, 20)
      accelerationPanel1:setSize( lg.getWidth()/2, 50 )
      accelerationPanel1:setTextColor( 0, 0, 0 )
      lg.setLineWidth(3)
      lg.setColor(250,50,50)
      lg.rectangle('fill',0,0,w,h)
      lg.setColor(0,200,200)
      accelerationPanel1:setFont(titleText);
      --lg.setFont(defaultFont)
      --love.graphics.print(tonumber(string.format("%.3f", min)),-10,-10)
      accelerationPanel1:setText(speedPercent.."%")
    else
      accelerationPanel1:setText('')
    end
  end
end

function UI:basicUI()
  local width,height = love.graphics.getDimensions()
  shipSelectionWidthCalibration = 8
  shipSelectionHeightCalibration = 10
  shipSelectionPositionCalibration = 20

  local pausePanelTest = gui.create("label")
  pausePanelTest:setPos( width-width/shipSelectionWidthCalibration, 0)
  pausePanelTest:setSize( width/shipSelectionWidthCalibration, height/shipSelectionHeightCalibration )
  pausePanelTest:setTextColor( 200, 200, 200 )
  function pausePanelTest:paint(w,h)
    lg.setLineWidth(3)
    if paused == true then
      love.graphics.setColor(250,250,250)
      love.graphics.rectangle('line', 0, 0, w, h)
      pausePanelTest:setText("||")
    else
      love.graphics.setColor(250,250,250)
      love.graphics.rectangle('line', 0, 0, w, h)
      pausePanelTest:setText(">")
    end
  end
  shipSelection:drawSidebar(width,height)
end

function UI:defineTextBox()

end


return UI
