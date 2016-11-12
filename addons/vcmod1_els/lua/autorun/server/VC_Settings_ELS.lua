// Copyright © 2012-2015 VCMod (freemmaann). All Rights Reserved. if you have any complaints or ideas contact me: email - freemmaann@gmail.com or skype - comman6.

file.CreateDir("vcmod")

VC_Settings_Data_ELS = {
VC_Enabled = true,
VC_Enabled_ELS = true,

VC_Horn_Enabled = true,
VC_Horn_Volume = 1,

VC_ELS_Sounds = true,
VC_ELS_Volume = 1,
VC_ELS_SndOffExit = false,
VC_ELS_Off = true,
VC_ELS_OffIn = 60*2,
VC_ELS_Manual = true,
VC_ELS_BullHorn = true,

VC_ELS_Chatter = true,
VC_ELS_Chatter_Volume = 1,
VC_ELS_Chatter_Sel = 1,

VC_ELS_Lights = true,

VC_ELS_Vehicle_RedDamage = true,
VC_ELS_Vehicle_RedDamage_M = 0.5,

VC_ELS_LhtOffExit = false,
VC_ELS_Lht_Off = true,
VC_ELS_Lht_OffIn = 60*5,
}
if VC_Settings_Data then table.Merge(VC_Settings_Data_ELS, VC_Settings_Data) end VC_Settings = VC_Settings or {} VC_Settings_Data = VC_Settings_Data_ELS

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

concommand.Add("VC_ResetSettings_Sv", function(ply, cmd, arg) if ply:IsAdmin() then VC_ResetSettings_Sv() end end)
concommand.Add("VC_GetSettings_Sv", function(ply, cmd, arg) if ply:IsAdmin() then VC_GetSettings(ply) end end)
concommand.Add("VC_GetSettings_NPC_Sv", function(ply, cmd, arg) if ply:IsAdmin() then VC_GetSettings_NPC(ply) end end)

util.AddNetworkString("VC_SendSettingsToServer")
net.Receive("VC_SendSettingsToServer", function(len)
	local ply, Tbl = net.ReadEntity(), net.ReadTable()
	if ply:IsAdmin() then
	VC_Settings = Tbl CheckDefaults()
	file.Write("vcmod/settings_sv_VCMod1.txt", util.TableToJSON(Tbl))
	end
end)