AddCSLuaFile()

SWEP.PrintName = "Keys"
SWEP.Slot = 1
SWEP.SlotPos = 1
SWEP.DrawAmmo = false
SWEP.DrawCrosshair = false

SWEP.Author = "CaMoTraX"
SWEP.Instructions = "Left click to lock. Right click to unlock"
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
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = ""

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = 0
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = ""

function SWEP:Initialize()
	self:SetWeaponHoldType("normal")
end

function SWEP:Deploy()
	if SERVER then
		self.Owner:DrawWorldModel(false)
	end
end

function SWEP:PrimaryAttack()
	local ply = self.Owner
	local trace = {}
	trace.start = ply:EyePos()
	trace.endpos = ply:GetShootPos() + ply:GetForward()*50
	trace.filter = ply
	trace.mask = -1
	local tr = util.TraceLine(trace)
    
    if SERVER then
        if self.Owner:LockDoor( tr.Entity ) then 
            timer.Simple(0.9, function() if IsValid(self.Owner) then self.Owner:EmitSound(self.Sound) end end)
            self.Owner:AnimRestartGesture(GESTURE_SLOT_ATTACK_AND_RELOAD, ACT_GMOD_GESTURE_ITEM_PLACE, true)
        else
            if IsValid( tr.Entity ) && IsDoor( tr.Entity ) then
				self.Owner:EmitSound("physics/wood/wood_crate_impact_hard3.wav", 100, math.random(90, 110))
			end
        end
        self.Weapon:SetNextPrimaryFire(CurTime() + 0.3)
    end
	
    /*
	if IsValid( tr.Entity ) && IsDoor( tr.Entity ) && tr.Entity:GetRPVar( "doordata" ) && tr.Entity:GetRPVar( "doordata" ).owner == ply then
		if SERVER then
			--self.Owner:EmitSound("npc/metropolice/gear".. math.floor(math.Rand(1,7)) ..".wav")
			--tr.Entity:Fire("lock", "", 1)

			if self.Owner:LockDoor( tr.Entity ) then timer.Simple(0.9, function() if IsValid(self.Owner) then self.Owner:EmitSound(self.Sound) end end) end
			
			self.Owner:AnimRestartGesture(GESTURE_SLOT_ATTACK_AND_RELOAD, ACT_GMOD_GESTURE_ITEM_PLACE, true)
		end
		self.Weapon:SetNextPrimaryFire(CurTime() + 0.3)
	else
		if SERVER then
			if IsValid( tr.Entity ) && IsDoor( tr.Entity ) then
				self.Owner:EmitSound("physics/wood/wood_crate_impact_hard3.wav", 100, math.random(90, 110))
			end
		end
		self.Weapon:SetNextPrimaryFire(CurTime() + 0.3)
	end
    */
end

function SWEP:SecondaryAttack()
	local ply = self.Owner
	local trace = {}
	trace.start = ply:EyePos()
	trace.endpos = ply:GetShootPos() + ply:GetForward()*50
	trace.filter = ply
	trace.mask = -1
	local tr = util.TraceLine(trace)
    
     if SERVER then
        if self.Owner:UnLockDoor( tr.Entity ) then 
            timer.Simple(0.9, function() if IsValid(self.Owner) then self.Owner:EmitSound(self.Sound) end end)
            self.Owner:AnimRestartGesture(GESTURE_SLOT_ATTACK_AND_RELOAD, ACT_GMOD_GESTURE_ITEM_PLACE, true)
        else
            if IsValid( tr.Entity ) && IsDoor( tr.Entity ) then
				self.Owner:EmitSound("physics/wood/wood_crate_impact_hard3.wav", 100, math.random(90, 110))
			end
        end
        self.Weapon:SetNextPrimaryFire(CurTime() + 0.3)
    end
    
	/*
	if IsValid( tr.Entity ) && IsDoor( tr.Entity ) && tr.Entity:GetRPVar( "doordata" ) && tr.Entity:GetRPVar( "doordata" ).owner == ply then
		if SERVER then
			--self.Owner:EmitSound("npc/metropolice/gear".. math.floor(math.Rand(1,7)) ..".wav")
			tr.Entity:Fire("unlock", "", 1)

			timer.Simple(0.9, function() if IsValid(self.Owner) then self.Owner:EmitSound(self.Sound) end end)
			
			self.Owner:AnimRestartGesture(GESTURE_SLOT_ATTACK_AND_RELOAD, ACT_GMOD_GESTURE_ITEM_PLACE, true)
		end
		self.Weapon:SetNextSecondaryFire(CurTime() + 0.3)
	else
		if SERVER then
			if IsValid( tr.Entity ) && IsDoor( tr.Entity ) then
				self.Owner:EmitSound("physics/wood/wood_crate_impact_hard3.wav", 100, math.random(90, 110))
			end
		end
		self.Weapon:SetNextSecondaryFire(CurTime() + 0.3)
	end
    */
end

SWEP.OnceReload = false
function SWEP:Reload()

end
