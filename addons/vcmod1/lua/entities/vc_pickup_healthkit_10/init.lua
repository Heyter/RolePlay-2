// Copyright © 2012-2015 VCMod (freemmaann). All Rights Reserved. if you have any complaints or ideas contact me: steam - http://steamcommunity.com/id/freemmaann, email - freemmaann@gmail.com or skype - comman6.

AddCSLuaFile("cl_init.lua") AddCSLuaFile("shared.lua") include('shared.lua')

function ENT:Initialize() self:SetModel("models/healthvial.mdl") self:PhysicsInit(SOLID_VPHYSICS) self:SetMoveType(MOVETYPE_VPHYSICS) self:SetSolid(SOLID_VPHYSICS) self:SetUseType(SIMPLE_USE) local phys = self:GetPhysicsObject() if phys:IsValid() then phys:Wake() end end

function ENT:Use(ply) VCMsg("TouchCar10", ply) end
function ENT:Touch(ent)
	if ent.VC_IsJeep and ent.VC_Health and ent.VC_Health < ent.VC_MaxHealth and !self.VC_Used then
	local effectdata = EffectData() effectdata:SetOrigin(self:GetPos()) util.Effect("cball_explode", effectdata)
	if VC_RepairHealth then VC_RepairHealth(ent, ent.VC_MaxHealth/10) end
	VC_EmitSound(ent, "items/smallmedkit1.wav", nil, 70)
	self:Remove() self.VC_Used = true
	end
end