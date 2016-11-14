--[[---------------------------------------------------------
   File: cl_init.lua
   Desc: Include client side modules
-----------------------------------------------------------]]

--- Include Generic Stuff
include("shared.lua")
include("cl_hooks.lua")
include("config.lua")
include("color_config.lua")
include("sh_createteams.lua")
include("sh_pluginloader.lua")

/*---------------------------------------------------------
   Name: RPIsInSight( Entity )
   Desc: 
---------------------------------------------------------*/
function RPIsInSight(v)
	local trace = {}
	trace.start = LocalPlayer():EyePos()
	if v:IsPlayer() then 
		trace.endpos = v:EyePos() 
	elseif IsDoor( v ) then
		trace.endpos = v:LocalToWorld( v:OBBCenter() )
	else 
		trace.endpos = v:GetPos() 
	end
	trace.filter = {v, LocalPlayer()}
	trace.mask = -1
	local TheTrace = util.TraceLine(trace)
	if TheTrace.Hit then
		return false
	else
		return true
	end
end

function GM:SpawnMenuEnabled()
	return true
end

local act_spwn = CreateClientConVar( "spawnmenu_activated", "0", true, false ) 
function GM:SpawnMenuOpen()

	if LocalPlayer():IsSuperAdmin() then
		return true
	end
	return false
end

