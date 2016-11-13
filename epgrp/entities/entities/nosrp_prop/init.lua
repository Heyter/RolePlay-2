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
    
    self.owner = self.owner or nil
    self.craftowner = self.craftowner or nil
    self.name = self.name or "Unbekannt"
end

function ENT:OnTakeDamage( info )
    local attacker = info:GetAttacker()
	local phys = self:GetPhysicsObject()
	
    if !(self.HP) then 
		self.HP = self:GetPhysicsObject():GetMass() * 4
		self.pmaxhealth = self:GetPhysicsObject():GetMass() * 4
	end
    
    info:ScaleDamage( 0.1 )
    self.HP = self.HP - info:GetDamage()
    
	local rech = self.pmaxhealth/255
	local rech2 = self.HP/rech
	
	PropSetColor( self, Color( rech2, rech2, rech2, 255 ) )
    
    if self.HP < 1 then self:Remove() end
   
    return info
end