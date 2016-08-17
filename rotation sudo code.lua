
local radian = math.pi*2
local currAngle = radian/2
local targAngle = radian
local diff = targ - a
local startTime = love.timer.getTime()
local dur = (currAngle+targAngle)/player.speed

function think()
	if run == true then
		local p = math.min( (love.timer.getTime()-startTime/dur), 1 )
		currAngle = currAngle + diff*p
		if currAngle == targAngle then
			run = false
		end
	end
end
