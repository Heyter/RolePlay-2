RP.Arrested_Players = RP.Arrested_Players or {}
RP.Cell_Positions = RP.Cell_Positions or {}

util.AddNetworkString( "Request_Arrest" )
util.AddNetworkString( "Open_ArrestPanel" )

function LoadCellPositions()
	RP.SQL:Query( "SELECT * FROM cell_positions WHERE map = %1%", {game.GetMap()}, function( q )
		if not q[1] then return end
		
		for k, v in pairs( q ) do
			table.insert( RP.Cell_Positions, { v.x, v.y, v.z } )
		end
	end )
end

function Arrest_AddCellPos( ply, cmd, args )
	if !(ply:IsSuperAdmin()) then return end
	
	table.insert( RP.Cell_Positions, ply:GetPos() )
	local x, y, z = ply:GetPos().x, ply:GetPos().y, ply:GetPos().z
	
	RP.SQL:Query( "INSERT INTO cell_positions(map, x, y, z) VALUES(%1%, %2%, %3%, %4%)", 
	{game.GetMap(), x, y, z}, function( d ) 
		ply:RPNotify( "Cell Position hinzugefügt!", 4 )
	end)
end
concommand.Add( "rp_addcell", Arrest_AddCellPos )

// Net code
net.Receive( "Request_Arrest", function( data, ply )
	if !(IsValid( ply ) or ply:IsPolice()) then return end
	local pl = net.ReadEntity()
	local time = net.ReadInt( 32 )
	local reason = net.ReadString()
	
	ply:Arrest( pl, time, reason )
end)

//


function PLAYER_META:Arrest( ply, time, reason, force )
	local cop = self
	force = force or false
	if !(IsValid( ply ) or IsValid( cop )) then return end
	if !(cop:IsPolice()) && force == false then return end
	if !( ply:Arrest_InRange() ) then cop:RPNotify( "Der Spieler ist nicht in der nähe!", 4 ) return end
	if time > SETTINGS.MaxArrestTime then cop:RPNotify( "Maximale Arrest-Zeit: " .. tostring( SETTINGS.MaxArrestTime ), 4 ) return end
	--if ply:IsArrested() then cop:RPNotify( "Der Spieler ist schon Verhaftet!", 4 ) return end

	local cell = Arrest_FindCell()
	if cell == nil then print( "Alle Zellen für das Arresten sind Belegt! Spieler wurde nicht arrested!" ) return end
	
	table.insert( RP.Arrested_Players, {
		ply = ply,
		arrester = cop,
		time = time,
		unarrest_time = CurTime() + time,
		reason = reason
	} )
	
	ply:RHCRestrain()
	ply:SetPos( Vector( cell[1], cell[2], cell[3] ) )
	
	ply:StripWeapons()
	ply:SetNWBool( "arrested", true )
	ply:SetNWInt( "unarrest_time", CurTime() + time )
	
	timer.Simple( 0.2, function() ply:RHCRestrain() end )
	
	if GetMayor() != nil then
		GetMayor():RPNotify( (GetMayor():GetRPVar( "rpname") or "Unknown") .. " wurde Gefangen genommen. Grund: " .. reason, 10 )
		ECONOMY.AddToLog( {cop,ply,reason}, "arrest" )
	end
end

function PLAYER_META:UnArrest( ply )
	local info = {}
	for k, v in pairs( RP.Arrested_Players ) do		// Remove him and clean the table
		if v.ply != ply then continue end
		info = v
		table.remove( RP.Arrested_Players, k )
	end
	
	if ply:GetNWBool( "rhc_cuffed" ) then ply:RHCRestrain() end
	ply:SetNWBool( "arrested", false )
	ply:Spawn()
	
	ply:RPNotify( "Du hast deine Strafe abgesessen. Du bist wieder Frei", 10 )
end
hook.Add( "PlayerDeath", "RP_Arrest_Death", function( ply ) ply:UnArrest( ply ) end )

function PLAYER_META:Arrest_InRange()
	local found = false
	if !(IsValid( self )) then return false end
	
	for k, v in pairs( ents.FindByClass( "npc_ventor") ) do
		if v:GetPos():Distance( self:GetPos() ) <= SETTINGS.ArrestRange then found = true end
	end
	
	return found
end

function Arrest_FindCell()
	for k, v in pairs( RP.Cell_Positions ) do
		local ent = ents.FindInSphere( Vector( v.x, v.y, v.z ), 50 )
		local found_cell = false
		
		for i = 0, table.Count( ent ) do
			if !(IsValid(ent[i])) then continue end
			found_cell = true
			break
		end
		
		if found_cell then 
			return v 
		else
			return nil
		end
	end
end

hook.Add( "Think", "JailTimer_Think", function()
	for k, v in pairs( RP.Arrested_Players ) do
		if !(IsValid( v.ply )) then 
			table.remove( RP.Arrested_Players, k ) 
			continue 
		end
		
		if CurTime() > v.unarrest_time then
			v.ply:UnArrest( v.ply )
			table.remove( RP.Arrested_Players, k )
			continue
		end
	end
end)

function PLAYER_META:IsArrested()
	return self:GetNWBool( "arrested" )
end