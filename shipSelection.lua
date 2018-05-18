shipSelection = {}

function shipSelection:drawSidebar(width, height)
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

function shipSelection:nextPlayerShip()
  local prev = nil
  local found = false

  local alreadySelectedShip, int = shipBuilder:getSelectedPlayerShip()
  print("\n\n"..alreadySelectedShip.name.."("..int..") selected: "..tostring(alreadySelectedShip.selected).."    This is the ship that is selected before nextPlayerShip is run")

  for i = 1,#shipsList do
    ship = shipsList[i]

    if ship.player and ship.selected then

      prev = i+1
      shipBuilder:unselectSelectedShips()
      if found == false then
        print('first loop ran')
        for k = prev,#shipsList do
          print("Current iteration i: "..ship.name.." i = "..i.." current iteration k: "..shipsList[k].name.." k = "..k)
          if shipsList[k].player then
            print("subsequently this iteration of k is a player ship thus running unselect and selecting itself")
            shipsList[k].selected = true
            print(ship.name.."("..k..") selected: "..tostring(ship.selected).."   nextPlayerShip")
            found = true
          end
        end
        print(found)
        if found == false then
          print("second loop ran")
          for k = 1,prev do
            print("Current iteration i: "..ship.name.." i = "..i.." current iteration k: "..shipsList[k].name.." k = "..k)
            if shipsList[k].player then
              shipsList[k].selected = true
              print(shipsList[k].name.."("..k..") selected: "..tostring(shipsList[k].selected).."   nextPlayerShip")
              found = true
              break
            end
          end
        end --if found

      end --if ship.player ...

    end
  end
end


return shipSelection
