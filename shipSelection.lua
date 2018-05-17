shipSelection = {}

function shipSelection:drawSidebar()
  local width,height = love.graphics.getDimensions()

  shipSelectionWidthCalibration = 8
  shipSelectionHeightCalibration = 10
  shipSelectionPositionCalibration = 20

  local pausePanelTest = gui.create("button")
  pausePanelTest:setPos( width-width/shipSelectionWidthCalibration, 0)
  pausePanelTest:setSize( width/shipSelectionWidthCalibration, height/shipSelectionHeightCalibration )
  pausePanelTest:setTextColor( 200, 200, 200 )
  function pausePanelTest:paint(w,h)
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
  function pausePanelTest:doClick()
    if paused == true then
      paused = false
    else
      paused = true
    end
  end

  for i = 1,#shipsList do
    local ship = shipsList[i]
    if ship.player then
      local unitSelectionPanel = gui.create( "button" )
      unitSelectionPanel:setSize( width/shipSelectionWidthCalibration, height/shipSelectionHeightCalibration )
      unitSelectionPanel:setPos( 0, height/(shipSelectionPositionCalibration)+((i-1)*(height/shipSelectionHeightCalibration)+1*(i-1)) )
      unitSelectionPanel:setFont(titleText)
      unitSelectionPanel:setTextOffset(0,17-(i*3))
      function unitSelectionPanel:paint(w, h)
          love.graphics.setColor( unpack(ship.alliance.colour) )
          love.graphics.setLineWidth(3)
          love.graphics.rectangle('line', 0, 0+(i*3), w, h)
          unitSelectionPanel:setTextColor( 200, 200, 200 )
          unitSelectionPanel:setText(ship.name)
      end
      function unitSelectionPanel:doClick()
          ship:selectIndividual()
      end
    end
  end
end

return shipSelection
