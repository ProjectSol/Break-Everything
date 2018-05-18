UI = {}

function UI:runDraw()

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
 for i = 1,#shipsList do

 end
end


return UI
