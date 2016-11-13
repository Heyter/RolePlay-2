
local GUID_SaveLocation = "rphone/server_guid.txt"

util.AddNetworkString( "rphone_os_util_db_sendguid" )

local guid

local function GenerateServerGUID()
	local ip = GetConVarString( "ip" )
	local host = GetConVarString( "hostname" )
	local time = os.time()

	local guid = util.CRC( ([[%s%s%s]]):format( ip, host, time ) )

	return guid
end

hook.Add( "Initialize", "sv_os_util_db_getguid", function()
	if file.Exists( GUID_SaveLocation, "DATA" ) then
		guid = rPhone.FileRead( GUID_SaveLocation )
	end

	if !guid then
		guid = GenerateServerGUID()

		rPhone.FileWrite( GUID_SaveLocation, guid )
	end
end )

hook.Add( "PlayerInitialSpawn", "sv_os_util_db_sendguid", function( ply )
	net.Start( "rphone_os_util_db_sendguid" )
		net.WriteString( guid )
	net.Send( ply )
end )
