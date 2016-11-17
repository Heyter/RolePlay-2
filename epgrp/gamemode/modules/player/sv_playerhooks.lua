--[[---------------------------------------------------------
   File: sv_playerhooks.lua
   Desc: Overrides functions of garrysmod base related to players
-----------------------------------------------------------]]


--[[---------------------------------------------------------
   Name: gamemode:PlayerSpawn( )
   Desc: Called when a player spawns
-----------------------------------------------------------]]
function GM:PlayerSpawn(Player)
    player_manager.SetPlayerClass(Player, "player_roleplay")
    player_manager.OnPlayerSpawn(Player)
    player_manager.RunClass(Player, "Spawn")

    -- Call item loadout function
    hook.Call("PlayerLoadout", GAMEMODE, Player)

    -- Set player model
    hook.Call("PlayerSetModel", GAMEMODE, Player)
	Player:SetupHands()
end

--[[---------------------------------------------------------
   Name: gamemode:PlayerSetModel(pl)
   Desc: Set the player's model
-----------------------------------------------------------]]
function GM:PlayerSetModel(Player)
    if Player:GetRPVar( "model" ) == nil then
        local cl_playermodel = Player:GetInfo( "cl_playermodel" )
        local modelname = player_manager.TranslatePlayerModel(cl_playermodel)
        util.PrecacheModel(modelname)
        Player:SetModel(modelname)
    else
        if Player:Team() == TEAM_CITIZEN then
            Player:SetModel( Player:GetRPVar( "model" ) )
        else
			if Player:Team() == 0 then
                Player:SetModel( Player:GetRPVar( "model" ) )
                return
            end
            Player:SetModel( Player:GetRPVar( "job_model" ) )
        end
    end
end

--[[---------------------------------------------------------
   Name: gamemode:PlayerLoadout(Player)
   Desc: Give the player the default spawning weapons/ammo
-----------------------------------------------------------]]
function GM:PlayerLoadout(Player)
    player_manager.RunClass(Player, "Loadout")
end

--[[---------------------------------------------------------
   Name: gamemode:ShowHelp(Player)
   Desc: Called when player pressed F1
-----------------------------------------------------------]]
function GM:ShowHelp(Player)
    net.Start("SCShowHelp")
    net.Send(Player)
end

--[[---------------------------------------------------------
   Name: gamemode:ShowInventory(Player)
   Desc: Called when player pressed F2
-----------------------------------------------------------]]
function GM:ShowTeam(Player)
    net.Start("SCShowInventory")
    net.Send(Player)
end

--[[---------------------------------------------------------
   Name: PlayerCanHearPlayersVoice
   Desc: Voiceradius
-----------------------------------------------------------]]
function GM:PlayerCanHearPlayersVoice( listener, talker )
	local pos = talker:GetPos()
	local lpos = listener:GetPos()
	if !(talker:Alive()) then return false end
    
    if listener:GetRPVar( "RadioChat" ) == true && talker:GetRPVar( "RadioChat" ) == true && (listener:IsPolice() or listener:IsSWAT() or listener:IsMedic() or listener:Team() == TEAM_FIRE) then
        local c1 = listener:GetRPVar( "RadioChannel" ) or 1
        local c2 = talker:GetRPVar( "RadioChannel" ) or 1
		local hacked = listener:GetRPVar( "RadioHack" ) or 0
		local car = listener:GetVehicle() or nil
		
		local radio = (listener:GetInfoNum( "play_radio_in_car", 1 ) or 1)
		if radio then		// Check if the Player wants to hear Radio in car
			if (listener:IsPolice() or listener:IsSWAT() or listener:IsMedic() or listener:Team() == TEAM_FIRE) && talker:GetRPVar( "RadioChat" ) && (c1==c1) && car != nil && IsValid( car ) && car.JobCar == true then return true end	// Play the Radiochat when in a Job car
		end
		
		if hacked && c1 == c2 then return true end	// He has hacked the channel!
        if c1 != c2 then return false end   // Not in the same channel!
        
        return true
    end
    
	if pos:Distance( lpos ) > SETTINGS.VoiceRadius then return false end
    --if talker:GetRPVar( "RadioChat" ) == true then return false end		// We want to hear him, when near to him....
    
	return true, true
end

function GM:GravGunPunt( ply, ent )
    if !(IsValid( ent )) then return false end
    if ent:GetClass() == "drug_pot" then
        ent:SetAngles( Angle( 0, 0, 0 ) )
        return false
    end
    return false
end
