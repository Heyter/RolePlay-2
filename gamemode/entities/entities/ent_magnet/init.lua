AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:Initialize()
	self:SetModel("models/props_c17/streetsign004f.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	local phys = self:GetPhysicsObject()
    
    self:SetMaterial( "models/shiny" )
    self:SetColor( Color( 0, 150, 0, 255 ) )
    
    self.ent1 = nil
    self.ent2 = nil
    
    self.next_stick = CurTime() - 1

	phys:Wake()
    self.useable = true
end

function ENT:Use( ply )
    if !(IsValid( self.ent1 ) or IsValid( self.ent2 )) then return end
    if self.next_stick > CurTime() then return end
    
    constraint.RemoveAll( self )
    self:EmitSound( "buttons/button6.wav", 50, 100 )
    
    self.ent1 = nil
    self.ent2 = nil
    
    self:SetColor( Color( 0, 50, 0, 255 ) )
    
    self.next_stick = CurTime() + 2
    return
end

function ENT:Touch( ent )
    if !(IsValid( ent )) then return end
    if ent:IsPlayer() then return end
    
    if self.ent1 != nil && ent == self.ent1 then return end
    if self.ent2 != nil && ent == self.ent2 then return end
    
    if self.ent1 == nil then
        constraint.Weld( self, ent, 0, 0, 0, 0, false )
        self.ent1 = ent
        self:EmitSound( "physics/metal/metal_solid_impact_bullet4.wav", 50, 90 )
        self:SetColor( Color( 50, 0, 0, 255 ) )
        return
    end
    if self.ent2 == nil then
        constraint.Weld( self, ent, 0, 0, 0, 0, false )
        self.ent2 = ent
        self:EmitSound( "physics/metal/metal_solid_impact_bullet4.wav", 50, 90 )
        self:SetColor( Color( 50, 50, 50, 255 ) )
        return
    end
end

function ENT:Think()
    return false
end