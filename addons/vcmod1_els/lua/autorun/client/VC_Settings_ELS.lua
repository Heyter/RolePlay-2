// Copyright © 2012-2015 VCMod (freemmaann). All Rights Reserved. if you have any complaints or ideas contact me: email - freemmaann@gmail.com or skype - comman6.

file.CreateDir("vcmod")

VC_Settings_Data_ELS = {
VC_Enabled = true,

VC_HUD = true,
VC_HUD_3D = true,
VC_HUD_3D_Mult = 1,
VC_HUD_Height = 35,
VC_HUD_Health = true,
VC_HUD_ELS = true,
VC_HUD_ELS_Siren = true,

VC_Light_Main = true,
VC_Light_Main_M = 1,
VC_Light_HD = true,
VC_Light_HD_M = 1,
VC_Light_Glow = true,
VC_Light_Glow_M = 1,
VC_Light_Warm = true,
VC_Light_Warm_M = 1,
VC_Light_3D = true,
VC_LightDistance = 8000,

VC_DynamicLights = true,
VC_DynamicLights_OffDist = 1500,

VC_MouseControl = true,
VC_Keyboard_Input = true,
VC_Keyboard_Input_Hold = 0.2,

VC_ELS_Dyn_Enabled = true,
VC_ELS_Dyn_Mult = 1.5,
VC_ELS_Dyn_Interior = true,
VC_ELS_Dyn_Interior_M = 1,
VC_ELS_ExtraGlow = true,
VC_ELS_ExtraGlow_M = 1,
}
if VC_Settings_Data then table.Merge(VC_Settings_Data_ELS, VC_Settings_Data) end VC_Settings = VC_Settings or {} VC_Settings_Data = VC_Settings_Data_ELS

local function CheckDefaults() for k,v in pairs(VC_Settings_Data) do if VC_Settings[k] == nil then VC_Settings[k] = v end end end

function VC_ResetSettings_Cl() file.Write("vcmod/settings_cl_VCMod1.txt", util.TableToJSON(VC_Settings_Data)) VC_Settings = VC_Settings_Data CheckDefaults() end

function VC_LoadSettings() local Tbl = {} if file.Exists("vcmod/settings_cl_VCMod1.txt", "DATA") then Tbl = util.JSONToTable(file.Read("vcmod/settings_cl_VCMod1.txt", "DATA")) else Tbl = VC_Settings_Data end VC_Settings = table.Copy(Tbl) CheckDefaults() end

function VC_SaveSetting_Cl(k,v)
	if k and v != nil then
	local Tbl = {}
	if file.Exists("vcmod/settings_cl_VCMod1.txt", "DATA") then Tbl = util.JSONToTable(file.Read("vcmod/settings_cl_VCMod1.txt", "DATA")) else Tbl = VC_Settings_Data end
	Tbl[k] = v
	VC_Settings = Tbl CheckDefaults()
	file.Write("vcmod/settings_cl_VCMod1.txt", util.TableToJSON(Tbl))
	end
end

VC_LoadSettings()

concommand.Add("VC_SaveSetting_Cl", function(ply, cmd, arg) if arg and arg[1] and arg[2] then VC_SaveSetting_Cl(arg[1], arg[2]) end end)