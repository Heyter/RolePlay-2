AddCSLuaFile( )

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
	if CLIENT or not IsValid(self:GetOwner()) then return end
	self:SetColor(Color(255,0,0,255))
	self:SetMaterial("models/shiny")
	SendUserMessage("StunStickColour", self:GetOwner(), 255,0,0, "models/shiny")
	return true
end

function SWEP:Holster()
	if CLIENT or not IsValid(self:GetOwner()) then return end
	SendUserMessage("StunStickColour", self:GetOwner(), 255, 255, 255, "")
	return true
end

function SWEP:OnRemove()
	if SERVER and IsValid(self:GetOwner()) then
		SendUserMessage("StunStickColour", self:GetOwner(), 255, 255, 255, "")
	end
end

usermessage.Hook("StunStickColour", function(um)
	local viewmodel = LocalPlayer():GetViewModel()
	local r,g,b,a = um:ReadLong(), um:ReadLong(), um:ReadLong(), 255
	viewmodel:SetColor(Color(r,g,b,a))
	viewmodel:SetMaterial(um:ReadString())
end)

function SWEP:PrimaryAttack()
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
	local c = ply.cuffed or false
	if (c) then
		return
	end
	
	local cpcuff = ents.Create("prop_physics")
	cpcuff:SetModel("models/props_borealis/door_wheel001a.mdl")
	cpcuff:SetCollisionGroup(COLLISION_GROUP_DEBRIS)
	cpcuff:SetMoveType( MOVETYPE_NONE )
	cpcuff:SetSolid(SOLID_NONE)
	cpcuff:SetPos(self.Owner:GetPos() + Vector(0,0,45))
	cpcuff:Spawn()
	cpcuff:Activate()
	cpcuff:SetRenderMode( RENDERMODE_TRANSALPHA )
	cpcuff:SetColor(Color( 255, 255, 255, 0 ))
	self.Owner:DeleteOnRemove(cpcuff)
	ply:DeleteOnRemove(cpcuff)
	
	local cpweld = constraint.Weld( self.Owner, cpcuff, 0, 0, 0)
	self.Owner:DeleteOnRemove(cpweld)
	ply:DeleteOnRemove(cpweld)
	
	local plcuff = ents.Create("prop_physics")
	plcuff:SetModel("models/props_borealis/door_wheel001a.mdl")
	plcuff:SetCollisionGroup(COLLISION_GROUP_DEBRIS)
	plcuff:SetMoveType( MOVETYPE_NONE )
	plcuff:SetSolid(SOLID_NONE)
	plcuff:SetPos(ply:GetPos() + Vector(0,0,45))
	plcuff:Spawn()
	plcuff:Activate()
	plcuff:SetRenderMode( RENDERMODE_TRANSALPHA )
	plcuff:SetColor(Color( 255, 255, 255, 0 ))
	cpcuff:DeleteOnRemove(plcuff)
	
	constraint.Weld( ply, plcuff, 0, 0, 0)
	constraint.Rope(cpcuff, plcuff, 0, 0, Vector(0,0,0) , Vector(0,0,0), 100, 0, 0, 3, "cable/cable2")
	
	ply.cuffprop = cpcuff
	ply.cuffer = self.Owner
	
	timer.Create("syncply" .. ply:UniqueID(), 0.05, 0, function()
		local pl = ply or nil
		if !(IsValid(pl)) then
			timer.Destroy("syncply" .. ply:UniqueID())
			return
		end
		if !(pl:Alive()) then
			pl.cuffprop:Remove()
			pl.cuffed = false
			timer.Destroy("syncply" .. ply:UniqueID())
			return
		end
		if !(ply.cuffer:Alive() or IsValid(ply.cuffer)) then
			self:UnCuff( pl )
			return
		end
		if pl:GetPos():Distance(cpcuff:GetPos()) > 80 then
			local z = pl:GetPos().z
			local x, y = plcuff:GetPos().x, plcuff:GetPos().y
			pl:SetPos(Vector( x, y, z ))
		end
		pl:SetEyeAngles(self.Owner:EyeAngles())
	end)
	
	ply.cufftable = {}
	for k, v in pairs(ply:GetWeapons()) do
		table.insert(ply.cufftable, v:GetClass())
		ply:StripWeapon(v:GetClass())
	end
	
	ply.cuffed = true
	ply:RPNotify("You has been cuffed!", 5)
end

function SWEP:UnCuff( ply )
	local cuff = ply.cuffprop or {}
	if !(IsValid(cuff)) then return end
	local cufftable = ply.cufftable or {}
	for k, v in pairs(cufftable) do
		ply:Give(v)
	end
	if timer.Exists("syncply" .. ply:UniqueID()) then
		timer.Destroy("syncply" .. ply:UniqueID())
	end
	ply.cuffer = {}
	ply.cuffed = false
	cuff:Remove()
	ply.cuffprop = {}
	ply:RPNotify("You has been uncuffed!", 5)
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
