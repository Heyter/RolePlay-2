local meta = FindMetaTable( "Player" )

function meta:SetupInventory()
	local inv_size = itemstore.config.InventorySizes[ self:GetUserGroup() ]

	if not inv_size then
		inv_size = itemstore.config.InventorySizes[ "default" ]
	end

	self.Inventory = itemstore.Container( unpack( inv_size ) )
	self.Inventory:SetOwner( self )
	self.Inventory:SetPermissions( self, true, true )

	local bank_size = itemstore.config.BankSizes[ self:GetUserGroup() ]

	if not bank_size then
		bank_size = itemstore.config.BankSizes[ "default" ]
	end

	self.Bank = itemstore.Container( unpack( bank_size ) )
	self.Bank:SetOwner( self )

	local function callback( con, pl )
		for _, ent in ipairs( ents.FindByClass( "itemstore_bank" ) ) do
			if ent:GetPos():Distance( pl:EyePos() ) < 256 then
				return true
			end
		end

		return false
	end

	self.Bank:AddCallback( "read", callback )
	self.Bank:AddCallback( "write", callback )

	itemstore.data.Load( self )

	hook.Run( "ItemStoreInventoryCreated", self, self.Inventory, self.Bank )

	return self.Inventory, self.Bank
end

function meta:PickupItem( ent )
	ent = ent or util.QuickTrace( self:GetShootPos(),
		self:GetAimVector() * itemstore.config.PickupDistance, self ).Entity

	if not IsValid( ent ) then return false end
	if ent.__Deleted then return false end
	if not itemstore.items.Pickups[ ent:GetClass() ] then return false end

	local class = itemstore.items.Pickups[ ent:GetClass() ]
	if itemstore.config.DisabledItems[ class ] then return false end
	
	local item = itemstore.Item( class )
	if not item then return end
	
	item:SaveData( ent )

	local con
	if itemstore.config.PicksupsGotoBank then
		con = self.Bank
	else
		con = self.Inventory
	end

	if not con:CanFit( item ) then return false end
	if hook.Call( "ItemStoreCanPickup", GAMEMODE, self, item, ent ) == false then return false end
	if not item:CanPickup( self, ent ) then return false end

	if con:AddItem( item ) then
		ent:Remove()
		--self:ChatPrint( itemstore.Translate( "picked_up", item:GetName() ) )
		self:EmitSound( "items/gunpickup2.wav" )

		return true
	end
end

function meta:MoveItem( from_con_id, from_slot, to_con_id, to_slot )
	local from_con = itemstore.containers.Get( from_con_id )
	local to_con = itemstore.containers.Get( to_con_id )

	if not from_con or not to_con then return end

	local from_item = from_con:GetItem( from_slot )
	local to_item = to_con:GetItem( to_slot )

	-- don't bother switching if we're swapping blank space
	if ( from_item or to_item ) and
		from_con:CanWrite( self, "move", to_con, from_slot, from_item, to_slot, to_item ) ~= false and
		to_con:CanWrite( self, "move", from_con, from_slot, from_item, to_slot, to_item ) ~= false then

		from_con:SetSuppressed( true )
		to_con:SetSuppressed( true )

		from_con:SetItem( from_slot, to_item )
		to_con:SetItem( to_slot, from_item )

		from_con:SetSuppressed( false )
		to_con:SetSuppressed( false )

		from_con:Sync()
		if from_con ~= to_con then
			to_con:Sync()
		end
	end
end

util.AddNetworkString( "ItemStoreMove" )
net.Receive( "ItemStoreMove", function( len, pl )
	local from_con_id = net.ReadUInt( 32 )
	local from_slot = net.ReadUInt( 32 )
	local to_con_id = net.ReadUInt( 32 )
	local to_slot = net.ReadUInt( 32 )

	pl:MoveItem( from_con_id, from_slot, to_con_id, to_slot )
end )

function meta:UseItem( con_id, slot, ... )
	local con = itemstore.containers.Get( con_id )
	local item = con:GetItem( slot )

	if not item then return end
	if not item.Use then return end
	if con:CanWrite( self, "use", slot, item ) == false then return end

	con:SetSuppressed( true )

	if item:Use( self, con, slot, ... ) then
		con:SetItem( slot, nil )
	end

	con:SetSuppressed( false )
	con:Sync()
end

util.AddNetworkString( "ItemStoreUse" )
net.Receive( "ItemStoreUse", function( len, pl )
	local con_id = net.ReadUInt( 32 )
	local slot = net.ReadUInt( 32 )
	local args = net.ReadTable()

	pl:UseItem( con_id, slot, unpack( args ) )
end )

function meta:UseItemWith( from_con_id, from_slot, to_con_id, to_slot )
	local from_con = itemstore.containers.Get( from_con_id )
	local to_con = itemstore.containers.Get( to_con_id )
	
	if not from_con then return end
	if not to_con then return end

	local from_item = from_con:GetItem( from_slot )
	local to_item = to_con:GetItem( to_slot )

	if not from_item then return end
	if not to_item then return end
	if from_item == to_item then return end

	if not from_item.UseWith then return end

	if not from_item:CanUseWith( to_item ) then return end

	if from_con:CanWrite( self, "usewith", from_slot, from_item, to_con,
		to_slot, to_item ) == false then return end

	from_con:SetSuppressed( true )
	to_con:SetSuppressed( true )
	
	if from_item:UseWith( self, to_item, from_con, from_slot, to_con, to_slot ) then
		from_con:SetItem( from_slot, nil )
	end

	from_con:SetSuppressed( false )
	to_con:SetSuppressed( false )

	from_con:Sync()
	if from_con ~= to_con then to_con:Sync() end
end

util.AddNetworkString( "ItemStoreUseWith" )
net.Receive( "ItemStoreUseWith", function( len, pl )
	local from_con_id = net.ReadUInt( 32 )
	local from_slot = net.ReadUInt( 32 )
	local to_con_id = net.ReadUInt( 32 )
	local to_slot = net.ReadUInt( 32 )

	pl:UseItemWith( from_con_id, from_slot, to_con_id, to_slot )
end )

function meta:DropItem( con_id, slot )
	local con = itemstore.containers.Get( con_id )
	local item = con:GetItem( slot )

	if not item then return end
	if con:CanWrite( self, "drop", slot, item ) == false then return end

	local pos = util.QuickTrace( self:GetShootPos(), self:GetAimVector() * 100, self ).HitPos
	local ent = item:CreateEntity( pos )
	
	// Nos RP Compatibl.
	ent.owner = tostring( self:SteamID() )

	if item.DropStack or item:TakeOne() then
		con:SetSuppressed( true )
		con:SetItem( slot, nil )
		con:SetSuppressed( false )
	end

	con:Sync()

	self:EmitSound( "items/ammocrate_open.wav" )
end

util.AddNetworkString( "ItemStoreDrop" )
net.Receive( "ItemStoreDrop", function( len, pl )
	local con_id = net.ReadUInt( 32 )
	local slot = net.ReadUInt( 32 )

	pl:DropItem( con_id, slot )
end )

function meta:DestroyItem( con_id, slot )
	local con = itemstore.containers.Get( con_id )
	local item = con:GetItem( slot )

	if item and con:CanWrite( self, "destroy", slot, item ) ~= false then
		con:SetItem( slot, nil )
		self:EmitSound( "physics/concrete/concrete_break2.wav" )
	end
end

util.AddNetworkString( "ItemStoreDestroy" )
net.Receive( "ItemStoreDestroy", function( len, pl )
	local con_id = net.ReadUInt( 32 )
	local slot = net.ReadUInt( 32 )

	pl:DestroyItem( con_id, slot )
end )

function meta:MergeItem( from_con_id, from_slot, to_con_id, to_slot )
	local from_con = itemstore.containers.Get( from_con_id )
	local to_con = itemstore.containers.Get( to_con_id )
	local from_item = from_con:GetItem( from_slot )
	local to_item = to_con:GetItem( to_slot )

	if from_item and to_item and not ( from_con == to_con and from_slot == to_slot ) and
		from_con:CanWrite( self, "merge", to_con_id, from_slot, from_item, to_slot, to_item ) ~= false and
		to_con:CanWrite( self, "merge", from_con_id, from_slot, from_item, to_slot, to_item ) ~= false and
		to_item:CanMerge( from_item ) then

		from_con:SetSuppressed( true )
		to_con:SetSuppressed( true )

		to_item:Merge( from_item )
		from_con:SetItem( from_slot, nil )

		from_con:SetSuppressed( false )
		to_con:SetSuppressed( false )

		from_con:Sync()
		if from_con ~= to_con then to_con:Sync() end
	end
end

util.AddNetworkString( "ItemStoreMerge" )
net.Receive( "ItemStoreMerge", function( len, pl )
	local from_con_id = net.ReadUInt( 32 )
	local from_slot = net.ReadUInt( 32 )
	local to_con_id = net.ReadUInt( 32 )
	local to_slot = net.ReadUInt( 32 )

	pl:MergeItem( from_con_id, from_slot, to_con_id, to_slot )
end )

function meta:SplitItem( con_id, slot, amount )
	local con = itemstore.containers.Get( con_id )
	local item = con:GetItem( slot )

	if con:FirstEmptySlot() and item and item:CanSplit( amount ) and
		con:CanWrite( self, "split", slot, item, amount ) ~= false then

		con:AddItem( item:Split( amount ), true )
	end
end

util.AddNetworkString( "ItemStoreSplit" )
net.Receive( "ItemStoreSplit", function( len, pl )
	local con_id = net.ReadUInt( 32 )
	local slot = net.ReadUInt( 32 )
	local amount = net.ReadUInt( 16 )

	pl:SplitItem( con_id, slot, amount )
end )

util.AddNetworkString( "ItemStoreOpen" )
function meta:OpenContainer( id, name, hideinv )
	net.Start( "ItemStoreOpen" )
		net.WriteUInt( id, 32 )
		net.WriteString( name )
		net.WriteBit( hideinv )
	net.Send( self )
end

util.AddNetworkString( "ItemStoreSyncInventory" )
net.Receive( "ItemStoreSyncInventory", function( len, pl )
	pl.Inventory:Sync()

	net.Start( "ItemStoreSyncInventory" )
		net.WriteUInt( pl.Inventory:GetID(), 32 )
	net.Send( pl )
end )

hook.Add( "PlayerInitialSpawn", "ItemStoreLoadInventory", function( pl )
	pl:SetupInventory()
end )

hook.Add( "PlayerUse", "ItemStorePickup", function( pl, ent )
	if ent.__Deleted then
		-- Anti-dupe, never let anything marked as deleted to be used
		return false
	end

	-- thanks brax
	if itemstore.config.PickupKey > -1 and pl:KeyDown( itemstore.config.PickupKey )
		and pl:PickupItem( ent ) then
		
		return false
	end
end )

hook.Add( "PlayerDeath", "ItemStoreDeathLoot", function( pl )
	if not itemstore.config.DeathLoot then return end
	if table.Count( pl.Inventory:GetItems() ) <= 0 then return end

	local ent = ents.Create( "itemstore_deathloot" )
	ent:SetPos( pl:GetPos() )
	ent:Spawn()

	ent.Container:SetWidth( pl.Inventory:GetWidth() )
	ent.Container:SetHeight( pl.Inventory:GetHeight() )
	ent.Container:SetPages( pl.Inventory:GetPages() )

	for k, v in pairs( pl.Inventory:GetItems() ) do
		ent.Container:SetItem( k, v )
		pl.Inventory:SetItem( k, nil )
	end

	ent.Timeout = CurTime() + itemstore.config.DeathLootTimeout
end )