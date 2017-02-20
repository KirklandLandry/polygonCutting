
local polyList = {}
local drawingSpliceLine = false
local mouseDown = false
local m1 = {x = 0, y = 0}

-- debug 
local intersectionPtDrawList = {}


function packPoint2D(px,py)
	return {x = px, y = py}
end 

function packEdge2DFromPts(pt1, pt2)
	return {p1 = pt1, p2 = pt2}
end 

function packEdge2D(x1, y1, x2, y2)
	return packEdge2DFromPts(
		packPoint2D(x1, y1),
		packPoint2D(x2, y2)
		)
end 

-- BASE LOAD
function loadGame()
	polyList = {}
	polyList[1] = {
		edges = {},
	}
	table.insert(polyList[1].edges, packEdge2D(70,70, 260,70))
	table.insert(polyList[1].edges, packEdge2D(260,70, 260,260))
	table.insert(polyList[1].edges, packEdge2D(260,260, 70,260))
	table.insert(polyList[1].edges, packEdge2D(70,260, 70,70))	
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

function drawEdge(e)
	love.graphics.line(e.p1.x, e.p1.y, e.p2.x, e.p2.y) 		
end 

-- BASE DRAW
function drawGame()
	for i=1,#polyList do
		-- draw the poly
		--love.graphics.polygon("line", polyList[i])
		-- debug poly draw
		for n=1,#polyList[i].edges,1 do
			drawEdge(polyList[i].edges[n])
		end 
		-- draw circles on every point 
		for n=1,#polyList[i].edges,1 do
			love.graphics.circle("fill", polyList[i].edges[n].p1.x, polyList[i].edges[n].p1.y, 5, 32)
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

	-- to prevent trying to split a line that starts or ends inside the poly, 
	-- should reject immediately if mouse point is inside poly 
	-- need to split poly into tris. point check on each tri in poly 

	intersectionPtDrawList = {}
	-- for every poly 
	for i=1,#polyList do
		-- for each edge get the pairs of intersection points
		for n=1,#polyList[i].edges,1 do
			local percent = 0
			
			percent = getLineIntersectionPercent(
					polyList[i].edges[n].p1, polyList[i].edges[n].p2, 
					packPoint2D(m1.x,m1.y), packPoint2D(m2.x,m2.y))

			if percent ~= 0 then
				local intersectionPt = getLineIntersectionPoint(percent, m1, m2)
				table.insert(intersectionPtDrawList, packPoint2D(intersectionPt.x, intersectionPt.y))
			end  
		end 
	
		-- don't do it if there's less than 1 intersection pt
		-- shouldn't need this later once the checks mentioned at the start are added 
		if #intersectionPtDrawList > 1 then 
			--table.sort( intersectionPtDrawList, sortPointList )
		end 

	end
end 

--[[
function sortPointList(a, b)
	return calcSignedDistance(a, b) 
end 

function calcSignedDistance(a, b)
	return (
		a.x - b.x * 
		)
end]]