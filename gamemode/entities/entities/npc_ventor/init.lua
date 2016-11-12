AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

function ENT:Initialize( )
    self:SetModel( "models/odessa.mdl" )
	self:SetUseType( SIMPLE_USE )
	self:CapabilitiesAdd( CAP_ANIMATEDFACE )
	self:CapabilitiesAdd( CAP_TURN_HEAD )
	self:SetSolid( SOLID_BBOX )
	self:SetMaxYawSpeed( 9999 )
	--self:DropToFloor()

	local bubble = ents.Create( "bubble" )
	bubble:SetParent( self )
	bubble:SetPos( self:GetPos() + Vector(0,0,120) )
	bubble:Spawn( )
    
    self.dialogfixed = self.dialogfixed or true
    self.callfunc = self.callfunc or nil
end

function ENT:SetUseFunction( fnOnUse )
	self.useFn = fnOnUse
end

function ENT:AcceptInput( Name, Activator, Caller )	
    local dialog = nil
    
    if self.dialogfixed == false then
        if self.callfunc == nil then return end
        self.callfunc( Caller )
        return
    end

    self.spawndata.Team = self.spawndata.Team or nil

	if Name == "Use" and Activator:IsPlayer() then

        if self.spawndata.Team == nil then
            dialog = self.spawndata.callfunc
        else
            if Activator:Team() == self.spawndata.Team then
                dialog = self.spawndata.teamHello
            elseif Activator:Team() == TEAM_CITIZEN then
                dialog = self.spawndata.callfunc
            end
        end
	end
    
    if dialog != nil then
        net.Start( "NPC_DialogOpen" )
            net.WriteEntity( self )
            net.WriteString( dialog )
        net.Send( Activator )
    end
end

/*
function ENT:AcceptInput( name, activator, caller, data )
    if caller:IsPlayer() and name == "Use" then
        net.Start( self.callmessage )
        net.Send( caller )		
	end
end
*/