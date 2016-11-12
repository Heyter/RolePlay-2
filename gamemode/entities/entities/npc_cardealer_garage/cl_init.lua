include ("shared.lua")

function ENT:Initialize()
end

function ENT:Draw()
    self:DrawModel()
	
	
		local maxdistance = 250
		local distance = LocalPlayer():GetPos():Distance( self:GetPos() )
		if distance > 500 then return true end
		local alpha = (255/maxdistance) * distance
		
		local offset = Vector( 0, 8.5, self:OBBCenter().z)
		local ang = self:GetAngles() + Angle( 0, -90, 0 )
		local pos = self:GetPos() + offset + ang:Up()
	 
		ang:RotateAroundAxis( ang:Forward(), 90 )
		ang:RotateAroundAxis( ang:Right(), 90 )
	 
		cam.Start3D2D(pos, ang, 0.1)
			draw.WordBox(2, -125, -135, "Garagen ATM", "RPNormal_25", Color(0, 0, 0, 255-alpha), Color(255,255,255,200-alpha))
			draw.WordBox(2, -130, -80, "Drücke E um zu integrieren", "RPNormal_25", Color(0, 0, 0, 255-alpha), Color(255,255,255,200-alpha))
			--draw.RoundedBox( 2, -125, -300, 250, 115, Color( 0, 0, 0, 255-alpha ) )
			/*
			LocalPlayer().garage_table = LocalPlayer().garage_table or {}
			if #LocalPlayer().garage_table == 0 then
				draw.SimpleText( "Keine Autos vorhanden!", "RPNormal_25", -115, -238, Color( 255, 255, 255, 100-alpha ), true, true )
			end
			for k, v in pairs( LocalPlayer().garage_table or {} ) do
				local data = GetCarInfo( v.carname)
				draw.RoundedBox( 2, -115, -(300 - ((10*k) + (25*(k-1)))), 230, 25, Color( v.col_red, v.col_green, v.col_blue, 100-alpha ) )
				if data == nil then continue end
				draw.SimpleTextOutlined( data.name, "Trebuchet13", -52, -(289 - ((10*k) + (25*(k-1)))), Color( 255, 255, 255, 255-alpha ), 1, 1, 1, Color( 0, 0, 0, 255-alpha ) )
				draw.RoundedBox( 2, 45, -(295 - ((10*k) + (25*(k-1)))), 60, 15, Color( 0, 0, 0, 255-alpha ) )
				local rech = (60/data.fuel)*v.fuel
				draw.RoundedBox( 2, 47, -(293 - ((10*k) + (25*(k-1)))), rech - 4, 11, Color( 0, 255, 0, 255-alpha ) )
				draw.SimpleTextOutlined( "Tank:", "Trebuchet11", 28, -(288 - ((10*k) + (25*(k-1)))), Color( 255, 255, 255, 255-alpha ), 1, 1, 1, Color( 0, 0, 0, 255-alpha ) )
			end
			*/
		cam.End3D2D()
end

function ENT:Think()

end

net.Receive( "opengaragemenu", function()
	local garage_table = LocalPlayer().garage_table or {}
	local garage = vgui.Create( "DFrame" )
	garage:SetSize( 550, 350 )
	garage:SetTitle( "" )
	garage:Center()
	garage:MakePopup()
	garage.Paint = function()
		draw.RoundedBox( 6, 0, 0, garage:GetWide(), garage:GetTall(), Color( 80, 80, 80, 200 ) )
	end

	local back_top = vgui.Create( "DPanel", garage )
	back_top:SetPos( 10, 30 )
	back_top:SetSize( garage:GetWide() - 20, garage:GetTall()/ 2 )
	back_top.Paint = function()
		draw.RoundedBox( 0, 0, 0, back_top:GetWide(), back_top:GetTall(), Color( 80, 80, 80, 230 ) )
	end

	local info_tall = (garage:GetTall() - 30) - (back_top:GetTall() + 20)
	local info_bot = vgui.Create( "DPanel", garage )
	info_bot:SetPos( 10, 30 + (back_top:GetTall() + 10) )
	info_bot:SetSize( garage:GetWide() - 20, info_tall )
	info_bot.Paint = function()
		draw.RoundedBox( 0, 0, 0, info_bot:GetWide(), info_bot:GetTall(), Color( 80, 80, 80, 230 ) )
	end

	-------------------------------------------------------
	--  InfoPanel
	-------------------------------------------------------
	local info_1 = vgui.Create( "DLabel", info_bot )
	info_1:SetFont( "Trebuchet24" )
	info_1:SetColor( Color( 255, 255, 255, 200 ) )
	info_1:SetPos( 10, 10 )
	info_1:SetText( "" )

	local info_2 = vgui.Create( "DLabel", info_bot )
	info_2:SetFont( "Trebuchet24" )
	info_2:SetColor( Color( 255, 255, 255, 200 ) )
	info_2:SetPos( 10, 35 )
	info_2:SetText( "" )

	local info_3 = vgui.Create( "DLabel", info_bot )
	info_3:SetFont( "Trebuchet24" )
	info_3:SetColor( Color( 255, 255, 255, 200 ) )
	info_3:SetPos( 10, 60 )
	info_3:SetText( "" )

	-------------------------------------------------------
	--  CarPanels
	-------------------------------------------------------
	for i=1, 3 do
		if i > #garage_table then continue end
		
		local car_info = GetCarInfo( garage_table[i].carname )
		
		local pp = back_top:GetWide()/3
		local x, y = pp*(i-1), 25
		local w, t = 128, 128
		
		local carpanel = vgui.Create( "DPanel", back_top )
		carpanel:SetSize( w, t )
		carpanel:SetPos( x + 25, y )
		carpanel.Paint = function()
			local col
			if garage_table[i].health > 50 then col = Color( 0, 150, 0, 255 ) else col = Color( 150, 0, 0, 255 ) end
			
			draw.RoundedBox( 0, 0, 0, carpanel:GetWide(), carpanel:GetTall(), col )
		end
		
		local carpanel2 = vgui.Create( "DPanel", carpanel )
		carpanel2:SetSize( 120, 120 )
		carpanel2:SetPos( 4, 4 )
		carpanel2.Paint = function()
			draw.RoundedBox( 0, 0, 0, carpanel2:GetWide(), carpanel2:GetTall(), Color( 50, 50, 50, 255 ) )
		end
		
		local icon = vgui.Create( "DModelPanel", carpanel )
		icon:SetModel( garage_table[i].model )
		icon:SetColor( Color(garage_table[i].col_red, garage_table[i].col_green, garage_table[i].col_blue, 255) )
		icon:SetPos( 4, 4 )
		icon:SetSize( 120, 120 )
		icon:SetCamPos( Vector( 0, 170, 110 ) )
		icon:SetLookAt( Vector( 0, 0, 0 ) )
		
		local button = vgui.Create( "DButton", carpanel )
		button:SetPos( 4, 4 )
		button:SetSize( 120, 120 )
		button:SetText( "" )
		button.Paint = function() end
		button.DoClick = function()
			net.Start( "spawn_garagecar" )
				net.WriteString( garage_table[i].carname )
			net.SendToServer()
			surface.PlaySound( "buttons/button18.wav" )
		end
		button.OnCursorEntered = function()
			info_1:SetText( "Name: " .. car_info.name)
			info_1:SizeToContents()
			info_2:SetText( "Kennzeichen: " .. garage_table[i].car_number)
			info_2:SizeToContents()
			info_3:SetText( "Tank: " .. tostring((car_info.fuel/100)*garage_table[i].fuel) .. "%" )
			info_3:SizeToContents()
			surface.PlaySound( "buttons/button16.wav" )
		end
	end
end)
