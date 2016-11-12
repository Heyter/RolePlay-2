include( "shared.lua" )

include( "sv_data.lua" )
include( "sv_player.lua" )
include( "sv_statistics.lua" )

AddCSLuaFile( "shared.lua" )
AddCSLuaFile( "language.lua" )
AddCSLuaFile( "cl_player.lua" )
AddCSLuaFile( "containers.lua" )
AddCSLuaFile( "items.lua" )
AddCSLuaFile( "gamemodes.lua" )
AddCSLuaFile( "config.lua" )
AddCSLuaFile( "admin.lua" )
AddCSLuaFile( "trading.lua" )

AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "cl_gui.lua" )

AddCSLuaFile( "skins/" .. itemstore.config.Skin .. ".lua" )

for _, filename in ipairs( file.Find( "itemstore/vgui/*.lua", "LUA" ) ) do
	AddCSLuaFile( "itemstore/vgui/" .. filename )
end

if itemstore.config.AntiDupe then
	local meta = FindMetaTable( "Entity" )
	local oldRemove = meta.Remove

	function meta:Remove()
		self.__Deleted = true
		oldRemove( self )
	end
end

function itemstore.Print( pl, text )
	if IsValid( pl ) then
		pl:PrintMessage( HUD_PRINTCONSOLE, text )
	else
		print( text )
	end
end
