
print("////////////////////////////////////////////")
print("//Loading Realistic Handcuffs System Files//")
print("// www.scriptfodder.com/scripts/view/2979 //")
print("//         Created by ToBadForYou         //")
print("////////////////////////////////////////////")
if SERVER then
	include("sh_rhandcuffs_config.lua")
	AddCSLuaFile("sh_rhandcuffs_config.lua")
	
	include("sv_rhandcuffs.lua")
	include("sh_rhandcuffs.lua")
	include("sv_rhandcuffs_npc.lua")
	
	AddCSLuaFile("sh_rhandcuffs.lua")
	AddCSLuaFile("cl_rhandcuffs_npc.lua")
elseif CLIENT then
	include("sh_rhandcuffs_config.lua")
	include("sh_rhandcuffs.lua")
	include("cl_rhandcuffs_npc.lua")
end