function circleCircleCollision(x1,y1,r1, x2,y2,r2)
	-- if the distance between the 2 centres is less thena the sum of the 2 radii, the circles overlap
	return (x2-x1)^2 + (y1-y2)^2 <= (r1+r2)^2
end 

-- http://stackoverflow.com/questions/401847/circle-rectangle-collision-detection-intersection
-- http://www.wildbunny.co.uk/blog/2011/04/20/collision-detection-for-dummies/
function rectCircleCollision(bx,by,bw,bh, cx,cy,cr)
	-- find the closest edge to the circle within the rectangle
	local closestX = math.clamp(cx, bx, bx + bw)
	local closestY = math.clamp(cy, by, by + bh)
	-- calculate the distance between the circle's centre and this closest point 
	local distanceX = cx - closestX 
	local distanceY = cy - closestY	
	-- if the distance is less the n the circle's radius, intersection 
	local distanceSquared = math.pow(distanceX,2) + math.pow(distanceY,2)
	if distanceSquared < math.pow(cr,2) then 
		return true 
	else 
		return false
	end  
end

function rectRectCollision(x1,y1,w1,h1, x2,y2,w2,h2)
	return x1 < x2+w2 and x2 < x1+w1 and y1 < y2+h2 and y2 < y1+h1
end