
local ContentWorkshopID = "237428507"


if SERVER then
	AddCSLuaFile()

	AddCSLuaFile( "rphone/core/sh_rphone.lua" )
end

include( "rphone/core/sh_rphone.lua" )


rPhone.SharedInclude( "rphone/core/sh_config.lua" )

rPhone.SharedInclude( "rphone/core/sh_numbers.lua" )
rPhone.SharedInclude( "rphone/core/sh_tones.lua" )
rPhone.ServerInclude( "rphone/core/sh_libs.lua" )

rPhone.ServerInclude( "rphone/core/server/sv_numbers.lua" )
rPhone.ServerInclude( "rphone/core/server/sv_tones.lua" )

rPhone.ClientInclude( "rphone/core/client/cl_numbers.lua" )
rPhone.ClientInclude( "rphone/core/client/cl_packages.lua" )
rPhone.ClientInclude( "rphone/core/client/cl_apps.lua" )
rPhone.ClientInclude( "rphone/core/client/cl_canvas.lua" )
rPhone.ClientInclude( "rphone/core/client/cl_panel.lua" )
rPhone.ClientInclude( "rphone/core/client/cl_rphone.lua" )
rPhone.ClientInclude( "rphone/core/client/cl_tones.lua" )


local bundlesdir = "rphone/bundles/"
local _, bundles = file.Find( rPhone.ToGarrySafePath( bundlesdir, "/*" ), "LUA" )

for _, bundle in pairs( bundles ) do
	local binit = rPhone.ToGarrySafePath( bundlesdir, bundle, "sh_init.lua" )

	if file.Exists( binit, "LUA" ) then
		rPhone.SharedInclude( binit )
	end
end


if !SERVER then return end

if rPhone.GetVariable( "RPHONE_DOWNLOAD_CONTENT_WORKSHOP", true ) then
	resource.AddWorkshop( ContentWorkshopID )
else
	local function addResourceDirectory( dir )
		local resources, rdirs = file.Find( rPhone.ToGarrySafePath( dir, "/*" ), "GAME" )

		for _, rs in pairs( resources ) do
			resource.AddFile( rPhone.ToGarrySafePath( dir, rs ) )
		end

		for _, rdir in pairs( rdirs ) do
			addResourceDirectory( rPhone.ToGarrySafePath( dir, rdir ) )
		end
	end

	addResourceDirectory( "materials/dan/rphone/" )
	addResourceDirectory( "sound/dan/rphone/" )
end
