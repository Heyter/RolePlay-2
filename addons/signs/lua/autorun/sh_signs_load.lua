
include( "signs/sh_signs.lua" )
include( "signs/sh_config.lua" )
include( "signs/sh_addents.lua" )

if SERVER then
	AddCSLuaFile()

	AddCSLuaFile( "signs/sh_signs.lua" )
	AddCSLuaFile( "signs/sh_config.lua" )
	AddCSLuaFile( "signs/sh_addents.lua" )

	AddCSLuaFile( "signs/client/cl_signs.lua" )

	include( "signs/server/sv_signs.lua" )

	local function addResources( dir )
		for _, res in pairs( file.Find( dir .. "/*", "GAME" ) ) do
			resource.AddFile( dir .. "/" .. res )
		end
	end

	addResources( "resource/fonts" )
else
	include( "signs/client/cl_signs.lua" )
end