// Copyright © 2012-2016 VCMod (freemmaann). All Rights Reserved. if you have any complaints or ideas contact me: steam - http://steamcommunity.com/id/freemmaann, email - freemmaann@gmail.com or skype - comman6.

AddCSLuaFile("cl_init.lua") AddCSLuaFile("shared.lua") include('shared.lua')

function ENT:Initialize() self:SetModel("models/weapons/w_toolgun.mdl") self:PhysicsInit(SOLID_VPHYSICS) self:SetMoveType(MOVETYPE_VPHYSICS) self:SetSolid(SOLID_VPHYSICS) self:SetUseType(SIMPLE_USE) local phys = self:GetPhysicsObject() if phys:IsValid() then phys:SetMaterial("metal") phys:Wake() end
	self.VC_Model = ents.Create("prop_dynamic")
	self.VC_Model:SetModel("models/props_c17/TrapPropeller_Lever.mdl")
	self.VC_Model:SetPos(self:LocalToWorld(Vector(14,0.2,3)))
	self.VC_Model:SetAngles(self:LocalToWorldAngles(Angle(0,90,0)))
	self.VC_Model:SetParent(self)
	self.VC_Model:Spawn()
	self.VC_Model:DeleteOnRemove(self)

	self:SetCustomCollisionCheck(true)
end

function ENT:Use(ply) if VC and VC.CodeEnt.Fuel_nozzle and VC.CodeEnt.Fuel_nozzle.Use then return VC.CodeEnt.Fuel_nozzle.Use(self, ply) end end
function ENT:Think() if VC and VC.CodeEnt.Fuel_nozzle and VC.CodeEnt.Fuel_nozzle.Think then return VC.CodeEnt.Fuel_nozzle.Think(self, ply) end end
function ENT:Touch(ent) if VC and VC.CodeEnt.Fuel_nozzle and VC.CodeEnt.Fuel_nozzle.Touch then return VC.CodeEnt.Fuel_nozzle.Touch(self, ent) end end
function ENT:OnTakeDamage(dinfo) if VC and VC.CodeEnt.Fuel_nozzle and VC.CodeEnt.Fuel_nozzle.OnTakeDamage then return VC.CodeEnt.Fuel_nozzle.OnTakeDamage(self, dinfo) end end
function ENT:VC_PickedUp(ply) if VC and VC.CodeEnt.Fuel_nozzle and VC.CodeEnt.Fuel_nozzle.VC_PickedUp then return VC.CodeEnt.Fuel_nozzle.VC_PickedUp(self, ply) end end