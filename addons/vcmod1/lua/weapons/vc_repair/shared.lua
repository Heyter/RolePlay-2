// Copyright © 2012-2015 VCMod (freemmaann). All Rights Reserved. if you have any complaints or ideas contact me: email - freemmaann@gmail.com or skype - comman6.

AddCSLuaFile("shared.lua")

SWEP.Category 		= "VCMod"
SWEP.PrintName		= "Repair"
SWEP.Author			= "freemmaann"
SWEP.Instructions	= "Aim at the car to repair it, right click to repair it instantly (admin only)"

SWEP.ViewModel		= "models/weapons/v_crowbar.mdl"
SWEP.WorldModel		= "models/weapons/w_crowbar.mdl"
SWEP.ViewModelFOV	= 55

SWEP.Spawnable		= true
SWEP.Slot 			= 5
SWEP.UseHands 		= true

SWEP.Primary.ClipSize		= -1
SWEP.Primary.DefaultClip	= -1
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "none"

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"

function SWEP:Initialize() self:SetHoldType("melee") end

function SWEP:Deploy()
	self:SendWeaponAnim(ACT_VM_DRAW)
	self.VC_TBNIA = CurTime()+ self.Owner:GetViewModel():SequenceDuration()
	return true
end

function SWEP:Holster()
	if self.VC_FixSound then self.VC_FixSound:Stop() self.VC_FixSound = nil end
	self:SetNWBool("VC_DamagedAim", false) self.VC_DamagedInfo = nil self:SetNWEntity("VC_DamagedEnt", NULL)
	self.VC_StartTime = nil self.VC_ForAmount = nil self:SetNWBool("VC_Fixing", false) self.VC_NextScanTime = nil
return true
end

function SWEP:PrimaryAttack()
	if (!self.VC_TBNIA or CurTime() >= self.VC_TBNIA) and self.VC_DamagedInfo then
	self:SetNextPrimaryFire(CurTime()+0.5)
	self.Owner:SetAnimation(PLAYER_ATTACK1)
	end
end

function SWEP:SecondaryAttack()
	if self.Owner:IsAdmin() then
	local tr = self.Owner:GetEyeTraceNoCursor() local ent, ShootPos, AimVector = tr.Entity, self:GetOwner():GetShootPos(), self:GetOwner():GetAimVector()
		if IsValid(ent) and tr.HitPos:Distance(ShootPos) <= 75 and ent:IsVehicle() and ent.VC_Health and ent.VC_Health < ent.VC_MaxHealth then
		self:SetNextSecondaryFire(CurTime()+0.5)
		self.Weapon:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
		self.Owner:SetAnimation(PLAYER_ATTACK1)
		self.VC_TBNIA = CurTime()+ self.Owner:GetViewModel():SequenceDuration()
		VCMsg("Vehicle completely repaired.", self.Owner)
		VC_RepairHealth_Max(ent, self)
		end
	end
end

function VC_LeanRandom(ent, Int) ent:GetPhysicsObject():AddAngleVelocity(Vector(math.random(-200*Int, 250*Int), math.random(-200*Int, 200*Int), math.random(-100*Int, 100*Int))) end

function VC_RepairHealth(ent, am, self)
	ent.VC_Health = math.Clamp((ent.VC_Health or 0)+ am*(VC_Settings.VC_RepairTool_Speed_M or 1), 0, ent.VC_MaxHealth) if ent.VC_Health/ent.VC_MaxHealth < 0.125 then ent.VC_Health = ent.VC_MaxHealth*0.125 if self:GetOwner().addXP then self:GetOwner():addXP(15) end end ent:SetNWInt("VC_Health", ent.VC_Health)
	if ent.VC_EBroke and ent.VC_Health > 0 then
	ent.VC_EBroke = false
	ent.VC_EngineOff = false
	ent:Fire("TurnOn")
	if self:GetOwner().addXP and ent.VC_Health >= ent.VC_MaxHealth then self:GetOwner():addXP(50) end
	if IsValid(ent.VC_EngSmk) then ent.VC_EngSmk:Remove() end
	ent.VC_EngSmk = nil ent.VC_TBESDO = nil
	end
end

function VC_RepairHealth_Max(ent, self)
	ent.VC_Health = ent.VC_MaxHealth if ent.VC_Health/ent.VC_MaxHealth < 0.125 then ent.VC_Health = ent.VC_MaxHealth*0.125 if self:GetOwner().addXP then self:GetOwner():addXP(15) end end ent:SetNWInt("VC_Health", ent.VC_Health)
	if ent.VC_EBroke and ent.VC_Health > 0 then
	ent.VC_EBroke = false
	ent:Fire("TurnOn")
	if self:GetOwner().addXP and ent.VC_Health >= ent.VC_MaxHealth then self:GetOwner():addXP(50) end
	if IsValid(ent.VC_EngSmk) then ent.VC_EngSmk:Remove() end
	ent.VC_EngSmk = nil ent.VC_TBESDO = nil
	end
end

function VC_GetDamagedPart_VCMod1(ent, MPos, AimVector, MinDot, SPos, self)
	local Pos, FixFunc, Pnt, Time, ContFunc = nil, nil, nil, nil, nil, nil
	if ent.VC_Health and ent.VC_Health < ent.VC_MaxHealth then Pos = ent:OBBCenter() Pnt = {} ContFunc = function(ent, Pnt) VC_RepairHealth(ent, 0.5*VC_FTm, self) end Time = 100 end
	return {Pos, FixFunc, Pnt, Time, ContFunc}
end

function SWEP:Think()
	if self.VC_TBNIA and CurTime()>= self.VC_TBNIA then self:SendWeaponAnim(ACT_VM_IDLE) self.VC_TBNIA = nil end

	if SERVER then
		if self.VC_DamagedInfo then
			if self:GetOwner():KeyDown(IN_ATTACK) and (!self.VC_TBNIA or CurTime() >= self.VC_TBNIA) then
				if IsValid(self:GetNWEntity("VC_DamagedEnt")) then
				if !self.VC_StartTime then self.VC_StartTime = CurTime() self.VC_ForAmount = 1+self.VC_DamagedInfo[4] self:SetNWBool("VC_Fixing", true) self:SetNWInt("VC_FixingStartTime", CurTime()) self:SetNWInt("VC_StartTime", self.VC_StartTime) self:SetNWInt("VC_ForAmount", self.VC_ForAmount) end
					if CurTime() >= (self.VC_StartTime+0.5) then
					if self:GetNWEntity("VC_DamagedEnt"):IsVehicle() then VC_LeanRandom(self:GetNWEntity("VC_DamagedEnt"), 0.005) end
					local Pos = VC_VectorToWorld(self:GetNWEntity("VC_DamagedEnt"), self:GetNWVector("VC_DamagedPos"))
					if !self.VC_FixSound and self.VC_DamagedInfo[6] then self.VC_FixSound = VC_EmitSound(self:GetNWEntity("VC_DamagedEnt"), self.VC_DamagedInfo[6], 100, 75, 0.3, Pos) end
					if self.VC_DamagedInfo[5] then if type(self.VC_DamagedInfo[3]) != "table" then VC_LeanRandom(self:GetNWEntity("VC_DamagedEnt"):GetParent(), 0.005) end self.VC_DamagedInfo[5](self:GetNWEntity("VC_DamagedEnt"), self.VC_DamagedInfo[3]) end
					end
				end
			elseif self.VC_StartTime then
			self.VC_StartTime = nil self.VC_ForAmount = nil self:SetNWBool("VC_Fixing", false) if self.VC_FixSound then self.VC_FixSound:Stop() self.VC_FixSound = nil end
			end
		elseif self.VC_StartTime then
		self.VC_StartTime = nil self.VC_ForAmount = nil self:SetNWBool("VC_Fixing", false) if self.VC_FixSound then self.VC_FixSound:Stop() self.VC_FixSound = nil end
		end

		if self.VC_StartTime and CurTime() >= (self.VC_StartTime+self.VC_ForAmount) then
		local ent = self:GetNWEntity("VC_DamagedEnt")

		if self.VC_DamagedInfo[2] then self.VC_DamagedInfo[2](ent, self.VC_DamagedInfo[3]) end

		if self.VC_FixSound then self.VC_FixSound:Stop() self.VC_FixSound = nil end
		self:SetNWBool("VC_DamagedAim", false) self.VC_DamagedInfo = nil self:SetNWEntity("VC_DamagedEnt", NULL)
		self.VC_StartTime = nil self.VC_ForAmount = nil self:SetNWBool("VC_Fixing", false) self.VC_NextScanTime = nil
		end

		if !self.VC_NextScanTime or CurTime() >= self.VC_NextScanTime then
			local tr = self.Owner:GetEyeTraceNoCursor() local ent, ShootPos, AimVector = tr.Entity, self:GetOwner():GetShootPos(), self:GetOwner():GetAimVector()
			if IsValid(ent) and tr.HitPos:Distance(ShootPos) <= 75 then
				if ent:IsVehicle() then
					local Info = VC_GetDamagedPart_VCMod1(ent, tr.HitPos, AimVector, 0.9, ShootPos, self)
					if Info[1] then
					self:SetNWBool("VC_DamagedAim", true) self.VC_DamagedInfo = Info self:SetNWVector("VC_DamagedPos", self.VC_DamagedInfo[1]) self:SetNWEntity("VC_DamagedEnt", ent)
					elseif self.VC_DamagedInfo then
					self:SetNWBool("VC_DamagedAim", false) self.VC_DamagedInfo = nil self:SetNWEntity("VC_DamagedEnt", NULL)
					end
				elseif self.VC_DamagedInfo then
				self:SetNWBool("VC_DamagedAim", false) self.VC_DamagedInfo = nil self:SetNWEntity("VC_DamagedEnt", NULL)
				end
			elseif self.VC_DamagedInfo then
			self:SetNWBool("VC_DamagedAim", false) self.VC_DamagedInfo = nil self:SetNWEntity("VC_DamagedEnt", NULL)
			end
		self.VC_NextScanTime = CurTime()+(self.VC_DamagedInfo and 0.2 or 1)
		end
	end
end

if CLIENT then
	function SWEP:GetViewModelPosition(pos, ang)
	local FTm = VC_FTm()
	local ent = self:GetNWEntity("VC_DamagedEnt")
	if !self.VC_PastAngleInt then self.VC_PastAngleInt = 0 end
	if !self.VC_FixingInt then self.VC_FixingInt = 0 end
		if self:GetNWBool("VC_Fixing") then
			if self:GetNWInt("VC_FixingStartTime") != 0 then
				if !self.VC_FixingIntDec then
				self.VC_FixingInt = self.VC_FixingInt+0.03*FTm
				if self.VC_FixingInt > 1 then self.VC_FixingInt = 1 self.VC_FixingIntDec = true end
				else
				local Extra = CurTime()-self:GetNWInt("VC_FixingStartTime") if Extra > 4 then Extra = 4 end Extra = Extra/8
				self.VC_FixingInt = self.VC_FixingInt-(0.03-Extra*0.025)*FTm if self.VC_FixingInt < 0 then self.VC_FixingInt = 0 self.VC_FixingIntDec = false end
				end
			end
		elseif self.VC_FixingInt > 0 then
		self.VC_FixingInt = self.VC_FixingInt-0.02*FTm if self.VC_FixingInt < 0 then self.VC_FixingInt = 0 end
		end

		local FixAng = Angle(0,0,0) if self.VC_FixingInt > 0 then FixAng = LerpAngle(VC_EaseInOut(self.VC_FixingInt), FixAng, Angle(10,-5,-50)) end

		if IsValid(ent) then
		if self.VC_PastAngleInt < 1 then self.VC_PastAngleInt = self.VC_PastAngleInt+0.05*FTm if self.VC_PastAngleInt > 1 then self.VC_PastAngleInt = 1 end end
		elseif self.VC_PastAngleInt > 0 then
		self.VC_PastAngleInt = self.VC_PastAngleInt-0.02*FTm if self.VC_PastAngleInt < 0 then self.VC_PastAngleInt = 0 end
		end

		if self.VC_PastAngleInt > 0 then
		self.VC_PastAngle = LerpAngle((IsValid(ent) and 0.05 or 0.01)*FTm, self.VC_PastAngle or ang, IsValid(ent) and ((ent:LocalToWorld(self:GetNWVector("VC_DamagedPos"))-pos):Angle()+Angle(0,22,0)) or ang)

		ang = LerpAngle(VC_EaseInOut(self.VC_PastAngleInt), ang, self.VC_PastAngle)
		else
		self.VC_PastAngle = nil
		end
	return pos, ang+FixAng
	end
end