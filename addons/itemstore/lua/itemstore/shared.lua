itemstore.Version = "3.0b"
itemstore.About = string.format( [[ItemStore v%s

Authored solely by Olivia (UselessGhost)
http://steamcommunity.com/id/uselessghost
]], itemstore.Version )

MsgC( Color( 255, 150, 150 ), "================================" .. string.rep( "=", #itemstore.Version ) .. "\n" )
MsgC( Color( 255, 255, 255 ), string.format( "          ItemStore %s          \n", itemstore.Version ) )
MsgC( Color( 255, 255, 255 ), string.rep( " ", #itemstore.Version / 2 ) .. " Coded by UselessGhost (Olivia)\n" )
MsgC( Color( 255, 150, 150 ), "================================" .. string.rep( "=", #itemstore.Version ) .. "\n" )

concommand.Add( "itemstore_about", function()
	MsgC( color_white, itemstore.About )
end )

itemstore.config = {}

function itemstore.config.Verify( setting, correct_type )
	if type( itemstore.config[ setting ] ) ~= correct_type then
		ErrorNoHalt( string.format( "[ItemStore] Configuration error: %s is %s, should be %s.", setting, var_type, proper_type ) )
		include( "config_default.lua" )

		return false
	end

	return true
end

include( "config.lua" )

itemstore.config.Verify( "MaxStack", "number" )
itemstore.config.Verify( "DataProvider", "string" )
itemstore.config.Verify( "GamemodeProvider", "string" )
itemstore.config.Verify( "Language", "string" )
itemstore.config.Verify( "ContextInventory", "boolean" )
itemstore.config.Verify( "ContextInventoryPosition", "string" )
itemstore.config.Verify( "InvholsterTakesAmmo", "boolean" )
itemstore.config.Verify( "PickupsGotoBank", "boolean" )
itemstore.config.Verify( "AntiDupe", "boolean" )
itemstore.config.Verify( "InventorySizes", "table" )
itemstore.config.Verify( "BankSizes", "table" )
itemstore.config.Verify( "PickupDistance", "number" )
itemstore.config.Verify( "PickupKey", "number" )
itemstore.config.Verify( "Colours", "table" )
itemstore.config.Verify( "DisabledItems", "table" )
itemstore.config.Verify( "CustomItems", "table" )
itemstore.config.Verify( "IgnoreOwner", "boolean" )
itemstore.config.Verify( "Skin", "string" )

include( "language.lua" )
include( "gamemodes.lua" )
include( "items.lua" )
include( "containers.lua" )
include( "trading.lua" )
include( "admin.lua" )

local _, dirs = file.Find( "itemstore/modules/*", "LUA" )
for _, mod in ipairs( dirs ) do
	MsgC( color_white, string.format( "Loading ItemStore module: %s\n", mod ) )

	local path = "itemstore/modules/" .. mod

	for _, filename in ipairs( file.Find( path .. "/*.lua", "LUA" ) ) do
		if not string.match( filename, "^sv_.+%.lua$" ) then
			AddCSLuaFile( path .. "/" .. filename )
		end
	end

	local sv_init = path .. "/sv_init.lua"
	local cl_init = path .. "/cl_init.lua"
	local shared = path .. "/shared.lua"

	if file.Exists( shared, "LUA" ) then
		include( shared )
	end

	if SERVER and file.Exists( sv_init, "LUA" ) then
		include( sv_init )
	end

	if CLIENT and file.Exists( cl_init, "LUA" ) then
		include( cl_init )
	end
end
