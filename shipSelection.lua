shipSelection = {}


function shipSelection:tabSwap()
  shipSelection:nextPlayerShip()
  for i = 1,#shipsList do
    print("DebugRun: "..tostring(shipsList[i].selected))
  end
end

function shipSelection:drawSidebar(width, height)
  sidebar = {}
  for i = 1,#shipsList do
    local ship = shipsList[i]

    if ship.player then

      local unitSelectionPanel = gui.create( "button" )
      unitSelectionPanel:setSize( width/shipSelectionWidthCalibration, height/shipSelectionHeightCalibration )
      unitSelectionPanel:setPos( 0, height/(shipSelectionPositionCalibration)+((i-1)*(height/shipSelectionHeightCalibration)+1*(i-1)) )
      unitSelectionPanel:setFont(titleText)
      unitSelectionPanel.sideBarPanel = true
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
    prev = i+1

    if ship.player and ship.selected then
      if found == true then
        break
      else
        shipBuilder:unselectSelectedShips()
      end

      if found == false then
        print('first loop ran')
        for k = prev,#shipsList do
          print("Current iteration i: "..ship.name.." i = "..i.." current iteration k: "..shipsList[k].name.." k = "..k)
          if shipsList[k].player then
            shipsList[k].selected = true
            print(shipsList[k].selected)
            print("subsequently this iteration of k is a player ship thus running unselect and selecting itself")
            shipsList[k].selected = true
            print(shipsList[k].name.."("..k..") selected: "..tostring(shipsList[k].selected).."   nextPlayerShip")
            found = true
            print("Found has been set to true")
            break
          end
        end --for k = prev,...

        print("Ship Located: "..tostring(found))

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

      end --if found except it's the first one this time

    end --if ship.player ...
  end
end

function shipSelection:cntrlGroupSelect(num)
  local globalPanels = gui.getObjects()
  local localPanels = {}
  print(#globalPanels)
  for i = 1,#globalPanels do
    if globalPanels[i].sidebarPanel == true then
      table.insert(globalPanels[i], localPanels)
      print(i)
    else

    end
  end

  for i = 1,#localPanels do
    print(#localPanels)
  end

end

function shipSelection:clickSetTarget()
  local mX, mY = love.mouse.getPosition()
  local ship = shipBuilder:getSelectedPlayerShip()
  local targetedShip = nil
  for i = 1,#shipsList do
    if shipsList[i].alliance ~= ship.alliance then
      local mousedOver = shipsList[i].fixture:testPoint(mX,mY)
      if mousedOver == true then
        print('Success')
      end
    end
  end
end



return shipSelection
