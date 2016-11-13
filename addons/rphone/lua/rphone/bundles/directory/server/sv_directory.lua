
util.AddNetworkString( "rphone_directory_include" )
util.AddNetworkString( "rphone_directory_update" )

local list_all = rPhone.GetVariable( "DIRECTORY_LIST_ALL", false )
local players_include = {}
local update_delays = {}

net.Receive( "rphone_directory_include", function( len, ply )
	if list_all then return end

	players_include[ply] = net.ReadBit() == 1
end )

net.Receive( "rphone_directory_update", function( len, ply )
	if update_delays[ply] and (CurTime() - update_delays[ply] < 1) then return end

	local numbers = {}

	for _, pl in pairs( player.GetAll() ) do
		if list_all or players_include[pl] then
			numbers[pl] = rPhone.GetNumber( pl )
		end
	end

	net.Start( "rphone_directory_update" )
		net.WriteUInt( table.Count( numbers ), 8 )

		for pl, num in pairs( numbers ) do
			net.WriteEntity( pl )
			net.WriteString( num )
		end
	net.Send( ply )

	update_delays[ply] = CurTime()
end )
