// Copyright © 2012-2015 VCMod (freemmaann). All Rights Reserved. if you have any complaints or ideas contact me: email - freemmaann@gmail.com or skype - comman6.

if !VC_Lng_T then VC_Lng_T = {} end

function VC_Lng(msg)
	local RM = nil
	if VC_Lng_Sel and VC_Lng_T[VC_Lng_Sel] and VC_Lng_T[VC_Lng_Sel] and VC_Lng_T[VC_Lng_Sel][msg] then RM = VC_Lng_T[VC_Lng_Sel][msg] else RM = VC_Lng_T["EN"][msg] end
	return RM or msg
end

function VC_Lng_Save(lng)
	file.CreateDir("vcmod")
	local Settings = {}
	if file.Exists("vcmod/settings_cl_other.txt", "DATA") then Settings = util.JSONToTable(file.Read("Data/vcmod/settings_cl_other.txt", "GAME")) end
	Settings.Language = lng VC_Lng_Sel = lng
	file.Write("vcmod/settings_cl_other.txt", util.TableToJSON(Settings))
end

function VC_Lng_Pick()
	local sysLng = system.GetCountry()
	if VC_Lng_T[sysLng] then
	VCMsg("player location detected, setting language to "..sysLng..".")
	VC_Lng_Save(sysLng)
	else
	VC_Lng_Sel = nil
	end
end
function VC_Lng_Get() local Settings = {} if file.Exists("vcmod/settings_cl_other.txt", "DATA") then Settings = util.JSONToTable(file.Read("Data/vcmod/settings_cl_other.txt", "GAME")) end if Settings.Language and VC_Lng_T[Settings.Language] then VC_Lng_Sel = Settings.Language else if !Settings.Language then VC_Lng_Pick() else VC_Lng_Sel = nil end end end VC_Lng_Get()