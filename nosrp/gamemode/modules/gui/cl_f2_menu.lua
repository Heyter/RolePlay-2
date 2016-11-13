f2_menu = {}
f2_menu_cache = {}
f2_menu_cache.panel = {}
f2_menu_cache.curpanel = {}
f2_menu_cache.active_panel = {}

/*------------------------
    Lets create the Panel!
*/------------------------
function CreateF2Menu()
    f2_menu = vgui.Create( "DFrame" )
    f2_menu:SetWide( 1107 ) --ScrW()/1.3 )
    f2_menu:SetTall( 600 ) --ScrH()/1.5 )
    f2_menu:SetTitle( "" )
    f2_menu:Center()
    f2_menu:MakePopup()
    f2_menu.visible = true
    f2_menu.Paint = function()
        draw.RoundedBox( 6, 0, 0, f2_menu:GetWide(), f2_menu:GetTall(), HUD_SKIN.THEME_BGCOLOR )
        draw.RoundedBox( 2, 0, 0, f2_menu:GetWide(), (f2_menu:GetTall()/6), HUD_SKIN.THEME_COLOR )
        draw.RoundedBox( 2, 0, (f2_menu:GetTall()/6) - 2, f2_menu:GetWide(), 2, Color( 0, 102, 204, 50 ) )
        draw.SimpleText( "EPG RP - Menu", "RPNormal_54", 25, f2_menu:GetTall()/24, Color( 255, 255, 255, 255 ) )
    end
    
    f2_menu.HideBtn = vgui.Create( "DButton", f2_menu )
    f2_menu.HideBtn:SetSize( 100, 25 )
    f2_menu.HideBtn:SetPos( f2_menu:GetWide() - 100, 0 )
    f2_menu.HideBtn:SetText( "" )
    f2_menu.HideBtn.DoClick = function() 
        f2_menu:Hide() 
        f2_menu.visible = false
    end
    f2_menu.HideBtn.Paint = function()
        draw.RoundedBox( 0, 0, 0, f2_menu.HideBtn:GetWide(), f2_menu.HideBtn:GetTall(), HUD_SKIN.FULL_GREY )
        surface.SetFont( "RPNormal_25" )
        local w, h = surface.GetTextSize( "Close" )
        draw.SimpleText( "Close", "RPNormal_25", (f2_menu.HideBtn:GetWide() - w)/2, (f2_menu.HideBtn:GetTall() - h)/2, Color( 255, 255, 255, 255 ) )
    end
    
    
    f2_menu.ButtonList = vgui.Create( "DPanelList", f2_menu )
    f2_menu.ButtonList:SetSize( 180, f2_menu:GetTall() - f2_menu:GetTall()/6 )
    f2_menu.ButtonList:SetPos( 0, (f2_menu:GetTall()) - f2_menu.ButtonList:GetTall() )
    f2_menu.ButtonList:SetSpacing( 0 )
    f2_menu.ButtonList:EnableHorizontal( false )
    f2_menu.ButtonList:EnableVerticalScrollbar( true )
    f2_menu.ButtonList.Paint = function()
        --draw.RoundedBox( 0, 0, 0, f2_menu.ButtonList:GetWide(), f2_menu.ButtonList:GetTall(), Color( 0, 0, 0, 255 ) )
    end
    f2_menu.ButtonList.VBar.Paint = function() end
    f2_menu.ButtonList.VBar.btnUp.Paint = function() end
    f2_menu.ButtonList.VBar.btnDown.Paint = function() end
    f2_menu.ButtonList.VBar.btnGrip.Paint = function() 
        draw.RoundedBox( 2, 0, 0, f2_menu.ButtonList.VBar:GetWide(), f2_menu.ButtonList.VBar:GetTall(), Color( 0, 0, 0, 50 ) )
    end
    
    
    /*---------------------------
        Lets create the Buttons
    */---------------------------
    f2_menu_cache.curpanel = {}
    f2_menu_cache.active_panel = {}
    
    for k, v in ipairs( f2_menu_cache.panel ) do
        local pnl = vgui.Create( "DPanel", f2_menu )
        pnl:SetPos( (f2_menu.ButtonList:GetWide()), f2_menu:GetTall() / 6 )
        pnl:SetWide( f2_menu:GetWide() - f2_menu.ButtonList:GetWide())
        pnl:SetTall( f2_menu.ButtonList:GetTall() )
        v.panel_func( pnl )

        local btn = vgui.Create( "DButton", f2_menu.ButtonList )
        btn:SetText( "" )
        btn:SetSize( f2_menu.ButtonList:GetWide(), f2_menu.ButtonList:GetTall()/3 )
        btn.panel = pnl
        btn.DoClick = function()
            if IsValid( f2_menu.curpanel ) then f2_menu.curpanel:Hide() end
            f2_menu.curpanel = btn.panel
            if IsValid( f2_menu.curpanel ) then f2_menu.curpanel:Show() end
        end
        btn.Paint = function()
           -- draw.RoundedBox( 0, 0, 0, btn:GetWide(), btn:GetTall(), Color( 220, 220, 220, 50 ) )
            --draw.RoundedBox( 0, 2, 2, btn:GetWide() - 4, btn:GetTall() - 4, Color( 240, 240, 240, 255 ) )
            draw.RoundedBox( 0, 0, 0, btn:GetWide(), 2, Color( 200, 200, 200, 50 ) )
            draw.RoundedBox( 0, 0, btn:GetTall() - 2, btn:GetWide(), 2, Color( 0, 0, 0, 50 ) )
            
            local font = "RPNormal_25"
            surface.SetFont( font )
            local w, h = surface.GetTextSize( v.text )
            
            draw.SimpleText( v.text, font, (btn:GetWide() / 2) - (w/2), btn:GetTall() - (h+2), Color( 0, 0, 0, 150 ) )
        end
        
        btn.image = vgui.Create("DImage", btn)
        btn.image:SetPos( (btn:GetWide() - 128)/2, 5 )
        btn.image:SetSize( 128, 128 )
        btn.image:SetImage( v.icon )

        f2_menu.ButtonList:AddItem( btn )
        table.insert( f2_menu_cache.active_panel, btn )
        
        for _, p in pairs( f2_menu_cache.active_panel ) do
            p.panel:Hide()
        end
        f2_menu_cache.active_panel[1].panel:Show()   // Show the first entity
    end
end

/*----------------------------
    Function to create the
    Buttons at the left.
*/----------------------------
function f2_menu.AddButton( text, icon, panel_func )
    table.insert( f2_menu_cache.panel, {text=text,icon=icon,panel_func=panel_func} )
end 

/*------------------------
    Opens the Panel
*/------------------------
function OpenF2Menu()
    if !(IsValid( f2_menu )) then CreateF2Menu() end
    f2_menu:Show() 
    f2_menu.visible = true
end

/*------------------------
    Closes the Panel
*/------------------------
function CloseF2Menu()
    if !(IsValid( f2_menu )) then CreateF2Menu() end
    f2_menu:Hide() 
    f2_menu.visible = false
end

hook.Add( "Think", "F2_OpenClose_Think", function()
	if input.IsKeyDown( KEY_Q ) then
		OpenF2Menu()
	else
		if !(f2_menu.visible) then return end
		CloseF2Menu()
	end	
end)

/*--------------------------
    Calls the open command
*/--------------------------
net.Receive("SCShowHelp", function(length, player)
    if !(f2_menu.visible) then 
       -- OpenF2Menu()
    else 
        --CloseF2Menu()
    end
end)


/*------------------------
    EXAMPLES
*/------------------------
f2_menu.AddButton( "Regeln", "roleplay/f2_menu/icons/rules_new.png", function( pnl ) 
    local image = vgui.Create("HTML", pnl)
    image:SetPos( 0, 0 )
    image:SetSize( pnl:GetWide(), pnl:GetTall() )
    image:OpenURL( "https://forum.epic-gaming.de/index.php?thread/228-epgrp-regeln/&postID=1512#post1512" )
end )
f2_menu.AddButton( "Inventar", "roleplay/f2_menu/icons/inventory_new.png", function( pnl )
	--local size = itemstore.config.InventorySizes[ "default" ]
    --local w, h = unpack( size )
    --local inv = itemstore.containers.Open( LocalPlayer().InventoryID, "", w, h )
    
    --inv:SetParent( pnl )
    --inv:ShowCloseButton( false )
    --inv:SetDraggable( false )
	
	local inv = vgui.Create( "ItemStoreContainerWindow" )
	inv:SetContainerID( LocalPlayer().InventoryID )
	inv:SetTitle( "" )
	inv:ShowCloseButton( false )
	inv:SetParent( pnl )
	inv:InvalidateLayout( true )
	
    --pnl.Container = vgui.Create( "ItemStoreContainer", pnl )
    --pnl.Container:SetSize( pnl:GetWide(), pnl:GetTall() ) 
    --pnl.Container:SetSize( 10 + ( itemstore.config.SlotSize[ 1 ] + 1 ) * columns - 1, ( itemstore.config.SlotSize[ 2 ] + 1 ) * rows + 33 )
    --pnl.Container:SetContainerID( 0 )
end )
f2_menu.AddButton( "Fertigkeiten", "roleplay/f2_menu/icons/skills_new.png", function( pnl ) 
    skill_list = vgui.Create( "DPanelList", pnl )
    skill_list:SetSize( pnl:GetWide(), pnl:GetTall() )
    skill_list:SetPos( 0, 0 )
    skill_list:SetSpacing( 0 )
    skill_list:EnableHorizontal( false )
    skill_list:EnableVerticalScrollbar( true )
    skill_list.Paint = function()
        draw.RoundedBox( 0, 0, 0, skill_list:GetWide(), skill_list:GetTall(), HUD_SKIN.THEME_BGCOLOR )
    end
    
    local buy_gens_pnl = vgui.Create( "DPanel", skill_list )
    buy_gens_pnl:SetSize( skill_list:GetWide(), skill_list:GetTall()/3 )
    buy_gens_pnl:SetPos( 0, 0 )
    buy_gens_pnl.w1 = 0
    buy_gens_pnl.w2 = 0
    buy_gens_pnl.Paint = function()
        draw.SimpleText( "Skill Punkte Kaufen oder Zurücksetzen", "RPNormal_35", 15, 5, Color( 100, 100, 100, 255 ) )
        draw.SimpleText( "Verfügbare Punkte:", "RPNormal_32", 15, 35, Color( 100, 100, 100, 255 ) )
        local col = Color( 180, 0, 0, 255 )
        if LocalPlayer():GetRPVar( "skill_points" ) > 0 then col = Color( 0, 180, 0, 255 ) end
        draw.SimpleText( LocalPlayer():GetRPVar( "skill_points" ), "RPNormal_32", 205, 35, col )
        
        local text = "Hier kannst du deine Skill Punkte für " .. LocalPlayer():GetSkillPointResetCost() .. ",-EUR Zurücksetzen oder"
        local font = "RPNormal_28"
        surface.SetFont( font )
        local w, h = surface.GetTextSize( text )
        draw.SimpleText( text, font, 15, 75, Color( 100, 100, 100, 255 ) )
        buy_gens_pnl.w1 = w
        
        text = "Für " .. LocalPlayer():GetSkillPointCost() .. ",-EUR ein neuen Skill-Punkt Kaufen."
        font = "RPNormal_28"
        surface.SetFont( font )
        w, h = surface.GetTextSize( text )
        draw.SimpleText( text, font, 15, 100, Color( 100, 100, 100, 255 ) )
        buy_gens_pnl.w2 = w
    end
    
    local reset_gen = vgui.Create( "DButton", buy_gens_pnl )
    reset_gen:SetText( "" )
    reset_gen:SetSize( 120, 25 )
    reset_gen.Paint = function()
        reset_gen:SetPos( buy_gens_pnl.w1 - 148, 76 )
        draw.RoundedBox( 0, 0, 0, reset_gen:GetWide(), reset_gen:GetTall(), HUD_SKIN.THEME_COLOR )
        text = "Zurücksetzen"
        font = "RPNormal_25"
        surface.SetFont( font )
        w, h = surface.GetTextSize( text )
        draw.SimpleText( text, font, ( reset_gen:GetWide() - w ) / 2, ( reset_gen:GetTall() - h )/2, Color( 255, 255, 255, 255 ) )
    end
    reset_gen.DoClick = function()
        net.Start( "RP_Reset_Gen" )
        net.SendToServer()
    end
    
    local buy_gen = vgui.Create( "DButton", buy_gens_pnl )
    buy_gen:SetText( "" )
    buy_gen:SetSize( 75, 25 )
    buy_gen.Paint = function()
        buy_gen:SetPos( buy_gens_pnl.w2 - 53, 102 )
        draw.RoundedBox( 0, 0, 0, buy_gen:GetWide(), buy_gen:GetTall(), HUD_SKIN.THEME_COLOR )
        text = "Kaufen"
        font = "RPNormal_25"
        surface.SetFont( font )
        w, h = surface.GetTextSize( text )
        draw.SimpleText( text, font, ( buy_gen:GetWide() - w ) / 2, ( buy_gen:GetTall() - h )/2, Color( 255, 255, 255, 255 ) )
    end
    buy_gen.DoClick = function()
        net.Start( "RP_Buy_Gen" )
        net.SendToServer()
    end
    
    skill_list:AddItem( buy_gens_pnl )

    local i = 0
    for k, v in pairs( SETTINGS.GeneTypes ) do
        local list_col = HUD_SKIN.LIST_BG_FIRST
        i = i + 1
        if i == 2 then list_col = HUD_SKIN.LIST_BG_SECOND i = 0 end
            
        local p = vgui.Create( "DPanel" )
        p:SetSize( skill_list:GetWide(), skill_list:GetTall()/3 )
        p:SetPos( 0, 0 )
        
        local left = p:GetWide()/10
        local bar_w, bar_h = p:GetWide() - (left*2), 45
        bar_w = bar_w - ( 5 + bar_h ) 
        
        local inner_left = p:GetWide()/10 + 4
        local inner_top = 110 + 4
        local inner_w = bar_w - 8
        local inner_h = bar_h - 8
        
        p.Paint = function() 
            
            draw.RoundedBox( 0, 0, 0, p:GetWide(), p:GetTall(), list_col )
            draw.SimpleText( v.name, "RPNormal_40", left, 25, Color( 100, 100, 100, 255 ) )
            draw.SimpleText( v.desc, "RPNormal_25", left, 65, Color( 100, 100, 100, 255 ) )
            
            draw.RoundedBox( 2, p:GetWide()/10, 110, bar_w, bar_h, Color( 100, 100, 100, 200 ) )
            
            local points = (LocalPlayer():GetRPVar( "skills_" .. v.name ) or 0)
            local font = "RPNormal_25"
            local text = math.Round(points) .. " / " .. v.max .. " Skill Punkte"
            surface.SetFont( font )
            local t_w, t_h = surface.GetTextSize( text )
            

            local p_w = (inner_w / (v.max or 0)) * points
            
            draw.RoundedBox( 2, inner_left, inner_top, p_w, inner_h, HUD_SKIN.THEME_COLOR ) 
            draw.SimpleText( text, font, (left + bar_w) - (15 + t_w), inner_top + 5, Color( 255, 255, 255, 255 ) )
        end
        
        if v.can_skill then
            local add = vgui.Create( "DButton", p )
            add:SetSize( bar_h, bar_h )
            add:SetPos( left + bar_w + 5, 110 )
            add:SetText( "" )
            add.Paint = function()
                local text = "+"
                local font = "RPNormal_45"
                surface.SetFont( font )
                local w, h = surface.GetTextSize( text )
                
                draw.RoundedBox( 2, 0, 0, add:GetWide(), add:GetTall(), HUD_SKIN.THEME_COLOR )
                draw.SimpleText( text, font, (add:GetWide() - w)/2, (add:GetTall() - h)/2, Color( 255, 255, 255, 255 ) )
            end
            add.DoClick = function()
                net.Start( "RP_Purchase_Skill_Point" )
                    net.WriteString( v.name )
                net.SendToServer()
            end
        end
        
        skill_list:AddItem( p )
    end
end )
f2_menu.AddButton( "Freunde", "roleplay/f2_menu/icons/friends.png", function( pnl ) 
    local l1 = vgui.Create( "DLabel", pnl )
    l1:SetPos( 5, 5 )
    l1:SetFont( "RPNormal_40" )
    l1:SetColor( Color( 100, 100, 100, 255 ) )
    l1:SetText( "Spieler:" )
    l1:SizeToContents()

    local l2 = vgui.Create( "DLabel", pnl )
    l2:SetPos( 5, 295 )
    l2:SetFont( "RPNormal_40" )
    l2:SetColor( Color( 100, 100, 100, 255 ) )
    l2:SetText( "Freunde Verlauf:" )
    l2:SizeToContents()

    local player_list = vgui.Create( "DPanelList", pnl )
    player_list:SetSize( pnl:GetWide(), pnl:GetTall()/2.1 )
    player_list:SetPos( 0, 50 )
    player_list:SetSpacing( 0 )
    player_list:EnableHorizontal( false )
    player_list:EnableVerticalScrollbar( true )
    player_list.Paint = function()
        --draw.RoundedBox( 0, 0, 0, player_list:GetWide(), player_list:GetTall(), Color( 0, 0, 0, 255 ) )
    end
    player_list.buddies = LocalPlayer():GetRPVar( "pp_table" ).buddies
    player_list.players = player.GetAll()

    local recent_list = vgui.Create( "DPanelList", pnl )
    recent_list:SetSize( pnl:GetWide(), 160 )
    recent_list:SetPos( 0, 340 )
    recent_list:SetSpacing( 0 )
    recent_list:EnableHorizontal( false )
    recent_list:EnableVerticalScrollbar( true )
    recent_list.Paint = function()
        --draw.RoundedBox( 0, 0, 0, recent_list:GetWide(), recent_list:GetTall(), Color( 0, 0, 0, 255 ) )
        if #recent_list:GetItems() == 0 then
            local text = "Leer"
            
            local font = "RPNormal_50"
            surface.SetFont( font )
            local w, h = surface.GetTextSize( text )
            
            draw.SimpleText( text, font, (recent_list:GetWide() - w)/2, (recent_list:GetTall() - h)/2, Color( 120, 120, 120, 150 ) )
        end
    end

    function player_list.RefreshLists()
        player_list:Clear()
        recent_list:Clear()
        
        local i = 0
        for k, v in pairs( player.GetAll() ) do
            if v == LocalPlayer() then continue end
            
            local list_col = HUD_SKIN.LIST_BG_FIRST
            i = i + 1
            if i == 2 then list_col = HUD_SKIN.LIST_BG_SECOND i = 0 end
            
            local p = vgui.Create( "DPanel", player_list )
            p:SetPos( 0, 0 )
            p:SetSize( player_list:GetWide(), player_list:GetTall()/6 )
            p.Paint = function()
                draw.RoundedBox( 0, 0, 0, p:GetWide(), p:GetTall(), list_col )
                draw.SimpleText( (v:GetRPVar( "rpname" ) or v:Nick()), "RPNormal_30", 5, 5, Color( 120, 120, 120, 255 ) )
            end
            
            local add = vgui.Create( "DButton", p )
            add:SetText( "" )
            add:SetSize( p:GetTall() - 10, p:GetTall() - 10 )
            add:SetPos( p:GetWide() - (10+add:GetWide()), 5 )
            add.Paint = function()
                local text
                local col

                if LocalPlayer():IsBuddy( v ) then
                    text = "-"
                    col = Color( 180, 0, 0, 255 )
                else
                    text = "+"
                    col = HUD_SKIN.THEME_COLOR
                end
                
                local font = "RPNormal_30"
                surface.SetFont( font )
                local w, h = surface.GetTextSize( text )
                
                draw.RoundedBox( 2, 0, 0, add:GetWide(), add:GetTall(), col )
                draw.SimpleText( text, font, (add:GetWide() - w)/2, (add:GetTall() - h)/2, Color( 255, 255, 255, 255 ) )
            end
            add.DoClick = function()
                if LocalPlayer():IsBuddy( v ) then
                    net.Start( "PP_RemoveBuddy" )
                        net.WriteString( tostring( v:SteamID() ) )
                    net.SendToServer()
                else
                    net.Start( "PP_AddBuddy" )
                        net.WriteEntity( v )
                    net.SendToServer()
                end
            end
            
            player_list:AddItem( p )
             
        end
        
        for k, v in pairs( LocalPlayer():GetRPVar( "pp_table" ).recent_buddies ) do
            local list_col = HUD_SKIN.LIST_BG_FIRST
            i = i + 1
            if i == 2 then list_col = HUD_SKIN.LIST_BG_SECOND i = 0 end
            
            local p = vgui.Create( "DPanel", player_list )
            p:SetPos( 0, 0 )
            p:SetSize( recent_list:GetWide(), recent_list:GetTall()/5 )
            p.Paint = function()
                draw.RoundedBox( 0, 0, 0, p:GetWide(), p:GetTall(), list_col )
                draw.SimpleText( v.name, "RPNormal_30", 5, 1, Color( 120, 120, 120, 255 ) )
            end
           
            recent_list:AddItem( p ) 
        end
    end
    player_list.RefreshLists()

    player_list.Think = function()
        player_list.nextcheck = player_list.nextcheck or CurTime() + 1
        if CurTime() < player_list.nextcheck  then return end
        player_list.nextcheck = CurTime() + 1
        
        if #player_list.players != #player.GetAll() then 
            player_list.RefreshLists()
        end
        
        if #LocalPlayer():GetRPVar( "pp_table" ).buddies != #player_list.buddies then
            player_list.RefreshLists()
        end
    end
end)
/*
f2_menu.AddButton( "Browser", "roleplay/f2_menu/icons/browser.png", function( pnl ) 
    HTMLTest = vgui.Create("HTML", pnl)
    HTMLTest:SetPos(0,0)
    HTMLTest:SetSize(pnl:GetWide(), pnl:GetTall())
    HTMLTest:OpenURL("http://nos-gaming,de")
end )
*/