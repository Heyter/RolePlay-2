AddCSLuaFile( "cl_init.lua" ) -- Make sure clientside
AddCSLuaFile( "shared.lua" )  -- and shared scripts are sent.
 
include('shared.lua')
 
function ENT:Initialize()
 
	self:SetModel( "models/props_lab/powerbox02b.mdl" )
	self:PhysicsInit( SOLID_VPHYSICS )      -- Make us work with physics,
	self:SetMoveType( MOVETYPE_VPHYSICS )   -- after all, gmod is a physics
	self:SetSolid( SOLID_VPHYSICS )         -- Toolbox
	self.mode = 1
	self.Rope = NULL
	self.MaxRopeLength = 350
	self.MinRopeLength = 50
	self.RopeLength = 50
	
	self.Working = false
	self.Hook = NULL
	self.truck = NULL
	
	self.switch = self.switch or NULL
	self.ang = self.ang or 0
	self.switchmode = 1
	self.switchdone = true
	
        local phys = self:GetPhysicsObject()
	if (phys:IsValid()) then
	    phys:Wake()
	end
	
	timer.Simple(0.3, function()
		for k, v in pairs(constraint.GetAllConstrainedEntities( self )) do
			if (v:IsVehicle() && v:GetModel() == "models/tdmcars/trucks/scania_high.mdl") then
				constraint.Rope(v.Holder, v.Hook, 0, 0, v.rope_begin, Vector(0,5,17), self.RopeLength, 0, 0, 5, "cable/cable2")
				self.truck = v
			end
		end
		self:CreateSwitch()
	end)
end

function ENT:CreateSwitch()
	local switch = ents.Create( "prop_physics" )
	switch:SetModel( "models/props_c17/TrapPropeller_Lever.mdl" )
	switch:SetPos( self:LocalToWorld( Vector( 3, 6, 5 ) ) )
	switch:SetAngles( self:LocalToWorldAngles( Angle( 0, 90, 180 ) ) )
	switch:Spawn()
	switch:Activate()
	
	self.switch = switch
	self.switch:SetParent( self )
	self.switch:SetNotSolid( true )
end

function ENT:Use( ply, caller )
	if self.Working then return end
	
	local v = self.truck
	
	if self.mode == 1 then
		self.Working = true
		self.switchmode = 2
		self.switchdone = false
		timer.Create("Tow_truck_worker", 0.1, 0, function()
			self.RopeLength = self.RopeLength + 5
			constraint.RemoveConstraints(v.Hook, "Rope")
			constraint.Rope(v.Holder, v.Hook, 0, 0, v.rope_begin, Vector(0,5,17), self.RopeLength, 0, 0, 5, "cable/cable2")
			if self.RopeLength > self.MaxRopeLength then
				timer.Destroy("Tow_truck_worker")
				self.Working = false
				self.mode = 2
			end
		end)
	else
		self.Working = true
		self.switchmode = 1
		self.switchdone = false
		timer.Create("Tow_truck_worker", 0.2, 0, function()
			self.RopeLength = self.RopeLength - 5
			constraint.RemoveConstraints(v.Hook, "Rope")
			constraint.Rope(v.Holder, v.Hook, 0, 0, v.rope_begin, Vector(0,5,17), self.RopeLength, 0, 0, 5, "cable/cable2")
			if self.RopeLength < self.MinRopeLength then
				timer.Destroy("Tow_truck_worker")
				self.Working = false
				self.mode = 1
			end
		end)
	end
end

function ENT:OnRemove()

end

function ENT:Think()
	if (IsValid( self.switch ) ) && !(self.switchdone) then
		if self.switchmode == 1 then
			self.ang = self.ang + 2
			if self.ang > 35 then self.switchdone = true return end
			self.switch:SetAngles( self:LocalToWorldAngles( Angle( 0, 90, 180 - self.ang ) ) )
		else
			self.ang = self.ang - 2
			if self.ang < -35 then self.switchdone = true return end
			self.switch:SetAngles( self:LocalToWorldAngles( Angle( 0, 90, 180 - self.ang ) ) )
		end
	end
end