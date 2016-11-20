if SERVER then
    util.AddNetworkString( "Item_Sell_Purchase" )
    util.AddNetworkString( "Open_SellItem_Menu" )
    util.AddNetworkString( "Ply_Sellitem" )
    
    net.Receive( "Item_Sell_Purchase", function( data, ply )
        local ent = net.ReadEntity()
        
        if !(IsValid( ply )) then return end
        if !(IsValid( ent )) then return end
        if !(ent.itemclass) then return end
		
		local item = itemstore.Item( ent.itemclass )
        if !(ply.Inventory:CanFit( item )) then return end
        
        local steuer = (ent:GetRPVar( "price" )/100) * ECONOMY.KAUFSTEUER
        if !(ply:CanAfford( (ent:GetRPVar( "price" ) + steuer) )) then return end
        if ent.sold then return end
        
        local o = FindPlayerBySteamID( ent.owner )
        if o == nil then ent:Remove() return end
       
        ply:AddCash( -(ent:GetRPVar( "price" ) + steuer) )
        o:SetSkill( "Handels Fähigkeit", 0.05, true )
        o:AddCash( ent:GetRPVar( "price" ) )
        o:RPNotify( ply:GetRPVar( "rpname" ) .. " hat einmal: " .. ent:GetRPVar( "name" ) .. " gekauft. Für: " .. math.Round(ent:GetRPVar( "price" )) .. ",-€", 5 )
		
		
		ent.data = ent.data or nil
		if ent.data != nil then				// Parameter übernehmen
			for k, v in pairs( ent.data ) do
				ent[k] = v
			end
		end
        
        local item = class == "itemstore_item" and ent:GetItem() or itemstore.Item( itemstore.items.Pickups[ ent.itemclass ] )
        item:Run( "CanPickup", ply, ent )
        item:Run( "SaveData", ent )
		item:Run( "Pickup", ply, ent )
        ply.Inventory:AddItem( item )
        
        --ply:AddInvItem( ent.itemclass, 1 )
        ECONOMY.AddCityCash( steuer )
        ent.sold = true
        ent:Remove()
    end)
    
    local meta = FindMetaTable( "Player" )
    function meta:SellItem( container, slot, price, desc )
		container = itemstore.containers.Get( container )	// Is ID first, gets converted into container table
		
		local item = container:GetItem( slot )
		local class = item:GetData( "Class" )
		
		local cashregister = nil
		
		for k, v in pairs( ents.FindInSphere( self:GetPos(), 500 ) ) do
			if !(IsValid( v )) then continue end
			if v:GetClass() == "ent_kasse" then
				cashregister = v
				break
			end
		end
		
		if cashregister == nil then self:RPNotify( "Du brauchst eine Kasse um Sachen verkaufen zu können!", 5 ) return end
		if cashregister.owner == nil then self:RPNotify( "Du brauchst eine Kasse um Sachen verkaufen zu können!", 5 ) return end
		if FindPlayerBySteamID( cashregister.owner ) == nil then self:RPNotify( "Du brauchst eine Kasse um Sachen verkaufen zu können!", 5 ) return end
		
		if ( item ) then
			local pos = self:GetShootPos() + self:GetAimVector() * 32 
			local ent = ents.Create( "item_sale" )
			if class != nil then
				ent.class = class
			end
			ent:SetPos( pos )
			ent:SetModel( item:GetModel() )
			ent.owner = self:SteamID()
			ent.itemclass = item.Class
			ent:Spawn()

			ent.data = item.Data
			PrintTable( ent.data )
			
			timer.Simple( 1, function()
				ent:SetRPVar( "name", item:GetName() )
				ent:SetRPVar( "price", price )
				ent:SetRPVar( "desc", desc )
			end)
			
			if ( not item.Stackable or ( item:GetData( "Amount" ) or 1 ) <= 1 ) then
				container:TakeItems( item.Class, ( item:GetData( "Amount" ) or 1 ) )
			elseif ( item.Stackable ) then
				container:TakeItems( item.Class, ( item:GetData( "Amount" ) or 1 ) )
				container:Sync()
			end
			
			self:EmitSound( "items/ammocrate_open.wav" )
		end
	end
    net.Receive( "Ply_Sellitem", function( data, ply ) local tbl = net.ReadTable() ply:SellItem( ply.salecontainer, ply.saleslot, tbl.price, tbl.desc ) end )
    
    concommand.Add( "itemstore_sell", function( pl, cmd, args )
		local container = itemstore.containers.Active[ tonumber( args[ 1 ] ) ]
		if ( container ) then
            pl.salecontainer = tonumber( args[ 1 ] )
            pl.saleslot = tonumber( args[ 2 ] )
            net.Start( "Open_SellItem_Menu" )
                net.WriteTable( {container = tonumber( args[ 1 ] ), slot = tonumber( args[ 2 ] )} )
            net.Send( pl )
		end
	end )
end

if CLIENT then
    function OpenItemPurchaseMenu()
        local ent = net.ReadEntity()
        if !(IsValid( ent )) then return end
        
        local item_name = ent:GetRPVar( "name" ) or "Unbekannt"
        local item_beschreibung = ent:GetRPVar( "desc" ) or "Unbekannt"
        local item_preis = ent:GetRPVar( "price" ) or 0

        local buyframe = vgui.Create( "DFrame" )
        buyframe:SetSize( 550, 350 )
        buyframe:ShowCloseButton( false )
        buyframe:SetTitle( "" )
        buyframe:Center()
        buyframe:MakePopup()
        buyframe.Paint = function()
            draw.RoundedBox( 2, 0, 0, 550, 350, Color( 230, 230, 230, 255 ) )
            draw.RoundedBox( 2, 0, 0, 550, 50, HUD_SKIN.THEME_COLOR )
            draw.SimpleText( "Abrechnung", "RPNormal_35", 11, 8, Color( 255, 255, 255, 255 ) )
            
            draw.SimpleText( "Artikel:  " .. item_name, "RPNormal_35", 15, 70, Color( 0, 0, 0, 200 ) )
            
            draw.SimpleText( "Beschreibung:  " .. item_beschreibung, "RPNormal_27", 15, 100, Color( 0, 0, 0, 200 ) )
            draw.SimpleText( "Preis:  ", "RPNormal_27", 15, 150, Color( 0, 0, 0, 200 ) )
            draw.SimpleText( "Mehrwerts Steuer:  ", "RPNormal_27", 15, 175, Color( 0, 0, 0, 200 ) )
            draw.SimpleText( "Gesamt Betrag:  ", "RPNormal_27", 15, 240, Color( 0, 0, 0, 200 ) )
            draw.SimpleText( "Kapital:  ", "RPNormal_27", 15, 270, Color( 0, 0, 0, 200 ) )
            
            
            draw.SimpleText( "+ " .. item_preis .. ",-€", "RPNormal_27", buyframe:GetWide()/2, 150, Color( 200, 0, 0, 200 ) )
            local steuer_preis = math.Round((item_preis/100)*ECONOMY.KAUFSTEUER)
            draw.SimpleText( "+ " .. steuer_preis .. ",-€", "RPNormal_27", buyframe:GetWide()/2, 175, Color( 200, 0, 0, 200 ) )
            draw.SimpleText( (steuer_preis+item_preis) .. ",-€", "RPNormal_27", buyframe:GetWide()/2, 240, Color( 200, 0, 0, 200 ) )
            local cash = LocalPlayer():GetRPVar( "cash" )
            draw.SimpleText( cash .. ",-€ - >> " .. cash-(steuer_preis+item_preis) .. ",-€", "RPNormal_27", buyframe:GetWide()/2, 270, Color( 0, 170, 0, 200 ) )
        end

        buyframe.purchase = vgui.Create( "DButton", buyframe )
        buyframe.purchase:SetSize( buyframe:GetWide()/2, 40 )
        buyframe.purchase:SetPos( 0, buyframe:GetTall() - buyframe.purchase:GetTall() )
        buyframe.purchase:SetText( "" )
        buyframe.purchase.Paint = function()
            draw.RoundedBox( 0, 0, 0, buyframe.purchase:GetWide(), buyframe.purchase:GetTall(), HUD_SKIN.THEME_COLOR )
            draw.SimpleText( "Bezahlen", "RPNormal_35", 80, 2.5, Color( 255, 255, 255, 255 ) )
        end
        buyframe.purchase.DoClick = function()
            net.Start( "Item_Sell_Purchase" )
                net.WriteEntity( ent )
            net.SendToServer()
            buyframe:Close()
        end

        buyframe.cancel = vgui.Create( "DButton", buyframe )
        buyframe.cancel:SetSize( buyframe:GetWide()/2, 40 )
        buyframe.cancel:SetPos( buyframe.purchase:GetWide(), buyframe:GetTall() - buyframe.cancel:GetTall() )
        buyframe.cancel:SetText( "" )
        buyframe.cancel.Paint = function()
            draw.RoundedBox( 0, 0, 0, buyframe.cancel:GetWide(), buyframe.cancel:GetTall(), Color( 180, 180, 180, 255 ) )
            draw.SimpleText( "Abbrechen", "RPNormal_35", 80, 2.5, Color( 255, 255, 255, 255 ) )
        end
        buyframe.cancel.DoClick = function() buyframe:Close() end
    end
    net.Receive( "OpenItemPurchaseMenu", OpenItemPurchaseMenu )
    
    
    function OpenSellItemMenu( container, slot )
        local item_name = itemstore.containers.Get( LocalPlayer().InventoryID ):GetItem( slot ):GetName()
        local item_sell_frame = vgui.Create( "DFrame" )
        item_sell_frame:SetSize( 450 , 250 )
        item_sell_frame:SetTitle( "" )
        item_sell_frame:ShowCloseButton( false )
        item_sell_frame:Center()
        item_sell_frame:MakePopup()
        item_sell_frame.Paint = function()
            draw.RoundedBox( 2, 0, 0, item_sell_frame:GetWide(), item_sell_frame:GetTall(), Color( 230, 230, 230, 255 ) )
            draw.RoundedBox( 2, 0, 0, item_sell_frame:GetWide(), 50, HUD_SKIN.THEME_COLOR )
            draw.SimpleText( "Gegenstand Verkaufen", "RPNormal_30", 15, 10, Color( 255, 255, 255, 255 ) )
            draw.SimpleText( "Gegenstand Name:  " .. item_name, "RPNormal_30", 15, 65, Color( 0, 0, 0, 200 ) )
            
            draw.SimpleText( "Preis: ", "RPNormal_27", 15, 110, Color( 0, 0, 0, 200 ) )
            draw.SimpleText( "Beschreibung: ", "RPNormal_27", 15, 140, Color( 0, 0, 0, 200 ) )
        end

        item_sell_frame.price = vgui.Create( "DTextEntry", item_sell_frame )
        item_sell_frame.price:SetPos( 70, 110 )
        item_sell_frame.price:SetTall( 26 )
        item_sell_frame.price:SetWide( 100 )
        item_sell_frame.price:SetFont( "RPNormal_25" )
        item_sell_frame.price:SetTextColor( Color( 100, 100, 100, 255 ) )

        item_sell_frame.desc = vgui.Create( "DTextEntry", item_sell_frame )
        item_sell_frame.desc:SetPos( 140, 140 )
        item_sell_frame.desc:SetTall( 26 )
        item_sell_frame.desc:SetWide( 250 )
        item_sell_frame.desc:SetFont( "RPNormal_25" )
        item_sell_frame.desc:SetTextColor( Color( 100, 100, 100, 255 ) )

        item_sell_frame.okbtn = vgui.Create( "DButton", item_sell_frame )
        item_sell_frame.okbtn:SetPos( 0, item_sell_frame:GetTall() - 35 )
        item_sell_frame.okbtn:SetSize( item_sell_frame:GetWide()/2, 35 )
        item_sell_frame.okbtn:SetText( "" )
        item_sell_frame.okbtn.Paint = function()
            local i = item_sell_frame.okbtn
            draw.RoundedBox( 2, 0, 0, i:GetWide(), i:GetTall(), HUD_SKIN.THEME_COLOR )
            draw.SimpleText( "Verkaufen", "RPNormal_30", 60, 2, Color( 255, 255, 255, 255 ) )
        end
        item_sell_frame.okbtn.DoClick = function()
            if tonumber( item_sell_frame.price:GetValue() ) && tonumber(item_sell_frame.price:GetValue()) > 0 then
                net.Start( "Ply_Sellitem" )
                    net.WriteTable( { container = container, slot = slot, price = tonumber( item_sell_frame.price:GetValue() ), desc = tostring( item_sell_frame.desc:GetValue() ) } )
                net.SendToServer()
                item_sell_frame:Close()
            end
        end

        item_sell_frame.cancelbtn = vgui.Create( "DButton", item_sell_frame )
        item_sell_frame.cancelbtn:SetPos( item_sell_frame.okbtn:GetWide(), item_sell_frame:GetTall() - 35 )
        item_sell_frame.cancelbtn:SetSize( item_sell_frame:GetWide()/2, 35 )
        item_sell_frame.cancelbtn:SetText( "" )
        item_sell_frame.cancelbtn.Paint = function()
            local i = item_sell_frame.cancelbtn
            draw.RoundedBox( 2, 0, 0, i:GetWide(), i:GetTall(), Color( 180, 180, 180, 255 ) )
            draw.SimpleText( "Abbrechen", "RPNormal_30", 65, 2, Color( 255, 255, 255, 255 ) )
        end
        item_sell_frame.cancelbtn.DoClick = function()
            item_sell_frame:Close()
        end
    end
    net.Receive( "Open_SellItem_Menu", function() 
        local tbl = net.ReadTable()
        OpenSellItemMenu( tbl.container, tbl.slot ) 
    end )
end
