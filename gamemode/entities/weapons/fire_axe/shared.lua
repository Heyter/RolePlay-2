AddCSLuaFile( )


SWEP.PrintName = "Feueraxt"
SWEP.Slot = 2
SWEP.SlotPos = 1
SWEP.DrawAmmo = false
SWEP.DrawCrosshair = false

SWEP.Author = "Just4FunKiller"
SWEP.Instructions = "Links klick um eine verschlossene Tür zu öffnen."
SWEP.Contact = ""
SWEP.Purpose = ""

SWEP.ViewModelFOV = 62
SWEP.ViewModelFlip = false

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

SWEP.ViewModel = "models/weapons/v_fireaxe.mdl"
SWEP.WorldModel = "models/weapons/w_fireaxe.mdl"

function SWEP:Initialize()
	self:SetWeaponHoldType( "melee" )
end

function SWEP:PrimaryAttack()
	self.Weapon:SetNextPrimaryFire( CurTime() + 0.5 )

	local tr = self.Owner:GetEyeTrace()

	if IsValid( tr.Entity ) and IsDoor( tr.Entity ) then
		local dist = self.Owner:EyePos():Distance( tr.HitPos )
		if dist > 75 then return end
		
		local FireIsNear = false
		for _, v in pairs( ents.FindInSphere(tr.Entity:GetPos(), 600) ) do
			if v:GetClass() == "ent_fire" then
				FireIsNear = true
				break
			end
		end

		if FireIsNear then
			local rnd = math.Round( math.random( 0, 7 ) )
			
			if rnd == 2 or rnd == 5 then
				tr.Entity:Fire( "unlock", "", 0 )
				tr.Entity:Fire( "open", "", 0.5 )

				self.Owner:SetSkill( "Ruf", self.Owner:GetSkill( "Ruf" ) + 0.05 )
			end
		end
	end
end

function SWEP:SecondaryAttack()
	self:PrimaryAttack()
end