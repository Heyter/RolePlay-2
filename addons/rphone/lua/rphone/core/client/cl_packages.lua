
local packages = {}

local PACK = {}
PACK.__index = PACK
PACK.__newindex = function( self, k, v )
	if k != "PackageName" then
		rawset( self, k, v )
	end
end



function rPhone.CreatePackage( pname )
	local pack = rPhone.GetPackage( pname ) or setmetatable( { PackageName = pname }, PACK )

	packages[pname] = pack

	return pack
end

function rPhone.GetPackage( pname )
	return packages[pname]
end

function rPhone.GetPackages()
	local ret = {}

	for pname, pack in pairs( packages ) do
		ret[pname] = pack
	end

	return ret
end

function rPhone.AssertPackage( pname )
	return rPhone.GetPackage( pname ) or rPhone.Error( 
		([[Attempted to retrieve missing package '%s'.]]):format( pname ), 
		false, false, 
		3
	)
end
