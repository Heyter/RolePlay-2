AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")


function ENT:Initialize()
	self:SetModel("models/props_wasteland/interior_fence002e.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	local phys = self:GetPhysicsObject()
	
	if self.dt.owning_ent != self.dt.owning_ent:IsPlayer() then
		--self.dt.owning_ent = Entity(1)
	end
	
	if self.dt.owning_ent:IsPlayer() then
		self.Entity.Owner = self.dt.owning_ent
	end

	phys:Wake()
	
	self.activated = false
end
local function IsListedWeapon( wep )
	for k, v in pairs( CRAFT_TABLE ) do
		if not v.Category == "Weapon" then continue end
		if v.UniqueName == wep && wep != "weapon_physgun" then return true end
	end
	return false
end

function ENT:Think()	
	for k, v in pairs(ents.FindInSphere( self:GetPos(), 20 )) do
		if v:IsPlayer() && IsValid( v ) then
			for _, wep in pairs(v:GetWeapons()) do
				if IsListedWeapon( wep:GetClass() ) then
					self:DoAlarm()
				end
			end
		end
	end
end

function ENT:DoAlarm()
	if !(self.activated) then
		self.activated = true
		self:SetColor(Color(255,0,0,255))
		timer.Simple( 2, function() self.activated = false self:SetColor(Color(255,255,255,255)) end )
		self:EmitSound("/ambient/alarms/klaxon1.wav", 100, 100)
	end
end

function ENT:Use(activator,caller)
	
end

function ENT:OnRemove()
	
end