AddCSLuaFile()

SWEP.PrintName = "Door Welder"
SWEP.Slot = 1
SWEP.SlotPos = 9
SWEP.DrawAmmo = false
SWEP.DrawCrosshair = false

SWEP.Author = "CaMoTraX"
SWEP.Instructions = "Links klick um die Tuer zu Verschweissen"
SWEP.Contact = ""
SWEP.Purpose = ""

SWEP.ViewModelFOV = 62
SWEP.ViewModelFlip = false
SWEP.ViewModel = Model("models/weapons/v_crowbar.mdl")
SWEP.WorldModel = Model("models/weapons/w_crowbar.mdl")

SWEP.Spawnable = false
SWEP.AdminSpawnable = true
SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = 0
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = ""

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = 0
SWEP.Secondary.Automatic = true
SWEP.Secondary.Ammo = ""

SWEP.LastWeld = CurTime() + 0.5

function SWEP:Initialize()
	self:SetWeaponHoldType("normal")
end

function SWEP:Deploy()
	if SERVER then
		self.Owner:DrawViewModel(false)
		self.Owner:DrawWorldModel(false)
	end
end

local SparkSounds = {"/ambient/energy/spark1.wav", "/ambient/energy/spark2.wav", "/ambient/energy/spark3.wav", "/ambient/energy/spark4.wav"}

function SWEP:PrimaryAttack()
if SERVER then
	local trace = self.Owner:GetEyeTrace()
	local ent = trace.Entity
	
	self.Weapon:SetNextSecondaryFire( CurTime() + 0.2 )
	self.Weapon:SetNextPrimaryFire( CurTime() + 0.2 )
	
	if !( IsValid( ent ) ) then return end
	if self.Owner:GetPos():Distance( trace.Entity:GetPos() ) > 80 then return end
	if !(IsDoor( ent )) or ent:IsVehicle() then return end
	if !(ent:GetDoorOwner() == self.Owner) then return end
	
	local gotweld = ent:GetNWInt("Welded")
	if gotweld > 99 then return end
	ent:SetNWInt( "Welded", gotweld + 0.5 )
	
	ent:Fire("lock", "", 1)
	
	local effectdata = EffectData()
	effectdata:SetOrigin(trace.HitPos)
	effectdata:SetMagnitude(1)
	effectdata:SetScale(4)
	effectdata:SetRadius(2)
	util.Effect("Sparks", effectdata)
	
	self.Owner:EmitSound(SparkSounds[math.Round( math.Rand(1, #SparkSounds) )], 75, 100)
	
end
end

function SWEP:DrawHUD()
	local trace = self.Owner:GetEyeTrace()
	local ent = trace.Entity
	
	local WeldStatus = ent:GetNWInt("Welded") or 10
	
	if IsValid( ent ) && (ent:GetClass() == "prop_door_rotating" or ent:GetClass() == "door_rotating" or ent:GetClass() == "func_door") && WeldStatus > 1 && LocalPlayer():GetPos():Distance( trace.Entity:GetPos() ) < 80 then
		draw.SimpleTextOutlined( math.Round(WeldStatus) .. "% Verschweißt!", "RPNormal_30", ScrW() / 2, ScrH() / 2, Color(0,WeldStatus + 155,0,255), 1, 1, 2, Color(0,0,0,200) )
	end
end

function SWEP:SecondaryAttack()
if SERVER then
	local trace = self.Owner:GetEyeTrace()
	local ent = trace.Entity
	
	self.Weapon:SetNextSecondaryFire( CurTime() + 0.2 )
	self.Weapon:SetNextPrimaryFire( CurTime() + 0.2 )
	
	if !( IsValid( ent ) ) then return end
	if self.Owner:GetPos():Distance( trace.Entity:GetPos() ) > 80 then return end
	if !(IsDoor( ent )) or ent:IsVehicle() then return end
	
	local gotweld = ent:GetNWInt("Welded")
	if gotweld < 1 then return end
	ent:SetNWInt( "Welded", gotweld - 1 )
	
	local effectdata = EffectData()
	effectdata:SetOrigin(trace.HitPos)
	effectdata:SetMagnitude(1)
	effectdata:SetScale(4)
	effectdata:SetRadius(2)
	util.Effect("Sparks", effectdata)
	
	self.Owner:EmitSound(SparkSounds[math.Round( math.Rand(1, #SparkSounds) )], 75, 100)
	
end
end

function SWEP:Holster()
	return true
end

function SWEP:Think()

end