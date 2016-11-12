AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

local mighty_file = util.JSONToTable( file.Read( "NOSRP_BONE_MANIPULATION_TOOL/player_mightymuscle.txt", "DATA" ) )
local mighty_last = 120

function ENT:Initialize()
	self:SetModel("models/props_junk/garbage_glassbottle001a.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self.CanUse = true
	local phys = self:GetPhysicsObject()

	phys:Wake()
end

function ENT:Use( ply )
	if ply:GetNWInt( "IsMighty" ) then return end
	
	ply:SetNWInt( "IsMighty", true )
	ply:SetRPVar( "BoneManipulation", mighty_file )		// We need this later for the client!
	ply:ManipulateBones( mighty_file )
	
	ply:SetColor( Color( 0, 255, 0, 255 ) )

	ply:EmitSound( "vo/npc/Barney/ba_ohyeah.wav", 50, 70, 1 )
	timer.Simple( mighty_last, function( )
		if !(IsValid( ply )) then print("ret") return end
		
		ply:SetNWInt( "IsMighty", false )
		ply:SetColor( Color( 255, 255, 255, 255 ) )
		ply:NormalizeBones()
	end)
	self:Remove()
end

function ENT:Think()

end

hook.Add( "PlayerDeath", "RemoveMightyMuscle", function( ply )
	ply:NormalizeBones()
end)