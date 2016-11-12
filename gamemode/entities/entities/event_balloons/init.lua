AddCSLuaFile( "cl_init.lua" ) -- Make sure clientside
AddCSLuaFile( "shared.lua" )  -- and shared scripts are sent.
 
include('shared.lua')

local playerscores = {}
local playerpos = {}

local winreward = 1000
 
function ENT:Initialize()
 
	self:SetModel( "models/props_junk/sawblade001a.mdl" )
	self:PhysicsInit( SOLID_VPHYSICS )      -- Make us work with physics,
	self:SetMoveType( MOVETYPE_VPHYSICS )   -- after all, gmod is a physics
	self:SetSolid( SOLID_VPHYSICS )         -- Toolbox
	self:SetColor(Color(255,0,0,255))
 
        local phys = self:GetPhysicsObject()
	if (phys:IsValid()) then
	    phys:Wake()
	end
	
	self.time = (CurTime() + 240)
	
	for k, v in pairs(player.GetAll()) do
		v:StripWeapons()
		v:Give("weapon_crossbow")
		v:GiveAmmo( 999, "XBowBolt" )
		v:ChatPrint("Balloon Event hat begonnen!")
		if v:IsAdmin() then
			v:Give("weapon_physgun")
			v:Give("gmod_tool")
		end
		local pos = v:GetPos()
		local postbl = {
			ply = v,
			pos = pos
		}
		
		local statstbl = {
			ply = v,
			stats = 0
		}
		
		table.insert( playerpos, postbl )
		table.insert( playerscores, statstbl )
		
		v:SetPos( self:GetPos() + Vector(math.Rand( -400, 400 ), math.Rand( -400, 400 ), 100) )
	end
	
	timer.Create("EVENT_BALLOON_CREATE_BALLOON", 0.3, 0, function()
		for i=0, 1 do
			local balloon = ents.Create("gmod_balloon") --normal balloon
			balloon:SetModel("models/MaxOfS2D/balloon_classic.mdl")
			balloon:Spawn()
			balloon:SetRenderMode( RENDERMODE_TRANSALPHA )
			balloon:SetColor(Color(math.random(0,255), math.random(0,255), math.random(0,255), 255))
			balloon:SetForce(30)
			balloon:SetMaterial("models/balloon/balloon")
			balloon:SetPos( self:GetPos() + (self:GetUp() * 120) + Vector(math.Rand(-250,250), math.Rand(-250,250), 0) )
			balloon:DeleteOnRemove(balloon)
			timer.Create( "EVENT_BALLOON_REMOVE_BALLOON" .. balloon:EntIndex(), 15, 1, function() balloon:Remove() end )
		end
	end)

end

// [EVENT] Functions


/////////////
// Stats \\
/////////////

local function CreateStats( ply )
	local statstbl = {
			ply = ply,
			stats = 0
		}
		
	table.insert( playerscores, statstbl )
end

local function StatsExists( ply )
	local found = false
	for k, v in pairs( playerscores ) do
		if v.ply == ply then
			found = true
		end
	end
	return found
end

local function IncrementStat( ply )
	for k, v in pairs( playerscores ) do
		if v.ply == ply then
			v.stats = v.stats + 1
		end
	end
end

local function CalcWinner()
	local mostbal = 0
	local wply = nil
	
	for k, v in pairs( playerscores ) do
		if v.stats > mostbal then
			mostbal = v.stats
			wply = v.ply
		end
	end
	
	wply:AddCash( winreward )
	
	for k2, v2 in pairs( player.GetAll() ) do
		if v2 == wply then
			wply:ChatPrint( "Du hast das Event gewonnen und bekommst $" .. winreward .. "!" )
		else
			v2:ChatPrint( wply:Nick() .. " hat mit " .. mostbal .. " Balloons gewonnen! Er bekommt: $" .. winreward )
		end
	end
end

/////////////
// Other \\
/////////////

local function TeleportPlayersBack()
	for k, v in pairs( playerpos ) do
		for _, ply in pairs( player.GetAll() ) do
			if v.ply == ply then
				ply:SetPos(v.pos)
			
			end
		end
	end
end

local function RemovePlayerTable( ply )
	for k, v in pairs( playerpos ) do
		if ply == v.ply then
			table.remove( playerpos, playerpos[k] )
		end
	end
	
	for k2, v2 in pairs( playerscores ) do
		if ply == v2.ply then
			table.remove( playerscores, playerscores[k2] )
		end
	end
end

function ENT:Think()
	if CurTime() > self.time then
		timer.Destroy("EVENT_BALLOON_CREATE_BALLOON")
		self:Remove()
		
		for k, ply in pairs(player.GetAll()) do
			ply:StripWeapons()
			ply:StripAmmo()
			
			gamemode.Call("PlayerLoadout", ply)
			
			ply:ChatPrint("Das Balloon Event ist nun zu ende!")
		end
		
		CalcWinner()
		TeleportPlayersBack()
		table.Empty( playerscores )
		table.Empty( playerpos )
	end
end

// Hooks

local function PlyDisconnect( ply )
	RemovePlayerTable( ply )
end
hook.Add("PlayerDisconnect", "EVENT_BALLOON_DISCONNECT", PlyDisconnect)

local function GivePlayerEventSwep( ply )
	if timer.Exists("EVENT_BALLOON_CREATE_BALLOON") then
		ply:StripWeapons()
		ply:Give("weapon_crossbow")
		ply:GiveAmmo( 999, "XBowBolt" )
	end
	
	if !StatsExists( ply ) then
		CreateStats( ply )
	end
end
hook.Add("PlayerSpawn", "EVENT_BALLOON_SPAWN", GivePlayerEventSwep )

hook.Add("EntityTakeDamage", "Event_Balloon_damage", function( ent, dmginfo )
	if IsValid( ent ) && ent:GetClass() == "gmod_balloon" && timer.Exists("EVENT_BALLOON_CREATE_BALLOON") then
		dmginfo:GetAttacker():AddMoney(10)
		IncrementStat( dmginfo:GetAttacker() )
		timer.Destroy( "EVENT_BALLOON_REMOVE_BALLOON" .. ent:EntIndex() )
	end
end)

function ReturnEventDamage( ply, HitGroup, DmgInfo )
	if timer.Exists("EVENT_BALLOON_CREATE_BALLOON") then
		DmgInfo:ScaleDamage(0)
		return DmgInfo
	end
end
hook.Add("ScalePlayerDamage", "EVENT_BALLOON_RETRUN_DAMAGE", ReturnEventDamage)