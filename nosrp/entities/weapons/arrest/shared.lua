AddCSLuaFile()

SWEP.PrintName = "Hand Cuffs"
SWEP.Slot = 1
SWEP.SlotPos = 3
SWEP.DrawAmmo = false
SWEP.DrawCrosshair = false

SWEP.Base = "weapon_cs_base2"

SWEP.Author = "CaMoTraX"
SWEP.Instructions = "Left click to cuff. Right click to uncuff."
SWEP.Contact = ""
SWEP.Purpose = ""
SWEP.IconLetter = ""

SWEP.ViewModelFOV = 62
SWEP.ViewModelFlip = false
SWEP.AnimPrefix = "stunstick"

SWEP.Spawnable = false
SWEP.AdminSpawnable = true

SWEP.NextStrike = 0

SWEP.ViewModel = Model("models/weapons/v_stunbaton.mdl")
SWEP.WorldModel = Model("models/weapons/w_stunbaton.mdl")

SWEP.Sound = Sound("weapons/stunstick/stunstick_swing1.wav")

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
	return true
end

function SWEP:Holster()
	return true
end

function SWEP:PrimaryAttack()
	if CurTime() < self.NextStrike then return end

	self.Owner:SetAnimation(PLAYER_ATTACK1)
	self.Weapon:EmitSound(self.Sound)
	self.Weapon:SendWeaponAnim(ACT_VM_HITCENTER)

	self.NextStrike = CurTime() + .4

	if CLIENT then return end

	local trace = self.Owner:GetEyeTrace()
	
	if !(trace.Entity:IsPlayer()) then return end

	if IsValid(trace.Entity) and trace.Entity:IsPlayer() and trace.Entity:IsPolice() then
		self.Owner:RPNotify("You can not cuff other CPs!", 5)
		return
	end

	if not IsValid(trace.Entity) or (self.Owner:EyePos():Distance(trace.Entity:GetPos()) > 115) then
		return
	end
	
	local ply = trace.Entity
	
	self:Cuff( ply )

end

function SWEP:Cuff( ply )
	ply.cuffed = ply.cuffed or false
    if ply.cuffed then return end
    
    ply.cuffed = true
    
    ply.weps = {}
    
    ply:SetRunSpeed( 100 )
    ply:SetWalkSpeed( 100 )
    
    for k, v in pairs( ply:GetWeapons() ) do
        table.insert( ply.weps, v:GetClass() )
    end
    
    ply:StripWeapons()
    ply:StripAmmo()
    
    ply:RPNotify( "Du wurdest festgenommen!", 5 )
end

function SWEP:UnCuff( ply )
	ply.cuffed = ply.cuffed or false
    if !(ply.cuffed) then return end
    
    ply.cuffed = false
    
    ply:SetRunSpeed( SETTINGS.RunSpeed )
    ply:SetWalkSpeed( SETTINGS.WalkSpeed )
    
    for k, v in pairs( ply.weps ) do
        ply:Give( v )
    end
    
    ply:RPNotify( "Du wurdest freigelassen!", 5 )
    self.Owner:RemoveStars( ply, SETTINGS.MAX_STARS )
end

function SWEP:SecondaryAttack()
	if CurTime() < self.NextStrike then return end

	--self:SetWeaponHoldType("melee")
	--timer.Simple(0.3, function() if self:IsValid() then self:SetWeaponHoldType("normal") end end)

	self.Owner:SetAnimation(PLAYER_ATTACK1)
	self.Weapon:EmitSound(self.Sound)
	self.Weapon:SendWeaponAnim(ACT_VM_HITCENTER)

	self.NextStrike = CurTime() + .4

	if CLIENT then return end

	local trace = self.Owner:GetEyeTrace()
	
	if !(trace.Entity:IsPlayer()) then return end

	if IsValid(trace.Entity) and trace.Entity:IsPlayer() and trace.Entity:IsPolice() and GAMEMODE.Config.cpcanarrestcp then
		ply:RPNotify("You can not cuff other CPs!", 5)
		return
	end

	if not IsValid(trace.Entity) or (self.Owner:EyePos():Distance(trace.Entity:GetPos()) > 115) then
		return
	end
	
	local ply = trace.Entity
	
	self:UnCuff( ply )
end
