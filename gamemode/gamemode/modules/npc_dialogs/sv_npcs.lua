util.AddNetworkString( "RequestJobEnter" )
util.AddNetworkString( "RequestJobLeave" )
util.AddNetworkString( "RefillLoescher" )
util.AddNetworkString( "RefillLoescher_Reply" )
util.AddNetworkString( "Buy_Perma_Playermodel" )

net.Receive( "RequestJobEnter", function( len, ply)
	local npc = net.ReadEntity()
	local typ = npc.jobname
	
	util.AddNetworkString( "CanEnterJob" .. typ )
	
	local reply = ply:ChangeTeam( typ )

	if reply == "OK" then
		net.Start( "CanEnterJob" .. typ )
			net.WriteBit( true )
			net.WriteString( "" )
		net.Send( ply )
	elseif reply == "NIL" then
		net.Start( "CanEnterJob" .. typ )
			net.WriteBit( false )
			net.WriteString( "Unbekannt... Kontaktiere ein Admin!" )
		net.Send( ply )
	else
		net.Start( "CanEnterJob" .. typ )
			net.WriteBit( false )
			net.WriteString( reply )
		net.Send( ply )
	end
end)

net.Receive( "RequestJobLeave", function( len, ply)
	local npc = net.ReadEntity()
	local typ = npc.jobname
	
	ply:ChangeTeam( typ )
end)

net.Receive( "RefillLoescher", function( len, client )
	for k, v in pairs( client:GetWeapons() ) do
		if v:GetClass() == "weapon_fire_extinguisher" then
			if !(client:CanAfford( 250 )) then continue end
			v:Remove()
			timer.Simple( 0.1, function() client:Give( "weapon_fire_extinguisher" ) end )
			client:AddMoney( -250 )
			net.Start( "RefillLoescher_Reply" )
				net.WriteBit( true )
			net.Send( client )
			return
		end
	end
	net.Start( "RefillLoescher_Reply" )
		net.WriteBit( false )
	net.Send( client )
end)

net.Receive( "Buy_Perma_Playermodel", function( len, ply )
	if !(ply:CanAfford( 1500 )) then return end
	ply:AddMoney( -1500 )
	ply:SetPermaModel( tostring( GMNRP.Teams[1].model[tonumber(net.ReadString())] ) )
	ply:SendLua("GAMEMODE:AddNotify(\"Dein aussehen wurde erfolgreich gewechselt!\", NOTIFY_GENERIC, 10)")
end)