
concommand.Add( "rp_demote", function( admin, cmd, args )
	PrintTable( args )
	if !(IsValid( admin )) then return false end
	if !(admin:IsAdmin()) then return false end
	if !(args[1]) then return false end
	local target = FindPlayerBySteamID( args[1] )
	
	if !(IsValid(target)) then return false end
	
	target:RPNotify( "Du wurdest vom admin Degradiert!", 6 )
	admin:RPNotify( "Der Spieler wurde degradiert!", 3 )
	
	target:SwapTeam( TEAM_CITIZEN, true )
	return true
end)

concommand.Add( "rp_job", function( admin, cmd, args )
PrintTable( args )
	if !(IsValid( admin )) then return false end
	if !(admin:IsAdmin()) then return false end
	if !(args[1]) then return false end
	if !(tonumber(args[2])) then return false end
	local target = FindPlayerBySteamID( args[1] )
	
	if !(IsValid(target)) then return false end
	
	target:RPNotify( "Dir wurde ein Job vom Admin zugewiesen!", 6 )
	admin:RPNotify( "Der Spieler wurde zugewiesen!", 3 )
	
	target:SwapTeam( tonumber(args[2]), true )
	return true
end)

concommand.Add( "rp_givecash", function( admin, cmd, args )
	if !(IsValid( admin )) then return false end
	if !(admin:IsSuperAdmin()) then return false end
	if !(args[1]) then return false end
	if !(tonumber(args[2])) then return false end
	local target = FindPlayerBySteamID( args[1] )
	
	if !(IsValid(target)) then return false end
	
	admin:RPNotify( "Der Spieler Geld wurde Bearbeitet!", 3 )

	target:AddCash( tonumber( args[2] ) )
	return true
end)