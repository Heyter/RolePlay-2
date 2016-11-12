local entered = {player.GetAll()[1], player.GetAll()[2]}
local wahlzeit = CurTime() + 20

local function OpenMayorSelection()
    local vote_frame = vgui.Create( "DFrame" )
    vote_frame:SetTall( 350 )
    vote_frame:SetWide( 450 )
    vote_frame:Center()
    vote_frame:MakePopup()
    vote_frame:SetTitle( "" )
    vote_frame.Paint = function()
        draw.RoundedBox( 0, 0, 0, vote_frame:GetWide(), vote_frame:GetTall(), Color( 230, 230, 230, 255 ) )
        draw.RoundedBox( 0, 0, 0, vote_frame:GetWide(), 50, HUD_SKIN.THEME_COLOR )
        draw.SimpleText( "Mayor Wahl", "RPNormal_28", 10, 2, Color( 255, 255, 255, 255 ) )
        draw.SimpleText( "Die Wahl eines falschen Mayors kann schlechte Zeiten fÃ¼r die Stadt bedeuten.", "RPNormal_20", 10, 25, Color( 255, 255, 255, 255 ) )
        draw.SimpleText( "Wahlzeit: " .. math.Round((wahlzeit - CurTime())) .. " Sekunden", "RPNormal_20", 10, 52, Color( 0, 0, 0, 200 ) )
        if wahlzeit - CurTime() < 0 then vote_frame:Close() end
    end

    local vote_list = vgui.Create( "DPanelList", vote_frame )
    vote_list:SetPos( 0, 75 )
    vote_list:SetSpacing( 0 )
    vote_list:EnableHorizontal( false )
    vote_list:EnableVerticalScrollbar( true )
    vote_list:SetTall( vote_frame:GetTall() - 75 )
    vote_list:SetWide( vote_frame:GetWide() )

    local i = 0
    for k, v in pairs( entered ) do
        local col = HUD_SKIN.LIST_BG_FIRST
        i = i + 1
        if i == 2 then col = HUD_SKIN.LIST_BG_SECOND i=0 end
        
        local enter_item = vgui.Create( "DButton", vote_list )
        enter_item:SetTall( vote_list:GetTall()/4 )
        enter_item:SetWide( vote_list:GetWide() )
        enter_item:SetText( "" )
        enter_item.col = col
        enter_item.l1 = nil
        enter_item.l2 = nil
        enter_item.l3 = nil
        enter_item.Paint = function( )
            draw.RoundedBox( 0, 0, 0, enter_item:GetWide(), enter_item:GetTall(), enter_item.col )
        end
        enter_item.OnCursorEntered = function()
            if IsValid( enter_item.l1 ) then enter_item.l1:Hide() end
            if IsValid( enter_item.l2 ) then enter_item.l2:Hide() end
            if IsValid( enter_item.l3 ) then enter_item.l3:Show() end
        end
        enter_item.OnCursorExited = function()
            if IsValid( enter_item.l1 ) then enter_item.l1:Show() end
            if IsValid( enter_item.l2 ) then enter_item.l2:Show() end
            if IsValid( enter_item.l3 ) then enter_item.l3:Hide() end
        end
        enter_item.DoClick = function()
            net.Start( "SendMayorDecision" )
                net.WriteEntity( v )
            net.SendToServer()
            vote_frame:Close()
        end
        
        local icon_panel = vgui.Create( "DPanel", enter_item )
        icon_panel:SetPos( 5, 5 )
        icon_panel:SetSize( enter_item:GetTall() - 10, enter_item:GetTall() - 10 )
        icon_panel.Paint = function()
            draw.RoundedBox( 0, 0, 0, icon_panel:GetWide(), icon_panel:GetTall(), Color( 0, 0, 0, 150 ) )
        end
         
        local icon = vgui.Create( "DModelPanel", enter_item )
        icon:SetModel( v:GetModel() )
        icon:SetPos( 5, 5 )
        icon:SetSize( enter_item:GetTall() - 10, enter_item:GetTall() - 10 )
        icon:SetCamPos( Vector( 10, 10, 65 ) )
        icon:SetLookAt( Vector( 0, 0, 65 ) )
        function icon:LayoutEntity(Entity)
                Entity:SetAngles(Angle(0,50,0))
        end
        
        local p_name = vgui.Create( "DLabel", enter_item )
        p_name:SetPos( enter_item:GetTall() + 10, 10 )
        p_name:SetFont( "RPNormal_25" )
        p_name:SetText( (v:GetRPVar( "rpname" ) or v:Nick()) )
        p_name:SetColor( Color( 0, 0, 0, 200 ) )
        p_name:SizeToContents()
        enter_item.l1 = p_name
        
        local p_name2 = vgui.Create( "DLabel", enter_item )
        p_name2:SetPos( enter_item:GetTall() + 10, 35 )
        p_name2:SetFont( "RPNormal_20" )
        p_name2:SetText( "Dieser Spieler hat bereits " .. (v:GetRPVar( "playtime" ) or "0") .. " Minuten auf diesen Server Gespielt." )
        p_name2:SetColor( Color( 0, 0, 0, 200 ) )
        p_name2:SizeToContents()
        enter_item.l2 = p_name2
        
        surface.SetFont( "RPNormal_30" )
        local w, h = surface.GetTextSize( "Klicke um diesen Spieler zu WÃ¤hlen!")
        local p_name3 = vgui.Create( "DLabel", enter_item )
        p_name3:SetPos( w/2 - enter_item:GetTall(), (enter_item:GetTall() - h)/2 )
        p_name3:SetFont( "RPNormal_30" )
        p_name3:SetText( "Klicke um diesen Spieler zu WÃ¤hlen!" )
        p_name3:SetColor( Color( 0, 0, 0, 200 ) )
        p_name3:SizeToContents()
        p_name3:Hide()
        enter_item.l3 = p_name3
        
        vote_list:AddItem( enter_item )
    end
end

net.Receive( "MayorSelectionStart", function()
    entered = net.ReadTable()
    wahlzeit = CurTime() + 20
    OpenMayorSelection()
end)
