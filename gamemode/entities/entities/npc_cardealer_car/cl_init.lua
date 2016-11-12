include ("shared.lua")

function ENT:Initialize()
end

function ENT:Draw()
    self:DrawModel()
	LocalPlayer().lastcarinforequest = LocalPlayer().lastcarinforequest or CurTime()
	if !(self.carinfo) && LocalPlayer().lastcarinforequest < CurTime() then
		net.Start( "request_car_data" )
		net.SendToServer()
		LocalPlayer().lastcarinforequest = CurTime() + 2
	end
	if self.carinfo then
		local maxdistance = 350
		local distance = LocalPlayer():GetPos():Distance( self:GetPos() )
		if distance > 500 then return true end
		local alpha = (255/maxdistance) * distance
		
		local offset = Vector( 0, 0, (self:OBBCenter().z*2 + 15) + math.sin( CurTime()*2 ) )
		local ang = LocalPlayer():EyeAngles()
		local pos = self:GetPos() + offset + ang:Up()
	 
		ang:RotateAroundAxis( ang:Forward(), 90 )
		ang:RotateAroundAxis( ang:Right(), 90 )
	 
		cam.Start3D2D( pos, Angle( 0, ang.y, 90 ), 0.25 )
			draw.DrawText( self.carinfo.name, "RPNormal_32", 0, -2, Color( 255, 255, 255, 300 - alpha ), TEXT_ALIGN_CENTER )
			if LocalPlayer():CanAfford( self.carinfo.cost ) then
				draw.DrawText( tostring(self.carinfo.cost) .. "$", "RPNormal_27", 0, 25, Color( 0, 255, 0, 300 - alpha ), TEXT_ALIGN_CENTER )
			else
				draw.DrawText( tostring(self.carinfo.cost) .. "$", "RPNormal_27", 0, 25, Color( 255, 0, 0, 300 - alpha ), TEXT_ALIGN_CENTER )
			end
			draw.DrawText( "Schadensaufnahme:", "Default", -60, 50, Color( 255, 255, 255, 300 - alpha ), TEXT_ALIGN_CENTER )
			draw.RoundedBox( 2, 0, 50, 100, 15, Color( 0, 0, 0, 300 - alpha ) )
			local rech = (100/800)*self.carinfo.hp
			draw.RoundedBox( 2, 2.5, 51, rech - 5, 12.5, Color( 200, 0, 0, 300 - alpha ) )
		cam.End3D2D()
	end
end

function ENT:Think()

end

net.Receive( "openaskmenu", function()
	local car = net.ReadEntity()
	Derma_Query( "Haben sie Interesse an diesen Wagen? Wenn ja wählen sie eines der Aktionen aus.", "Authaus", "Auto Kaufen", function() net.Start( "buycar" ) net.WriteEntity( car ) net.SendToServer() end, "Auto Testfahren", function() net.Start( "testcar" ) net.WriteEntity( car ) net.SendToServer() end, "Nichts tun", function() end)
end)
