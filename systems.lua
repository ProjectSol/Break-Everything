systems = {}

function systems:pause()
  if paused == true then
    paused = false
  else
    paused = true
  end
end

return systems
