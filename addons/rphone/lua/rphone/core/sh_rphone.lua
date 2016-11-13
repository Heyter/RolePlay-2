
rPhone = {}

rPhone.MajorVersion = 1
rPhone.MinorVersion = 4
rPhone.Revision = 3

rPhone.Version = ([[%u.%u.%u]]):format( rPhone.MajorVersion, rPhone.MinorVersion, rPhone.Revision )
rPhone.APIVersion = bit.lshift( rPhone.MajorVersion, 8 ) + rPhone.MinorVersion
rPhone.VersionNumber = bit.lshift( rPhone.APIVersion, 8 ) + rPhone.Revision


local variables = {}
local events = {}


function rPhone.SetVariable( name, value )
	variables[name] = value
end

function rPhone.GetVariable( name, default )
	if variables[name] != nil then
		return variables[name]
	end

	return default
end

function rPhone.SetServerVariable( name, value )
	if SERVER then
		rPhone.SetVariable( name, value )
	end
end
rPhone.SVSetVariable = rPhone.SetServerVariable

function rPhone.SetClientVariable( name, value )
	if CLIENT then
		rPhone.SetVariable( name, value )
	end
end
rPhone.CLSetVariable = rPhone.SetClientVariable


function rPhone.RegisterEventCallback( event, ident, callback )
	events[event] = events[event] or {}

	if !callback then
		callback = ident
		ident = #events[event] + 1
	else
		rPhone.Assert( type( ident ) == "string", "Invalid callback identifier." )
	end

	events[event][ident] = callback
end

function rPhone.UnregisterEventCallback( event, ident )
	rPhone.Assert( type( ident ) == "string", "Invalid callback identifier." )

	events[event] = events[event] or {}
	events[event][ident] = nil
end

function rPhone.TriggerEvent( event, ... )
	if !events[event] then return end

	for _, cb in pairs( events[event] ) do
		cb( ... )
	end
end

function rPhone.TriggerEventForResult( event, ... )
	if !events[event] then return end

	for _, cb in pairs( events[event] ) do
		local results = { cb( ... ) }

		if #results > 0 then 
			return unpack( results )
		end
	end
end


function rPhone.ServerInclude( sf )
	if SERVER then
		include( sf )
	end
end

function rPhone.ClientInclude( cf )
	if SERVER then
		AddCSLuaFile( cf )
	else
		include( cf )
	end
end

function rPhone.SharedInclude( shf )
	if SERVER then
		AddCSLuaFile( shf )
	end

	include( shf )
end


function rPhone.Error( msg, nohalt, noprefix, level )
	local func = nohalt and ErrorNoHalt or error
	msg = (noprefix and '' or "rPhone: ") .. msg .. '\n'
	level = level or 2

	func( msg, level )
end

function rPhone.Assert( cond, msg )
	if !cond then
		rPhone.Error( msg, false, false, 3 )
	end
end

do
	local wtm = {
		k = { __mode = 'k' },
		v = { __mode = 'v' },
		kv = { __mode = 'kv' }
	}
	wtm.vk = wtm.kv

	function rPhone.NewWeakTable( mode )
		local mt = wtm[mode] or rPhone.Error(
			"Invalid weak table mode."
		)

		return setmetatable( {}, mt )
	end
end

function rPhone.SortedPairsFunc( tbl, func )
	local kvtbl = {}

	for k, v in pairs( tbl ) do
		table.insert( kvtbl, { k, v } )
	end

	table.sort( kvtbl, function( kvp1, kvp2 )
		return func( kvp1[1], kvp1[2], kvp2[1], kvp2[2] )
	end )

	local cnt = #kvtbl
	local i = 0

	local prox = newproxy( true )
	local proxmt = getmetatable( prox )
	proxmt.__call = function()
		i = i + 1

		local kvp = kvtbl[i]

		if kvp then
			return kvp[1], kvp[2], i
		end
	end
	proxmt.__len = function()
		return cnt
	end

	return prox
end

function rPhone.ToGarrySafePath( ... )
	return table.concat( { ... }, '/' ):gsub( [[/+]], '/' )
end

function rPhone.AssurePath( path )
	path = rPhone.ToGarrySafePath( path:GetPathFromFilename() )

	if !file.Exists( path, "DATA" ) then
		file.CreateDir( path )
	end
end

function rPhone.FileWrite( fpath, content, bin )
	rPhone.AssurePath( fpath )

	local mode = bin and "wb" or 'w'
	local fhdl = file.Open( fpath, mode, "DATA" )

	if fhdl then
		fhdl:Write( content )
		fhdl:Close()
	end
end

function rPhone.FileRead( fpath, bin, path )
	path = path or "DATA"
	
	local mode = bin and "rb" or 'r'
	local fhdl = file.Open( fpath, mode, path )
	local str

	if fhdl then
		str = fhdl:Read( fhdl:Size() )

		fhdl:Close()
	end

	return str
end
