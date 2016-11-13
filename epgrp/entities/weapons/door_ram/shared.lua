AddCSLuaFile()


SWEP.PrintName = "Battering Ram"
SWEP.Slot = 5
SWEP.SlotPos = 1
SWEP.DrawAmmo = false
SWEP.DrawCrosshair = false

-- Variables that are used on both client and server
SWEP.Base = "weapon_cs_base2"

SWEP.Author = "Camotrax"
SWEP.Instructions = "Left click to break open doors/unfreeze props or get people out of their vehicles."
SWEP.Contact = ""
SWEP.Purpose = ""

SWEP.IconLetter = ""

SWEP.ViewModelFOV = 62
SWEP.ViewModelFlip = false
SWEP.ViewModel = Model("models/weapons/v_rpg.mdl")
SWEP.WorldModel = Model("models/weapons/w_rocket_launcher.mdl")
SWEP.AnimPrefix = "rpg"

SWEP.Spawnable = false
SWEP.AdminSpawnable = true

SWEP.Sounds = {"/physics/wood/wood_panel_impact_hard1.wav", "/physics/wood/wood_panel_impact_hard1.wav"}

SWEP.Primary.ClipSize = -1      -- Size of a clip
SWEP.Primary.DefaultClip = 0        -- Default number of bullets in a clip
SWEP.Primary.Automatic = false      -- Automatic/Semi Auto
SWEP.Primary.Ammo = ""

SWEP.Secondary.ClipSize = -1        -- Size of a clip
SWEP.Secondary.DefaultClip = 0     -- Default number of bullets in a clip
SWEP.Secondary.Automatic = false     -- Automatic/Semi Auto
SWEP.Secondary.Ammo = ""

/*---------------------------------------------------------
Name: SWEP:Initialize()
Desc: Called when the weapon is first loaded
---------------------------------------------------------*/
function SWEP:Initialize()
	self.LastIron = CurTime()
	self:SetHoldType("normal")
	self.Ready = false
    self.AdminMode = false
end

/*---------------------------------------------------------------------------
Name: SWEP:Deploy()
Desc: called when the weapon is deployed
---------------------------------------------------------------------------*/
function SWEP:Deploy()
	self.Ready = false
end

function SWEP:Holster()
	if not self.Ready or not SERVER then return true end
	
	return true
end

/*---------------------------------------------------------
Name: SWEP:PrimaryAttack()
Desc: +attack1 has been pressed
---------------------------------------------------------*/
function SWEP:PrimaryAttack()
	if CLIENT then return end

	if not self.Ready then return end
    if not (self.Owner:IsPolice() or self.Owner:IsSWAT() or self.Owner:IsAdmin()) then return end

	local trace = self.Owner:GetEyeTrace()

	self.Weapon:SetNextPrimaryFire(CurTime() + 1)
	if (not IsValid(trace.Entity) or (not IsDoor( trace.Entity ) and not trace.Entity:IsVehicle() and trace.Entity:GetClass() ~= "prop_physics")) then
		return
	end

	if (IsDoor( trace.Entity ) and self.Owner:EyePos():Distance(trace.HitPos) > 45) then
		return
	end

	self.Owner:SetAnimation(PLAYER_ATTACK1)
	self.Owner:EmitSound(self.Sounds[math.Round( math.Rand(1,#self.Sounds) )], 75, 100)

	local b = trace.Entity:GetClass() == "prop_physics"
	local c = true
    local owner = trace.Entity:GetDoorOwner() or nil
    local stars
    if owner != nil then stars = owner:GetStarLevel() else stars = 0 end
    
	if (IsDoor( trace.Entity )) then
		local allowed = false
		-- if we need a warrant to get in
		if stars < 2 && !(self.AdminMode==true) then
			allowed = false
            self.Owner:RPNotify( "Das Wanted-Level ist nicht hoch genug, um das Haus zu durchsuchen.", 5 )
            return
		else
			allowed = true
		end

		if allowed then
			local gotweld = trace.Entity:GetNWInt("Welded") or 0
			if gotweld > 4 then
				trace.Entity:SetNWInt("Welded", gotweld - 5)
				trace.Entity:Fire("setanimation", .6)
				self.Owner:ViewPunch(Angle(-10, math.random(-5, 5), 0))
				
				local trashprops = {"models/gibs/metal_gib4.mdl", "models/gibs/metal_gib5.mdl", "models/gibs/metal_gib1.mdl"}
				for _, tprop in pairs(trashprops) do
					local trashprop = ents.Create("prop_physics")
					trashprop:SetPos( self.Owner:LocalToWorld(Vector(10, math.Rand(-10,10), math.Rand(50,90))) )
					trashprop:SetModel( tprop )
					trashprop:SetCollisionGroup(COLLISION_GROUP_DEBRIS)
					trashprop:Spawn()
					trashprop:Activate()
					trashprop:GetPhysicsObject():SetVelocity( Vector(math.Rand(-250, 250), math.Rand(-250, 250), math.Rand(-250, 250)) )
					timer.Simple( 30, function() trashprop:Remove() end )
				end
				return
			end
			local rand = math.Round(math.Rand(1,15))
			if rand == 4 or self.AdminMode == true then 
				trace.Entity:Fire("unlock", "", .5)
				trace.Entity:Fire("open", "", .6)
				trace.Entity:Fire("setanimation", "open", .6)
			
				self.Owner:EmitSound("/physics/wood/wood_panel_break1.wav", 75, 100)
			end
		end
	elseif (trace.Entity:IsVehicle()) then
		trace.Entity:Fire("unlock", "", .5)
		local driver = trace.Entity:GetDriver()
		if driver and driver.ExitVehicle then
			driver:ExitVehicle()
		end
	end
	self.Owner:ViewPunch(Angle(-10, math.random(-5, 5), 0))
end

function SWEP:SecondaryAttack()
	self.LastIron = CurTime()
	self.Ready = not self.Ready
    
	if self.Ready then
		self:SetHoldType("rpg")
	else
		self:SetHoldType("normal")
	end
end

function SWEP:Reload()
    self.nextswitch = self.nextswitch or CurTime() - 1
    if self.nextswitch > CurTime() then return false end
    self.nextswitch = CurTime() + 1
    if CLIENT then surface.PlaySound( "buttons/button16.wav" ) end
    print( self.AdminMode )
    if self.AdminMode && self.Owner:IsAdmin() then self.AdminMode = false return false end
    if !(self.AdminMode) && self.Owner:IsAdmin() then self.AdminMode = true return false end
end

function SWEP:GetViewModelPosition(pos, ang)
	local Mul = 1
	if self.LastIron > CurTime() - 0.25 then
		Mul = math.Clamp((CurTime() - self.LastIron) / 0.25, 0, 1)
	end

	if self.Ready then
		Mul = 1-Mul
	end

	ang:RotateAroundAxis(ang:Right(), - 15 * Mul)
	return pos,ang
end