include("shared.lua")

function ENT:Initialize()
end

function ENT:Think()
end

local Gas_Table = Gas_Table or {}
Gas_Table.gas_price = 1.2

function ENT:Draw()
	self:DrawModel()
	
	
	local a = self:GetAngles()
	local v = self:GetPos()
	v = v + self:GetUp() * 57
	v = v + self:GetForward() * 11
	v = v + self:GetRight() * 13
	
	a:RotateAroundAxis(a:Forward(), 90)
	a:RotateAroundAxis(a:Right(), -90)
	
	cam.Start3D2D(v, a, 0.1)
		surface.SetDrawColor(Color(0, 0, 0, 255))
		surface.DrawRect(0, 0, 260, 200)
		
		surface.SetFont("RPNormal_25")
		surface.SetTextPos(25, 25)
		surface.SetTextColor(Color(255, 255, 255, 255))
		surface.DrawText("Preis pro Liter")
		
		surface.SetFont("RPNormal_25")
		surface.SetTextPos(25, 50)
		surface.SetTextColor(Color(255, 100, 100, 255))
		surface.DrawText("$" .. tostring(ECONOMY.GASPREIS))
		
		surface.SetFont("RPNormal_25")
		surface.SetTextPos(25, 100)
		surface.SetTextColor(Color(255, 255, 255, 255))
		surface.DrawText("Getankte Liter:")
		
		surface.SetFont("RPNormal_25")
		surface.SetTextPos(145, 100)
		surface.SetTextColor(Color(255, 255, 255, 255))
		surface.DrawText(tostring(self.dt.tanked_liters) .. "/L")
		
		surface.SetFont("RPNormal_25")
		surface.SetTextPos(25, 125)
		surface.SetTextColor(Color(255, 255, 255, 255))
		surface.DrawText("Kosten:")
		
		local kosten = (self.dt.tanked_liters * Gas_Table.gas_price)
		
		surface.SetFont("RPNormal_25")
		surface.SetTextPos(90, 125)
		surface.SetTextColor(Color(255, 255, 255, 255))
		surface.DrawText("$" .. tostring(math.Round(kosten)))
	cam.End3D2D()
end

usermessage.Hook("RefreshGasPrice", function( data )
	local price = data:ReadString()

	Gas_Table.gas_price = tonumber(price)
end)