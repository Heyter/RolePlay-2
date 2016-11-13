//////////////// NET REGISTER ////////////////
util.AddNetworkString( "DrugDealer_Send_ClientInfo" )
util.AddNetworkString( "DrugDealer_PurchaseDrug" )
util.AddNetworkString( "DrugDealer_SellDrug" )
util.AddNetworkString( "Purchase_Succeed" )
util.AddNetworkString( "DrugDealer_Shop_Update_Items" )
util.AddNetworkString( "DrugDealer_Inspect_Drug" )
//////////////// END ////////////////


function DRUGDEALER.Initialize()    
    DRUGDEALER.RollNewDealer()
    DRUGDEALER.DecideSellPurchase()
end
hook.Add( "Initialize", "DRUGDEALER.Initialize", DRUGDEALER.Initialize )

hook.Add( "PlayerAuthed", "DRUGDEALER SendInfo", function( player )
    if IsValid( player ) then DRUGDEALER.SendClientInfo( player ) end
end)


function DRUGDEALER.SendClientInfo( player )
    local cache = {
        Dealer = DRUGDEALER.CurDealer,
        Purchasing = DRUGDEALER.Purchasing,
        IsSelling = DRUGDEALER.IsSelling,
        Autoclose = DRUGDEALER.LastSwitch + DRUGDEALER.CONFIG.RotationTime,
        Stocks = DRUGDEALER.Stocks,
		MinRuf = DRUGDEALER.MaxRuf
    }
	
    net.Start( "DrugDealer_Send_ClientInfo" )
        net.WriteTable( cache )
    net.Send( player )
end

function DRUGDEALER.RollNewDealer()     // Returns dealer string vom [array]
    local dealer_count = 0
    local cache = {}
    local rand = nil
    DRUGDEALER.Stocks = {}
    
    for k, v in pairs( DRUGDEALER.Dealers ) do
        table.insert( cache, k )
        dealer_count = dealer_count + 1
    end
    
    rand = math.Round( math.Rand( 1, dealer_count ) )
    
    local dealer = cache[rand]
    DRUGDEALER.CurDealer = dealer
	DRUGDEALER.MaxRuf = DRUGDEALER.Dealers[dealer].ruf
    
    // Roll Stock
    
    for k, v in pairs( DRUGDEALER.Dealers[dealer].selling ) do
        rand = math.Round( math.Rand( DRUGDEALER.Dealers[dealer].min_drugs, DRUGDEALER.Dealers[dealer].max_drugs / 3 ) )
        --local quality = math.Round( math.Rand( DRUGDEALER.Dealers[dealer].sale_quality[ v ].min, DRUGDEALER.Dealers[dealer].sale_quality[ v ].max ) )
        
        local mdl = DRUGDEALER.Dealers[dealer].sale_quality[ v ].model
        
        for i=1, rand do
            if table.Count(DRUGDEALER.Stocks) >= DRUGDEALER.Dealers[dealer].max_drugs then break end
            local quality = math.Round( math.Rand( DRUGDEALER.Dealers[dealer].sale_quality[ v ].min, DRUGDEALER.Dealers[dealer].sale_quality[ v ].max ) )
			
            table.insert( DRUGDEALER.Stocks, {
                type = v,
                quality = quality,
				price = DRUGDEALER.Dealers[dealer].sell_prices[v],
                model = mdl,
				uid = math.Round(math.Rand( 1, 10000 ))
            } )
        end
    end
    
    DRUGDEALER.DecideSellPurchase()
    
    DRUGDEALER.LastSwitch = CurTime()
    
    for k, v in pairs( player.GetAll() ) do
		print("sendinfo1")
        DRUGDEALER.SendClientInfo( v )
    end
	
	hook.Call( "Drugdealer_Stock_Changed" )
end

function DRUGDEALER.DecideSellPurchase()
    // Higher = Ofter
    local sell_chance = 45
    local purchase_chance = 20
    
    local chance = math.Round( math.Rand( 1, 100 ) )
    
    if chance >= sell_chance then DRUGDEALER.IsSelling = true else DRUGDEALER.IsSelling = false end
    if chance >= purchase_chance then DRUGDEALER.Purchasing = true else DRUGDEALER.Purchasing = false end
end

function DRUGDEALER.Player_Purchase( ply, type, uid )
    if !(IsValid( ply )) then return false end
	
	local sell_index = DRUGDEALER.GetSellingIndex( type )
	
    if DRUGDEALER.Dealers[DRUGDEALER.CurDealer].selling[sell_index] == nil then return false end
    
    local cost = DRUGDEALER.Dealers[DRUGDEALER.CurDealer].sell_prices[type]
    
    --if !(ply:GetSkill( "Ruf" )) >= DRUGDEALER.Dealers[DRUGDEALER.CurDealer].ruf then return "lowruf" end
    if !(ply:CanAfford( cost )) then return "nocash" end
	
	// Lösche das item aus dem Table
		local new_tbl = {}
		local index = 0
		for k, v in pairs( DRUGDEALER.Stocks ) do
			if type == v.type && v.uid == uid then
				net.Start( "DrugDealer_Shop_Update_Items" )
					net.WriteInt( v.uid, 32 )
				net.Send( player.GetAll() )
				index = k
				continue 
			end
			
			table.insert( new_tbl, v )
		end
	//
    
    --ply:AddCash( -cost )
    
    local item = itemstore.Item( DRUGDEALER.GetSecondProduct( type ) )
    item:SetData( "Dealer", DRUGDEALER.CurDealer )
    item:SetData( "Quality", DRUGDEALER.Stocks[index].quality )
    ply.Inventory:AddItem( item )
	
	
    DRUGDEALER.Stocks = new_tbl
    
    for k, v in pairs( player.GetAll() ) do DRUGDEALER.SendClientInfo( v ) end      // Resend all informations
    
    ply:RPNotify( "Du hast ein " .. type .. " gekauft!", 3 )
end
net.Receive( "DrugDealer_PurchaseDrug", function( len, ply ) 
	local uid = net.ReadInt( 32 )
	local type = net.ReadString()
	
	DRUGDEALER.Player_Purchase( ply, type, uid )
end )

function DRUGDEALER.Think()
    if CurTime() >= ( DRUGDEALER.LastSwitch + DRUGDEALER.CONFIG.RotationTime ) then
        DRUGDEALER.RollNewDealer()
    end
end
hook.Add( "Think", "DRUGDEALER.Think", DRUGDEALER.Think )




// SellDrugs

function DRUGDEALER.Player_Sell( player, info )
	/* Info Table 
		type = drogentyp ( drug_weed )
		gramm = Wie viel gramm ( Preis * 10 | 15 Gramm = 150€ )
		slot = Inventar Slot vom Item
	*/
	local drug = DRUGDEALER.TranslateClassToName( info.type )
	if !(IsValid( player )) then return false end
	if !(DRUGDEALER.Purchasing) then return false end
	if not table.HasValue(DRUGDEALER.Dealers[DRUGDEALER.CurDealer].selling, drug) then return false end		// Verkauft und Kauft die Drogenart nicht!
	
	local inv_id = player.Inventory:GetID()
	
	if info.type == "drug_weed" then		// Weed Verkaufs Rechnung
		local drug = player.Inventory:GetItem( info.slot )
		local q = drug:GetData( "Quality" ) or 0
		local g = drug:GetData( "Gramm" ) or 0
		local q_rech = 0.1 * q
		local price = g * q_rech	// Gebe je nach qualität geld. ( 10 / 100 = 0.1 * qualität )
		
		player:DestroyItem( inv_id, info.slot )		// Zerstört das Item
		player:AddCash( price )
		player:RPNotify( "Du hast " .. tostring( g ) .. " Gramm Gras für " .. tostring( price ) .. " verkauft!", 5 )
		
		net.Start( "Purchase_Succeed" )
			net.WriteInt( info.uid, 32 )
		net.Send( player )
		
		return		// Verkauf erfolgreich!
	end	
end
net.Receive( "DrugDealer_SellDrug", function( len, ply )
    local info = net.ReadTable()
    DRUGDEALER.Player_Sell( ply, info )
end)


/// Inspecting

net.Receive( "DrugDealer_Inspect_Drug", function( len, ply )
	local uid = net.ReadInt( 32 )
	
	// Time Calculation
	local talent_calc = (DRUGDEALER.CONFIG.QualityCheckTime / 10) * (ply:GetSkill( "Weed Erfahrung" ) or 0)
	local time = DRUGDEALER.CONFIG.QualityCheckTime - ((DRUGDEALER.CONFIG.QualityCheckTime / 100) * talent_calc)
	
	// Succeed Calculation
	local succeed_calc = DRUGDEALER.CONFIG.QualitySucceedChance + (ply:GetSkill( "Weed Erfahrung" ) or 0)
	local succeed = false
	local succeed_num = math.Round( math.Rand( 1, 100) )
	if succeed_num <= succeed_calc then succeed = true end
	
	local callback = {
		time = time,
		uid = uid,
		succeed = succeed
	}
	
	net.Start( "DrugDealer_Inspect_Drug" )
		net.WriteTable( callback )
	net.Send( ply )
end)