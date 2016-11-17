// insert coin here...

function Open_JobGarage()
	local w, h = 500, 500
	local t = LocalPlayer():Team()
	local cars = GAMEMODE.TEAMS[LocalPlayer():Team()].CarType or {}
	local job_info = GAMEMODE.TEAMS[LocalPlayer():Team()]

	local frame = vgui.Create( "DFrame" )
	frame:SetSize( w, h )
	frame:SetPos( (ScrW() - w)/2, (ScrH() - h)/2 )
	frame:SetTitle( "" )
	frame:MakePopup()
	frame.Paint = function( self )
		draw.RoundedBox( 0, 0, 0, w, h, HUD_SKIN.THEME_BGCOLOR )
		draw.RoundedBox( 0, 0, 0, w, 50, HUD_SKIN.THEME_COLOR )
		
		draw.SimpleText( "Wähle ein Auto", "RPNormal_30", 10, 10, Color( 255, 255, 255, 255 ) )
	end

	local close = vgui.Create( "DButton", frame )
	close:SetSize( 100, 25 )
	close:SetPos( frame:GetWide() - 100, 0 )
	close:SetText( "" )
	close.DoClick = function() frame:Remove() end
	close.Paint = function()
		draw.RoundedBox( 0, 0, 0, close:GetWide(), close:GetTall(), HUD_SKIN.FULL_GREY )
		surface.SetFont( "RPNormal_25" )
		local w, h = surface.GetTextSize( "Close" )
		draw.SimpleText( "Close", "RPNormal_25", (close:GetWide() - w)/2, (close:GetTall() - h)/2, Color( 255, 255, 255, 255 ) )
	end

	local l = vgui.Create( "DPanelList", frame )
	l:SetPos( 0, 50 )
	l:SetSize( w, h - 50 )
	l:SetSpacing( 0 )
	l:EnableHorizontal( false )
	l:EnableVerticalScrollbar( true )
	l.VBar.Paint = function() end
	l.VBar.btnUp.Paint = function() end
	l.VBar.btnDown.Paint = function() end
	l.VBar.btnGrip.Paint = function() 
		draw.RoundedBox( 2, 0, 0, item_list.VBar:GetWide(), item_list.VBar:GetTall(), Color( 0, 0, 0, 50 ) )
	end

	local i = 0
	for k, v in pairs( cars ) do
		local col = HUD_SKIN.LIST_BG_FIRST
		local info = list.Get("Vehicles")[k] or nil
		
		if info == nil then continue end
		
		i = i + 1
		if i > 1 then col = HUD_SKIN.LIST_BG_SECOND i = 1 end
		
		local p = vgui.Create( "DPanel", frame )
		p:SetSize( w, l:GetTall()/4 )
		p:SetPos( 0, 0 )
		p.Paint = function( self )
			draw.RoundedBox( 0, 0, 0, p:GetWide(), p:GetTall(), col )
			
			draw.SimpleText( info.Name, "RPNormal_28", p:GetTall() + 25, 25, HUD_SKIN.FULL_GREY )
			draw.SimpleText( v, "RPNormal_20", p:GetTall() + 25, 50, HUD_SKIN.FULL_GREY )
			
			local cars = GetGlobalInt( "SpawnedCars_" .. tostring( LocalPlayer():Team() ) ) or nil
			if cars == nil then return end
			
			draw.SimpleText( tostring( cars ) .. "/" .. job_info.MaxCars, "RPNormal_40", p:GetWide() - 15, p:GetTall()/2, Color( 0, 0, 0, 100 ), 2, 1 )
		end
		
		local icon = vgui.Create( "DModelPanel", p )
		icon:SetModel( info.Model )
		icon:SetPos( 0, 0 )
		icon:SetSize( p:GetTall(), p:GetTall() )
		local ent = icon:GetEntity()
		local max, min = icon:GetEntity():GetRenderBounds()
		icon:SetCamPos( Vector( 0.5, 0.4, 0.3 ) * min:Distance( max ) )
		   icon:SetLookAt( ( min + max )/2 )
		
		local spawn = vgui.Create( "DButton", p )
		spawn:SetPos( 0, 0 )
		spawn:SetSize( p:GetWide(), p:GetTall() )
		spawn:SetText( "" )
		spawn.Paint = function() end
		spawn.DoClick = function( self )
			frame:Remove()
			
			print( k )
			
			net.Start( "NPC_ClaimJobCar" )
				net.WriteString( k )
			net.SendToServer()
		end
		
		l:AddItem( p )
	end
end