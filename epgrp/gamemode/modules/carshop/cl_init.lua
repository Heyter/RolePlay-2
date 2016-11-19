CARSHOP.BuyableCars = CARSHOP.BuyableCars or {}
net.Receive( "CarDealer_SendChoosenCars", function() CARSHOP.BuyableCars = net.ReadTable() end)

function CARSHOP.OpenGarage()
    CARSHOP.GaragePanel = vgui.Create( "DFrame" )
    CARSHOP.GaragePanel:SetSize( 550, 450 )
    CARSHOP.GaragePanel:SetTitle( "" )
    CARSHOP.GaragePanel:Center()
    CARSHOP.GaragePanel:MakePopup()
    CARSHOP.GaragePanel.Paint = function()
        draw.RoundedBox( 6, 0, 0, CARSHOP.GaragePanel:GetWide(), CARSHOP.GaragePanel:GetTall(), Color( 240,240,240,255 ) )
        draw.RoundedBox( 2, 0, 0, CARSHOP.GaragePanel:GetWide(), (CARSHOP.GaragePanel:GetTall()/8), HUD_SKIN.THEME_COLOR )
        draw.RoundedBox( 2, 0, (CARSHOP.GaragePanel:GetTall()/8) - 2, CARSHOP.GaragePanel:GetWide(), 2, Color( 0, 102, 204, 50 ) )
        draw.SimpleText( "Garage", "RPNormal_40", 25, CARSHOP.GaragePanel:GetTall()/60, Color( 255, 255, 255, 255 ) )
    end

    local s = CARSHOP.GaragePanel:GetTall()/8
    CARSHOP.GaragePanel.List = vgui.Create( "DPanelList", CARSHOP.GaragePanel )
    CARSHOP.GaragePanel.List:SetSize( CARSHOP.GaragePanel:GetWide(), CARSHOP.GaragePanel:GetTall() - s)
    CARSHOP.GaragePanel.List:SetPos( 0, CARSHOP.GaragePanel:GetTall()/8 )
    CARSHOP.GaragePanel.List:SetSpacing( 0 )
    CARSHOP.GaragePanel.List:EnableHorizontal( false )
    CARSHOP.GaragePanel.List:EnableVerticalScrollbar( true )
    CARSHOP.GaragePanel.List.Paint = function()
        --draw.RoundedBox( 0, 0, 0, CARSHOP.GaragePanel.List:GetWide(), CARSHOP.GaragePanel.List:GetTall(), Color( 0, 0, 0, 255 ) )
    end

    CARSHOP.GaragePanel.HideBtn = vgui.Create( "DButton", CARSHOP.GaragePanel )
    CARSHOP.GaragePanel.HideBtn:SetSize( 100, 25 )
    CARSHOP.GaragePanel.HideBtn:SetPos( CARSHOP.GaragePanel:GetWide() - 100, 0 )
    CARSHOP.GaragePanel.HideBtn:SetText( "" )
    CARSHOP.GaragePanel.HideBtn.DoClick = function() 
        CARSHOP.GaragePanel:Close()
    end
    CARSHOP.GaragePanel.HideBtn.Paint = function()
        draw.RoundedBox( 0, 0, 0, CARSHOP.GaragePanel.HideBtn:GetWide(), CARSHOP.GaragePanel.HideBtn:GetTall(), HUD_SKIN.FULL_GREY )
        surface.SetFont( "RPNormal_25" )
        local w, h = surface.GetTextSize( "Close" )
        draw.SimpleText( "Close", "RPNormal_25", (CARSHOP.GaragePanel.HideBtn:GetWide() - w)/2, (CARSHOP.GaragePanel.HideBtn:GetTall() - h)/2, Color( 255, 255, 255, 255 ) )
    end

    CARSHOP.GaragePanel.List.VBar.Paint = function() end
    CARSHOP.GaragePanel.List.VBar.btnUp.Paint = function() end
    CARSHOP.GaragePanel.List.VBar.btnDown.Paint = function() end
    CARSHOP.GaragePanel.List.VBar.btnGrip.Paint = function() 
        draw.RoundedBox( 2, 0, 0, CARSHOP.GaragePanel.List.VBar:GetWide(), CARSHOP.GaragePanel.List.VBar:GetTall(), Color( 0, 0, 0, 50 ) )
    end

    local my_garage = LocalPlayer():GetRPVar( "garage_table" )

    for k, v in pairs( my_garage ) do
        local p = vgui.Create( "DButton", CARSHOP.GaragePanel )
        p:SetSize( CARSHOP.GaragePanel:GetWide(), (CARSHOP.GaragePanel:GetTall() - s)/4 )
        p:SetPos( 0, 59 )
        p:SetText( "" )
        p.DoClick = function()
            if v.Health < 1 then return end
            net.Start( "CarDealer_SpawnGarageCar" )
                net.WriteString( k )
            net.SendToServer()
        end
        p.Paint = function() 
            draw.RoundedBox( 0, 0, 0, p:GetWide(), p:GetTall(), Color( 240, 240, 240, 255 ) )
            
            local text = v.Name
            local font = "RPNormal_27"
            surface.SetFont( font )
            local w, h = surface.GetTextSize( text )
                            
            local col = HUD_SKIN.FULL_GREY
            local left = p:GetTall() - 4
            
            
            if v.Health < 1 then
                draw.SimpleText( "[DEFEKT] " .. text, font, left + 5, 2, Color( 255, 0, 0, 200 ) )
            else
                draw.SimpleText( text, font, left + 5, 2, Color( col.r, col.g, col.b, col.a - 50 ) )
            end

            draw.SimpleText( v.Desc, "RPNormal_20", left + 5, h - 5, Color( col.r, col.g, col.b, col.a - 50 ) )
            
            text = "HP"
            font = "RPNormal_25"
            surface.SetFont( font )
            w, h = surface.GetTextSize( text )
            draw.SimpleText( text, font, left + 5, p:GetTall()/2, Color( col.r, col.g, col.b, col.a - 50 ) )
            draw.SimpleText( "Armor", font, left + 5, h + 45, Color( col.r, col.g, col.b, col.a - 50 ) )

            local max_hp = CARSHOP.CARTABLE.CARS[k].Health or 0
            local max_armor = CARSHOP.CARTABLE.CARS[k].Armor or 0
            local max_tank = CARSHOP.CARTABLE.CARS[k].Fuel or 0
            local max_sk = CARSHOP.GetHighestAmount( "Damage_Class" ) or 0
            p.CreateProgressBar( w + left + 10, p:GetTall()/2 + 10, 100, 3, v.Health, max_hp )
            p.CreateProgressBar( w + left + 39, h + 45 + 11, 100, 3, v.Armor, max_armor )
                            
            draw.SimpleText( "Tank", font, w + left + 160, h + 45, Color( col.r, col.g, col.b, col.a - 50 ) )
            p.CreateProgressBar( w + left + 198, h+44 + 12, 100, 3, v.Fuel, max_tank )
            draw.SimpleText( "S.K", font, left + 150, p:GetTall()/2, Color( col.r, col.g, col.b, col.a - 50 ) )
            p.CreateProgressBar( w + left + 160, p:GetTall()/2 + 11, 100, 3, v.Damage_Class, max_sk )
        end
        
        function p.CreateProgressBar( x, y, w, h, value, max )
            local rech = (w / max) * value
            draw.RoundedBox( 0, x - 1, y - 3, 1, h + 6, Color( 50, 50, 50, 200 ) )
            draw.RoundedBox( 0, x + ((w / max)*max), y - 3, 1, h + 6, Color( 50, 50, 50, 200 ) )
            draw.RoundedBox( 0, x, y, w, h, Color( 0, 0, 0, 50 ) )
            draw.RoundedBox( 0, x, y, rech, h, Color( 50, 50, 50, 200 ) )
        end
        
        local icon = vgui.Create( "DModelPanel", p )
        icon:SetPos( 2, 2 )
        icon:SetModel( v.Model )
        CARSHOP.ApplyVisuals( LocalPlayer(), icon:GetEntity(), k )
        icon:SetColor( Color( v.col_r, v.col_g, v.col_b, 255 ) )
        local max, min = icon:GetEntity():GetRenderBounds()
        icon:SetSize( p:GetTall() - 4, p:GetTall() - 4 )
        icon:SetCamPos( Vector( 0.4, 0.5, 0.3 ) * min:Distance( max ) )
        icon:SetLookAt( ( min + max ) / 2 )
        icon.LayoutEntity = function( Entity )
            if ( icon.bAnimated ) then
                icon:RunAnimation()
            end
        end
        icon:GetEntity():SetAngles( Angle( 0, 0, 0 ) )

        CARSHOP.GaragePanel.List:AddItem( p )
    end
end

function CARSHOP.OpenShop()
    local CarShop_Menu = vgui.Create( "DFrame" )
    CarShop_Menu:SetWide( 850 )
    CarShop_Menu:SetTall( 600 )
    CarShop_Menu:SetTitle( "" )
    CarShop_Menu:Center()
    CarShop_Menu:MakePopup()
    CarShop_Menu.Paint = function()
        draw.RoundedBox( 6, 0, 0, CarShop_Menu:GetWide(), CarShop_Menu:GetTall(), Color( 240,240,240,255 ) )
        draw.RoundedBox( 2, 0, 0, CarShop_Menu:GetWide(), (CarShop_Menu:GetTall()/6), HUD_SKIN.THEME_COLOR )
        draw.RoundedBox( 2, 0, (CarShop_Menu:GetTall()/6) - 2, CarShop_Menu:GetWide(), 2, Color( 0, 102, 204, 50 ) )
        draw.SimpleText( "Autohaus", "RPNormal_54", 25, CarShop_Menu:GetTall()/24, Color( 255, 255, 255, 255 ) )
    end

    CarShop_Menu.HideBtn = vgui.Create( "DButton", CarShop_Menu )
    CarShop_Menu.HideBtn:SetSize( 100, 25 )
    CarShop_Menu.HideBtn:SetPos( CarShop_Menu:GetWide() - 100, 0 )
    CarShop_Menu.HideBtn:SetText( "" )
    CarShop_Menu.HideBtn.DoClick = function() 
        CarShop_Menu:Close()
    end
    CarShop_Menu.HideBtn.Paint = function()
        draw.RoundedBox( 0, 0, 0, CarShop_Menu.HideBtn:GetWide(), CarShop_Menu.HideBtn:GetTall(), HUD_SKIN.FULL_GREY )
        surface.SetFont( "RPNormal_25" )
        local w, h = surface.GetTextSize( "Close" )
        draw.SimpleText( "Close", "RPNormal_25", (CarShop_Menu.HideBtn:GetWide() - w)/2, (CarShop_Menu.HideBtn:GetTall() - h)/2, Color( 255, 255, 255, 255 ) )
    end
    Add_Icon_Panel( CarShop_Menu )


    CarShop_Menu.ButtonList.AddButton( "Shop", "roleplay/f2_menu/icons/purchase.png", function( pnl ) 
        pnl.CarList = vgui.Create( "DPanelList", pnl )
        pnl.CarList:SetSize( pnl:GetWide(), pnl:GetTall() )
        pnl.CarList:SetPos( 0, 0 )
        pnl.CarList:SetSpacing( 0 )
        pnl.CarList:EnableHorizontal( false )
        pnl.CarList:EnableVerticalScrollbar( true )
        pnl.CarList.Paint = function()
            --draw.RoundedBox( 0, 0, 0, pnl.ButtonList:GetWide(), pnl.ButtonList:GetTall(), Color( 0, 0, 0, 255 ) )
        end
        pnl.CarList.VBar.Paint = function() end
        pnl.CarList.VBar.btnUp.Paint = function() end
        pnl.CarList.VBar.btnDown.Paint = function() end
        pnl.CarList.VBar.btnGrip.Paint = function() 
            draw.RoundedBox( 2, 0, 0, pnl.CarList.VBar:GetWide(), pnl.CarList.VBar:GetTall(), Color( 0, 0, 0, 50 ) )
        end
        
        for k, v in pairs( CARSHOP.BuyableCars ) do
            local carpanel = vgui.Create( "DPanel", pnl.CarList )
            carpanel:SetSize( pnl:GetWide(), pnl:GetTall()/4 )
            carpanel.Paint = function() 
                draw.RoundedBox( 0, 0, 0, carpanel:GetWide(), carpanel:GetTall(), Color( 240, 240, 240, 255 ) )
            end

            local icon = vgui.Create( "DModelPanel", carpanel )
            icon:SetPos( 2, 2 )
            icon:SetModel( v.Model )
            local max, min = icon:GetEntity():GetRenderBounds()
            icon:SetSize( carpanel:GetTall() - 4, carpanel:GetTall() - 4 )
            icon:SetCamPos( Vector( 0.4, 0.5, 0.3 ) * min:Distance( max ) )
                                      icon:SetLookAt( ( min + max ) / 2 )
            icon.LayoutEntity = function( Entity )
                if ( icon.bAnimated ) then
                    icon:RunAnimation()
                end
            end
            icon:GetEntity():SetAngles( Angle( 0, 0, 0 ) )
            
            local move_panel = vgui.Create( "DPanel", carpanel )
            move_panel:SetPos( 2 + icon:GetWide(), 0 )
            move_panel:SetSize( carpanel:GetWide() - ( 2 + icon:GetWide() ), carpanel:GetTall() )
			move_panel.parents = {}
            move_panel.inmove = false
            move_panel.status = 1
            move_panel.still_selected = false
            move_panel.Paint = function() 
                --draw.RoundedBox( 0, 0, 0, move_panel:GetWide(), move_panel:GetTall(), Color( 0, 0, 0, 150 ) )
                
                if move_panel.status == 1 then
                    local text = v.Name
                    local font = "RPNormal_35"
                    surface.SetFont( font )
                    local w, h = surface.GetTextSize( text )
                    
                    local col = HUD_SKIN.FULL_GREY
                    
                    draw.SimpleText( text, font, (move_panel:GetWide() - w)/2, (move_panel:GetTall() - h)/2, Color( col.r, col.g, col.b, col.a - 50 ) )
                    text = "Halte die Maus hier drüber für mehr Informationen!"
                    font = "RPNormal_21"
                    surface.SetFont( font )
                    w, h = surface.GetTextSize( text )
                    
                    draw.SimpleText( text, font, (move_panel:GetWide() - w)/2, (move_panel:GetTall() - h)/1.4, Color( col.r, col.g, col.b, col.a - 50 ) )
                end
                if move_panel.status == 2 then
                    local text = v.Name
                    local font = "RPNormal_45"
                    surface.SetFont( font )
                    local w, h = surface.GetTextSize( text )
                    
                    local col = HUD_SKIN.FULL_GREY
                    
                    draw.SimpleText( text, font, 2, 2, Color( col.r, col.g, col.b, col.a - 50 ) )
                    draw.SimpleText( v.Cost .. ",-EUR", "RPNormal_25", w + 1, h - 26, Color( col.r, col.g, col.b, col.a - 50 ) )
                    draw.SimpleText( v.Desc, "RPNormal_20", 2, h - 8, Color( col.r, col.g, col.b, col.a - 50 ) )
                    text = "HP"
                    font = "RPNormal_27"
                    surface.SetFont( font )
                    w, h = surface.GetTextSize( text )
                    draw.SimpleText( text, font, 2, move_panel:GetTall()/2, Color( col.r, col.g, col.b, col.a - 50 ) )
                    draw.SimpleText( "Armor", font, 2, h + 60, Color( col.r, col.g, col.b, col.a - 50 ) )
                    
                    local max_hp = CARSHOP.GetHighestAmount( "Health" ) or 0
                    local max_armor = CARSHOP.GetHighestAmount( "Armor" ) or 0
                    local max_tank = CARSHOP.GetHighestAmount( "Fuel" ) or 0
                    local max_sk = CARSHOP.GetHighestAmount( "Damage_Class" ) or 0
                    move_panel.CreateProgressBar( w + 42, move_panel:GetTall()/2 + 12, 100, 3, v.Health, max_hp )
                    move_panel.CreateProgressBar( w + 42, h+60 + 12, 100, 3, v.Armor, max_armor )
                    
                    draw.SimpleText( "Tank", font, w + 180, h + 60, Color( col.r, col.g, col.b, col.a - 50 ) )
                    move_panel.CreateProgressBar( w + 225, h+60 + 12, 100, 3, v.Fuel, max_tank )
                    draw.SimpleText( "S.K", font, w + 180, move_panel:GetTall()/2, Color( col.r, col.g, col.b, col.a - 50 ) )
                    move_panel.CreateProgressBar( w + 225, move_panel:GetTall()/2 + 12, 100, 3, v.Damage_Class, max_sk )
                end
            end
            move_panel.OnCursorEntered = function()
                move_panel.entered = true
                if move_panel.inmove && move_panel.status == 2 && move_panel.still_selected == false then
                    move_panel.still_selected = true
                end
                if move_panel.inmove == true then return end
                if move_panel.status == 2 then return end
                
                move_panel.inmove = true
                
                local x, y = move_panel:GetPos()
                move_panel:MoveTo( carpanel:GetWide(), y, 0.2, 0, -1, function()
                    move_panel.status = 2
                    move_panel.PurchaseButton:Show()
                    move_panel.ViewButton:Show()
                    timer.Simple( 0.2, function()
                        move_panel:MoveTo( x, y, 0.2, 0, -1, function() 
                            move_panel.inmove = false
                            if move_panel.still_selected == false then
                                move_panel.OnCursorExited()
                            end
                        end)
                    end)
                end)
            end
            move_panel.OnCursorExited = function()
                move_panel.entered = false
				timer.Simple( 0.5, function()
                    if IsValid(move_panel) then
    					if move_panel.inmove == true then return end
                        if move_panel.status == 1 then return end
    					if move_panel.entered == true then return end
    					
    					for k, v in pairs( move_panel.parents ) do
    						if v.focused == true then return end
    					end
    					
    					move_panel.inmove = true
    					move_panel.still_selected = false
    					
    					local x, y = move_panel:GetPos()
    					
    					move_panel:MoveTo( carpanel:GetWide(), y, 0.2, 0, -1, function()
    						move_panel.status = 1
    						move_panel.PurchaseButton:Hide()
    						move_panel.ViewButton:Hide()
    						timer.Simple( 0.2, function()
    							move_panel:MoveTo( x, y, 0.2, 0, -1, function()
                                    if IsValid(move_panel) then
    								    move_panel.inmove = false
                                    end
    							end)
    						end)
    					end)
                    end
				end)
            end
            
            move_panel.PurchaseButton = vgui.Create( "DButton", move_panel )
            move_panel.PurchaseButton:SetSize( 100, 50 )
            local m_w, m_h = (move_panel:GetWide() - move_panel.PurchaseButton:GetWide()) - 15, 20
            move_panel.PurchaseButton:SetPos( m_w, m_h )
            move_panel.PurchaseButton:SetText( "" )
            move_panel.PurchaseButton.Paint = function()
                local text = "Kaufen"
                v.Sold = v.Sold or false
                if v.Sold then text = "Verkauft!" end
                local font = "RPNormal_25"
                surface.SetFont( font )
                local w, h = surface.GetTextSize( text )
                if v.Sold then
                    draw.RoundedBox( 0, 0, 0, move_panel.PurchaseButton:GetWide(), move_panel.PurchaseButton:GetTall(), HUD_SKIN.FULL_GREY )
                    draw.SimpleText( text, font, (move_panel.PurchaseButton:GetWide() - w)/2, (move_panel.PurchaseButton:GetTall() - h)/2, Color( 255, 255, 255, 255 ) )
                else
                    draw.RoundedBox( 0, 0, 0, move_panel.PurchaseButton:GetWide(), move_panel.PurchaseButton:GetTall(), HUD_SKIN.THEME_COLOR )
                    draw.SimpleText( text, font, (move_panel.PurchaseButton:GetWide() - w)/2, (move_panel.PurchaseButton:GetTall() - h)/2, Color( 255, 255, 255, 255 ) )
                end
            end
            move_panel.PurchaseButton.DoClick = function()
                if !(LocalPlayer():CanAfford( v.Cost )) then return end 
                net.Start( "CarDealer_PurchaseCar" )
                    net.WriteString( k )
                net.SendToServer()
            end
            move_panel.PurchaseButton.Think = function()
                v.Sold = v.Sold or false
                if v.Sold then 
                    move_panel.PurchaseButton:SetEnabled( false ) 
                else 
                    move_panel.PurchaseButton:SetEnabled( true ) 
                end
            end
			
			move_panel.PurchaseButton.focused = false
			move_panel.PurchaseButton.OnCursorEntered = function() move_panel.PurchaseButton.focused = true end
			move_panel.PurchaseButton.OnCursorExited = function() move_panel.PurchaseButton.focused = false end
			table.insert( move_panel.parents, move_panel.PurchaseButton )
            move_panel.PurchaseButton:Hide()
            
            move_panel.ViewButton = vgui.Create( "DButton", move_panel )
            move_panel.ViewButton:SetSize( 100, 25 )
            local m_w, m_h = (move_panel:GetWide() - move_panel.ViewButton:GetWide()) - 15, 20 + (move_panel.PurchaseButton:GetTall() + 5)
            move_panel.ViewButton:SetPos( m_w, m_h )
            move_panel.ViewButton:SetText( "" )
            move_panel.ViewButton.Paint = function()
                draw.RoundedBox( 0, 0, 0, move_panel.ViewButton:GetWide(), move_panel.ViewButton:GetTall(), HUD_SKIN.THEME_COLOR )
                local text = "Zeigen"
                local font = "RPNormal_25"
                surface.SetFont( font )
                local w, h = surface.GetTextSize( text )
                draw.SimpleText( text, font, (move_panel.ViewButton:GetWide() - w)/2, (move_panel.ViewButton:GetTall() - h)/2, Color( 255, 255, 255, 255 ) )

            end
			
			move_panel.ViewButton.focused = false
			move_panel.ViewButton.OnCursorEntered = function() move_panel.ViewButton.focused = true end
			move_panel.ViewButton.OnCursorExited = function() move_panel.ViewButton.focused = false end
			table.insert( move_panel.parents, move_panel.ViewButton )
            move_panel.ViewButton:Hide()
            
            function move_panel.CreateProgressBar( x, y, w, h, value, max )
                local rech = (w / max) * value
                draw.RoundedBox( 0, x - 1, y - 3, 1, h + 6, Color( 50, 50, 50, 200 ) )
                draw.RoundedBox( 0, x + ((w / max)*max), y - 3, 1, h + 6, Color( 50, 50, 50, 200 ) )
                draw.RoundedBox( 0, x, y, w, h, Color( 0, 0, 0, 50 ) )
                draw.RoundedBox( 0, x, y, rech, h, Color( 50, 50, 50, 200 ) )
            end
            pnl.CarList:AddItem( carpanel )
        end
        
    end )
    if CARSHOP.CONFIG.KatalogEnabled then
        CarShop_Menu.ButtonList.AddButton( "Auto Bestellen", "roleplay/f2_menu/icons/deliver.png", function( pnl ) 
            local image = vgui.Create("DImage", pnl)
            image:SetPos( 0, 0 )
            image:SetSize( pnl:GetWide(), pnl:GetTall() )
            image:SetImage( "fadmin/listview.vmt" )
        end )
    end
    if CARSHOP.CONFIG.MarketplaceEnabled then
        CarShop_Menu.ButtonList.AddButton( "Marktplatz", "roleplay/f2_menu/icons/rules_new.png", function( pnl ) 
            local image = vgui.Create("DImage", pnl)
            image:SetPos( 0, 0 )
            image:SetSize( pnl:GetWide(), pnl:GetTall() )
            image:SetImage( "fadmin/listview.vmt" )
        end )
    end
    if CARSHOP.CONFIG.TuningEnabled then
        CarShop_Menu.ButtonList.AddButton( "Tuning", "roleplay/f2_menu/icons/rules_new.png", function( pnl ) 
            local image = vgui.Create("DImage", pnl)
            image:SetPos( 0, 0 )
            image:SetSize( pnl:GetWide(), pnl:GetTall() )
            image:SetImage( "fadmin/listview.vmt" )
        end )
    end
    CarShop_Menu.ButtonList.AddButton( "Garage", "roleplay/f2_menu/icons/garage.png", function( pnl ) 
        pnl.GarageList = vgui.Create( "DPanelList", pnl )
        pnl.GarageList:SetSize( pnl:GetWide(), pnl:GetTall() )
        pnl.GarageList:SetPos( 0, 0 )
        pnl.GarageList:SetSpacing( 0 )
        pnl.GarageList:EnableHorizontal( false )
        pnl.GarageList:EnableVerticalScrollbar( true )
        pnl.GarageList.Paint = function()
            --draw.RoundedBox( 0, 0, 0, pnl.ButtonList:GetWide(), pnl.ButtonList:GetTall(), Color( 0, 0, 0, 255 ) )
        end
        pnl.GarageList.VBar.Paint = function() end
        pnl.GarageList.VBar.btnUp.Paint = function() end
        pnl.GarageList.VBar.btnDown.Paint = function() end
        pnl.GarageList.VBar.btnGrip.Paint = function() 
            draw.RoundedBox( 2, 0, 0, pnl.GarageList.VBar:GetWide(), pnl.GarageList.VBar:GetTall(), Color( 0, 0, 0, 50 ) )
        end
        
        for k, v in pairs( LocalPlayer():GetRPVar( "garage_table" ) ) do
            local carpanel = vgui.Create( "DPanel", pnl.GarageList )
            carpanel:SetSize( pnl:GetWide(), pnl:GetTall()/4 )
            carpanel.Paint = function() 
                draw.RoundedBox( 0, 0, 0, carpanel:GetWide(), carpanel:GetTall(), Color( 240, 240, 240, 255 ) )
            end

            local icon = vgui.Create( "DModelPanel", carpanel )
            icon:SetPos( 2, 2 )
            icon:SetModel( v.Model )
            CARSHOP.ApplyVisuals( LocalPlayer(), icon:GetEntity(), k )
            icon:SetColor( Color( v.col_r, v.col_g, v.col_b, 255 ) )
            local max, min = icon:GetEntity():GetRenderBounds()
            icon:SetSize( carpanel:GetTall() - 4, carpanel:GetTall() - 4 )
            icon:SetCamPos( Vector( 0.4, 0.5, 0.3 ) * min:Distance( max ) )
                                      icon:SetLookAt( ( min + max ) / 2 )
            icon.LayoutEntity = function( Entity )
                if ( icon.bAnimated ) then
                    icon:RunAnimation()
                end
            end
            icon:GetEntity():SetAngles( Angle( 0, 0, 0 ) )
            
            local move_panel = vgui.Create( "DPanel", carpanel )
            move_panel:SetPos( 2 + icon:GetWide(), 0 )
            move_panel:SetSize( carpanel:GetWide() - ( 2 + icon:GetWide() ), carpanel:GetTall() )
            move_panel.inmove = false
            move_panel.status = 1
            move_panel.still_selected = false
			move_panel.parents = {}
            move_panel.Paint = function() 
                --draw.RoundedBox( 0, 0, 0, move_panel:GetWide(), move_panel:GetTall(), Color( 0, 0, 0, 150 ) )
                
                if move_panel.status == 1 then
                    local text = v.Name
                    local font = "RPNormal_35"
                    surface.SetFont( font )
                    local w, h = surface.GetTextSize( text )
                    
                    local col = HUD_SKIN.FULL_GREY
                    
                    draw.SimpleText( text, font, (move_panel:GetWide() - w)/2, (move_panel:GetTall() - h)/2, Color( col.r, col.g, col.b, col.a - 50 ) )
                    text = "Halte die Maus hier drüber für mehr Informationen!"
                    font = "RPNormal_21"
                    surface.SetFont( font )
                    w, h = surface.GetTextSize( text )
                    
                    draw.SimpleText( text, font, (move_panel:GetWide() - w)/2, (move_panel:GetTall() - h)/1.4, Color( col.r, col.g, col.b, col.a - 50 ) )
                end
                if move_panel.status == 2 then
                    local text = v.Name
                    local font = "RPNormal_45"
                    surface.SetFont( font )
                    local w, h = surface.GetTextSize( text )
                    
                    local col = HUD_SKIN.FULL_GREY
                    
                    local sell = CARSHOP.CalculateSellPrice( LocalPlayer(), k )
                    draw.SimpleText( text, font, 2, 2, Color( col.r, col.g, col.b, col.a - 50 ) )
                    draw.SimpleText( sell .. ",-EUR", "RPNormal_25", w + 1, h - 26, Color( col.r, col.g, col.b, col.a - 50 ) )
                    draw.SimpleText( v.Desc, "RPNormal_20", 2, h - 8, Color( col.r, col.g, col.b, col.a - 50 ) )
                    text = "HP"
                    font = "RPNormal_27"
                    surface.SetFont( font )
                    w, h = surface.GetTextSize( text )
                    draw.SimpleText( text, font, 2, move_panel:GetTall()/2, Color( col.r, col.g, col.b, col.a - 50 ) )
                    draw.SimpleText( "Armor", font, 2, h + 60, Color( col.r, col.g, col.b, col.a - 50 ) )
                    
                    local max_hp = CARSHOP.CARTABLE.CARS[k].Health or 0
                    local max_armor = CARSHOP.CARTABLE.CARS[k].Armor or 0
                    local max_tank = CARSHOP.CARTABLE.CARS[k].Fuel or 0
                    local max_sk = CARSHOP.GetHighestAmount( "Damage_Class" ) or 0
                    move_panel.CreateProgressBar( w + 42, move_panel:GetTall()/2 + 12, 100, 3, v.Health, max_hp )
                    move_panel.CreateProgressBar( w + 42, h+60 + 12, 100, 3, v.Armor, max_armor )
                    
                    draw.SimpleText( "Tank", font, w + 180, h + 60, Color( col.r, col.g, col.b, col.a - 50 ) )
                    move_panel.CreateProgressBar( w + 225, h+60 + 12, 100, 3, v.Fuel, max_tank )
                    draw.SimpleText( "S.K", font, w + 180, move_panel:GetTall()/2, Color( col.r, col.g, col.b, col.a - 50 ) )
                    move_panel.CreateProgressBar( w + 225, move_panel:GetTall()/2 + 12, 100, 3, v.Damage_Class, max_sk )
                end
            end
            move_panel.OnCursorEntered = function()
                move_panel.entered = true
                if move_panel.inmove && move_panel.status == 2 && move_panel.still_selected == false then
                    move_panel.still_selected = true
                end
                if move_panel.inmove == true then return end
                if move_panel.status == 2 then return end
                
                move_panel.inmove = true
                
                local x, y = move_panel:GetPos()
                move_panel:MoveTo( carpanel:GetWide(), y, 0.2, 0, -1, function()
                    move_panel.PurchaseButton:Show()
                    move_panel.ViewButton:Show()
                    move_panel.status = 2
                    timer.Simple( 0.2, function()
                        if IsValid(move_panel) then
                            move_panel:MoveTo( x, y, 0.2, 0, -1, function() 
                                move_panel.inmove = false
                                if move_panel.still_selected == false then
                                    move_panel.OnCursorExited()
                                end
                            end)
                        end
                    end)
                end)
            end
            move_panel.OnCursorExited = function()
                move_panel.entered = false
				timer.Simple( 0.5, function()
                    if IsValid(move_panel) then
    					if move_panel.inmove == true then return end
                        if move_panel.status == 1 then return end
    					if move_panel.entered == true then return end
    					
    					// Checks if cursor on a parented panel
    					for k, v in pairs( move_panel.parents ) do
    						if v.focused then return end
    					end
    					
    					move_panel.inmove = true
    					move_panel.still_selected = false
    					
    					local x, y = move_panel:GetPos()
    					
    					move_panel:MoveTo( carpanel:GetWide(), y, 0.2, 0, -1, function()
    						move_panel.status = 1
    						move_panel.PurchaseButton:Hide()
    						move_panel.ViewButton:Hide()
    						timer.Simple( 0.2, function()
                                if IsValid(move_panel) then
        							move_panel:MoveTo( x, y, 0.2, 0, -1, function() 
        								move_panel.inmove = false
        							end)
                                end
    						end)
    					end)
                    end
				end)
            end
            
            move_panel.PurchaseButton = vgui.Create( "DButton", move_panel )
            move_panel.PurchaseButton:SetSize( 100, 50 )
            local m_w, m_h = (move_panel:GetWide() - move_panel.PurchaseButton:GetWide()) - 15, 20
            move_panel.PurchaseButton:SetPos( m_w, m_h )
            move_panel.PurchaseButton:SetText( "" )
			move_panel.PurchaseButton.focused = false
			move_panel.PurchaseButton.OnCursorEntered = function() move_panel.PurchaseButton.focused = true end
			move_panel.PurchaseButton.OnCursorExited = function() move_panel.PurchaseButton.focused = false end
            move_panel.PurchaseButton.Paint = function()
                local text = "Verkaufen"
                local font = "RPNormal_25"
                surface.SetFont( font )
                local w, h = surface.GetTextSize( text )
                
                draw.RoundedBox( 0, 0, 0, move_panel.PurchaseButton:GetWide(), move_panel.PurchaseButton:GetTall(), HUD_SKIN.FULL_GREY )
                draw.SimpleText( text, font, (move_panel.PurchaseButton:GetWide() - w)/2, (move_panel.PurchaseButton:GetTall() - h)/2, Color( 255, 255, 255, 255 ) )
            end
            move_panel.PurchaseButton.DoClick = function()
                net.Start( "CarDealer_SellCar" )
                    net.WriteString( k )
                net.SendToServer()
            end
            move_panel.PurchaseButton.Think = function()
                v.Sold = v.Sold or false
                if v.Sold then 
                    move_panel.PurchaseButton:SetEnabled( false ) 
                else 
                    move_panel.PurchaseButton:SetEnabled( true ) 
                end
            end
            move_panel.PurchaseButton:Hide()
            
            move_panel.ViewButton = vgui.Create( "DButton", move_panel )
			move_panel.ViewButton.focused = false
			move_panel.ViewButton.OnCursorEntered = function() move_panel.ViewButton.focused = true end
			move_panel.ViewButton.OnCursorExited = function() move_panel.ViewButton.focused = false end
            move_panel.ViewButton:SetSize( 100, 25 )
            local m_w, m_h = (move_panel:GetWide() - move_panel.ViewButton:GetWide()) - 15, 20 + (move_panel.PurchaseButton:GetTall() + 5)
            move_panel.ViewButton:SetPos( m_w, m_h )
            move_panel.ViewButton:SetText( "" )
            move_panel.ViewButton.Paint = function()
                draw.RoundedBox( 0, 0, 0, move_panel.ViewButton:GetWide(), move_panel.ViewButton:GetTall(), HUD_SKIN.THEME_COLOR )
                local text = ""
                local rech = math.Round(((v.repair - os.time()) / 60))
                if v.repair > 1 then
                    text = rech .. " Minuten"
                elseif v.Health > 50 then
                    text = "In Takt"
                else
					if move_panel.ViewButton.focused then
						text = tostring(CARSHOP.CalculateRepairCost( k, LocalPlayer() )) .. ",-€"
					else
						text = "Reparieren"
					end
                end
                local font = "RPNormal_25"
                surface.SetFont( font )
                local w, h = surface.GetTextSize( text )
                draw.SimpleText( text, font, (move_panel.ViewButton:GetWide() - w)/2, (move_panel.ViewButton:GetTall() - h)/2, Color( 255, 255, 255, 255 ) )

            end
            move_panel.ViewButton.DoClick = function()
                net.Start( "CarDealer_RepairCar" )
                    net.WriteString( k )
                net.SendToServer()
            end
            move_panel.ViewButton:Hide()
            
            function move_panel.CreateProgressBar( x, y, w, h, value, max )
                local rech = (w / max) * value
                draw.RoundedBox( 0, x - 1, y - 3, 1, h + 6, Color( 50, 50, 50, 200 ) )
                draw.RoundedBox( 0, x + ((w / max)*max), y - 3, 1, h + 6, Color( 50, 50, 50, 200 ) )
                draw.RoundedBox( 0, x, y, w, h, Color( 0, 0, 0, 50 ) )
                draw.RoundedBox( 0, x, y, rech, h, Color( 50, 50, 50, 200 ) )
            end
            
			
			// Add all the contents for the parent check
			table.insert( move_panel.parents, move_panel.ViewButton )
			table.insert( move_panel.parents, move_panel.PurchaseButton )
            
            pnl.GarageList:AddItem( carpanel )
        end
    end )


    CarShop_Menu.ButtonList.RefreshList()
end