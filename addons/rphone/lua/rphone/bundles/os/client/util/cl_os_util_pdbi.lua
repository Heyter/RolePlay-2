
local PDB_SaveLocation = "rphone/package_db/"


local OS = rPhone.AssertPackage( "os" )
local Util = OS.Util

local guid
local pdbi_instances = {}
local pdbi_data = rPhone.NewWeakTable( 'k' )

local serializeTable, deserializeTable

net.Receive( "rphone_os_util_db_sendguid", function( len )
	guid = net.ReadString()

	OS.SetDependancyPrepared( "os_util_db" )
end )



OS.AddDependancy( "os_util_db" )

do
	local serializeValue, deserializeValue
	local toKVTypeTable, fromKVTypeTable

	function serializeValue( val, types )
		local vt = type( val )

		if !types[vt] then return end

		if vt == "number" then
			val = tostring( val )
		elseif vt == "boolean" then
			val = val and '1' or '0'
		elseif vt == "table" then
			val = toKVTypeTable( val, types )
		elseif vt != "string" then
			return
		end

		return types[vt], val
	end

	function deserializeValue( vi, val, types )
		if !types[vi] then return end

		local tname = types[vi]

		if tname == "string" then
			return val
		elseif tname == "number" then
			return tonumber( val )
		elseif tname == "boolean" then
			return (val == '1') and true or false
		elseif tname == "table" then
			return fromKVTypeTable( val, types )
		end
	end

	function toKVTypeTable( tbl, types )
		local ret = {}

		for k, v in pairs( tbl ) do
			local tk, sk = serializeValue( k, types )
			local tv, sv = serializeValue( v, types )

			if sk != nil and sv != nil then
				table.insert( ret, { tk, sk, tv, sv } )
			end
		end

		return ret
	end

	function fromKVTypeTable( tbl, types )
		local ret = {}

		for _, kvp in pairs( tbl ) do
			local key = deserializeValue( kvp[1], kvp[2], types )
			local val = deserializeValue( kvp[3], kvp[4], types )

			if key != nil and val != nil then
				ret[key] = val
			end
		end

		return ret
	end

	function serializeTable( data )
		local tbl = { types = {
			string = '0',
			number = '1',
			boolean = '2',
			table = '3'
		} }

		tbl.data = toKVTypeTable( data, tbl.types )

		return util.TableToJSON( tbl )
	end

	function deserializeTable( str )
		local tbl = util.JSONToTable( str )
		local types = {}

		for k, v in pairs( tbl.types or {} ) do
			types[v] = k
		end

		return fromKVTypeTable( tbl.data, types )
	end
end



local PDBI = {}
PDBI.__index = function( self, k ) return PDBI[k] or self:GetData()[k] end
PDBI.__newindex = function( self, k, v ) self:GetData()[k] = v end

function PDBI:GetData()
	local idata = pdbi_data[self]

	if idata then return idata.data end
end

function PDBI:Load()
	local idata = pdbi_data[self]

	if !idata then return end

	local packhash = util.CRC( idata.packagename )
	local str = util.Decompress( rPhone.FileRead( 
		([[%s/%s/%s.txt]]):format( PDB_SaveLocation, idata.shared and "shared" or guid, packhash ), 
		true 
	) or '' )
	local data

	if str and str != '' then
		data = deserializeTable( str )
	end

	idata.data = data or {}
end

function PDBI:Commit()
	local idata = pdbi_data[self]

	if !idata then return end

	local packhash = util.CRC( idata.packagename )
	local raw = util.Compress( serializeTable( idata.data ) or '' )

	rPhone.FileWrite( 
		([[%s/%s/%s.txt]]):format( PDB_SaveLocation, idata.shared and "shared" or guid, packhash ),
		raw, 
		true
	)
end



function Util.CreatePDBI( pname, shared )
	if pdbi_instances[pname] then return pdbi_instances[pname] end

	local idata = {
		packagename = pname,
		data = {},
		shared = shared
	}
	local inst = setmetatable( {}, PDBI )

	pdbi_instances[pname] = inst
	pdbi_data[inst] = idata

	inst:Load()

	return inst
end
