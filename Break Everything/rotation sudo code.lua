
local radian = math.pi*2
local a = radian/2
local prevAngle = a
local targ = radian
local diff = targ - a
local startTime = love.timer.getTime()
local dur = 2

function think()
	if run == true then
		local p = math.min( (love.timer.getTime()-startTime/dur), 1 )
		a = prevAngle + diff*p
		if a == targ then
			run = false
		end
	end
end
