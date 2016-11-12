
function Add_Icon_Panel( pnl )

    pnl.ButtonList = vgui.Create( "DPanelList", pnl )
    pnl.ButtonList:SetSize( 180, pnl:GetTall() - pnl:GetTall()/6 )
    pnl.ButtonList:SetPos( 0, (pnl:GetTall()) - pnl.ButtonList:GetTall() )
    pnl.ButtonList:SetSpacing( 0 )
    pnl.ButtonList:EnableHorizontal( false )
    pnl.ButtonList:EnableVerticalScrollbar( true )
    pnl.ButtonList.Paint = function()
        --draw.RoundedBox( 0, 0, 0, pnl.ButtonList:GetWide(), pnl.ButtonList:GetTall(), Color( 0, 0, 0, 255 ) )
    end
    pnl.ButtonList.VBar.Paint = function() end
    pnl.ButtonList.VBar.btnUp.Paint = function() end
    pnl.ButtonList.VBar.btnDown.Paint = function() end
    pnl.ButtonList.VBar.btnGrip.Paint = function() 
        draw.RoundedBox( 2, 0, 0, pnl.ButtonList.VBar:GetWide(), pnl.ButtonList.VBar:GetTall(), Color( 0, 0, 0, 50 ) )
    end
    
    /*---------------------------
        Lets create the Buttons
    */---------------------------
    pnl.cache = {}
    pnl.cache.panel = {}
    pnl.cache.curpanel = {}
    pnl.cache.active_panel = {}
    
    function pnl.ButtonList.RefreshList()
        for k, v in ipairs( pnl.cache.panel ) do
            local p = vgui.Create( "DPanel", pnl )
            p:SetPos( (pnl.ButtonList:GetWide()), pnl:GetTall() / 6 )
            p:SetWide( pnl:GetWide() - pnl.ButtonList:GetWide())
            p:SetTall( pnl.ButtonList:GetTall() )
            v.panel_func( p )

            local btn = vgui.Create( "DButton", pnl.ButtonList )
            btn:SetText( "" )
            btn:SetSize( pnl.ButtonList:GetWide(), pnl.ButtonList:GetTall()/3 )
            btn.panel = p
            btn.DoClick = function()
                if IsValid( pnl.curpanel ) then pnl.curpanel:Hide() end
                pnl.curpanel = btn.panel
                if IsValid( pnl.curpanel ) then pnl.curpanel:Show() end
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
            btn.image:SetSize( btn:GetWide()/1.25, btn:GetTall()/1.25 )
            btn.image:SetPos( (btn:GetWide() - btn:GetWide()/1.25)/2, 5 )
            btn.image:SetImage( v.icon )

            pnl.ButtonList:AddItem( btn )
            table.insert( pnl.cache.active_panel, btn )
            
            for _, p in pairs( pnl.cache.active_panel ) do
                p.panel:Hide()
            end
            pnl.cache.active_panel[1].panel:Show()   // Show the first entity
        end
    end
    
    function pnl.ButtonList.AddButton( text, icon, panel_func )
        table.insert( pnl.cache.panel, {text=text,icon=icon,panel_func=panel_func} )
    end
end

function CreateChooseSheet( ... )
    local data = {...}
    local count = #data
    
    // settings
    local button_h = 35
    local font = "RPNormal_25"

    local sheet = vgui.Create( "DFrame" )
    sheet:SetPos( gui.MouseX(), gui.MouseY() )
    sheet:SetTall( 25 + (button_h * math.Clamp((count-1), 0, 30)) )
    sheet:SetWide( 150 )
    sheet:SetTitle( "" )
    sheet:ShowCloseButton( false )
    sheet:MakePopup()
    sheet.Paint = function( self )
        draw.RoundedBox( 0, 0, 0, self:GetWide(), self:GetTall(), HUD_SKIN.LIST_BG_FIRST )
        draw.RoundedBox( 0, 0, 0, self:GetWide(), 25, HUD_SKIN.THEME_COLOR )
        draw.SimpleText( data[1], font, 5, 0, Color( 255, 255, 255, 255 ) )
    end
    sheet.Think = function( self )
        if input.IsMouseDown( MOUSE_LEFT ) then sheet:Close() end
    end
    
    local List = vgui.Create( "DPanelList", sheet )
    List:SetPos( 0, 25 )
    List:SetSize( sheet:GetWide(), sheet:GetTall() - 25 )
    List:SetSpacing( 0 )
    List:EnableHorizontal( false )
    List:EnableVerticalScrollbar( true )
    
    local i = 0
    local w, t = 150, 25
    for k, v in pairs( data ) do
        if k == 1 then continue end
        i = i + 1
        if i >= 2 then i = 0 continue end
        if (k+1) > count then break end
        if !(type(data[k+1]) == "function") then continue end
        
        local btn = vgui.Create( "DButton", List )
        btn:SetSize( sheet:GetWide(), button_h )
        btn:SetText( "" )
        btn.selected = false
        btn.Paint = function( self )
            if btn.selected then
                draw.RoundedBox( 0, 0, 0, self:GetWide(), self:GetTall(), Color( 50, 50, 50, 255 ) )
                draw.SimpleText( v, font, self:GetWide()/2, self:GetTall()/2, Color( 255, 255, 255, 150 ), 1, 1 )
            else
                draw.RoundedBox( 0, 0, 0, self:GetWide(), self:GetTall(), Color( 230, 230, 230, 255 ) )
                draw.SimpleText( v, font, self:GetWide()/2, self:GetTall()/2, Color( 0, 0, 0, 150 ), 1, 1 )
            end
        end
        btn.OnCursorEntered = function( self ) self.selected = true end
        btn.OnCursorExited = function( self ) self.selected = false end
        btn.DoClick = function( self )
            data[k+1]()
            sheet:Close()
        end
        
        List:AddItem( btn )
        
        surface.SetFont( font )
        local t_w, t_h = surface.GetTextSize( v )
        
        if t_w > w then w = (t_w + 25 ) end
        
        t = t + button_h
        sheet:SetTall( t )
        sheet:SetWide( w )
        List:SetTall( t )
        List:SetWide( w )
    end
end