AddCSLuaFile( "cl_init.lua" ) -- Make sure clientside
AddCSLuaFile( "shared.lua" )  -- and shared scripts are sent.
 
include('shared.lua')
 
function ENT:Initialize()
 
	self:SetModel( "models/Items/HealthKit.mdl" )
	self:PhysicsInit( SOLID_VPHYSICS )      -- Make us work with physics,
	self:SetMoveType( MOVETYPE_VPHYSICS )   -- after all, gmod is a physics
	self:SetSolid( SOLID_VPHYSICS )         -- Toolbox
	self.Damage = 500
	self.Useable = 1
 
        local phys = self:GetPhysicsObject()
	if (phys:IsValid()) then
	    phys:Wake()
	end
end

function ENT:Use( activator, caller )
    if self.Useable == 1 then
        activator:FixBleeding()
        activator:FixArms()
        activator:FixLegs()
        self:Remove()
    end
end

function ENT:OnTakeDamage(dmg)
   self.Damage = self.Damage - dmg:GetDamage()
    if self.Damage <= 150 then

        self:Ignite(999999)
        self.Useable = 0
   
       if self.Damage <= 0 then
        self:Destruct()
       end
   end
end

function ENT:Destruct()
    timer.Destroy("Destroy Timer")
	local vPoint = self:GetPos()
	local effectdata = EffectData()
	effectdata:SetStart(vPoint)
	effectdata:SetOrigin(vPoint)
	effectdata:SetScale(1)
	util.Effect("Explosion", effectdata)
	self:Remove()
end
