Timer = {timerValue = 0, timerMax = 0, mode = nil}
TimerModes = {repeating = "repeating", single = "single"}

function Timer:new(timerMax, mode)	
	assert((mode == TimerModes.repeating or mode == TimerModes.single) and timerMax >= 0, 
	"incorrect timer initialization (check that you sent a valid TimerMode and timerMax is > 0)")	
	local o = {}
	setmetatable(o, self)
	self.__index = self
	o.timerValue = 0
	o.timerMax = timerMax
	o.mode = mode or TimerModes.single
	return o
end
 
 -- updating the timer. if isComplete(dt) isn't called, timer isn't updated
 -- returns true if timer is complete, false if incomplete
function Timer:isComplete(dt)
	self.timerValue = self.timerValue + dt 
	if self.timerValue >= self.timerMax then 
		if self.mode == TimerModes.single then 
			self.timerValue = self.timerMax
		elseif self.mode == TimerModes.repeating then 
			self.timerValue = 0 
		end
		return true
	end
	return false
end

-- resets timer to newMax or 0 if no new value is given
function Timer:reset(newMax)
	self.timerValue = newMax or 0
end

-- force timer to completion
function Timer:maxOut()
	self.timerValue = self.timerMax
end 

-- a value between 0 to 1
function Timer:percentComplete()
	return (self.timerValue / self.timerMax)
end 

-- draw a timer on screen 
function Timer:draw(x, y, width, height)
	local timerPercentComplete = self.timerValue / self.timerMax
	love.graphics.rectangle("line", x, y, width, height)
	love.graphics.rectangle("fill", x, y, width - (width * timerPercentComplete), height)
end 