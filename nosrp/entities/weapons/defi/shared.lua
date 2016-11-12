AddCSLuaFile()


SWEP.PrintName = "Defibrillator"
SWEP.Slot = 1
SWEP.SlotPos = 9
SWEP.DrawAmmo = false
SWEP.DrawCrosshair = false


SWEP.Author = "CaMoTraX"
SWEP.Instructions = "Links klick um ein Spieler wiederzubeleben."
SWEP.Contact = ""
SWEP.Purpose = ""

SWEP.ViewModelFOV = 62
SWEP.ViewModelFlip = false
SWEP.AnimPrefix	 = "rpg"

SWEP.Spawnable = false
SWEP.AdminSpawnable = true
SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = 0
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = ""

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = 0
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = ""

local Cooldown = false
function SWEP:Initialize()
	self:SetWeaponHoldType("normal")
end

if CLIENT then
	
end

function SWEP:Deploy()
	if SERVER then
		self.Owner:DrawViewModel(false)
		self.Owner:DrawWorldModel(false)
	end
end

function SWEP:PrimaryAttack()

	if CLIENT or Cooldown then return end

	Cooldown = true
	timer.Simple(3, function() Cooldown = false end)
	self.Weapon:SetNextPrimaryFire(CurTime() + 0.2)

	local trace = self.Owner:GetEyeTrace()

	if not IsValid(trace.Entity) or not trace.Entity:IsRagdoll() or trace.Entity:GetPos():Distance(self.Owner:GetPos()) > 200 then
		return
	end
	
	local ply = trace.Entity:GetRPVar( "ply" )
    
    if !(IsValid( ply )) then return end
    if trace.Entity:GetRPVar( "revived" ) then return end

	self.Owner:EmitSound("npc/combine_soldier/gear5.wav", 50, 100)
	timer.Simple(0.3, function() self.Owner:EmitSound("gmn_drp/revive.wav", 50, 100) end)
	
	local success = math.Rand( 1, 15 )
	
	if math.Round(success) == 7 or math.Round(success) == 3 then
        ServerLog( "[REANIMIERT] " .. self.Owner:Name() .. " hat " .. (ply:GetRPVar( "rpname" ) or ply:Nick()) .. " reanimiert!" )
        
        if ply then
            RevivePlayer( trace.Entity, self.Owner )
            self.Owner:SetSkill( "Erste Hilfe", self.Owner:GetSkill( "Erste Hilfe" ) + 0.01 )
            self.Owner:SetSkill( "Ruf", self.Owner:GetSkill( "Ruf" ) + 0.05 )
        end
	end
end

function SWEP:SecondaryAttack()

end

SWEP.OnceReload = true
function SWEP:Reload()

end

function SWEP:Holster()
	return true
end

local aimed = false

function SWEP:Think()
	local trace = self.Owner:GetEyeTrace()
    if !(IsValid( trace.Entity )) then aimed = false return false end
    
	local ply = trace.Entity:GetRPVar( "ply" )
	
	if trace.HitPos:Distance(self.Owner:GetShootPos()) < 120 and trace.Entity:IsRagdoll() and IsValid( ply ) then
		aimed = true
	else
		aimed = false
	end
end

function SWEP:DrawHUD()
	if aimed && not Cooldown then
		draw.SimpleText("Spieler Wiederbeleben!", "RPNormal_30", ScrW() / 2, ScrH() / 2 + 5, Color(255,255,255,50), 1, 1)
	end
end