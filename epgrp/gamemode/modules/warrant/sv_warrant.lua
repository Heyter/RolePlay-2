function PLAYER_META:SetStars( victim, level, script )
	script = script or false
	if !(script) then
		if !(IsValid( self )) then return end
        local t = GAMEMODE.TEAMS[self:Team()]
		if !(t.CanWarrant) then return end
		if victim:IsPolice() or victim:IsSWAT() then return end
		
		if GetMayor() != nil then
			GetMayor():RPNotify( (GetMayor():GetRPVar( "rpname") or "Unknown") .. " Wir jetzt gesucht. Grund: " .. reason, 10 )
			ECONOMY.AddToLog( {ply,self,reason}, "warrant" )
		end
	end
	
	if !(IsValid( victim )) then return end
	
	victim:SetRPVar( "warrant", math.Clamp(level, 0, SETTINGS.MAX_STARS) )

	victim:AdjustTimer( SETTINGS.WARRANT_LENGHT[level] )
    victim:SetSkill( "Ruf", victim:GetSkill( "Ruf" ) - (0.2*level) )
end

function PLAYER_META:GetStarLevel()
    if !( IsValid( self ) ) then return 0 end
    return (self:GetRPVar( "warrant" ) or 0)
end

function PLAYER_META:AdjustTimer( time )
	if timer.Exists( "Player_Warrant_Expiration_" .. tostring(self:UniqueID() ) ) then
		timer.Remove( "Player_Warrant_Expiration_" .. tostring(self:UniqueID() ) )
	end
	
	timer.Create( "Player_Warrant_Expiration_" .. tostring(self:UniqueID()), time, 1, function() 
		if !(IsValid( self )) then return end
		if self:GetRPVar( "warrant" ) == 0 then return end
		
		self:SetRPVar( "warrant", self:GetRPVar( "warrant" ) - 1 )
		if self:GetRPVar( "warrant" ) == 0 then return end
		
		self:AdjustTimer( SETTINGS.WARRANT_LENGHT[self:GetRPVar( "warrant" )] )
	end )
end

function PLAYER_META:RemoveStars( victim, level )
	if !(IsValid( self )) then return end
	if !(IsValid( victim )) then return end
	if !(self:IsPolice()) then return end
	if victim:IsPolice() or victim:IsSWAT() then return end
	if level < 1 then return end
	
	local stars = victim:GetRPVar( "warrant" )
	victim:SetRPVar( "warrant", math.Clamp(stars - level, 0, SETTINGS.MAX_STARS) )
	
	if timer.Exists( "Player_Warrant_Expiration_" .. tostring(victim:UniqueID() ) ) then
		if math.Clamp(stars - level, 0, SETTINGS.MAX_STARS) < 1 then
			timer.Remove( "Player_Warrant_Expiration_" .. tostring(victim:UniqueID() ) )
		else
			victim:AdjustTimer( SETTINGS.WARRANT_LENGHT[victim:GetRPVar( "warrant" )] )
		end
	end
end
hook.Add( "NOSRP_PlayerDeath", "Warrant_Remove_Stars", function( ply ) ply:RemoveStars( ply, SETTINGS.MAX_STARS ) end )

function PLAYER_META:HasWarrantAccess()
    local t = GAMEMODE.TEAMS[self:Team()]
    return t.CanWarrant
end

function PLAYER_META:COP_CanBlastDoor( owner )
	return (owner:GetStarLevel() >= SETTINGS.Warrant_BlastDoor)
end

function PLAYER_META:COP_ShotPlayer( ply )
	if !(IsValid( ply ) or IsValid( self )) then return true end
	if !(self:IsSWAT() or self:IsPolice()) then return true end
	
	if ply:GetStarLevel() < SETTINGS.Warrant_ShootPerson then
		ECONOMY.AddToLog( {self,ply,0} , "damage" )
	end
end
--hook.Add( "PlayerShouldTakeDamage", "COP_ShotPlayer", function( ply, cop ) cop:COP_ShotPlayer( ply ) end )

// Some Chat Commands ////////////////////////////////////////

RP.PLUGINS.CHATCOMMAND.AddChatCommand( "/warrant", function( ply, args, public )
    if !(ply:HasWarrantAccess()) then ply:ChatPrint( "Police only command" ) return "" end
    if !(args[1]) then ply:ChatPrint( "Please provide a valid playername: /warrant <player|name> <level|number>" ) return "" end

    local user = RP.PLUGINS.CHATCOMMAND.FindUserByName( args[1] )
    if user == nil then ply:ChatPrint( "Please provide a valid playername: /warrant <player|name> <level|number>" ) return "" end
    if !(args[2]) then ply:ChatPrint( "Please enter a warrant level: /warrant <player|name> <level|number>" ) return "" end
    ply:SetStars( user, tonumber(args[2]) )
    return ""
end )

RP.PLUGINS.CHATCOMMAND.AddChatCommand( "/unwarrant", function( ply, args, public )
    if !(ply:HasWarrantAccess()) then ply:ChatPrint( "Police only command" ) return "" end
    if !(args[1]) then ply:ChatPrint( "Please provide a valid playername: /unwarrant <player|name> <number|stars to remove>" ) return "" end

    local user = RP.PLUGINS.CHATCOMMAND.FindUserByName( args[1] )
    if user == nil then ply:ChatPrint( "Please provide a valid playername: /unwarrant <player|name> <number|stars to remove>" ) return "" end
    if !(args[2]) then ply:ChatPrint( "Please enter a unwarrant level: /unwarrant <player|name> <number|stars to remove>" ) return "" end
    ply:RemoveStars( user, tonumber(args[2]) )
    return ""
end )