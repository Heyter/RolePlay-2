AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:Initialize()
	self:SetModel("models/props_lab/reciever01d.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self.CanUse = true
	local phys = self:GetPhysicsObject()
    
    self.nextconnect = CurTime() + 0.5
    self.next_tone = CurTime() + 0.5
    
    self.active_sound = "buttons/blip2.wav"
    self.alarm_sound = "buttons/button8.wav"
    self.activate_sound = "buttons/button3.wav"
    self.deactivate_sound = "buttons/button2.wav"
    
    self.secured = false
    self.alarm = false
    
    self.angle = Angle( 0, 0, 0 )
    

	phys:Wake()
    self.useable = true
end

function ENT:Use( ply )
    self.nextchange = self.nextchange or CurTime() - 1
    if self.nextchange > CurTime() then return end
    self.nextchange = CurTime() + 1

    if (ply != self.owner and not self.owner:IsBuddy( ply )) then ply:RPNotify( "Du bist nicht mit dem Eigentümer befreundet!", 5 ) return end
    
    if !(self.secured) then
        self.angle = self.door:GetAngles()
        self.secured = true
        self:EmitSound( self.activate_sound, 40, 100 )
    else
        self.secured = false
        self.alarm = false
        self:EmitSound( self.deactivate_sound, 40, 100 )
    end
end

function ENT:Think()
    if self.nextconnect < CurTime() && self.secured then
        self:EmitSound( self.active_sound, 40, 80 )
        self.nextconnect = CurTime() + 10
    end
    if self.secured then
        if self.door:GetAngles() != self.angle then
            self.alarm = true
        end
    end
    if self.alarm then
        if self.next_tone < CurTime() then
            self:EmitSound( self.alarm_sound, 100, 150 )
            self.next_tone = CurTime() + .5
        end
    end
    
    local data = self.door:GetRPVar( "doordata" )
    if data.owner != self.owner then
        self:Remove()
    end
end