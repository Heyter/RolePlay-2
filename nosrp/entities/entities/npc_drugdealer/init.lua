AddCSLuaFile( "cl_init.lua" ) -- This means the client will download these files
AddCSLuaFile( "shared.lua" )

include('shared.lua') -- At this point the contents of shared.lua are ran on the server only.

// Drug Dealer for Gmod-Networks
// 20.01.2013 | By CaMoTraX

// CL <= SV
util.AddNetworkString( "NewDialogBtn1" )
util.AddNetworkString( "NewDialogBtn2" )
util.AddNetworkString( "NotPurchasing" )
util.AddNetworkString( "NotSelling" )

// CL => SV
util.AddNetworkString( "SellAllDrugs" )
util.AddNetworkString( "PurchaseSeeds" )


function ENT:Initialize( ) --This function is run when the entity is created so it's a good place to setup our entity.
	
	self:SetModel( "models/Humans/Group03/male_09.mdl" ) -- Sets the model of the NPC.
	self:SetHullType( HULL_HUMAN ) -- Sets the hull type, used for movement calculations amongst other things.
	self:SetHullSizeNormal( )
	self:SetNPCState( NPC_STATE_SCRIPT )
	self:SetSolid(  SOLID_BBOX ) -- This entity uses a solid bounding box for collisions.
	self:CapabilitiesAdd( CAP_ANIMATEDFACE ) -- Adds what the NPC is allowed to do ( It cannot move in this case ).
	self:SetUseType( SIMPLE_USE ) -- Makes the ENT.Use hook only get called once at every use.
	self:DropToFloor()

	self:SetMaxYawSpeed( 90 ) --Sets the angle by which an NPC can rotate at once.
	
	self.sellprice = 150 // Wie viel man für ein Cocain Bag bekommt.
	self.price = 150 // Wie teuer Seeds sind.
	self.pocketmoney = 100000 // Wie viel der Dealer alle 10 Minuten auszahlen kann.
	
	self.selling = true // Fängt am start an zu Verkaufen.
	self.purchasing = false // Kauft am start nichts von den Spielern.
	
	timer.Create("Drug_Dealer_Timer" .. self:EntIndex(), 600, 0, function()
		local sellingrand = math.Round(math.Rand(1,10))
		local purchasinggrand = math.Round(math.Rand(1,10))
        
		
		self.sellprice = self.sellprice + math.Round(math.Rand(-10, 10))
		self.price = math.Round(math.Rand(150, 200))
		
		self.pocketmoney = self.pocketmoney + 50000
		
		
		if sellingrand == 3 or sellingrand == 7 or sellingrand == 10 or sellingrand == 5 then
			self.selling = true
		else
			self.selling = false
		end
		
		if purchasinggrand == 3 or purchasinggrand == 7 or purchasinggrand == 10 then
			self.purchasing = true
		else
			self.purchasing = false
		end
		
	end)
	
	net.Receive( "SellAllDrugs", function( len, ply )
		if !(IsValid( ply )) then return end
		
		if !(self.purchasing) then
			net.Start( "NotPurchasing" )
			net.Send( ply )
			return
		end
		
        local a = ply.Inventory:CountItems( "drug_weed" ) or 0
        if a == nil then return end
        
		if self.pocketmoney < (self.sellprice * a) then
			net.Start( "NotPurchasing" )
			net.Send( ply )
			return
		end
		
		if a > 0 then
			local total = self.sellprice * a
		
			ply:AddCash( total )
			ply.Inventory:TakeItems( "drug_weed", a )
			self.pocketmoney = self.pocketmoney - total

			net.Start( "NewDialogBtn1" )
				net.WriteTable( {money = total} )
			net.Send( ply )
			
		end
	end)
	
	net.Receive( "PurchaseSeeds", function( len, ply )
		if !(IsValid( ply )) then return end
		
		if !(self.selling) then
			net.Start( "NotSelling" )
			net.Send( ply )
			return
		end
		
		local tbl = net.ReadTable() or {}
		
		if !(ply:CanAfford(self.price * tbl.seeds)) then
			ply:RPNotify( "Du hast nicht so viel Geld! ( $" .. (self.price * tbl.seeds) .. " )", 5 )
			return
		end
      
        local item = itemstore.Item( "drug_seed" ) 
		
        item:SetData( "Class", "drug_seed" )
        item:SetData( "Model", "models/Humans/Group03/male_09.mdl" )
        item:SetData( "Name", "Hanf Samen" )
        item:SetData( "Amount", tonumber(tbl.seeds) )
        if !( ply.Inventory:CanFit( item ) ) then return end
		
        ply.Inventory:AddItem( item )
		ply:AddCash(-(self.price * tbl.seeds))
		self.pocketmoney = self.pocketmoney + (self.price * tbl.seeds)
		
		
		net.Start( "NewDialogBtn2" )
			net.WriteTable( {seeds = tbl.seeds} )
		net.Send( ply )
	end)
	
end

function ENT:NewChance( ply )
	if !(ply:IsAdmin()) then return end
	
	local sellingrand = math.Round(math.Rand(1,10))
	local purchasinggrand = math.Round(math.Rand(1,10))
	
	self.sellprice = self.sellprice + math.Round(math.Rand(-10, 10))
	self.price = math.Round(math.Rand(150, 200))
	
	self.pocketmoney = self.pocketmoney + 50000
	
	
	if sellingrand == 3 or sellingrand == 7 or sellingrand == 10 or sellingrand == 5 then
		self.selling = true
	else
		self.selling = false
	end
	
	if purchasinggrand == 3 or purchasinggrand == 7 or purchasinggrand == 10 then
		self.purchasing = true
	else
		self.purchasing = false
	end
    ply:RPNotify( "Selling: " .. tostring( self.selling ), 5 )
    ply:RPNotify( "Purchasing: " .. tostring( self.purchasing ), 5 )
    return ""
end
RP.PLUGINS.CHATCOMMAND.AddChatCommand("/drugchange", function( ply ) ply:GetEyeTrace().Entity:NewChance( ply ) end)

function ENT:OnTakeDamage()
	return false -- This NPC won't take damage from anything.
end 

function ENT:AcceptInput( Name, activator, aaller )	

	if Name == "Use" and activator:IsPlayer() then
		
		umsg.Start("ShowDrugshopMenu", activator)
		umsg.End()
		
	end
	
end