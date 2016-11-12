AddCSLuaFile( "cl_init.lua" ) -- Make sure clientside
AddCSLuaFile( "shared.lua" )  -- and shared scripts are sent.
 
include('shared.lua')

local event_players = {}
 
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

	self.firstfound = false
	self.started = false
	
	timer.Create( "EVENT_ZOMBIE", 5, 0, function() // Startet runde nach 30 Sekunden!
		if self.started then return end
		
		local found = false
		for k, v in pairs( event_players ) do
			if IsValid( v.ply ) && v.zombie then
				found = true
				v.ply:KillSilent()
				timer.Simple( 1, function() v.ply:Spawn() GAMEMODE:Notify( v.ply, 1, 8, "Du bist ein Zombie! Esse alle anderen auf die keine Zombies sind!" ) end )
			end
		end
		
		if not found then
			local rand = math.Rand( 1, (table.Count(player.GetAll()) - 1) )
			event_players[rand].zombie = true
			event_players[rand].ply:KillSilent()
			timer.Simple( 1, function() event_players[rand].ply:Spawn() GAMEMODE:Notify( event_players[rand].ply, 1, 8, "Du bist ein Zombie! Esse alle anderen auf die keine Zombies sind!" ) end )
		end
		self.started = true
	end )
	
	for k, v in pairs(player.GetAll()) do
		local zombiefound = false
		if math.Rand(1,8) == 6 then self.firstfound = true zombiefound = true end
		local plytbl = {
			zombie = zombiefound,
			ply = v
		}
		table.insert(event_players, plytbl)
		
		v:SetModel("models/player/breen.mdl")
		
		v:StripWeapons()
		--GiveEventSweps(v)
		
		v:SetHealth( 100 )
		
		v:ChatPrint("Zombie Event hat begonnen!")
	end

end

local function IsWolrdDown()
	local zombies = 0
	for k, v in pairs( event_players ) do
		if v.zombie then
			zombies = zombies + 1
		end
	end
	
	if zombies >= (table.Count(player.GetAll()) - 1) then
		return true
	else
		return false
	end
end

local function IsZombie( ply )
	for k, v in pairs( event_players ) do
		if v.ply == ply then
			if v.zombie then
				return true
			else
				return false
			end
		end
	end
end

local function EndEvent()
	if !(timer.Exists("EVENT_ZOMBIE")) then return end
	for k, v in pairs(player.GetAll()) do
		if IsValid( v ) then
			v:ChatPrint("Das Zombie Event ist nun zu ende!")
			timer.Destroy("EVENT_ZOMBIE")
			gamemode.Call("PlayerLoadout", ply)
		end
	end
	
	table.Empty( event_players )
	self:Remove()
end

local function GiveEventSweps( ply )
	ply:Give("weapon_physgun")
	ply:Give("weapon_crossbow")
	ply:Give("pistol")
	ply:Give("weapon_ak47")
	ply:GiveAmmo( 50, "XBowBolt" )
	ply:GiveAmmo( 1500, "Rifle" )
	ply:GiveAmmo( 1500, "Pistol" )
end

local function PlayerGotBite( ply, zombie )
	if timer.Exists("EVENT_ZOMBIE") then
		for k, v in pairs( event_players ) do
			if tostring(v.ply:SteamID()) == tostring(ply:SteamID()) then
				ply.zombie = true
				ply:ChatPrint( "Du wurdest gebissen! Nun wirst du als Zombie spawnen!" )
			end
		end
	
		if IsWolrdDown() then
			EndEvent()
		end
	end
end
hook.Add( "PlayerDeath", "EVENT_ZOMBIE_BITE", PlayerGotBite )

local function PlayerDisconnectInEvent( ply )
	if !(timer.Exists("EVENT_ZOMBIE")) then return end
	for k, v in pairs( event_players ) do
		if v.ply == ply then
			table.remove( event_players, event_players[k] )
		end
	end
end
hook.Add( "PlayerDisconnect", "EVENT_ZOMBIE_DISCONNECT", PlayerDisconnectInEvent )

local function GivePlayerEventSwep( ply )
	if timer.Exists("EVENT_ZOMBIE") then
		ply:StripWeapons()
		for k, v in pairs( event_players ) do
			if tostring(v.ply:SteamID()) == tostring(ply:SteamID()) then
				if v.zombie then // Ist der Player ein Zombie ?
					ply:Give("weapon_crowbar")
					ply:SetHealth( 600 )
					ply:SetModel("models/player/monk.mdl")
				else // Wenn nicht
					ply:SetHealth( 100 )
					GiveEventSweps( ply )
					ply:SetModel("models/player/breen.mdl")
				end
				print(ply.zombie)
			end
		end
	end
end
hook.Add("PlayerSpawn", "EVENT_ZOMBIE_SPAWN", GivePlayerEventSwep )

function ReturnEventDamage( ply, HitGroup, DmgInfo )
	if timer.Exists("EVENT_ZOMBIE") then
		if IsZombie( ply ) && IsZombie( DmgInfo:GetAttacker() ) then DmgInfo:ScaleDamage(0) return DmgInfo end
		if not IsZombie( ply ) && not IsZombie( DmgInfo:GetAttacker() ) then DmgInfo:ScaleDamage(0) return DmgInfo end
		
		return DmgInfo
	end
end
hook.Add("ScalePlayerDamage", "EVENT_ZOMBIE_RETRUN_DAMAGE", ReturnEventDamage)