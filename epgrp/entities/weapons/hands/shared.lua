AddCSLuaFile()

SWEP.PrintName = "Hände"
SWEP.Slot = 1
SWEP.SlotPos = 1
SWEP.DrawAmmo = false
SWEP.DrawCrosshair = false

SWEP.Author = "CaMoTraX"
SWEP.Instructions = ""
SWEP.Contact = ""
SWEP.Purpose = ""

SWEP.ViewModel = Model("models/weapons/v_hands.mdl")

SWEP.ViewModelFOV = 62
SWEP.ViewModelFlip = false
SWEP.AnimPrefix	 = "rpg"

SWEP.Spawnable = false
SWEP.AdminSpawnable = true
SWEP.Sound = "doors/door_latch3.wav"
SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = 0
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = ""

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = 0
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = ""

function SWEP:Initialize()
	self:SetWeaponHoldType("normal")
	
	self.prop = nil
	self.ang = Angle( 0, 0, 0 )
	self.lasthold = CurTime()
	self:SetNWEntity( "grabed", NULL )
end

function SWEP:Deploy()
	if SERVER then
		self.Owner:DrawWorldModel(false)
		self.prop = nil
		self.ang = Angle( 0, 0, 0 )
		self:SetNWEntity( "grabed", NULL )
		self.lasthold = CurTime()
	end
	return true
end

function SWEP:Holster()
	self.prop = nil
	self:SetNWEntity( "grabed", NULL )
	self.lasthold = CurTime()
	return true
end

function SWEP:PrimaryAttack()
	if CLIENT then return end
	
	if self.prop == nil then
		local trace = {}
		trace.start = self.Owner:GetShootPos()
		trace.endpos = trace.start + (self.Owner:GetAimVector() * 100)
		trace.filter = { self.Owner, self.Weapon }
		local tr = util.TraceLine( trace )
		
		if tr.Entity == NULL then return end
		if tr.Entity:IsPlayer() or tr.Entity:IsVehicle() or tr.Entity:IsNPC() or tr.Entity:IsWorld() or string.Left(tr.Entity:GetModel(), 1) == "*" then return end
		if self.Owner:GetGroundEntity() == tr.Entity then return end
		
		self:SetNWVector( "grabbed_vec", tr.Entity:GetPos() - tr.HitPos )
		self.ang = tr.Entity:GetAngles()
		self.prop = tr.Entity
		self:SetNWEntity( "grabed", self.prop )
	end
	self.lasthold = CurTime()
end

function SWEP:SecondaryAttack()
	if CLIENT then return end
	if self.prop == nil or !(IsValid(self.prop)) then return end
	
	local ent = self:GroundedEntity()
	
	
	self.prop.frozen = self.prop.frozen or false
	local frozen = self.prop.frozen
	
	if frozen then
		if self:CanFreeze() then
			self.prop:GetPhysicsObject():EnableMotion( true )
			self.prop.frozen = false
		end
	else
		--if ent == NULL or ent == nil then return end
		if self:CanFreeze() then
			self.prop:GetPhysicsObject():EnableMotion( false )
			self.prop.frozen = true
		end
	end
	
end

function SWEP:CanFreeze()
	if self.prop.owner then		// Check owner ( only owner can unfreeze or friends )
		local o = player.GetBySteamID( self.prop.owner )
		if o == false then return true end	// Owner does no longer exists
		
		if (o != false && o == self.Owner) or (o != false && o:IsBuddy( self.Owner )) then
			return true
		else
			return false
		end
	else
		return true
	end
end

function SWEP:GroundedEntity()
	local center = self.prop:OBBCenter().z/2
	local pos = Vector( 0, 0, -(center + 5))
	local trace = {}
	trace.start = self.prop:GetPos()
	trace.endpos = trace.start + pos
	trace.filter = { self.Owner, self.Weapon, self.prop }
	local tr = util.TraceLine( trace )
	
	return tr.Entity
end

function SWEP:Think()
	if CLIENT then return end
	
	self.rotating = self.rotating or false
	self.r_check = self.r_check or CurTime()
	self.w = self.w or false
	self.s = self.s or false
	self.a = self.a or false
	self.d = self.d or false
	self.walkspeed = self.walkspeed or self.Owner:GetWalkSpeed()
	
	if CurTime() > (self.r_check + 0.2) then
		self.rotating = false
		self.Owner:SetWalkSpeed( self.walkspeed )
	end
	
	if CurTime() > self.lasthold + 0.1 then self:SetNWEntity( "grabed", NULL ) self.prop = nil end
	if self.prop != nil then
		if self.prop == nil or !(IsValid(self.prop)) then return end
		
		self.prop.frozen = self.prop.frozen or false
		if self.prop.frozen then return end
		
		local trace = {}
		trace.start = self.Owner:GetShootPos()
		trace.endpos = trace.start + (self.Owner:GetAimVector() * 60)
		trace.filter = { self.Owner, self.Weapon, self.prop }
		local tr = util.TraceLine( trace )
		
		local vec = trace.endpos - self.prop:GetPos();
		local altitude = tr.HitPos:Distance(trace.start)
		
		if altitude < 150 then
			if vec == Vector(0, 0, 0) then
				--vec = Vector(0, 0, 100);
			else
				--vec = vec + Vector(0, 0, 1);
			end
		end
		
		vec = vec + self:GetNWVector( "grabbed_vec" )
		
		vec:Normalize()
		local mass = self.prop:GetPhysicsObject():GetMass()
		local max = 20
		if mass < 50 then
			mass = mass + 25
		end
		
		local speed = self.prop:GetPhysicsObject():GetVelocity()
		if self.prop:GetClass() != "prop_ragdoll" then
			--local self.ang = Angle( a.p, a.y, a.r )
			
			// Rotating
		
			if ( self.Owner:KeyDown( IN_WALK ) ) then 
				self.rotating = true 
				self.r_check = CurTime()
				self.Owner:SetWalkSpeed( 0.000001 )
			end
			if ( self.Owner:KeyDown( IN_FORWARD ) && self.rotating ) then 
				self.ang.r = self.ang.r + 1
			end
			if ( self.Owner:KeyDown( IN_BACK ) && self.rotating ) then 
				self.ang.r = self.ang.r - 1
			end
			if ( self.Owner:KeyDown( IN_MOVELEFT ) && self.rotating ) then 
				self.ang.y = self.ang.y - 1
			end
			if ( self.Owner:KeyDown( IN_MOVERIGHT ) && self.rotating ) then 
				self.ang.y = self.ang.y + 1
			end
			
			if ( self.Owner:KeyDown( IN_SPEED ) && self.rotating ) then 
				self.ang = Angle( 0, 0, 0 )
			end
			
			self.prop:SetAngles( self.ang )
		else
			max = 200
			mass = mass + 3
		end
		
		if vec == Vector( 0, 0, 0 ) then
			self.prop:GetPhysicsObject():SetVelocity( (vec * math.Clamp((mass), 10, max)))
		else
			self.prop:GetPhysicsObject():SetVelocity( (vec * math.Clamp((mass), 10, max)) + (speed/1.1))
		end
	end
end

function SWEP:DrawHUD()
	local ent = self:GetNWEntity( "grabed" )
	local w, h = 5, 5
	local col = Color( 255, 255, 255, 200 )
	if ent != NULL then
		local center = ent:GetPos() - self:GetNWVector( "grabbed_vec" )
		local pos = center:ToScreen()
		
		surface.SetDrawColor( col.r, col.g, col.b, col.a )
		surface.DrawLine( ScrW()/2, ScrH()/2, pos.x, pos.y ) 
		
		draw.RoundedBox( 0, (ScrW() - w)/2, (ScrH() - h)/2, w, h, col )
		draw.RoundedBox( 0, pos.x - w/2, pos.y - h/2, w, h, col )
	end
end
