util.AddNetworkString( "orgchatmsg" )
util.AddNetworkString( "orginvitebox" )
util.AddNetworkString( "orgmenu" )
util.AddNetworkString( "refreshclientbank" )
util.AddNetworkString( "refreshclientplayerlist" )
util.AddNetworkString( "refreshclientmotd" )
util.AddNetworkString( "orgsadminselect" )
util.AddNetworkString( "requestorg" )
util.AddNetworkString( "requestorganswer" )
util.AddNetworkString( "editorg" )
util.AddNetworkString( "orgcheckname" )
util.AddNetworkString( "returnorgcheckname" )
util.AddNetworkString( "leaveorg" )
util.AddNetworkString( "meetuppoint" )

ORGS_MySQLConfig = ORGS_MySQLConfig or {}
ORGS_MySQLConfig.enabled = true
hook.Add("Initialize", "connecttodb", function()
	if ORGS_MySQLConfig.enabled then
		createTables()
		--db.connectToMySQL()
		print("[ORG ADDON]: Connecting to MySQL Database...")
	else 
		--db.createTables()
		print("[ORG ADDON]: Using the internal database (SQLite)!")
	end
end)

hook.Add( "PlayerInitialSpawn", "loadplayerorg", function( pl )
	pl:loadOrg()
end)

hook.Add("PlayerDisconnected", "setplayerlastseen", function( pl )
	if pl:hasOrg() then
		pl:setLastSeen( tostring( os.date() ) )
	end
end)

hook.Add( "PlayerShouldTakeDamage", "orgfriendlyfire", function( victim, attacker )
	if ORGS_Config.enableFriendlyFire then
		if victim.org and attacker.org then
			if victim.org["orgid"] == attacker.org["orgid"] then
				return false
			end
		end
	end
end)

hook.Add("CanTool", "disabletools", function(_, trace)
	local ent = trace.Entity
	if( ent:GetClass() == "ent_npcorg" ) then
		return false
	end
end)
