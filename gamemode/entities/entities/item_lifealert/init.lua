AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

function ENT:Initialize()
	self:SetModel( "models/props_lab/reciever01d.mdl" )
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	local phys = self:GetPhysicsObject()
	
	phys:Wake()
end

function ENT:Use(ply,caller)
	if !(IsValid(ply)) then return end
	local hasalert = ply:GetNWBool( "haslifealert" ) or false
	if hasalert then return end
	
	ply:SetNWBool("haslifealert", true)
	GAMEMODE:Notify( ply, 1, 8, "Du hast nun ein Life Alert! Falls du Bewusstlos wirst, ruft dieser ein Medic an die Unfallstelle." )
	self:Remove()
end
