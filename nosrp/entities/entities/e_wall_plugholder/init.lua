AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:Initialize()
	self:SetModel("models/sligwolf/electro/steckdose_001.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(SOLID_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
    self.LastUse = CurTime() + 1

	local phys = self:GetPhysicsObject()
    
    -------- Important Values -----
    self.Master = self.Master or nil
    if self.Master then
        self.HasEnergy = (self.Master.IsOn or false)
    else
        self.HasEnergy = true
    end
    self.Inuse = false
    -------------------------------
    
    self.PlugPos = {
        Pos1 = {pos=Vector( 0, 0, .2 ), inuse=false}
    }
    
    self.PlugAngles = {
        Pos1 = Angle( 0, 0, 0 )
    }
end

function ENT:PlugIn( plug )
    if IsValid( plug ) then
        for k, v in pairs( self.PlugPos ) do
            if v.inuse then continue end
            local phys = plug:GetPhysicsObject()
            phys:EnableMotion( false )
            plug:SetPos( self.Entity:LocalToWorld( v.pos ) )
            plug:SetAngles( self.Entity:LocalToWorldAngles( self.PlugAngles[k] ) )
            plug.Plug = self
            plug.Master = self.Master
            plug.Slot = self.PlugPos[k]
            self.PlugPos[k].inuse = true
            constraint.Weld( self, plug, 0, 0, 0, false, false )
        end
    end
end

function ENT:UnPlug( plug )
    if !(IsValid( plug )) then return end
    
    plug.Slot.inuse = false
    plug.Plug = nil
    plug.Master = nil
    constraint.RemoveConstraints( plug, "Weld" )
    
    local phys = plug:GetPhysicsObject()
    phys:EnableMotion( true )
    phys:ApplyForceCenter( plug:LocalToWorld( Vector( 0, 0, phys:GetMass() ) ) )
end


function ENT:Think()
    if IsValid( self.Master ) then    // Checks if the plugholder has energy
        if self.Master.IsOn then
            self.HasEnergy = true
            self.dt.plugged = 1
        else
            self.HasEnergy = false
            self.dt.plugged = 0
        end
    else
        self.HasEnergy = true
        --self.dt.plugged = 1
    end
end