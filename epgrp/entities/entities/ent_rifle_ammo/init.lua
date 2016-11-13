AddCSLuaFile( "cl_init.lua" ) -- Make sure clientside
AddCSLuaFile( "shared.lua" )  -- and shared scripts are sent.
 
include('shared.lua')
 
function ENT:Initialize()
 
	self:SetModel( "models/Items/BoxSRounds.mdl" )
	self:PhysicsInit( SOLID_VPHYSICS )      -- Make us work with physics,
	self:SetMoveType( MOVETYPE_VPHYSICS )   -- after all, gmod is a physics
	self:SetSolid( SOLID_VPHYSICS )         -- Toolbox
	self.Damage = 500
	self.Useable = 1
    
    self.ammotypes = {}
    self.ammotypes["rifle"] = 30
	self.ammotypes["smg"] = 30
    self.ammotypes["smg1"] = 30
    self.ammotypes["ar2"] = 30
    self.ammotypes["SniperPenetratedRound"] = 15
 
        local phys = self:GetPhysicsObject()
	if (phys:IsValid()) then
	    phys:Wake()
	end
end

function ENT:Use( activator, caller )
    if self.Useable == 1 then
        self.lastuse = self.lastuse or CurTime() - 1
        if self.lastuse > CurTime() then return end
        self.lastuse = CurTime() + 1
        
        local wep = activator:GetActiveWeapon()
        if !(IsValid( wep )) then return end
        if string.Left( wep:GetClass(), 3 ) == "m9k" then
            local ammotype = (wep:GetTable().AmmoType or wep:GetTable().Primary.Ammo)
            if !(ammotype) then return end

            local ammo = self.ammotypes[tostring(ammotype)]
            if ammo == nil then return end

            activator:GiveAmmo( self.ammotypes[tostring(ammotype)], ammotype )
            self:Remove()
        else
            activator:PickupItem( self )
            activator:RPNotify( "Die Munition wurde im Inventar verstaut!", 5 )
        end
    end
end

function ENT:OnTakeDamage(dmg)

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
