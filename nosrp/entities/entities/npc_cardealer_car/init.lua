AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

function ENT:Initialize( )
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetUseType(SIMPLE_USE)
	
	local phys = self:GetPhysicsObject()
	
	phys:EnableMotion( false )
	
	self.GettingTested = false
end

function ENT:AcceptInput( Name, Activator, Caller )	
	if Name == "Use" and Caller:IsPlayer() then
		--SpawnTestCar( self, Activator )
		net.Start( "openaskmenu" )
			net.WriteEntity( self )
		net.Send( Activator )
	end
end


net.Receive( "testcar", function( len, ply )
	local car = net.ReadEntity()
	SpawnTestCar( car, ply )
end)

net.Receive( "buycar", function( len, ply )
	local car = net.ReadEntity()
	ply:PurchaseCar( car )
end)
