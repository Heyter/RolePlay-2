AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

function ENT:Initialize( )
	self.Entity:PhysicsInit( SOLID_VPHYSICS )
    self.Entity:SetMoveType( MOVETYPE_VPHYSICS )
    self.Entity:SetSolid( SOLID_VPHYSICS )
	self.Entity:SetUseType(SIMPLE_USE)
	
    local phys = self:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:Wake()
	end
    self.class = self.class or "base_weapon"
	--phys:SetMass( 1 )
end

function ENT:AcceptInput( Name, Activator, Caller )	
	if Name == "Use" and Caller:IsPlayer() and self:IsWeapon() then
        Caller:Give( self.weaponclass )
		self:Remove()
	elseif Name == "Use" and Caller:IsPlayer() then
		local pos = self:GetPos()
		local ang = self:GetAngles()
		local mdl = self:GetModel()
		local owner = self.owner
		
		local ent = ents.Create( self.weaponclass )
		ent:SetModel( mdl )
		ent:SetAngles( ang )
		ent:SetPos( pos )
		ent:Spawn()
		ent.owner = owner
		
		ent:Fire( "use", 0 )
		self:Remove()
	end
end