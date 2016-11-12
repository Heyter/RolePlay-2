local MatGradientUp = Material("vgui/gradient-u")
local MatGradientDown = Material("vgui/gradient-d")

function DrawSimpleCircle(posx, posy, radius, color)
	local poly = { }
	local v = 40
	for i = 0, v do
		poly[i+1] = {x = math.sin(-math.rad(i/v*360)) * radius + posx, y = math.cos(-math.rad(i/v*360)) * radius + posy}
	end
	draw.NoTexture()
	surface.SetDrawColor(color)
	surface.DrawPoly(poly)
end

function DrawCircle(posx, posy, radius, progress, color)
	local poly = { }
	local v = 220
	poly[1] = {x = posx, y = posy}
	for i = 0, v*progress+0.5 do
		poly[i+2] = {x = math.sin(-math.rad(i/v*360)) * radius + posx, y = math.cos(-math.rad(i/v*360)) * radius + posy}
	end
	draw.NoTexture()
	surface.SetDrawColor(color)
	surface.DrawPoly(poly)
end

function DrawCircleGradient(posx, posy, radius, progress, color)
	local poly = { }
	local v = 100
	poly[1] = {x = posx, y = posy}
	for i = 0, v*progress do
		poly[i+2] = {x = math.sin(-math.rad(i/v*360)) * radius + posx, y = math.cos(-math.rad(i/v*360)) * radius + posy}
		poly[i+2].u = 0
		poly[i+2].v = 0.6
	end
	surface.SetMaterial(MatGradientDown)
	surface.SetDrawColor(Color(color.r,color.g,color.b,color.a))
	surface.DrawPoly(poly)
end
