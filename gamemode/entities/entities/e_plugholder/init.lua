AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:Initialize()
	self:SetModel("models/sligwolf/electro/steckdose_003.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
    self.LastUse = CurTime() + 1

	local phys = self:GetPhysicsObject()
    
    local plug = ents.Create( "e_plug" )
    plug:SetPos( self:LocalToWorld( Vector( 10, 0, 5 ) ) )
    plug.Plugholder = self
    plug:Spawn()
    
    plug:DeleteOnRemove( self )
    self:DeleteOnRemove( plug )
    
    constraint.Rope( self, plug, 0, 0, Vector( 5, 0, 0 ), Vector( 0, 0, 3 ), 100, 0, 0, .1, "cable/rope", false ) 
    
    
    -------- Important Values -----
    self.Master = self.Master or nil
    self.Plug = plug
    self.HasEnergy = plug.HasEnergy or false
    self.MaxVolts = 120
    -------------------------------
    
    self.PlugPos = {
        Pos1 = {pos=Vector( 0, 0, .2 ), inuse=false, plug=nil},
        Pos2 = {pos=Vector( -2.4, 0, .2 ), inuse=false, plug=nil},
        Pos3 = {pos=Vector( 2.4, 0, .2 ), inuse=false, plug=nil}
    }
    
    self.PlugAngles = {
        Pos1 = Angle( 0, -35, 0 ),
        Pos2 = Angle( 0, -35, 0 ),
        Pos3 = Angle( 0, -35, 0 )
    }
    
	phys:Wake()
end

function ENT:PlugIn( plug )
    if IsValid( plug ) then
        for k, v in pairs( self.PlugPos ) do
            if plug == v.plug then return end
        end
    
        for k, v in pairs( self.PlugPos ) do
            if v.inuse then continue end
            plug:SetPos( self.Entity:LocalToWorld( v.pos ) )
            plug:SetAngles( self.Entity:LocalToWorldAngles( self.PlugAngles[k] ) )
            plug.Plug = self
            plug.Slot = k
            self.PlugPos[k].inuse = true
            self.PlugPos[k].plug = plug
            constraint.Weld( self, plug, 0, 0, 0, false, false )
            self.Entity:EmitSound( "buttons/button14.wav", 100, 150 )
            return true
        end
    end
    return false
end

function ENT:UnPlug( plug )
    if !(IsValid( plug )) then return end
    
    self.PlugPos[plug.Slot].inuse = false
    self.PlugPos[plug.Slot].plug = nil
    plug.Plug = nil
    constraint.RemoveConstraints( plug, "Weld" )
    
    local phys = plug:GetPhysicsObject()
    phys:EnableMotion( true )
    phys:ApplyForceCenter( plug:LocalToWorld( Vector( 0, 0, phys:GetMass() ) ) )
    self.Entity:EmitSound( "buttons/button15.wav", 100, 50 )
end

function ENT:OverVoltage()
    self.lasteffect = self.lasteffect or CurTime() - 1
    if self.lasteffect >= CurTime() then return end
    self.lasteffect = CurTime() + 2
    
    for k, v in pairs( self.PlugPos ) do
        if !(IsValid( v.plug )) then continue end
            
        local effectdata = EffectData()
        effectdata:SetOrigin(self:GetPos())
        effectdata:SetMagnitude(1)
        effectdata:SetScale(1)
        effectdata:SetRadius(1)
        util.Effect("Sparks", effectdata)
    end
    
    local rand = math.Rand( 1, 100 )
    
    if rand == 33 or rand == 25 or rand == 63 or rand == 85 then
        if IsValid( self.Master ) then
            --self.Master:Break()   // Sicherung durchknallen lassen
        end
    end
    
    self:EmitSound( "ambient/energy/spark1.wav", 50, 100 )
end

function ENT:Think()
    if IsValid( self.Plug ) then    // Checks if the plugholder has energy
        local volts = 0
        for k, v in pairs( self.PlugPos ) do
            if !(IsValid( v.plug )) then v.plug=nil v.inuse=false continue end
            volts = volts + v.plug.Volt
        end
        
        self.Plug.Volt = volts
        if volts > self.MaxVolts then
            self.HasEnergy = false
            self.dt.plugged = 0
            self:OverVoltage()
            return
        end
    
    
        if self.Plug.HasEnergy then
            self.HasEnergy = true
            self.dt.plugged = 1
        else
            self.HasEnergy = false
            self.dt.plugged = 0
        end
    else
        self.HasEnergy = false
        self.dt.plugged = 0
    end
end