--[[---------------------------------------------------------
   File: shared.lua
   Desc: Gamemode definitions
-----------------------------------------------------------]]

GM.Name = "NOS RolePlay"
GM.Author = "ThaRealCamotrax"
GM.Email = "camotrax@web.de"
GM.Website = ""

PLAYER_META = FindMetaTable( "Player" )
ENTITY_META = FindMetaTable( "Entity" )

RP = RP or {}
RP.PLUGINS = RP.PLUGINS or {}

-- NPC Loading
local fol2 = GM.FolderName.."/gamemode/npc_panels/"
local files2, folders2 = file.Find(fol2 .. "*", "LUA")
for k,v in pairs(files2) do
    if SERVER then
        AddCSLuaFile( fol2 .. v )
    end
    if CLIENT then
        include(fol2 .. v)
    end
end

table.RemoveByKey = function( tbl, string )
    if !(tbl) then return tbl end
    if !(string) then return tbl end
    
    local cache = {}
    for name, value in pairs( tbl ) do
        if name == string then
            value = "TABLETODELETE"
            continue
        else
            cache[name] = value
        end
    end 
    return cache
end