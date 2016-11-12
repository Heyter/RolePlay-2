ITEM.Name = "Shipment"
ITEM.Description = "A shipment of guns.\n\nContents: %s"
ITEM.Model = "models/Items/item_item_crate.mdl"
ITEM.Stackable = true
ITEM.DropStack = true
ITEM.Base = "base_darkrp"

-- Because all of you feel the need to fuck with your shipments on a daily basis.

function ITEM:Initialize()
	if not SERVER then return end
	if not self:GetData( "Class" ) then return end

	local shipment = CustomShipments[ self:GetData( "Contents" ) ]
	if shipment and shipment.entity == self:GetData( "class" ) then return end

	for k, v in ipairs( CustomShipments ) do
		if v.entity == self:GetData( "Class" ) then
			self:SetData( "Contents", k )
			return
		end
	end
end

function ITEM:GetDescription()
	local shipment = CustomShipments[ self:GetData( "Contents" ) ]

	local str = "ERROR: Shipment invalid. Delete this item!"
	if shipment then
		str = string.format( self.Description, shipment.name )
	end

	return self:GetData( "Description", str )
end

function ITEM:CanMerge( item )
	return self.Stackable and self:GetClass() == item:GetClass() and
		self:GetData( "Contents" ) == item:GetData( "Contents" ) and
		item:GetAmount() + self:GetAmount()
end

function ITEM:SaveData( ent )
	self:SetData( "Owner", ent:Getowning_ent() )
	self:SetData( "Contents", ent:Getcontents() )
	self:SetData( "Amount", ent:Getcount() )

	self:SetData( "Class", CustomShipments[ ent:Getcontents() ].entity )

	timer.Destroy( ent:EntIndex() .. "crate" )
end

function ITEM:CanPickup( pl, ent )
	return self.MaxStack >= ent:Getcount()
end

function ITEM:LoadData( ent )
	ent:Setcontents( self:GetData( "Contents" ) )
	ent:Setcount( self:GetData( "Amount" ) )
	ent:Setowning_ent( self:GetData( "Owner" ) )
end

function ITEM:Use( pl )
	if pl:isArrested() then return end

	local class = CustomShipments[ self:GetData( "Contents" ) ].entity
	if pl:HasWeapon( class ) then
		local wep_class = weapons.Get( class )

		if wep_class then
			pl:GiveAmmo( wep_class.Primary.DefaultClip, wep_class.Primary.Ammo )
		end
	end

	pl:Give( class )

	return self:TakeOne()
end
