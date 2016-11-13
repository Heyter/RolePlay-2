
util.AddNetworkString( "rphone_numbers_send" )

local sqlstr = sql.SQLStr
local reserved = {}

local function sendNumber( ply )
	if !IsValid( ply ) then return end
	
	local num = rPhone.GetNumber( ply )

	net.Start( "rphone_numbers_send" )
		net.WriteString( num )
	net.Send( ply )
end

local function generateNumber()
	local len = rPhone.GetDefaultNumberLength()
	local num = ""

	for i=1, len do
		num = num .. math.random( (i == 1) and 1 or 0, 9 )
	end

	return num
end

hook.Add( "Initialize", "sv_numbers_checkdb", function()
	if !sql.TableExists( "rphone_numbers" ) then
		sql.Query( [[
			CREATE TABLE rphone_numbers (
				steamid TEXT PRIMARY KEY NOT NULL,
				number TEXT
			)
		]] )
	end
end )

hook.Add( "PlayerInitialSpawn", "sv_numbers_sendnumber", sendNumber )



function rPhone.SetNumber( ply, num )
	if !rPhone.IsValidNumber( num ) or !rPhone.IsNumberUnused( num ) then return false end

	local steamid = sqlstr( (type( ply ) == "string") and ply or ply:SteamID() )
	local safenum = sqlstr( num )

	local result = sql.QueryRow( 
		([[SELECT * FROM rphone_numbers WHERE steamid=%s]]):format(	steamid )
	)

	local qstr

	if !result then
		qstr = ([[INSERT INTO rphone_numbers VALUES (%s, %s)]]):format(
			steamid,
			safenum
		)
	else
		qstr = ([[UPDATE rphone_numbers SET number=%s WHERE steamid=%s]]):format(
			safenum,
			steamid
		)
	end

	sql.Query( qstr )

	if type( ply ) == "string" then
		for _, pl in pairs( player.GetAll() ) do
			if pl:SteamID() == ply then
				ply = pl

				break
			end
		end
	end

	if type( ply ) != "string" and IsValid( ply ) then
		sendNumber( ply )
	end

	return true
end

function rPhone.GetNumber( ply )
	local steamid = sqlstr( (type( ply ) == "string") and ply or ply:SteamID() )

	local result = sql.QueryRow( 
		([[SELECT * FROM rphone_numbers WHERE steamid=%s]]):format(	steamid )
	)

	local num = (result or {}).number

	if !num then
		num = rPhone.FindUnusedNumber()

		rPhone.SetNumber( ply, num )
	end

	return num
end

function rPhone.GetSteamIDFromNumber( num )
	if !rPhone.IsValidNumber( num ) then return end

	local result = sql.QueryRow(
		([[SELECT * FROM rphone_numbers WHERE number=%s]]):format( sqlstr( num ) )
	)

	if result then
		return result.steamid
	end
end

function rPhone.ReleaseNumber( num )
	if !rPhone.IsValidNumber( num ) then return end

	sql.Query(
		([[DELETE FROM rphone_numbers WHERE numer=%s]]):format( sqlstr( num ) )
	)
end

function rPhone.IsNumberUnused( num )
	return !rPhone.IsNumberReserved( num ) and !rPhone.GetSteamIDFromNumber( num )
end

function rPhone.FindUnusedNumber()
	local num

	repeat
		num = generateNumber()
	until rPhone.IsNumberUnused( num )

	return num
end

function rPhone.ReserveNumber( num )
	if !rPhone.IsValidNumber( num ) then return end

	rPhone.ReleaseNumber( num )

	reserved[num] = true
end

function rPhone.UnreserveNumber( num )
	if !rPhone.IsValidNumber( num ) then return end

	reserved[num] = nil
end

function rPhone.IsNumberReserved( num )
	return reserved[num] == true
end
