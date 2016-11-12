// Copyright © 2012-2015 VCMod (freemmaann). All Rights Reserved. if you have any complaints or ideas contact me: email - freemmaann@gmail.com or skype - comman6.

file.CreateDir("vcmod")

VC_Settings_Data = {
VC_Enabled = true,

VC_Wheel_Lock = true,
VC_Brake_Lock = true,
VC_Door_Sounds = true,
VC_Truck_BackUp_Sounds = true,
VC_Wheel_Dust = true,
VC_Wheel_Dust_Brakes = true,
VC_Exit_Velocity = true,
VC_Exit_NoCollision = true,
VC_Exhaust_Effect = true,
VC_Passenger_Seats = true,

VC_RepairTool_Speed_M = 1,

VC_Lights = true,
VC_Lights_Night = true,
VC_Lights_HandBrake = false,
VC_Lights_Interior = true,
VC_Lights_Blinker_OffOnExit = false,
VC_HeadLights = true,
VC_LightsOffTime = 300,
VC_HLightsOffTime = 30,
VC_HLights_Dist_M = 0.5,

VC_Cruise_Enabled = true,
VC_Cruise_OffOnExit = true,

VC_Horn_Volume = 1,
VC_Horn_Enabled = true,

VC_NPC_AutoSpawn = true,
VC_NPC_RefundPrice = 75,
VC_NPC_Remove = true,
VC_NPC_Remove_Time = 1000,

VC_Trl_Enabled = true,
VC_Trl_Dist = 200,
VC_Trl_Mult = 1,
VC_Trl_Enabled_Reg = true,

VC_Damage = true,
VC_PhysicalDamage = true,
VC_PhysicalDamage_Mult = 1,
VC_Dmg_Fire_Duration = 30,
VC_Health_Multiplier = 1,
VC_Damage_Expl_Rem = true,
VC_Damage_Expl_Rem_Time = 400,

VC_Reduce_Ply_Dmg_InVeh = true,
VC_Reduce_Ply_Dmg_InVeh_Mult = 0.3,
}
if !VC_Settings_Data then VC_Settings_Data = {} end if VC_Settings_Data_ELS then table.Merge(VC_Settings_Data, VC_Settings_Data_ELS) end VC_Settings = VC_Settings or {}

local function CheckDefaults() for k,v in pairs(VC_Settings_Data) do if VC_Settings[k] == nil then VC_Settings[k] = v end end end

function VC_ResetSettings_Sv() file.Write("vcmod/settings_sv_VCMod1.txt", util.TableToJSON(VC_Settings_Data)) VC_Settings = VC_Settings_Data CheckDefaults() end

function VC_LoadSettings() local Tbl = {} if file.Exists("vcmod/settings_sv_VCMod1.txt", "DATA") then Tbl = util.JSONToTable(file.Read("vcmod/settings_sv_VCMod1.txt", "DATA")) else Tbl = VC_Settings_Data end VC_Settings = table.Copy(Tbl) CheckDefaults() end

function VC_SaveSetting_Sv(k,v)
	if k and v != nil then
	local Tbl = {}
	if file.Exists("vcmod/settings_sv_VCMod1.txt", "DATA") then Tbl = util.JSONToTable(file.Read("vcmod/settings_sv_VCMod1.txt", "DATA")) else Tbl = VC_Settings_Data end
	Tbl[k] = v
	VC_Settings = Tbl CheckDefaults()
	file.Write("vcmod/settings_sv_VCMod1.txt", util.TableToJSON(Tbl))
	end
end

util.AddNetworkString("VC_SendToClient_Options")
function VC_GetSettings(ply) net.Start("VC_SendToClient_Options") net.WriteTable(VC_Settings) if ply then net.Send(ply) else net.Broadcast() end end

VC_LoadSettings()

local Tbl = {
	["blah"] = {name = "miau", price = 500, VIP = true}
}

util.AddNetworkString("VC_SendToClient_Options_NPC")
function VC_GetSettings_NPC(ply) net.Start("VC_SendToClient_Options_NPC") net.WriteTable(Tbl) if ply then net.Send(ply) else net.Broadcast() end end

concommand.Add("VC_ResetSettings_Sv", function(ply, cmd, arg) if VC_CanEditAdminSettings(ply) then VC_ResetSettings_Sv() end end)
concommand.Add("VC_GetSettings_Sv", function(ply, cmd, arg) if VC_CanEditAdminSettings(ply) then VC_GetSettings(ply) end end)
concommand.Add("VC_GetSettings_NPC_Sv", function(ply, cmd, arg) if VC_CanEditAdminSettings(ply) then VC_GetSettings_NPC(ply) end end)

util.AddNetworkString("VC_SendSettingsToServer")
net.Receive("VC_SendSettingsToServer", function(len)
	local ply, Tbl = net.ReadEntity(), net.ReadTable()
	if VC_CanEditAdminSettings(ply) then
	VC_Settings = Tbl CheckDefaults()
	file.Write("vcmod/settings_sv_VCMod1.txt", util.TableToJSON(Tbl))
	end
end)