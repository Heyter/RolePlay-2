RP.Shops = {}

RP.Shops["Moebel"] = {
    shipping_time = 600,
    Spawninfo = {
        pos = Vector( -6894, -9946, 73 ),
        ang = Angle( 0, 0, 0 ),
        model = "models/Humans/Group02/Female_07.mdl",
        size = 0.8
    },
    Itemlist = {
        {name = "Eisentor", type = "nosrp_prop", model = "models/props_lab/blastdoor001c.mdl", price = 1500, min_stock = 10, max_stock = 50},
        {name = "Eisentor klein", type = "nosrp_prop", model = "models/props_lab/blastdoor001b.mdl", price = 750, min_stock = 10, max_stock = 50},
        {name = "Kleiderschrank", type = "nosrp_prop", model = "models/props_c17/FurnitureDresser001a.mdl", price = 500, min_stock = 10, max_stock = 50},
        {name = "Backofen", type = "nosrp_prop", model = "models/props_c17/furnitureStove001a.mdl", price = 1500, min_stock = 10, max_stock = 50},
        {name = "Trockner", type = "nosrp_prop", model = "models/props_c17/FurnitureWashingmachine001a.mdl", price = 1500, min_stock = 10, max_stock = 50},
        {name = "Bücher Regal", type = "nosrp_prop", model = "models/props_interiors/Furniture_shelf01a.mdl", price = 250, min_stock = 10, max_stock = 50},
        {name = "Mülleimer", type = "nosrp_prop", model = "models/props_trainstation/trashcan_indoor001b.mdl", price = 200, min_stock = 10, max_stock = 50},
        {name = "Eisentisch klein", type = "nosrp_prop", model = "models/props_wasteland/kitchen_counter001b.mdl", price = 650, min_stock = 10, max_stock = 50},
        {name = "Rotes Sofa", type = "nosrp_prop", model = "models/props_c17/FurnitureCouch001a.mdl", price = 325, min_stock = 10, max_stock = 50},
        {name = "Grünes Sofa", type = "nosrp_prop", model = "models/props_c17/FurnitureCouch002a.mdl", price = 325, min_stock = 10, max_stock = 50},
        {name = "Holz Stuhl", type = "nosrp_prop", model = "models/props_c17/FurnitureChair001a.mdl", price = 150, min_stock = 10, max_stock = 50},
        {name = "Metall Stuhl", type = "nosrp_prop", model = "models/props_c17/chair02a.mdl", price = 150, min_stock = 10, max_stock = 50},
        {name = "Wassertonne", type = "nosrp_prop", model = "models/props_borealis/bluebarrel001.mdl", price = 225, min_stock = 10, max_stock = 50},
        {name = "Lampenschirm", type = "nosrp_prop", model = "models/props_c17/lampShade001a.mdl", price = 50, min_stock = 10, max_stock = 50},
        {name = "Holztisch", type = "nosrp_prop", model = "models/props_combine/breendesk.mdl", price = 650, min_stock = 10, max_stock = 50},
        {name = "Nobler Sessel", type = "nosrp_prop", model = "models/props_combine/breenchair.mdl", price = 250, min_stock = 10, max_stock = 50},
        {name = "Verkehrshütchen", type = "nosrp_prop", model = "models/props_junk/TrafficCone001a.mdl", price = 150, min_stock = 10, max_stock = 50},
        {name = "Barrikate doppelseitig", type = "nosrp_prop", model = "models/props_wasteland/barricade001a.mdl", price = 400, min_stock = 10, max_stock = 50},
        {name = "Barrikate einseitig", type = "nosrp_prop", model = "models/props_wasteland/barricade002a.mdl", price = 300, min_stock = 10, max_stock = 50},
        {name = "Eisenplatte", type = "nosrp_prop", model = "models/props_junk/TrashDumpster02b.mdl", price = 925, min_stock = 10, max_stock = 50},
        {name = "Eisentisch Lang", type = "nosrp_prop", model = "models/props_wasteland/controlroom_desk001a.mdl", price = 1025, min_stock = 10, max_stock = 50},
        {name = "Eisentisch Kurz", type = "nosrp_prop", model = "models/props_wasteland/controlroom_desk001b.mdl", price = 975, min_stock = 10, max_stock = 50}
    }
}

RP.Shops["Bauladen"] = {
    shipping_time = 600,
    Spawninfo = {
        pos = Vector( -6894, -10477, 73 ),
        ang = Angle( 0, 0, 0 ),
        model = "models/Humans/Group02/Female_02.mdl",
        size = 1
    },
    Itemlist = {
        {name = "Karton", type = "cardboard_box", model = "models/props_junk/cardboard_box004a.mdl", price = 100, min_stock = 10, max_stock = 50},
        {name = "Stueck Plastik", type = "chunk_of_plastic", model = "models/props_c17/canisterchunk01a.mdl", price = 250, min_stock = 10, max_stock = 50},
        {name = "Blumentopf", type = "drug_pot", model = "models/props_c17/pottery06a.mdl", price = 1000, min_stock = 10, max_stock = 50},
        {name = "Kleber", type = "glue", model = "models/props_lab/jar01b.mdl", price = 250, min_stock = 10, max_stock = 50},
        {name = "Lodine", type = "lodine", model = "models/props_lab/jar01a.mdl", price = 125, min_stock = 10, max_stock = 50},
        {name = "Poliermittel", type = "metal_polish", model = "models/props_junk/plasticbucket001a.mdl", price = 250, min_stock = 10, max_stock = 50},
        {name = "Metallstange", type = "metal_rod", model = "models/props_c17/signpole001.mdl", price = 400, min_stock = 10, max_stock = 50},
        {name = "Farbeimer", type = "paint_bucket", model = "models/props_junk/metal_paintcan001a.mdl", price = 225, min_stock = 10, max_stock = 50},
        {name = "Stück Metall", type = "piece_of_metal", model = "models/gibs/metal_gib4.mdl", price = 450, min_stock = 10, max_stock = 50},
        {name = "Kabelrolle", type = "rope_roll", model = "models/props_c17/pulleywheels_small01.mdl", price = 250, min_stock = 10, max_stock = 50},
        {name = "Holzregal", type = "wooden_board", model = "models/props_c17/FurnitureShelf001b.mdl", price = 225, min_stock = 10, max_stock = 50},
        {name = "Nagel", type = "wooden_nail", model = "models/props_c17/TrapPropeller_Lever.mdl", price = 150, min_stock = 10, max_stock = 50}
    }
}

RP.Shops["Tankstelle"] = {
    shipping_time = 600,
    Spawninfo = {
        pos = Vector( -7490, -6604, 73 ),
        ang = Angle( 0, 90, 0 ),
        model = "models/Humans/Group02/male_09.mdl",
        size = 1.1
    },
    Itemlist = {
        {name = "Bionade", type = "bionade", model = "models/props_junk/garbage_glassbottle003a.mdl", price = 25, min_stock = 10, max_stock = 50},
        {name = "Radio", type = "radio", model = "models/props/cs_office/radio.mdl", price = 1500, min_stock = 1, max_stock = 5},
        {name = "Alarmanlage", type = "door_alarm", model = "models/props_lab/reciever01d.mdl", price = 500, min_stock = 1, max_stock = 5},
        {name = "Kasse", type = "ent_kasse", model = "models/props_c17/cashregister01a.mdl", price = 1500, min_stock = 5, max_stock = 15},
        {name = "Volle Autobatterie", type = "normal_batterie", model = "models/Items/car_battery01.mdl", price = 250, min_stock = 5, max_stock = 15},
        {name = "Herzschlagmessgerät", type = "item_lifealert", model = "models/props_c17/FurnitureDresser001a.mdl", price = 5000, min_stock = 5, max_stock = 15},
        {name = "Katzenstreu", type = "kitty_litter", model = "models/props_junk/cardboard_box001a.mdl", price = 250, min_stock = 10, max_stock = 30},
        {name = "Propan Tank", type = "propane_tank", model = "models/props_junk/PropaneCanister001a.mdl", price = 1000, min_stock = 10, max_stock = 20},
        {name = "Benzin Kanister", type = "fuel_can", model = "models/props_junk/gascan001a.mdl", price = 1000, min_stock = 5, max_stock = 20},
        {name = "Feuerlöscher", type = "fire_extinguisher", model = "models/props/cs_office/Fire_Extinguisher.mdl", price = 1500, min_stock = 5, max_stock = 15}
    }
}

if SERVER then
    util.AddNetworkString( "PurchaseShopItems" )
    util.AddNetworkString( "OpenItemShop" )
    
    // NPC Spawning
        hook.Add( "Initialize", "NOSRP_SpawnShops", function()
            timer.Simple( 5, function()
                for k, v in pairs( RP.Shops ) do
                    local npc = ents.Create( "npc_ventor" )
                    npc:SetPos( v.Spawninfo.pos )
                    npc:SetAngles( v.Spawninfo.ang )
                    npc:SetModelScale( v.Spawninfo.size or 1, 1 )
                    npc:Spawn()
                    npc.dialogfixed = false
                    npc.callfunc = function( ply ) net.Start( "OpenItemShop" ) net.WriteEntity( npc ) net.Send( ply ) end
                    npc:SetModel( v.Spawninfo.model )
                    npc.ShopStorage = {}
					npc.shop_index = k
                    
                    for i, tbl in pairs( RP.Shops[k].Itemlist ) do
                        npc.ShopStorage[tbl.type] = math.Round( math.Rand( tbl.min_stock or 10, tbl.max_stock or 50) )
                    end
                    
                    npc:SetRPVar( "ShopIndex", k )
                    npc:SetRPVar( "Storage", npc.ShopStorage )
                    
                    timer.Create( "Shop_Refill_" .. tostring( npc:EntIndex() ), v.shipping_time, 0, function()
                        for i, tbl in pairs( RP.Shops[k].Itemlist ) do
                            npc.ShopStorage[tbl.type] = math.Round( math.Rand( tbl.min_stock or 10, tbl.max_stock or 50) )
                        end
                        npc:SetRPVar( "Storage", npc.ShopStorage )
                    end)
                end
            end)
        end)
    //
	
	
	concommand.Add( "shop_refill", function( ply )
		if !(ply:IsSuperAdmin()) then return false end
	
		local tr = util.TraceLine( {
			start = ply:EyePos(),
			endpos = ply:EyePos() + ply:EyeAngles():Forward() * 500,
			filter = {ply}
		} )
		
		print( tr.Entity )
		if tr.Entity == nil or tr.Entity:GetClass() != "npc_ventor" then 
			ply:PrintMessage(HUD_PRINTTALK, "you need to look at a Ventor!" );
			return 
		end
		
		local shop_list = tr.Entity.shop_index
		local npc = tr.Entity
		
		for i, tbl in pairs( RP.Shops[shop_list].Itemlist ) do
			npc.ShopStorage[tbl.type] = math.Round( math.Rand( tbl.min_stock or 10, tbl.max_stock or 50) )
		end
		
		npc:SetRPVar( "Storage", npc.ShopStorage )
	end) 

    net.Receive( "PurchaseShopItems", function( data, ply )
        local tbl = net.ReadTable()
        local npc = Entity( tonumber(net.ReadString()) )
        local cost = 0
        
        if !(npc:GetRPVar( "Storage" )) then return end
        
        for k, v in pairs( tbl ) do
            local storage = npc:GetRPVar( "Storage" )[v.class]
            if storage <= 0 then continue end
            
            local total = v.cost*v.amount
            total = math.Round(total + (total * ECONOMY.KAUFSTEUER))
            
            if !(ply:CanAfford( total )) then continue end
            local item = itemstore.Item( v.class )
            if !(ply.Inventory:CanFit( item )) then continue end
            
            local mdl = ""
            if v.class == "nosrp_prop" then mdl = v.model else mdl = RP.CRAFTING.GetItemInfo( v.class ).Model end
            
            item:SetData( "Class", v.class )
            item:SetData( "Model", mdl )
            item:SetData( "Name", v.name )
            if item.Stackable then item:SetData( "Amount", v.amount ) end
            
            if item.Stackable then 
                ply.Inventory:AddItem( item )
            else
                for i=1, v.amount do
                    ply.Inventory:AddItem( item )
                end
            end
            ply:AddCash( -total )
            
            local new_amount = math.Clamp( storage - v.amount, 0, 9999 )
            local s = npc:GetRPVar( "Storage" )
            s[v.class] = new_amount
            
            npc:SetRPVar( "Storage", s )
        end
    end)
end

if CLIENT then
    net.Receive( "OpenItemShop", function( data )
        Open_Shop_Menu( net.ReadEntity() )
    end)
    
    function Open_Shop_Menu( npc )
        local shop = npc:GetRPVar( "ShopIndex" )
        local name = shop
        shop = RP.Shops[shop]
        local _basket = {}
        local storage = (npc:GetRPVar( "Storage" ) or {})
        if shop == nil then
            net.Start( "SendPlayerVar" )
            net.SendToServer()
            return 
        end

        function AddToBasket( name, cost, classname, model )
            local total = cost
            total = cost + (total * ECONOMY.KAUFSTEUER)
        
            local c = 0
            for k, v in pairs( _basket ) do
                c = c + (v.cost*v.amount)
            end
            
            c = c + total
            if LocalPlayer():GetRPVar( "cash" ) < c then return end
            
            local found = false
            for k, v in pairs( _basket ) do
                if name == v.name then
                    v.amount = v.amount + 1
                    found = true
                end
            end
            if !(found) then
                table.insert( _basket, {name = name, class = classname, amount = 1, cost = total, model = model} )
            end
            RefreshBasket()
        end

        function RemoveFromBasket( name )
            local found = false
            for k, v in pairs( _basket ) do
                if name == v.name then
                    v.amount = v.amount - 1
                    if v.amount < 1 then
                        table.remove( _basket, k )
                    end
                end
            end
            RefreshBasket()
        end

        function RefreshBasket()
            shop_menu.basket:Clear()
            local i = 0
            for k, v in pairs( _basket ) do
                local col = HUD_SKIN.LIST_BG_FIRST
                i = i + 1
                if i == 2 then col = HUD_SKIN.LIST_BG_SECOND i = 0 end
                
                local p = vgui.Create( "DPanel", basket )
                p:SetWide( shop_menu:GetWide() )
                p:SetTall( shop_menu.basket:GetTall()/6 )
                p.col = col
                p.Paint = function()
                    draw.RoundedBox( 0, 0, 0, p:GetWide(), p:GetTall(), p.col )
                    draw.SimpleText( v.amount .. "x " .. v.name, "RPNormal_26", 15, 1, Color( 50, 50, 50, 150 ) )
                end
                
                local del = vgui.Create( "DButton", p )
                del:SetText( "" )
                del:SetSize( 150, p:GetTall() - 4 )
                del:SetPos( p:GetWide() - del:GetWide(), 2 )
                del.name = v.name
                del.DoClick = function()
                    RemoveFromBasket( del.name )
                end
                del.Paint = function()
                    draw.RoundedBox( 2, 0, 0, del:GetWide(), del:GetTall(), Color( 0, 153, 204, 230 ) )
                    local font = "RPNormal_26"
                    local text = "1x Entfernen"
                    surface.SetFont( font )
                    local w, h = surface.GetTextSize( text )
                    draw.SimpleText( text, font, del:GetWide()/2 - w/2, del:GetTall()/2 - h/2, Color( 255, 255, 255, 255 ) )
                end
                
                shop_menu.basket:AddItem( p )
            end
        end

        shop_menu = vgui.Create( "DFrame" )
        shop_menu:SetSize( 650, 700 )
        shop_menu:SetTitle( "" )
        shop_menu:Center()
        shop_menu:MakePopup()
        shop_menu.Paint = function()
            draw.RoundedBox( 2, 0, 0, shop_menu:GetWide(), shop_menu:GetTall(), Color( 230, 230, 230, 255 ) )
            draw.RoundedBox( 2, 0, 0, shop_menu:GetWide(), 50, HUD_SKIN.THEME_COLOR )
            
            draw.SimpleText( "Shop - " .. name, "RPNormal_45", 15, 2, Color( 255, 255, 255, 255 ) )
            
            draw.SimpleText( "Einkaufswagen:", "RPNormal_27", 15, 52, Color( 50, 50, 50, 150 ) )
            
            local cost = 0
            for k, v in pairs( _basket ) do
                cost = cost + (v.cost*v.amount)
            end
            local font = "RPNormal_27"
            local text = "Kosten: " .. cost .. ",-Euro"
            surface.SetFont( font )
            local w, h = surface.GetTextSize( text )
            draw.SimpleText( text, font, shop_menu:GetWide() - (w+15), 52, Color( 200, 0, 0, 200 ) )
            
            draw.RoundedBox( 0, 0, shop_menu:GetTall()/3, shop_menu:GetWide(), 30, HUD_SKIN.THEME_COLOR )
            draw.SimpleText( "Artikel die wir auf Lager haben:", "RPNormal_27", 15, shop_menu:GetTall()/3, Color( 255, 255, 255, 255 ) )
        end

        local purchase = vgui.Create( "DButton", shop_menu )
        purchase:SetText( "" )
        purchase:SetSize( 250, 30 )
        purchase:SetPos( shop_menu:GetWide() - purchase:GetWide(), shop_menu:GetTall()/3 )
        purchase.Paint = function()
            draw.RoundedBox( 4, 0, 0, purchase:GetWide(), purchase:GetTall(), Color( 80, 80, 80, 255 ) )
            local font = "RPNormal_27"
            local text = "Kaufen"
            surface.SetFont( font )
            local w, h = surface.GetTextSize( text )
            draw.SimpleText( text, font, purchase:GetWide()/2 - w/2, purchase:GetTall()/2 - h/2-2, Color( 255, 255, 255, 255 ) )
        end
        purchase.DoClick = function()
            net.Start( "PurchaseShopItems" )
                net.WriteTable( _basket )
                net.WriteString( tostring( npc:EntIndex() ) )
            net.SendToServer()
            
            _basket = {}
            RefreshBasket()
        end

        local basket = vgui.Create( "DPanelList", shop_menu )
        basket:SetPos( 0, 80)
        basket:SetSize( shop_menu:GetWide(), shop_menu:GetTall()/4.55)
        basket:SetSpacing( 0 )
        basket:EnableHorizontal( false )
        basket:EnableVerticalScrollbar( true )
        basket.Paint = function()
            draw.RoundedBox( 0, 0, 0, basket:GetWide(), basket:GetTall(), Color( 0, 0, 0, 50 ) )
        end
        basket.Paint = function() end
        basket.VBar.Paint = function() end
        basket.VBar.btnUp.Paint = function() end
        basket.VBar.btnDown.Paint = function() end
        basket.VBar.btnGrip.Paint = function() 
            draw.RoundedBox( 2, 0, 0, basket.VBar:GetWide(), basket.VBar:GetTall(), Color( 0, 0, 0, 50 ) )
        end
        shop_menu.basket = basket

        local shop_list = vgui.Create( "DPanelList", shop_menu )
        shop_list:SetPos( 0, shop_menu:GetTall()/3 + 30 )
        shop_list:SetSize( shop_menu:GetWide(), shop_menu:GetTall() - 263)
        shop_list:SetSpacing( 0 )
        shop_list:EnableHorizontal( false )
        shop_list:EnableVerticalScrollbar( true )
        shop_list.Paint = function() end
        shop_list.VBar.Paint = function() end
        shop_list.VBar.btnUp.Paint = function() end
        shop_list.VBar.btnDown.Paint = function() end
        shop_list.VBar.btnGrip.Paint = function() 
            draw.RoundedBox( 2, 0, 0, shop_list.VBar:GetWide(), shop_list.VBar:GetTall(), Color( 0, 0, 0, 50 ) )
        end

        local i = 0
        for k, v in pairs( shop.Itemlist ) do
            v.instock = {}
            local col = HUD_SKIN.LIST_BG_FIRST
            i = i + 1
            if i == 2 then col = HUD_SKIN.LIST_BG_SECOND i = 0 end
            local p = vgui.Create( "DPanel", shop_list )
            p.col = col
            p:SetSize( shop_list:GetWide(), shop_list:GetTall()/4 )
            p:SetPos( 0, 0 )
            p.Paint = function()
                storage = (npc:GetRPVar( "Storage" ) or {})
                v.instock = storage[v.type]
                
                pric = math.Round(v.price + ( v.price*ECONOMY.KAUFSTEUER ))
                draw.RoundedBox( 0, 0, 0, p:GetWide(), p:GetTall(), p.col )
                draw.SimpleText( v.name, "RPNormal_45", p:GetTall() + 10, 5, Color( 50, 50, 50, 200 ) )
                draw.SimpleText( "Stk. auf Lager: " .. v.instock, "RPNormal_27", p:GetTall() + 10, 40, Color( 50, 50, 50, 200 ) )
                draw.SimpleText( "Preis: " .. pric .. ",-Euro", "RPNormal_27", p:GetTall() + 10, 70, Color( 50, 50, 50, 200 ) )
            end
            
            local icon = vgui.Create( "DModelPanel", p )
            local mdl = ""
            if v.type == "nosrp_prop" then mdl = v.model else mdl = RP.CRAFTING.GetItemInfo( v.type ).Model end
            icon:SetModel( mdl )
            icon:SetPos( 0, 0 )
            local ent = icon:GetEntity()
            icon:SetSize( p:GetTall(), p:GetTall() )
            local max, min = icon:GetEntity():GetRenderBounds()
			icon:SetCamPos( Vector( 0.5, 0.5, 0.6 ) * min:Distance( max ) )
		    icon:SetLookAt( ( min + max ) / 4 )
            
            local add = vgui.Create( "DButton", p )
            add:SetText( "" )
            add:SetSize( 230, p:GetTall()/2 )
            add:SetPos( p:GetWide() - (add:GetWide() + 25), p:GetTall()/4 )
            add.enabled = true
            add.Paint = function()
                draw.RoundedBox( 4, 0, 0, add:GetWide(), add:GetTall(), Color( 0, 153, 204, 230 ) )
                local font = "RPNormal_27"
                local text = "In den Einkaufswagen"
                if v.instock <= 0 then 
                    text = "Ausverkauft!" 
                    if add.enabled == true then add.enabled = false end
                end
                surface.SetFont( font )
                local w, h = surface.GetTextSize( text )
                draw.SimpleText( text, font, add:GetWide()/2 - w/2, add:GetTall()/2 - h/2, Color( 255, 255, 255, 255 ) )
            end
            add.DoClick = function()
                if add.enabled then
                    AddToBasket( v.name, v.price, v.type, v.model )
                end
            end
             
            
            shop_list:AddItem( p )
        end
    end
end