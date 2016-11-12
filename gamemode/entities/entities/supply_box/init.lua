AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

util.AddNetworkString( "Supply_Box_Use" )
util.AddNetworkString( "Supply_Box_Close" )
util.AddNetworkString( "Supply_Box_Refill" )
util.AddNetworkString( "Supply_Box_Repair" )

net.Receive( "Supply_Box_Close", function( data, ply )
    local ent = net.ReadEntity()
    if !(IsValid( ply )) then return end
    if !(IsValid( ent )) then return end

    ent.Player = nil
end)

net.Receive( "Supply_Box_Refill", function( data, ply )
    local ent = net.ReadEntity()
    local ammo = net.ReadString()
    if !(IsValid( ply )) then return end
    if !(IsValid( ent )) then return end
    if ammo == "" then return end

    ent:RefillAmmo( ply, ammo )
end)

function ENT:Initialize()
	self:SetModel("models/Items/ammocrate_smg1.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self.CanUse = true
	local phys = self:GetPhysicsObject()
    self.Player = nil
    self.state = 1

	phys:Wake()
end

function ENT:RefillAmmo( ply, ammo )
    if !(ply:IsSWAT() or ply:IsPolice()) then return end
    
    local rounds = 0
    
    if ammo == "pistol" then
        rounds = 60
        ply:SetAmmo( rounds, ammo )
    elseif "xbolt" then
        rounds = 120
        ply:SetAmmo( rounds, ammo )
    else
        rounds = 160
        ply:SetAmmo( rounds, ammo )
    end
    
    ECONOMY.AddCityCash( -math.Round(GetSupplyAmmoPrice()*rounds) )
    ECONOMY.AddToLog( "-" .. tostring(math.Round(GetSupplyAmmoPrice()*rounds)) .. ",-EUR für Personal Munition. ( " .. ply:GetRPVar( "rpname" ) .. " )" )
    ply:RPNotify( "Du hast deine Munition erhalten!", 5 )
end

function ENT:Use( ply )
    ply.next_supply = ply.next_supply or CurTime() + 2
    if CurTime() < ply.next_supply then return end
    ply.next_supply = CurTime() + 2
    
    if !(ply:IsSWAT() or ply:IsPolice()) then return end
    if self.Player then ply:RPNotify( "Die box wird momentan von ein Spieler benutzt!", 5 ) return end
    
    local sequence = self:LookupSequence( "Close" )
    self:SetSequence( sequence )
    self.state = 2
    
    self.Player = ply

    net.Start( "Supply_Box_Use" )
        net.WriteEntity( self )
    net.Send( self.Player )
    
    self:EmitSound( "AmmoCrate.Open", 100, 100 )
end

function ENT:Think()
    if self.Player == nil && self.state == 2 then
        self.state = 1
        local sequence = self:LookupSequence( "Open" )
        self:SetSequence( sequence )
        self:EmitSound( "AmmoCrate.Close", 100, 100 )
    end
    
    if self.Player != nil && !(IsValid(self.Player)) then
        self.Player = nil
        local sequence = self:LookupSequence( "Open" )
        self:SetSequence( sequence )
        self:EmitSound( "AmmoCrate.Close", 100, 100 )
    end
end