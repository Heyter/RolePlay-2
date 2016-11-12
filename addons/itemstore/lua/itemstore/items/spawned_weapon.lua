ITEM.Name = "Weapon"
ITEM.Description = "An equippable weapon."
ITEM.Model = "models/weapons/w_pistol.mdl"
ITEM.Base = "base_darkrp"
ITEM.Stackable = false

ITEM.Weapons = {
	weapon_physgun = "Physgun",
	weapon_physcannon = "Gravity Gun",
	weapon_crowbar = "Crowbar",
	weapon_stunstick = "Stunstick",
	weapon_pistol = "Pistol",
	weapon_357 = "357",
	weapon_smg1 = "SMG1",
	weapon_ar2 = "AR2",
	weapon_annabelle = "Annabelle",
	weapon_shotgun = "Shotgun",
	weapon_crossbow = "Crossbow",
	weapon_frag = "Frag Grenade",
	weapon_rpg = "RPG",
	weapon_slam = "S.L.A.M.",
	weapon_bugbait = "Bug Bait"
}

function ITEM:GetWeaponClass( wep )
	return wep.GetWeaponClass and wep:GetWeaponClass() or wep.weaponclass
end

function ITEM:GetName()
	local name = self.Name

	if self.Weapons[ self:GetData( "Class" ) ] then
		name = self.Weapons[ self:GetData( "Class"  ) ]
	end

	local wep_class = weapons.Get( self:GetData( "Class" ) )
	if wep_class and wep_class.PrintName then
		name = wep_class.PrintName
	end

	return self:GetData( "Name", name )
end

function ITEM:CanPickup( pl, ent )
	if ent.PlayerUse then return false end
	if not weapons.Get( self:GetData( "Class" ) ) and
		not self.Weapons[ self:GetClass() ] then return false end

	return true
end

function ITEM:CanMerge( item )
	return self.Stackable and item:GetClass() == self:GetClass() and
		item:GetData( "Class" ) == self:GetData( "Class" ) and
		self.MaxStack >= self:GetAmount() + item:GetAmount()
end

function ITEM:Merge( item )
	self:SetAmount( self:GetAmount() + item:GetAmount() )

	self:SetData( "Clip2", ( item:GetData( "Clip2" ) or 0 ) +
		( self:GetData( "Clip2" ) or 0 ) )

	self:SetData( "Ammo", ( item:GetData( "Ammo" ) or 0 ) +
		( self:GetData( "Ammo" ) or 0 ) + ( self:GetData( "Clip1" ) or 0 ) )
end

function ITEM:Split( amount )
	self:SetAmount( self:GetAmount() - amount )

	local item = self:Copy()
	item:SetAmount( amount )

	self:SetData( "Clip1", 0 )
	self:SetData( "Clip2", 0 )
	self:SetData( "Ammo", 0 )

	return item
end

function ITEM:SaveData( ent )
	self:SetData( "Class", self:GetWeaponClass( ent ) )
	self:SetData( "Amount", self:GetAmount() )
	self:SetData( "Model", ent:GetModel() )

	self:SetData( "Clip1", ent.clip1 and ent.clip1 * self:GetAmount() or 0 )
	self:SetData( "Clip2", ent.clip2 and ent.clip2 * self:GetAmount() or 0 )
	self:SetData( "Ammo", ent.ammoadd and ent.ammoadd * self:GetAmount() or 0 )
end

function ITEM:CanPickup( pl, ent )
	return self.MaxStack >= self:GetAmount()
end

function ITEM:LoadData( ent )
	ent:SetModel( self:GetData( "Model" ) )
	self:SetAmount( 1 )

	if ent.GetWeaponClass then
		ent:SetWeaponClass( self:GetData( "Class" ) )
	else
		ent.weaponclass = self:GetData( "Class" )
	end

	ent.clip1 = math.floor( self:GetData( "Clip1", 0 ) / self:GetAmount() )
	ent.clip2 = math.floor( self:GetData( "Clip2", 0 ) / self:GetAmount() )
	ent.ammoadd = math.floor( self:GetData( "Ammo", 0 ) / self:GetAmount() )

	function ent:Initialize()
		self:PhysicsInit( SOLID_VPHYSICS )
		self:SetMoveType( MOVETYPE_VPHYSICS )
		self:SetSolid( SOLID_VPHYSICS )
		self:SetUseType( SIMPLE_USE )
		self:GetPhysicsObject():Wake()

		self:SetCollisionGroup( COLLISION_GROUP_INTERACTIVE_DEBRIS )
	end
end

function ITEM:Use( pl )
	--if pl:isArrested() then return false end

	if not self.Weapons[ self:GetData( "Class" ) ] and
		not weapons.Get( self:GetData( "Class" ) ) then return false end

	if pl:HasWeapon( self:GetData( "Class" ) ) then return false end

	pl:Give( self:GetData( "Class" ) )
	local wep = pl:GetWeapon( self:GetData( "Class" ) )

	-- make sure we actually gave the weapon before we start deducting stuff
	if IsValid( wep ) then
		if self:GetData( "Clip1" ) then
			wep:SetClip1( self:GetData( "Clip1" ) )
		end

		if self:GetData( "Clip2" ) then
			wep:SetClip2( self:GetData( "Clip2" ) )
		end

		pl:GiveAmmo( self:GetData( "Ammo", 0 ), wep:GetPrimaryAmmoType() )

		self:SetData( "Clip1", 0 )
		self:SetData( "Clip2", 0 )
		self:SetData( "Ammo", 0 )
	end

	return self:TakeOne()
end
