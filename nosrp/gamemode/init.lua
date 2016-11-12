DeriveGamemode( "sandbox" )

--[[---------------------------------------------------------
   File: init.lua
   Desc: Initialized Gamemode; Sends Lua files to clients;
            Includes serverside Lua files; Sets NetworkStrings
-----------------------------------------------------------]]

--[[ NPC Stuff --]]
util.AddNetworkString( "NPC_DialogOpen" )
util.AddNetworkString( "NPC_CanTakeJob" )
util.AddNetworkString( "NPC_LeaveJob" )
util.AddNetworkString( "NPC_ClaimJobCar" )


-------------------- Send CS LUA FILES 
-- Generic
AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_hooks.lua")
AddCSLuaFile("sh_createteams.lua")
AddCSLuaFile("sh_pluginloader.lua")
AddCSLuaFile("config.lua")
AddCSLuaFile("color_config.lua")
-- Translation
--AddCSLuaFile("translations.lua")

-------------------- Include Server Side files

include("sv_database.lua")
include("shared.lua")
include("config.lua")
include("sh_createteams.lua")

include("server/chatcommands.lua")


include("sh_pluginloader.lua")      // Muss ganz unten sein!

--[[---------------------------------------------------------
   Name: GM:Initialize( )
   Desc: Initializes Gamemode, called by Garry's Mod.
            Connects to database, adds network strings
-----------------------------------------------------------]]
function GM:Initialize()
    InitializeDatabase()
    --Load_Plugins()
    
    timer.Simple( 2, function() 
        LoadDoors()
        SpawnNPCs()
		daylight:init( )
        --LoadOrganisations()
        --BUSSTOP.Load()
    end)

    -- Initialize Network Strings
    -- Client -> Server
    util.AddNetworkString("CSLoaded")
    -- Server -> Client
    util.AddNetworkString("SetCash")
    util.AddNetworkString("SetBank")
    util.AddNetworkString("TransmitEntities")
    util.AddNetworkString("SCShowRules")
    util.AddNetworkString("SCPlayerModels")
    util.AddNetworkString("SCShowHelp")
    util.AddNetworkString("SCShowInventory")
    util.AddNetworkString("SCChatMessage") -- byte Channel, Entity Player, String Message
    util.AddNetworkString("CSSendNPCS")
end

--[[---------------------------------------------------------
   Name: GM:PlayerInitialSpawn( )
   Desc: Initializes the Player, load his cash and stuff...
-----------------------------------------------------------]]
function GM:PlayerAuthed(Player)
    timer.Simple( 1, function()
        LoadPlayer( Player )
        Player:SetTeam( TEAM_CITIZEN )
        Player:UpdateRPVars( )
    end)
end


resource.AddFile( "resources/fonts/big_noodle_titling.ttf" )
