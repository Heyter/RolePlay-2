AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")
function ENT:Initialize()
	self:SetModel("models/sligwolf/electro/stecker_001.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
    self.LastUse = CurTime() + 1

	local phys = self:GetPhysicsObject()
    
    self.dev = true
    
    -------- Important Values -----
    self.HasEnergy = false
    self.Plug = nil
    self.Slot = nil
    self.Volt = self.Volt or 12
    -------------------------------
    

	phys:Wake()
end

function ENT:Use(activator,caller)
	if self.LastUse < CurTime() then 
        self.LastUse = CurTime() + 1
    else 
        return false 
    end
    
    if IsValid( self.Plug ) then self.Plug:UnPlug( self ) end
end

function ENT:Touch( ent )
    if ent:GetClass() == "e_wall_plugholder" or ent:GetClass() == "e_plugholder" then
        if ent.Slot == nil then ent:PlugIn( self ) end
    end
end


function ENT:Think()
    if IsValid( self.Plug ) then    // Checks if the plugholder has energy
        if self.Plug.HasEnergy then
            self.HasEnergy = true
            if self.dev then self:SetColor( Color( 0, 255, 0, 255 ) ) end
        else
            self.HasEnergy = false
            if self.dev then self:SetColor( Color( 255, 0, 0, 255 ) ) end
        end
    else
        self.Plug = nil
        self.Master = nil
        self.HasEnergy = false
        if self.dev then self:SetColor( Color( 255, 0, 0, 255 ) ) end
    end
end


// Plug Creation
function CreatePlug( ent, cablepos, len, volt )
    cablepos = cablepos or Vector( 0, 0, 0 )
    len = len or 100
    volt = volt or 12
    
    local plug = ents.Create( "e_plug" )
    plug:SetPos( ent:LocalToWorld( Vector( 10, 0, 5 ) ) )
    plug.Volt = volt
    plug:Spawn()
    
    ent.Plug = plug
    
    ent:DeleteOnRemove( plug )
    
    constraint.Rope( ent, plug, 0, 0, cablepos, Vector( 0, 0, 3 ), len, 0, 0, .1, "cable/rope", false ) 
end