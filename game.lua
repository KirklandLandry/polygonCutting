
local polyList = {}
local drawingSpliceLine = false
local mouseDown = false
local m1 = {x = 0, y = 0}

-- debug 
local intersectionPtDrawList = {}


function packPoint2D(px,py)
	return {x = px, y = py}
end 

-- BASE LOAD
function loadGame()
	table.insert(polyList, {70,70, 260,70, 260,260, 70,260})
end

-- BASE UPDATE 
function updateGame(dt)	
	if getKeyDown("escape") then 
		love.event.quit(0)
	end 

	if love.mouse.isDown("1") then 
		if not mouseDown then 
			if not drawingSpliceLine then 
				drawingSpliceLine = true
				m1.x = love.mouse.getX()
				m1.y = love.mouse.getY()
			else 
				drawingSpliceLine = false 
				splicePoly({x = love.mouse.getX(), y = love.mouse.getY()})
			end 
			mouseDown = true
		end 
	else 
		mouseDown = false
	end 

end

-- BASE DRAW
function drawGame()
	for i=1,#polyList do
		-- draw the poly
		love.graphics.polygon("line", polyList[i])
		-- debug poly draw
		--[[for n=1,#polyList[i],2 do
			if (n == (#polyList[i]-1)) then 
				love.graphics.line(polyList[i][n], polyList[i][n+1], polyList[i][1], polyList[i][2])
			else 
				love.graphics.line(polyList[i][n], polyList[i][n+1], polyList[i][n+2], polyList[i][n+3])
			end 		
		end ]]
		-- draw circles on every point 
		for n=1,#polyList[i],2 do
			love.graphics.circle("fill", polyList[i][n], polyList[i][n+1], 5, 32)
		end
	end
	
	-- the splice line 
	if drawingSpliceLine then 
		local x, y = love.mouse.getPosition()
		love.graphics.line(m1.x, m1.y, x, y)
	end 
	-- intersection point 
	for i=1,#intersectionPtDrawList do
		love.graphics.circle("fill", intersectionPtDrawList[i].x, intersectionPtDrawList[i].y, 4, 10)
	end
	
end 

function perpDot(a, b)
	return ((a.y * b.x) - (a.x * b.y))
end 

function getLineIntersectionPercent(a1, a2, b1, b2)
	local a = packPoint2D(a2.x - a1.x, a2.y - a1.y)
	local b = packPoint2D(b2.x - b1.x, b2.y - b1.y)

	local f = perpDot(a,b)

	-- lines are parallel 
	if f == 0 then return 0 end 

	local c = packPoint2D(b2.x - a2.x, b2.y - a2.y)
	local aa = perpDot(a,c)
	local bb = perpDot(b,c)

    if (f < 0) then  
        if (aa > 0) then return 0 end 
        if (bb > 0) then return 0 end 
        if (aa < f) then return 0 end 
        if (bb < f) then return 0 end 
    else
        if (aa < 0) then return 0 end 
        if (bb < 0) then return 0 end 
        if (aa > f) then return 0 end 
        if (bb > f) then return 0 end 
    end 
    -- the line percent
    return (1 - (aa / f))
end 

function getLineIntersectionPoint(percent, b1, b2)
	return 	packPoint2D(
			((b2.x - b1.x) * percent) + b1.x,
			((b2.y - b1.y) * percent) + b1.y)
end 

-- https://geidav.wordpress.com/2015/03/21/splitting-an-arbitrary-polygon-by-a-line/
function splicePoly(m2)
	intersectionPtDrawList = {}
	-- for every poly 
	for i=1,#polyList do
		-- for each edge get the pairs of intersection points
		for n=1,#polyList[i],2 do
			local percent = 0
			if (n == (#polyList[i]-1)) then 
				percent = getLineIntersectionPercent(
					packPoint2D(polyList[i][n], polyList[i][n+1]), packPoint2D(polyList[i][1], polyList[i][2]), 
					packPoint2D(m1.x,m1.y), packPoint2D(m2.x,m2.y)) 
			else 
				percent = getLineIntersectionPercent(
					packPoint2D(polyList[i][n], polyList[i][n+1]), packPoint2D(polyList[i][n+2], polyList[i][n+3]), 
					packPoint2D(m1.x,m1.y), packPoint2D(m2.x,m2.y)) 
			end
			if percent ~= 0 then
				local intersectionPt = getLineIntersectionPoint(percent, m1, m2)
				table.insert(intersectionPtDrawList, packPoint2D(intersectionPt.x, intersectionPt.y))
			end  
		end 

 

	end

end 