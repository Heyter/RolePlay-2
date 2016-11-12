//////////////////////////////////////
//     	  GExtension (c) 2016       //
//                                  //
//  Created by Jakob 'ibot3' Müller //
//                                  //
//  You are not permitted to share, //
//   	 trade, give away, sell     //
//      or otherwise distribute     //
//////////////////////////////////////

GExtension = GExtension or {}
GExtension.Groups = GExtension.Groups or {}
GExtension.Players = GExtension.Players or {}
GExtension.Settings = GExtension.Settings or {}
GExtension.Language = GExtension.Language or {}
GExtension.Statistics = GExtension.Statistics or {}
GExtension.Rewards = GExtension.Rewards or {}
GExtension.Warnings = GExtension.Warnings or {}
GExtension.Colors = GExtension.Colors or {}
GExtension.BoughtPackages = GExtension.BoughtPackages or {}
GExtension.Donations = GExtension.Donations or {}
GExtension.ConnectMessage = GExtension.ConnectMessage or {}
GExtension.ChatCommands = GExtension.ChatCommands or {}
GExtension.Tickets = GExtension.Tickets or {}
GExtension.ReservedSlotPlayers = GExtension.ReservedSlotPlayers or {}
GExtension.SpecPropPlayers = GExtension.SpecPropPlayers or {}
GExtension.Adverts = GExtension.Adverts or {}
GExtension.ConnectQueue = GExtension.ConnectQueue or {}

GExtension.Initialized = false
GExtension.TimeOffset = ""

local luaroot = "gextension"

meta_ply = FindMetaTable("Player")

if SERVER then
	MsgN("[GExtension] Initializing...")

	--Config Files
	MsgN("[GExtension] Loading config files...")
	include( luaroot .. "/config/sv_config.lua" )
	AddCSLuaFile( luaroot .. "/config/sh_config.lua" )
	include( luaroot .. "/config/sh_config.lua" )

	--Language Files
	MsgN("[GExtension] Loading language files...")
	local files = file.Find( luaroot .."/language/*.lua", "LUA" )
	for _, file in ipairs( files ) do
		AddCSLuaFile( luaroot .. "/language/" .. file )
	end

	--Client Files
	MsgN("[GExtension] Loading client files...")
	local files = file.Find( luaroot .."/client/*.lua", "LUA" )
	for _, file in ipairs( files ) do
		AddCSLuaFile( luaroot .. "/client/" .. file )
	end

	--Shared Files
	MsgN("[GExtension] Loading shared files...")
	local files = file.Find( luaroot .."/shared/*.lua", "LUA" )
	for _, file in ipairs( files ) do
		AddCSLuaFile( luaroot .. "/shared/" .. file )
		include( luaroot .. "/shared/" .. file )
	end

	--Server Files
	MsgN("[GExtension] Loading server files...")
	local files = file.Find( luaroot .."/server/*.lua", "LUA" )
	for _, file in ipairs( files ) do
		include( luaroot .. "/server/" .. file )
	end

	MsgN("[GExtension] Finished loading!")

	hook.Run("GExtensionLoaded")
end

if CLIENT then
	MsgN("[GExtension] Initializing...")

	include( luaroot .. "/config/sh_config.lua" )

	--Client Files
	MsgN("[GExtension] Loading client files...")
	local files = file.Find( luaroot .."/client/*.lua", "LUA" )
	for _, file in ipairs( files ) do
		include( luaroot .."/client/" .. file )
	end

	--Shared Files
	MsgN("[GExtension] Loading shared files...")
	local files = file.Find( luaroot .."/shared/*.lua", "LUA" )
	for _, file in ipairs( files ) do
		include( luaroot .. "/shared/" .. file )
	end

	MsgN("[GExtension] Finished loading!")
end