ENT.Spawnable			= true
ENT.AdminSpawnable		= true

include('shared.lua')

function ENT:Draw()
	self:DrawModel()
	
	local a = self:GetAngles()
	local v = self:GetPos()
	v = v + self:GetUp() * 2
	v = v + self:GetForward() * -4
	v = v + self:GetRight() * -5
	
	a:RotateAroundAxis(a:Right(), 0)
	
	if IsValid( self:GetNWEntity("Parent") ) then
		local tnk = self:GetNWEntity("Parent").dt.tanked_liters or 0
		surface.SetFont("RPNormal_25")
		local len = surface.GetTextSize(tostring(tnk) .. "/L") / 2
		
		local pos = self:GetPos():ToScreen()
	
		if tnk > 1 then
			hook.Add("HUDPaint", "brhesh", function()
			if LocalPlayer():GetPos():Distance(self:GetPos()) < 100 && IsValid( self.dt.vehicle ) then
				surface.SetFont("RPNormal_25")
				surface.SetTextPos(pos.x - len, pos.y)
				surface.SetTextColor(Color(255, 255, 255, 255))
				surface.DrawText("Tank: ")
				
				surface.SetFont("RPNormal_25")
				surface.SetTextPos(pos.x - len, pos.y + 50)
				surface.SetTextColor(Color(255, 100, 100, 255))
				surface.DrawText("Getanke Liter: " .. tostring(tnk) .. "/L")
				
				local calc = (100 / 250) * (self.dt.vehicle:GetNWInt("Fuel") or 0)
				
				draw.RoundedBox( 4, pos.x - len, pos.y + 25, 100, 25, Color(255,255,255,255) )
				draw.RoundedBox( 2, pos.x - len + 4, pos.y + 25 + 4, calc -8, 25 - 8, Color(100,100,100,255) )
			end
			end)
		end
	end
end


function ENT:Initialize()
end

function ENT:Think()
end

function ENT:OnRestore()
end
