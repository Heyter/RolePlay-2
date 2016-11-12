local function OpenContextMenu( tab )
	local ply = tab.ply
	local context = DermaMenu()
	
	context:AddOption("Name Kopieren", function() SetClipboardText(ply:Nick()) end):SetImage("icon16/user_edit.png")
	context:AddOption("SteamID Kopieren", function() SetClipboardText(ply:SteamID()) end):SetImage("icon16/tag_blue.png")
	context:AddOption("Steam Community Profil", function() ply:ShowProfile() end):SetImage("icon16/world.png")
	context:AddOption("GMODWeb Profil", function() gui.OpenURL( "http://gextension.epic-gaming.de/?t=user&id=" .. ply:SteamID64()) end):SetImage("icon16/vcard.png")

	if LocalPlayer():IsUserGroup("operator") or LocalPlayer():IsUserGroup("moderator") or LocalPlayer():IsUserGroup("superadmin") or LocalPlayer():IsUserGroup("supporter") then  
		local admintools,menuimg = context:AddSubMenu("Admin")
		menuimg:SetImage("icon16/shield.png")
		admintools:AddOption("Kick", function() Derma_StringRequest( "Kick Grund", "Grund des kicks", "", function(r) RunConsoleCommand("ulx","kick",ply:Nick(),r) end, nil, "Kick", "Abbechen" ) end):SetImage("icon16/door_out.png")
		admintools:AddOption("Ban", function() Derma_StringRequest( "Ban Grund", "Grund des Banns", "", function(r)  
			Derma_StringRequest("Ban Länge", "Gib die Länge des Banns an", ScoreboardConfig.BanTime, function(t)
				RunConsoleCommand("ulx","ban",ply:Nick(),t,r) end , nil, "Okay", "Cancel") end, nil, "Ban", "Abbechen" ) end):SetImage("icon16/door_out.png")

		--admintools:AddSpacer()

		admintools:AddOption("Slay", function() RunConsoleCommand("ulx","slay",ply:Nick()) end):SetImage("icon16/bomb.png")
		--if ScoreboardConfig.SlayNR then
		--  admintools:AddOption("Slay Next Round", function () RunConsoleCommand("ulx", "slaynr", ply:Nick(), 1) end):SetImage("icon16/controller_delete.png")
		--end

		admintools:AddSpacer()

		admintools:AddOption("Mute", function() RunConsoleCommand("ulx","mute",ply:Nick()) end):SetImage("icon16/box.png")
		admintools:AddOption("Gag", function() RunConsoleCommand("ulx","gag",ply:Nick()) end):SetImage("icon16/bell_delete.png")

		admintools:AddSpacer()
	   
		admintools:AddOption("AFK", function() RunConsoleCommand("ulx","afk",ply:Nick()) end):SetImage("icon16/zoom.png")
		admintools:AddOption("Verwarnen", function() Derma_StringRequest( "Verwarn Grund", "Was soll in der Verwarnung stehen", "", function(r) RunConsoleCommand("gex_warn",ply:SteamID64(),r) end, nil, "Verwarnen", "Abbechen" ) end):SetImage("icon16/exclamation.png")

		admintools:AddSpacer()

		admintools:AddOption("Spectate", function() RunConsoleCommand("ulx","spectate",ply:Nick()) end):SetImage("icon16/zoom.png")

		admintools:AddSpacer()
	end
end



function OpenScroeboard()
    local score_w = ScrW()/1.6
    local score_h = ScrH()/1.2

    // Color shit
    local score_bg_color = Color( 230, 230, 230, 255 )
    local score_rawinfo_bg = Color( 50, 50, 50, 230 )
    local raw_textcolor = Color( 30, 30, 30, 200 )
    local raw_colors = {Color(200,200,200,150), Color(220,220,220,150)}

    local score_frame = vgui.Create( "DFrame" )
    score_frame:SetSize( score_w, score_h )
    score_frame:SetTitle( "" )
    score_frame:Center()
    score_frame:MakePopup()
    score_frame:ShowCloseButton( false )
    score_frame:SetDraggable( false )
    score_frame.Paint = function()
        local text = ""
        draw.RoundedBox( 4, 0, 0, score_w, score_h, score_bg_color )
        draw.RoundedBox( 0, 0, ScrH()/6, score_w, 30, score_rawinfo_bg )
        draw.RoundedBox( 0, 0, 0, score_w, 30, score_rawinfo_bg )
        
        ECONOMY.CITY_CASH = ECONOMY.CITY_CASH or 0
        ECONOMY.LAST_CITY_CASH = ECONOMY.LAST_CITY_CASH or 0
        
        //Economy
        draw.RoundedBox( 8, score_w/2 - (score_w/3)/2, -10, score_w/3, 70, Color( 90, 90, 90, 255 ) )
        text = SETTINGS.SCOREBOARD_TITLE
        surface.SetFont( "RPNormal_25" )
        local w, h = surface.GetTextSize( text )
        draw.SimpleText( text, "RPNormal_25", (score_w - w)/2, 5, score_bg_color )
        text = SETTINGS.SCOREBOARD_SUBTITLE
        surface.SetFont( "RPNormal_25" )
        local w, h = surface.GetTextSize( text )
        draw.SimpleText( text, "RPNormal_25", (score_w - w)/2, 30, score_bg_color )
        
        // Top
        draw.SimpleText( "Steuer: " .. ECONOMY.KAUFSTEUER .. "%", "RPNormal_25", 10, score_h/7.2, raw_textcolor )
        draw.SimpleText( "Zahltagssteuer: " .. ECONOMY.PAYDAY_STEUER .. "%", "RPNormal_25", 10, score_h/6, raw_textcolor )
        
        text = "Players Online: " .. tostring(#player.GetAll())
        surface.SetFont( "RPNormal_25" )
        local w, h = surface.GetTextSize( text )
        draw.SimpleText( text, "RPNormal_25", (score_w - w) - 30, score_h/6, raw_textcolor )
        
        
        // Info
        draw.SimpleText( "Name", "RPNormal_25", 25, ScrH()/6 + 3, score_bg_color )
        draw.SimpleText( "Premium", "RPNormal_25", score_w/2, ScrH()/6 + 3, score_bg_color )
        draw.SimpleText( "Ping", "RPNormal_25", score_w - 55, ScrH()/6 + 3, score_bg_color )
    end

    --local logo = vgui.Create("DImage", score_frame)
    --logo:SetImage( "roleplay/scoreboard/logo_nos.png" )
    --logo:SetPos( 5, 25 )
    --logo:SetSize( 340, 60 )

    local bg_image = vgui.Create("DImage", score_frame)
    bg_image:SetImage( "roleplay/scoreboard/ig_logo.png" )
    bg_image:SetPos( (score_w - 512) / 2, ((score_h + ScrH()/6 + 30) - 512) / 2 )
    bg_image:SizeToContents()

    local raw_list = vgui.Create( "DPanelList", score_frame )
    raw_list:SetPos( 0, ScrH()/6 + 30 )
    raw_list:SetSize( score_w, score_h - raw_list:GetTall() )
    raw_list:SetSpacing( 0 ) -- Spacing between items
    raw_list:EnableHorizontal( false ) -- Only vertical items
    raw_list:EnableVerticalScrollbar( true ) -- Allow scrollbar if you exceed the Y axis
    raw_list.VBar.Paint = function() end
    raw_list.VBar.btnUp.Paint = function() end
    raw_list.VBar.btnDown.Paint = function() end
    raw_list.VBar.btnGrip.Paint = function() 
        draw.RoundedBox( 2, 0, 0, raw_list.VBar:GetWide(), raw_list.VBar:GetTall(), Color( 0, 0, 0, 50 ) )
    end

    local i = 0
    for k, v in pairs( player.GetAll() ) do
        i = i + 1
        if i > 2 then i = 1 end
        local raw = vgui.Create( "DButton", raw_list )
		raw.ply = v
        raw.i = i
        raw.ping = v:Ping()
		raw:SetText( "" )
        raw:SetSize( score_w, 30 )
        raw:SetPos( 0, 0 )
        raw.Paint = function()
			local col = team.GetColor( v:Team()  )
			col.a = 150
			
            draw.RoundedBox( 0, 0, 0, raw:GetWide(), raw:GetTall(), raw_colors[raw.i] )
            draw.RoundedBox( 0, 0, 0, 6, raw:GetTall(), col  )
            
            if LocalPlayer():IsAdmin() then 
                draw.SimpleText( (v:GetRPVar( "rpname" ) or "Unbekannt") .. " - ( " .. v:Nick() .. " )", "RPNormal_25", 25, 3, raw_textcolor )
            else
                draw.SimpleText( v:GetRPVar( "rpname" ), "RPNormal_25", 25, 3, raw_textcolor )
            end
            //  VIP Display
            if v:IsUserGroup( "vip_1" ) then
                draw.SimpleText( "Bronze", "RPNormal_25", score_w/2, 3, Color( 102, 51, 0, 200 ) )
            elseif v:IsUserGroup( "vip_2" ) then
                draw.SimpleText( "Silber", "RPNormal_25", score_w/2, 3, Color( 102, 102, 102, 200 ) )
            elseif v:IsUserGroup( "vip_3" ) then
                draw.SimpleText( "Gold", "RPNormal_25", score_w/2, 3, Color( 255, 204, 51, 230 ) )
            else
                draw.SimpleText( "-", "RPNormal_25", score_w/2, 3, raw_textcolor )
            end
            
            // Ping shit
            draw.RoundedBox( 0, score_w - 50, raw:GetTall() - 10, 4, 5, Color( 0, 0, 0, 50 ) )
            draw.RoundedBox( 0, score_w - 45, raw:GetTall() - 15, 4, 10, Color( 0, 0, 0, 50 ) )
            draw.RoundedBox( 0, score_w - 40, raw:GetTall() - 20, 4, 15, Color( 0, 0, 0, 50 ) )
            draw.RoundedBox( 0, score_w - 35, raw:GetTall() - 25, 4, 20, Color( 0, 0, 0, 50 ) )
            
            if v:Ping() < 200 then
                draw.RoundedBox( 0, score_w - 50, raw:GetTall() - 10, 4, 5, Color( 0, 200, 0, 200 ) )
            end
            if v:Ping() < 100 then
                draw.RoundedBox( 0, score_w - 45, raw:GetTall() - 15, 4, 10, Color( 0, 200, 0, 200 ) )
            end
            if v:Ping() < 40 then
                draw.RoundedBox( 0, score_w - 40, raw:GetTall() - 20, 4, 15, Color( 0, 200, 0, 200 ) )
            end
            if v:Ping() < 20 then
                draw.RoundedBox( 0, score_w - 35, raw:GetTall() - 25, 4, 20, Color( 0, 200, 0, 200 ) )
            end
        end
        raw.Think = function()
            raw.ping = v:Ping()
        end
		raw:DoClick = function( self)
			OpenContextMenu( self )
		end
		
        raw_list:AddItem( raw )
        
    end
    return score_frame
end

--[[---------------------------------------------------------
   Name: gamemode:ScoreboardShow( )
   Desc: Sets the scoreboard to visible
-----------------------------------------------------------]]
local g_Scoreboard = nil
function GM:ScoreboardShow()

    if ( !IsValid( g_Scoreboard ) ) then
        g_Scoreboard = OpenScroeboard()
    end
    
    if ( IsValid( g_Scoreboard ) ) then
        g_Scoreboard:Show()
        g_Scoreboard:MakePopup()
        g_Scoreboard:SetKeyboardInputEnabled( false )
    end

end

--[[---------------------------------------------------------
   Name: gamemode:ScoreboardHide( )
   Desc: Hides the scoreboard
-----------------------------------------------------------]]
function GM:ScoreboardHide()

    if ( IsValid( g_Scoreboard ) ) then
        g_Scoreboard:Close()
    end

end


--[[---------------------------------------------------------
   Name: gamemode:HUDDrawScoreBoard( )
   Desc: If you prefer to draw your scoreboard the stupid way (without vgui)
-----------------------------------------------------------]]
function GM:HUDDrawScoreBoard()

end
