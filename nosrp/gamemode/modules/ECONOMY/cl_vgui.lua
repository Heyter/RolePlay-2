net.Receive( "ECONOMY_SEND_CITY_LOG", function()
    ECONOMY.CITY_CASH = tonumber(net.ReadString())
    ECONOMY.LAST_MONTH_CASH = tonumber(net.ReadString())
    ECONOMY.CITY_LOG = net.ReadTable()
end)

function OpenEconomyMenu()
    local panels = {}

    local EconomyMenu = vgui.Create( "DFrame" )
    EconomyMenu:SetSize( 800, 450 )
    EconomyMenu:SetTitle( " " )
    EconomyMenu:Center()
    EconomyMenu:MakePopup()
    EconomyMenu.Paint = function( self )
        -- Background
        draw.RoundedBox(0,0,0,self:GetWide(),self:GetTall(),Color(230,230,230,255))
        surface.SetDrawColor(200,200,200)
        surface.DrawOutlinedRect(0,0,self:GetWide(),self:GetTall())
        
        -- Top
        draw.RoundedBox(0,0,0,self:GetWide(),55,HUD_SKIN.THEME_COLOR)
        draw.DrawText("Economy Settings","RPNormal_30",25,5,Color(255,255,255,255),TEXT_ALIGN_LEFT)
        draw.DrawText("Alle Einstellungen sollten mit höchster Acht getätigt werden!","RPNormal_20",25,30,Color(255,255,255,255),TEXT_ALIGN_LEFT)
    
        draw.SimpleText( "Stadt Geld: " .. ECONOMY.CITY_CASH .. ",-€", "RPNormal_25", 25, 65, Color(0,255,0,255) )
        draw.SimpleText( "Letzten Monat: " .. ECONOMY.LAST_MONTH_CASH .. ",-€", "RPNormal_25", 250, 65, Color(0,0,0,150) )
        draw.SimpleText( "Differenz: " .. (ECONOMY.CITY_CASH - ECONOMY.LAST_MONTH_CASH) .. ",-€", "RPNormal_25", 525, 65, Color(0,0,0,150) )
    end

    local PropertySheet = vgui.Create( "DPropertySheet", EconomyMenu )
    PropertySheet:SetPos( 5, 100 )
    PropertySheet:SetSize( EconomyMenu:GetWide() - 10 , EconomyMenu:GetTall() - 150 )
    PropertySheet.Paint = function() end

    local btn = vgui.Create( "DButton", EconomyMenu )
    btn:SetTall( 40 )
    btn:SetWide( 350 )
    btn:SetPos( EconomyMenu:GetWide() - (btn:GetWide() + 5), EconomyMenu:GetTall() - (btn:GetTall() + 5) )
    btn:SetFont( "Default" )
    btn:SetText( " " )
    btn.Paint = function(self)
        draw.RoundedBox(2,0,0,self:GetWide(),self:GetTall(),HUD_SKIN.THEME_COLOR)
        draw.DrawText("Einstellungen Übernehmen","RPNormal_25",self:GetWide()/2,self:GetTall()/5,Color(255,255,255,255),TEXT_ALIGN_CENTER)
    end

    local hostpanel1 = vgui.Create( "DPanelList", PropertySheet )
    hostpanel1:SetAutoSize( true )
    hostpanel1:SetSpacing( 5 )
    hostpanel1:EnableHorizontal( false )
    hostpanel1:EnableVerticalScrollbar( true )
    hostpanel1:SizeToContents()

    for _, ecitem in pairs( ECONOMY.JOBPANELS ) do
        local job = GAMEMODE.TEAMS[ecitem.Job]
        
        if !(job) then continue end
        
        local categorie = vgui.Create("DCollapsibleCategory", hostpanel1)
        categorie:SetPos( 5, 5 )
        categorie:SetSize( hostpanel1:GetWide() - 10, hostpanel1:GetTall() - 5 ) -- Keep the second number at 50
        categorie:SetExpanded( 0 ) -- Expanded when popped up
        categorie:SetLabel( job.Name )
        hostpanel1:AddItem( categorie )
        
        CategoryList = vgui.Create( "DPanelList", categorie )
        CategoryList:SetAutoSize( true )
        CategoryList:SetSpacing( 5 )
        CategoryList:EnableHorizontal( true )
        CategoryList:EnableVerticalScrollbar( true )
        categorie:SetContents( CategoryList )
        
        for k, v in pairs( ecitem ) do
            if !(type( v ) == "table") then continue end
            
            // Checkboxes First!
            if v.typ == "checkbox" then
                local val

                if type( job[v.key] ) == "boolean" then
                    if job[v.key] then
                        val = 1
                    else
                        val = 0
                    end
                end
                
                local cb = vgui.Create( "DCheckBoxLabel" )
                cb:SetText( v.Name )
                cb:SetValue( val )
                cb:SizeToContents()
                cb:SetTextColor(Color( 0, 153, 204 ))
                
                CategoryList:AddItem( cb )
                table.insert( panels, {panel=cb, typ=v.typ, key=v.key, job=ecitem.Job} )
                continue
            end
            
            if v.typ == "slider" then
            
                surface.SetFont( "RPNormal_20" )
                local len = surface.GetTextSize( v.Name .. ":   " )
                len = math.Clamp( len - 110, 0, 300 )
            
                local p = vgui.Create( "DPanel", CategoryList )
                p:SetTall( 50 )
                p:SetWide( 110 + len )
                p.Paint = function() 
                    draw.RoundedBox( 2, 0, 0, p:GetWide(), p:GetTall(), HUD_SKIN.THEME_COLOR )
                end
                
                local l = vgui.Create( "DLabel", p )
                l:SetFont( "RPNormal_20" )
                l:SetText( v.Name .. ":" )
                l:SetPos( 5, 5 )
                l:SetColor(Color(255,255,255))
                l:SizeToContents()
            
                local cb = vgui.Create( "DNumberWang", p )
                cb:SetPos( 5, 25 )
                cb:SetWide( 100 + len )
                cb:SetMin( v.min )
                cb:SetMax( v.max )
                cb:SetDecimals( 0 )
                cb:SetValue( job[v.key] )
                cb.OnMouseReleased = function()
                    if cb:GetValue() > cb:GetMax() then cb:SetValue( cb:GetMax() ) return end
                    if cb:GetValue() < cb:GetMin() then cb:SetValue( cb:GetMin() ) return end
                end
                
                table.insert( panels, {panel=cb, typ=v.typ, key=v.key, job=ecitem.Job} )
                CategoryList:AddItem( p )
                continue
            end
            
        end
    end
    PropertySheet:AddSheet( "Job Control", hostpanel1, "gui/silkicons/user", false, false )
    
    
    local zins_panels = {}
    local hostpanel2 = vgui.Create( "DPanelList", PropertySheet )
    hostpanel2:SetPos( 0, 0 )
    hostpanel2:SetSize( PropertySheet:GetWide(), (PropertySheet:GetTall() - 35) )
    hostpanel2:SetSpacing( 0 )
    hostpanel2:EnableHorizontal( false )
    hostpanel2:EnableVerticalScrollbar( true )
    hostpanel2.Paint = function() end
    hostpanel2.VBar.Paint = function() end
    hostpanel2.VBar.btnUp.Paint = function() end
    hostpanel2.VBar.btnDown.Paint = function() end
    hostpanel2.VBar.btnGrip.Paint = function() 
        draw.RoundedBox( 2, 0, 0, hostpanel2.VBar:GetWide(), hostpanel2.VBar:GetTall(), Color( 0, 0, 0, 50 ) )
    end
    
    local i = 0
    for k, v in pairs( ECONOMY.STEUERPANEL ) do
        local list_col = HUD_SKIN.LIST_BG_FIRST
        i = i + 1
        if i == 2 then list_col = HUD_SKIN.LIST_BG_SECOND i = 0 end
        local pnl = vgui.Create( "DPanel", hostpanel2 )
        pnl:SetTall( (PropertySheet:GetTall() - 35) / 3 )
        pnl:SetWide( hostpanel2:GetWide() )
        pnl.Paint = function( pnl )
            draw.RoundedBox( 0, 0, 0, pnl:GetWide(), pnl:GetTall(), list_col )
        end
        
        local lbl = vgui.Create( "DLabel", pnl )
        lbl:SetPos( 10, 5 )
        lbl:SetFont( "RPNormal_25" )
        lbl:SetColor( Color( 100, 100, 100, 255 ) )
        lbl:SetText( k )
        lbl:SizeToContents()
        
        local lbl = vgui.Create( "DLabel", pnl )
        lbl:SetPos( 10, 5 )
        lbl:SetFont( "RPNormal_25" )
        lbl:SetColor( Color( 100, 100, 100, 255 ) )
        lbl:SetText( k )
        lbl:SizeToContents()
        
        local lbl2 = vgui.Create( "DLabel", pnl )
        lbl2:SetPos( 10, 25 )
        lbl2:SetFont( "RPNormal_20" )
        lbl2:SetColor( Color( 100, 100, 100, 255 ) )
        lbl2:SetText( v.description )
        lbl2:SizeToContents()
        
        local cb = vgui.Create( "DNumberWang", pnl )
        cb:SetPos( 10, 55 )
        cb.key = v.key
        cb:SetWide( 250 )
        cb:SetMin( v.min )
        cb:SetMax( v.max )
        cb:SetDecimals( 1 )
        cb:SetValue( ECONOMY[v.key] )
        cb.OnMouseReleased = function()
            if cb:GetValue() > cb:GetMax() then cb:SetValue( cb:GetMax() ) return end
            if cb:GetValue() < cb:GetMin() then cb:SetValue( cb:GetMin() ) return end
        end
        
        table.insert( zins_panels, cb )
        
        hostpanel2:AddItem( pnl )
    end
    PropertySheet:AddSheet( "Steuer -/ Zins Administration", hostpanel2, "gui/silkicons/wrench", false, false )
    
    
    
    local hostpanel3 = vgui.Create( "DPanelList", PropertySheet )
    hostpanel3:SetPos( 0, 0 )
    hostpanel3:SetSize( PropertySheet:GetWide(), (PropertySheet:GetTall() - 35) )
    hostpanel3:SetSpacing( 0 )
    hostpanel3:EnableHorizontal( false )
    hostpanel3:EnableVerticalScrollbar( true )
    hostpanel3.Paint = function() end
    hostpanel3.VBar.Paint = function() end
    hostpanel3.VBar.btnUp.Paint = function() end
    hostpanel3.VBar.btnDown.Paint = function() end
    hostpanel3.VBar.btnGrip.Paint = function() 
        draw.RoundedBox( 2, 0, 0, hostpanel3.VBar:GetWide(), hostpanel3.VBar:GetTall(), Color( 0, 0, 0, 50 ) )
    end
    
    i = 0
    for k, v in pairs( ECONOMY.SHOPITEMS ) do
        local list_col = HUD_SKIN.LIST_BG_FIRST
        i = i + 1
        if i == 2 then list_col = HUD_SKIN.LIST_BG_SECOND i = 0 end
        local pnl = vgui.Create( "DPanel", hostpanel3 )
        pnl:SetTall( (PropertySheet:GetTall() - 35) / 3 )
        pnl:SetWide( hostpanel2:GetWide() )
        pnl.Paint = function( pnl )
            draw.RoundedBox( 0, 0, 0, pnl:GetWide(), pnl:GetTall(), list_col )
            draw.SimpleText( k, "RPNormal_25", pnl:GetTall() + 10, 5, Color( 100, 100, 100, 255 ) )
            draw.SimpleText( v.desc, "RPNormal_20", pnl:GetTall() + 10, 30, Color( 100, 100, 100, 255 ) )
            local t = "Kosten: " .. v.cost .. ",-€"
            if v.cost < 1 then t = "Kosten: GRATIS" end
            draw.SimpleText( t, "RPNormal_20", pnl:GetTall() + 10, pnl:GetTall() - 25, Color( 100, 100, 100, 255 ) )
        end
        
        local icon = vgui.Create( "DModelPanel", pnl )
        icon:SetModel( v.model )
        icon:SetPos( 2, 2 ) 
        local max, min = icon:GetEntity():GetRenderBounds()
        icon:SetSize( pnl:GetTall() - 4, pnl:GetTall() - 4 )
        icon:SetCamPos( Vector( 0.5, 0.5, 0.5 ) * min:Distance( max ) )
		      icon:SetLookAt( ( min + max ) / 4 )
        
        local purchase = vgui.Create( "DButton", pnl )
        purchase:SetTall( 25 )
        purchase:SetWide( 150 )
        purchase:SetPos( pnl:GetWide() - purchase:GetWide() - 16, pnl:GetTall()- purchase:GetTall() )
        purchase:SetText( "" )
        purchase.Paint = function()
            draw.RoundedBox( 0, 0, 0, purchase:GetWide(), purchase:GetTall(), HUD_SKIN.THEME_COLOR )
            local text = "Kaufen"
            local font = "RPNormal_27"
            surface.SetFont( font )
            local w, h = surface.GetTextSize( text )
            draw.SimpleText( text, font, (purchase:GetWide() - w)/2, (purchase:GetTall() - h)/2, Color( 255, 255, 255, 255 ) )
        end
        purchase.DoClick = function()
            net.Start( "ECONOMY_PURCHASE_ITEM" )
                net.WriteString( k )
            net.SendToServer()
        end
        
        hostpanel3:AddItem( pnl )
    end
    PropertySheet:AddSheet( "Stadt Shop", hostpanel3, "icon16/coins.png", false, false )
    
    
    
    
    local hostpanel4 = vgui.Create( "DPanelList", PropertySheet )
    hostpanel4:SetPos( 0, 0 )
    hostpanel4:SetSize( PropertySheet:GetWide(), (PropertySheet:GetTall() - 35) )
    hostpanel4:SetSpacing( 0 )
    hostpanel4:EnableHorizontal( false )
    hostpanel4:EnableVerticalScrollbar( true )
    hostpanel4.Paint = function() end
    hostpanel4.VBar.Paint = function() end
    hostpanel4.VBar.btnUp.Paint = function() end
    hostpanel4.VBar.btnDown.Paint = function() end
    hostpanel4.VBar.btnGrip.Paint = function() 
        draw.RoundedBox( 2, 0, 0, hostpanel4.VBar:GetWide(), hostpanel4.VBar:GetTall(), Color( 0, 0, 0, 50 ) )
    end
    
    i = 0
    for k, v in pairs( ECONOMY.CITY_LOG ) do
        local list_col = HUD_SKIN.LIST_BG_FIRST
        i = i + 1
        if i == 2 then list_col = HUD_SKIN.LIST_BG_SECOND i = 0 end
        
        local pnl = vgui.Create( "DPanel", hostpanel4 )
        pnl:SetTall( (PropertySheet:GetTall() - 35) / 8 )
        pnl:SetWide( hostpanel4:GetWide() )
        pnl.Paint = function( pnl )
            draw.RoundedBox( 0, 0, 0, pnl:GetWide(), pnl:GetTall(), list_col )
            local col = Color( 0, 200, 0, 200 )
            if string.Left( v[1], 1 ) == "-" then col = Color( 200, 0, 0, 200 ) end
            draw.SimpleText( v[1], "RPNormal_25", 5, 5, col )
        end
        
        
        hostpanel4:AddItem( pnl )
    end
    PropertySheet:AddSheet( "Stadt Log", hostpanel4, "icon16/pencil.png", false, false )
    

    btn.DoClick = function() // Accept Changes Button
    // For the JOB Control
        local vals = {}
        for k, v in pairs( panels ) do
            if v.typ == "slider" then
                local val
                if v.panel:GetValue() > v.panel:GetMax() then 
                    v.panel:SetValue( v.panel:GetMax() ) 
                    val = v.panel:GetMax()
                    table.insert( vals, {job=v.job, key=v.key, value=v.panel:GetMax()} )
                    continue
                end
                if v.panel:GetValue() < v.panel:GetMin() then 
                    v.panel:SetValue( v.panel:GetMin() ) 
                    val = v.panel:GetMin() 
                    table.insert( vals, {job=v.job, key=v.key, value=v.panel:GetMin()} )
                    continue
                end
                val = v.panel:GetValue()
                table.insert( vals, {job=v.job, key=v.key, value=val} )
            elseif v.typ == "checkbox" then
                if v.panel:GetChecked() then
                    table.insert( vals, {job=v.job, key=v.key, value=1} )
                    continue
                else
                    table.insert( vals, {job=v.job, key=v.key, value=0} )
                    continue
                end
            end
        end
    // Job Control End
    
    local zins_table = {}
    // Zins Control
        for k, v in pairs( zins_panels ) do
            if v:GetValue() > v:GetMax() then 
                v:SetValue( v:GetMax() ) 
            end
            if v:GetValue() < v:GetMin() then 
                v:SetValue( v:GetMin() ) 
            end
            table.insert( zins_table, {val=v:GetValue(), key=v.key} )
        end
    // End Zins Control
    
        net.Start( "ECONOMY_SEND_MAYOR_DECISIONS" )
            net.WriteTable( vals )
            net.WriteTable( zins_table )
        net.SendToServer()
    end
end