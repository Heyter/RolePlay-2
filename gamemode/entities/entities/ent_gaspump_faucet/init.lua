AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include('shared.lua')

function ENT:Initialize()
	self.Entity:SetModel("models/props_wasteland/prison_pipefaucet001a.mdl")
	self.Entity:PhysicsInit(SOLID_VPHYSICS)
	self.Entity:SetMoveType(MOVETYPE_VPHYSICS)
	self.Entity:SetSolid(SOLID_VPHYSICS)
	
	self.NextTouch = CurTime() + 3
	
	self.stored = true
	
	self.PickedUpBy = NULL
	self.Vehicle = nil
	self.dt.vehicle = nil
	
	timer.Simple(5, function()
		self:GetPhysicsObject():EnableMotion(false)
		self:SetNWEntity("Parent", self.Parent)
	end)
	
end

function ENT:Freeze()
	self.Entity:GetPhysicsObject():EnableMotion(false)
	self.stored = true
	--timer.Simple(2, function() if(IsValid(self.Entity)) then self.Entity:GetPhysicsObject():EnableMotion(true) self.Entity:GetPhysicsObject():Sleep() end end)
	
end

function ENT:Think()
	if(not IsValid(self.Parent)) then
		self:Remove()
	end
end

function ENT:Use()
	if CurTime() < self.NextTouch then return end
	self.NextTouch = CurTime() + 0.2
	local ent = self.Vehicle
	
	if self.stored then
		self:GetPhysicsObject():EnableMotion(true)
		self:GetPhysicsObject():SetVelocity(self:GetUp()*100)
		self.NextTouch = CurTime() + 1
		
		timer.Simple(2, function()
			self.stored = false
		end)
		
		return
	end

	if !(IsValid( ent )) then return end
	if !(ent:IsVehicle()) then return end
	
	local kosten = Gas_Table.gas_price
	
	if !(ent.Owner:CanAfford(kosten*self.Parent.dt.tanked_liters)) then return end
	
	local carfuel = self.Vehicle:GetNWInt("fuel")
	
	if carfuel > 100 then return end
	
	carfuel = carfuel + 1
	self.Vehicle:SetNWInt("Fuel", carfuel)
	
	if self.Vehicle:GetNWInt("Empty") then
		self.Vehicle:SetNWInt("Empty", false)
		
		self.Vehicle:Fire("TurnOn", "1", 0)
		self.Vehicle:Fire("HandBrakeOff", "1", 0)
	end
	
	self:EmitSound("/buttons/blip1.wav", 75, 100)
	
	local showprice = self.Parent.dt.tanked_liters + 1
	self.Parent.dt.tanked_liters = math.Round(showprice)
end

function ENT:Touch(ent)	
	if CurTime() < self.NextTouch then return end
	self.NextTouch = CurTime() + 1
	if !(ent:IsVehicle() && IsValid( ent )) then return end
	constraint.Weld( ent, self, 0, 0, 0, 0 )
	self.Vehicle = ent
	self.dt.vehicle = ent
	self:GetPhysicsObject():EnableMotion(false)
end

function ENT:Think()
	if !(IsValid( self.Vehicle )) && self.Vehicle != nil then
		self.Vehicle = nil
		self.dt.vehicle = nil
		
		self.NextTouch = CurTime() + 1
	end
end

