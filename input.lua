-- key list containing if a key is pressed or not 
local keys = {}

-- key press callback
function love.keypressed(key)
    keys[key] = {down = true, held = false} 
end

-- key released callback
function love.keyreleased(key)
    keys[key] = {down = false, held = false} 
end

-- just check if a key is down
function getKeyDown(key)
	if not keys[key] then 
		keys[key] = {down = false, held = false}
	elseif keys[key].down then 
		if not keys[key].held then keys[key].held = true end 
		return true
	end
	return false
end

-- checking if a key is pressed (not held)
function getKeyPress(key)
	if not keys[key] then 
		keys[key] = {down = false, held = false}
	elseif keys[key].down and keys[key].held == false then 
		if not keys[key].held then keys[key].held = true end 
		return true
	end
	return false
end

-- reset input
function resetInput()
	for k in pairs (keys) do
		keys[k] = nil
	end
	keys = {}
end 