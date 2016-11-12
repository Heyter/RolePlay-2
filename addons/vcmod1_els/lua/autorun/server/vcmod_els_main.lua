// Copyright © 2012-2015 VCMod (freemmaann). All Rights Reserved. if you have any complaints or ideas contact me: email - freemmaann@gmail.com or skype - comman6.

VCMod1_ELS = 1.123 vcmod1_els = VCMod1_ELS

file.CreateDir("vcmod")

AddCSLuaFile("autorun/client/vcmod_els_main_client.lua")
AddCSLuaFile("autorun/client/VC_Data_HUD_ELS.lua")
AddCSLuaFile("autorun/client/VC_Data_Menu_ELS.lua")
AddCSLuaFile("autorun/client/VC_Data_GUI.lua")
AddCSLuaFile("autorun/client/VC_Settings_ELS.lua")
AddCSLuaFile("autorun/client/VC_HUD.lua")
AddCSLuaFile("autorun/client/VC_HUD_PDTR.lua")

AddCSLuaFile("autorun/VC_Shared.lua")

AddCSLuaFile("autorun/vc_cdownload_els.lua")

if !VC_SyncTable then VC_SyncTable = {} end

util.AddNetworkString("VC_SendToClient_Siren_Seq") function VC_SendToClient_Siren_Seq(mdl, tbl, ply) net.Start("VC_SendToClient_Siren_Seq") net.WriteString(mdl) net.WriteTable(tbl) if ply then net.Send(ply) else net.Broadcast() end end
util.AddNetworkString("VC_SendToClient_Siren_Rest") function VC_SendToClient_Siren_Rest(mdl, tbl, ply) net.Start("VC_SendToClient_Siren_Rest") net.WriteString(mdl) net.WriteTable(tbl) if ply then net.Send(ply) else net.Broadcast() end end
util.AddNetworkString("VC_SendToClient_ClearSiren") function VC_SendToClient_ClearSiren(ent) net.Start("VC_SendToClient_ClearSiren") net.WriteEntity(ent) net.Broadcast() end
util.AddNetworkString("VC_SendToClient_Srn_Lht_Sel") function VC_SendToClient_Srn_Lht_Sel(ent, code, nocodes, ply) net.Start("VC_SendToClient_Srn_Lht_Sel") net.WriteEntity(ent) net.WriteInt(code, 32) net.WriteInt(nocodes and 1 or 0, 32) if ply then net.Send(ply) else net.Broadcast() end end

function VC_SendToClient_Siren(mdl, tbl, ply) if tbl then local ST = table.Copy(tbl) ST.Sequences = nil VC_SendToClient_Siren_Rest(mdl, ST, ply) if tbl.Sequences then VC_SendToClient_Siren_Seq(mdl, tbl.Sequences, ply) end end end

function VC_VectorToWorld(ent, vec) if !vec then vec = Vector(0,0,0) end return ent:LocalToWorld(vec) end

local function EmitSoundTS(ent, snd, pch, lvl) ent:EmitSound(snd, lvl or 60, math.Clamp(pch or 100,1,255)) end
local function VecAboveWtr(vec) local WTV = util.PointContents(vec) return WTV != 268435488 and WTV != 32 end
local function EnginePos(veh) local EPos = false if veh.VehicleTable and veh.VehicleTable.VC_EnginePos then EPos = VC_VectorToWorld(veh, veh.VehicleTable.VC_EnginePos) else if veh:GetClass() == "prop_vehicle_airboat" then EPos = veh:GetPos()+ veh:GetUp()*55+ veh:GetForward()*-45 else EPos = veh:LookupAttachment("vehicle_engine") != 0 and veh:GetAttachment(veh:LookupAttachment("vehicle_engine")).Pos or veh:GetPos()+ veh:GetUp()*25+ veh:GetForward()*75 end if veh.VC_Model == "models/vehicle.mdl" then EPos = EPos+ veh:GetForward()* -20 end end return EPos end

VC_ELS_Radio_Streams_Defaults = {
	{name = "Indianapolis Metro Police Dispatch", url = "http://198.178.123.14:8424"},
	{name = "Lincoln Nebraska EDACS", url = "http://108.167.16.109:8000"},
	{name = "Coral Springs Florida Police and Fire Dispatch", url = "http://173.246.43.210:8000"},
}

function VC_ReadChatter() if file.Exists("vcmod/els_chatter.txt", "DATA") then VC_ELS_ChatterTbl = util.KeyValuesToTable(file.Read("Data/vcmod/els_chatter.txt", "GAME")) else VC_ELS_ChatterTbl = table.Copy(VC_ELS_Radio_Streams_Defaults) end end
function VC_ResetChatter() file.Write("vcmod/els_chatter.txt", util.TableToKeyValues(VC_ELS_Radio_Streams_Defaults)) end
if !file.Exists("vcmod/els_chatter.txt", "DATA") then VC_ResetChatter() end VC_ReadChatter()
util.AddNetworkString("VC_ELS_Chatter") hook.Add("PlayerEnteredVehicle", "VC_ELS_VehEnter", function(ply, veh) if VC_Settings.VC_Enabled and VC_Settings.VC_ELS_Chatter then local MVeh = veh.VC_ExtraSeat and veh:GetParent() or veh if MVeh.VC_IsJeep and MVeh.VC_Script.Siren and MVeh.VC_Script.Siren.Sounds and !ply.VC_ChnSts then local ChatterData = VC_ELS_ChatterTbl[math.Round(VC_Settings.VC_ELS_Chatter_Sel)] net.Start("VC_ELS_Chatter") net.WriteTable({ChatterData and ChatterData.url or "", ChatterData and ChatterData.name or "", (ChatterData and ChatterData.vol or 1)*VC_Settings.VC_ELS_Chatter_Volume, veh}) net.Send(ply) end end end)

hook.Add("PlayerLeaveVehicle", "VC_VehExit_ELS", function(ply, veh)
	if VC_Settings.VC_Enabled then
		if VC_Settings.VC_ELS_Off or VC_Settings.VC_ELS_Lht_Off then
		local MVeh = veh.VC_ExtraSeat and veh:GetParent() or veh
			if !MVeh.VC_SeatTable or (MVeh == veh or !IsValid(MVeh:GetDriver())) then
			local HasDriver = false
			if MVeh.VC_SeatTable then for _, ent in pairs(MVeh.VC_SeatTable) do if ent != veh and IsValid(ent:GetDriver()) then HasDriver = true break end end end
			if !HasDriver and (!IsValid(MVeh:GetDriver()) or veh == MVeh) then MVeh.VC_ELSLhtOffTime = CurTime()+(VC_Settings.VC_ELS_Lht_OffIn or 300) MVeh.VC_ELSOffTime = CurTime()+(VC_Settings.VC_ELS_OffIn or 60*5) end
			end
		end
		
	if VC_Settings.VC_ELS_SndOffExit then VC_ELS_SoundOff(veh) end
	if VC_Settings.VC_ELS_LhtOffExit then VC_ELS_LightsOff(veh) end
	end
	VC_HornOff(veh) VC_ELS_ManualOff(veh)
end)

function VC_Initialize_ELS(ent)
	local Path = "data/vcmod/scripts_vcmod1_els/"..string.gsub(string.gsub(ent.VC_Model, ".mdl", ".txt"), "/", "_$VC$_")
	if file.Exists(Path, "GAME") then ent.VC_Script.Siren = util.JSONToTable(file.Read(Path, "GAME")).Siren end
	VC_Insert_Siren_Lights_Into_Reg(ent)
end

function VC_Think_ELS_Each(EntLN, ent)
	if VC_Settings.VC_Enabled and VC_Settings.VC_Enabled_ELS then

		local Elec = VC_ElectronicsOn(ent)
		if ent.VC_ELS_Sound_Tbl and !ent.VC_Horn_EnableELSOnHornEnd and !ent.VC_Horn_EnableELSOnManualEnd and !ent.VC_ELS_S_Disabled and Elec and VC_EngineAboveWater(ent) then if (!ent.VC_ELS_Sound or !ent.VC_ELS_Sound:IsPlaying()) and ent.VC_ELS_Sound_Tbl.Sound and ent.VC_ELS_Sound_Tbl.Sound != "" then ent.VC_ELS_Sound = VC_EmitSound(ent, ent.VC_ELS_Sound_Tbl.Sound, ent.VC_ELS_Sound_Tbl.Pitch, ent.VC_ELS_Sound_Tbl.Distance, ent.VC_ELS_Sound_Tbl.Volume, nil, true) ent.VC_ELS_Sound:Play() end elseif ent.VC_ELS_Sound then if ent.VC_ELS_Sound:IsPlaying() then ent.VC_ELS_Sound:Stop() end ent.VC_ELS_Sound = nil end
		
		if VC_Settings.VC_ELS_Manual and ent.VC_ELS_ManualOn and !ent.VC_Horn_EnableELSOnHornEnd and Elec and VC_EngineAboveWater(ent) and ent.VC_Script.Siren and ent.VC_Script.Siren.Sounds_Manual then
			if !ent.VC_ELSManSound or !ent.VC_ELSManSound:IsPlaying() then
			local HTbl = ent.VC_Script.Siren.Sounds_Manual ent.VC_Horn_EnableELSOnManualEnd = true ent.VC_HornTable = {Sound = HTbl and HTbl.Sound or (ent.VC_IsBig and "vcmod/horn/heavy.wav" or "vcmod/horn/light.wav"), Pitch = HTbl and HTbl.Pitch or 100, Distance = HTbl and HTbl.Distance or 85, Volume = HTbl and HTbl.Volume or 1}
			ent.VC_ELSManSound = VC_EmitSound(ent, ent.VC_HornTable.Sound, ent.VC_HornTable.Pitch, ent.VC_HornTable.Distance, ent.VC_HornTable.Volume, nil, true)
			end
		elseif ent.VC_ELSManSound and ent.VC_ELSManSound:IsPlaying() then
		if ent.VC_Horn_EnableELSOnManualEnd then ent.VC_Horn_EnableELSOnManualEnd = nil end
		ent.VC_ELSManSound:ChangeVolume(0, 0.01) timer.Simple(0.001, function() ent.VC_ELSManSound:Stop() end)
		end

		if !VCMod then
			if VC_Settings.VC_Horn_Enabled and ent.VC_HornOn and Elec and VC_EngineAboveWater(ent) then
				if !ent.VC_HornSound or !ent.VC_HornSound:IsPlaying() then
				local HTbl = VC_HornTable[ent.VC_CurrentHorn] or ent.VC_Script.Horn
				if VC_Settings.VC_ELS_BullHorn and (ent.VC_ELS_ManualOn or ent.VC_ELS_Snd_Sel and ent.VC_ELS_Snd_Sel > 0) and !ent.VC_ELS_S_Disabled and ent.VC_Script.Siren.Sounds_Horn and ent.VC_Script.Siren.Sounds_Horn.Use then ent.VC_Horn_EnableELSOnHornEnd = true HTbl = ent.VC_Script.Siren.Sounds_Horn end
				ent.VC_HornTable = {Sound = HTbl and HTbl.Sound or (ent.VC_IsBig and "vcmod/horn/heavy.wav" or "vcmod/horn/light.wav"), Pitch = HTbl and HTbl.Pitch or 100, Distance = HTbl and HTbl.Distance or 85, Volume = (HTbl and HTbl.Volume or 1)*(VC_Settings.VC_Horn_Volume or 1)}
				ent.VC_HornSound = VC_EmitSound(ent, ent.VC_HornTable.Sound, ent.VC_HornTable.Pitch, ent.VC_HornTable.Distance, ent.VC_HornTable.Volume, nil, true)
				ent:SetNWBool("VC_Siren_BullHorn", ent.VC_Horn_EnableELSOnHornEnd and true or false)
				end
			elseif ent.VC_HornSound and ent.VC_HornSound:IsPlaying() then
			if ent.VC_Horn_EnableELSOnHornEnd then ent.VC_Horn_EnableELSOnHornEnd = nil end
			ent.VC_HornSound:ChangeVolume(0, 0.01) timer.Simple(0.001, function() ent.VC_HornSound:Stop() end)
			end
		end

		if VC_Settings.VC_ELS_Lights and (!ent.VC_Health or ent.VC_Health > 0) then
		local CBR = ent if IsValid(ent.VC_Truck) then CBR = ent.VC_Truck end local MainEngineOn = VC_ElectronicsOn(CBR) and VC_EngineAboveWater(ent)

			local SrnOn = !ent.VC_ELS_L_Disabled and CBR.VC_ELS_Lht_Sel and CBR.VC_ELS_Lht_Sel != 0
			if MainEngineOn and SrnOn and !ent.VC_DrawSirenLights then
			ent:SetNWBool("VC_DrawSirenLights", true) ent.VC_DrawSirenLights = true
			elseif (!MainEngineOn or !SrnOn) and ent.VC_DrawSirenLights then
			ent:SetNWBool("VC_DrawSirenLights", false) ent.VC_DrawSirenLights = false
			end
		end
	end
end

hook.Add("Think", "VC_Think", function()
	VC_FTm = (CurTime()-(VC_LastFTm or 0))*66.66 VC_LastFTm = CurTime()
	for k,v in pairs(table.Copy(VC_SyncTable)) do if IsValid(v[1]) and IsValid(v[2]) then if !v[2].VC_NextSyncTime or CurTime() >= v[2].VC_NextSyncTime then VC_SendDataToClient(v[1], v[2]) VC_SyncTable[k] = nil v[2].VC_NextSyncTime = CurTime()+0.2 end else VC_SyncTable[k] = nil end end
	-- if VC_ASDGGG and CurTime() >= VC_ASDGGG then VCMsg("I"..Sdda.." re "..zxczx.."ror.") VC_Settings = nil end
	VC_Veh_List = ents.FindByClass("prop_vehicle_jeep*")
	if VCMod1 then VC_Think_Main_BS() end for EntLN, ent in pairs(VC_Veh_List) do if !ent.VC_Initialized then VC_Initialize(ent) ent.VC_Initialized = true end if VCMod1 then VC_Think_Main_Each(EntLN, ent) end if VCMod1_ELS then VC_Think_ELS_Each(EntLN, ent) end end
end)

function VC_Insert_Siren_Lights_Into_Reg(ent)
	if ent.VC_Script.Siren and ent.VC_Script.Siren.Lights then
		if !ent.VC_Script.Lights then ent.VC_Script.Lights = {} end local num = table.Count(ent.VC_Script.Lights)
		if ent.VC_Script.Siren and ent.VC_Script.Siren.Sections then local Tbl = {} for k,v in pairs(table.Copy(ent.VC_Script.Siren.Sections)) do Tbl[k] = {} for k2, v2 in pairs(v) do Tbl[k][num+k2] = true end end ent.VC_Script.Siren.Sections = Tbl end
		if ent.VC_Script.Siren.Sequences then for Seqk, Seqv in pairs(table.Copy(ent.VC_Script.Siren.Sequences)) do if Seqv.Lights_Sel then for Stgk, Stgv in pairs(Seqv.Lights_Sel) do ent.VC_Script.Siren.Sequences[Seqk].Lights_Sel[num+Stgk] = true ent.VC_Script.Siren.Sequences[Seqk].Lights_Sel[Stgk] = nil end end end end
		for Lhtk, Lt in pairs(ent.VC_Script.Siren.Lights) do
			Lt.UseSiren = true Lt.SirenColor = Lt.Color Lt.Color = nil table.insert(ent.VC_Script.Lights, Lt)
			if ent.VC_Script.Siren.Sequences then
				for Seqk, Seqv in pairs(ent.VC_Script.Siren.Sequences) do
					if Seqv.SubSeq then
						for SSeqk, SSeqv in pairs(Seqv.SubSeq) do
							if SSeqv.Stages then
								for Stgk, Stgv in pairs(SSeqv.Stages) do
									if ent.VC_Script.Siren.Sequences[Seqk].SubSeq[SSeqk].Stages[Stgk].Lights and ent.VC_Script.Siren.Sequences[Seqk].SubSeq[SSeqk].Stages[Stgk].Lights[Lhtk] then
									ent.VC_Script.Siren.Sequences[Seqk].SubSeq[SSeqk].Stages[Stgk].Lights[Lhtk] = num+ent.VC_Script.Siren.Sequences[Seqk].SubSeq[SSeqk].Stages[Stgk].Lights[Lhtk]
									end
								end
							end
						end
					end
				end
			end
		end
	ent.VC_Script.Siren.Lights = nil
	end
end

function VC_ELS_Chng(ent, off) if !ent.VC_Health or ent.VC_Health > 0 or !ent.VC_MaxHealth or ent.VC_MaxHealth == 0 then VC_EmitSound(ent, "vcmod/clk_els.wav", off and 95, 45) else VC_EmitSound(ent, "Clk", off and 95 or 105) end end

local function ConfigureELSLightsDash(ent)
	if !ent.VC_ELS_L_Disabled and ent.VC_ELS_Lht_Sel and ent.VC_ELS_Lht_Sel != 0 then
	if ent.VC_AvIndicators then local DBL = ent.VC_AvIndicators.Siren if DBL and !ent.VC_Indicators.Siren then VC_ApplyPoseParam(ent, DBL[1], DBL[3]) ent.VC_Indicators.Siren = table.Copy(DBL) end end
	elseif ent.VC_Indicators.Siren then VC_ApplyPoseParam(ent, ent.VC_Indicators.Siren[1], ent.VC_Indicators.Siren[2]) ent.VC_Indicators.Siren = nil
	end
end

function VC_ELS_Lht_SetCode(ent, code, nocodes)
	if (!ent.VC_ELS_Lht_Sel or ent.VC_ELS_Lht_Sel != code) and ent.VC_IsNotPrisonerPod and ent.VC_Script.Siren and ent.VC_Script.Siren.Sequences then
	ent.VC_ELS_Lht_Sel = code ent:SetNWInt("VC_ELS_Lht_Sel",  code) VC_SendToClient_Srn_Lht_Sel(ent, code, nocodes)
	ConfigureELSLightsDash(ent) VC_ELS_Chng(ent, code == 0)
	end
end

function VC_ELS_LightsOn(ent)
	if ent.VC_IsNotPrisonerPod and ent.VC_Script.Siren and ent.VC_Script.Siren.Sequences then
		if !ent.VC_ELS_Lht_Sel or ent.VC_ELS_Lht_Sel == 0 then
		local TTbl = {} for k,v in pairs(ent.VC_Script.Siren.Sequences) do if v.Codes then table.Merge(TTbl, table.Copy(v.Codes)) end end
		if ent.VC_Script.Siren.Codes then for k,v in pairs(ent.VC_Script.Siren.Codes) do if v.Include or v.Ovr and v.OvrC then TTbl[k] = true end end end
		local HasNoCodes = false if table.Count(TTbl) == 0 then HasNoCodes = true TTbl[1] = true end local LK = 0 for k,v in SortedPairs(TTbl) do LK = k end
			if ent.VC_ELS_Lht_Sel then
			if LK > ent.VC_ELS_Lht_Sel then for k,v in SortedPairs(TTbl) do if k > ent.VC_ELS_Lht_Sel then VC_ELS_Lht_SetCode(ent, k, HasNoCodes) break end end else VC_ELS_Lht_SetCode(ent, 0, HasNoCodes) end
			else
			local Key = nil for k,v in pairs(TTbl) do if !Key or Key > k then Key = k end end if Key then VC_ELS_Lht_SetCode(ent, Key, HasNoCodes) end
			end
		ent.VC_ELS_L_Disabled = false ent:SetNWBool("VC_ELS_L_Disabled", ent.VC_ELS_L_Disabled)
		elseif ent.VC_ELS_L_Disabled then ent.VC_ELS_L_Disabled = false ent:SetNWBool("VC_ELS_L_Disabled", ent.VC_ELS_L_Disabled) VC_ELS_Chng(ent)
		end
	ConfigureELSLightsDash(ent)
	end
end
function VC_ELS_LightsOff(ent) if !ent.VC_ELS_L_Disabled then ent.VC_ELS_L_Disabled = true ent:SetNWBool("VC_ELS_L_Disabled", ent.VC_ELS_L_Disabled) VC_ELS_Chng(ent, true) ConfigureELSLightsDash(ent) end end

function VC_ELS_Snd_SetCode(ent, code)
	if (!ent.VC_ELS_Snd_Sel or ent.VC_ELS_Snd_Sel != code) and ent.VC_IsNotPrisonerPod and ent.VC_Script.Siren and ent.VC_Script.Siren.Sounds then
	ent.VC_ELS_Snd_Sel = code ent:SetNWInt("VC_ELS_Snd_Sel", ent.VC_ELS_Snd_Sel)
	if ent.VC_ELS_Sound then if ent.VC_ELS_Sound:IsPlaying() then ent.VC_ELS_Sound:Stop() end ent.VC_ELS_Sound = nil end
	VC_ELS_Chng(ent, code == 0)
	end
end

function VC_ELS_Lht_Cycle(ent)
	if ent.VC_IsNotPrisonerPod and ent.VC_Script.Siren and ent.VC_Script.Siren.Sequences then
	local TTbl = {} for k,v in pairs(ent.VC_Script.Siren.Sequences) do if v.Codes then table.Merge(TTbl, table.Copy(v.Codes)) end end
	if ent.VC_Script.Siren.Codes then for k,v in pairs(ent.VC_Script.Siren.Codes) do if v.Include or v.Ovr and v.OvrC then TTbl[k] = true end end end
	local HasNoCodes = false if table.Count(TTbl) == 0 then HasNoCodes = true TTbl[1] = true end local LK = 0 for k,v in SortedPairs(TTbl) do LK = k end
		if ent.VC_ELS_Lht_Sel then
		if LK > ent.VC_ELS_Lht_Sel then for k,v in SortedPairs(TTbl) do if k > ent.VC_ELS_Lht_Sel then VC_ELS_Lht_SetCode(ent, k, HasNoCodes) break end end else VC_ELS_Lht_SetCode(ent, 0, HasNoCodes) end
		else
		local Key = nil for k,v in pairs(TTbl) do if !Key or Key > k then Key = k end end if Key then VC_ELS_Lht_SetCode(ent, Key, HasNoCodes) end
		end
	ConfigureELSLightsDash(ent)
	end
end

function VC_ELS_Snd_Cycle(ent)
	if ent.VC_IsNotPrisonerPod and ent.VC_Script.Siren and ent.VC_Script.Siren.Sounds then
	local LK = 0 for k,v in SortedPairs(ent.VC_Script.Siren.Sounds) do LK = k end
	if ent.VC_ELS_Snd_Sel then
		if LK > ent.VC_ELS_Snd_Sel then for k,v in SortedPairs(ent.VC_Script.Siren.Sounds) do if k > ent.VC_ELS_Snd_Sel then VC_ELS_Snd_SetCode(ent, k) break end end else VC_ELS_Snd_SetCode(ent, 0) end
		else
		for k,v in pairs(ent.VC_Script.Siren.Sounds) do VC_ELS_Snd_SetCode(ent, k) break end
		end
	if ent.VC_ELS_Snd_Sel then ent.VC_ELS_Sound_Tbl = ent.VC_Script.Siren.Sounds[ent.VC_ELS_Snd_Sel] else ent.VC_ELS_Sound_Tbl = nil end
	end
end

function VC_ELS_SoundOn(ent)
	if ent.VC_IsNotPrisonerPod and ent.VC_Script.Siren and ent.VC_Script.Siren.Sounds then
		if !ent.VC_ELS_Snd_Sel or ent.VC_ELS_Snd_Sel == 0 then
		for k,v in pairs(ent.VC_Script.Siren.Sounds) do VC_ELS_Snd_SetCode(ent, k) break end
		ent.VC_ELS_S_Disabled = false ent:SetNWBool("VC_ELS_S_Disabled", ent.VC_ELS_S_Disabled)
		elseif ent.VC_ELS_S_Disabled then ent.VC_ELS_S_Disabled = false ent:SetNWBool("VC_ELS_S_Disabled", ent.VC_ELS_S_Disabled) VC_ELS_Chng(ent)
		end
	if ent.VC_ELS_Snd_Sel then ent.VC_ELS_Sound_Tbl = ent.VC_Script.Siren.Sounds[ent.VC_ELS_Snd_Sel] else ent.VC_ELS_Sound_Tbl = nil end
	end
end
function VC_ELS_SoundOff(ent) if !ent.VC_ELS_S_Disabled then ent.VC_ELS_S_Disabled = true ent:SetNWBool("VC_ELS_S_Disabled", ent.VC_ELS_S_Disabled) VC_ELS_Chng(ent, true) end end

function VC_ELS_ManualOn(ent)
	if ent.VC_Script.Siren and ent.VC_Script.Siren.Sounds_Horn and ent.VC_Script.Siren.Sounds_Horn.Use and !ent.VC_ELS_ManualOn and ent.VC_IsNotPrisonerPod then
	if ent.VC_AvIndicators then local DBL = ent.VC_AvIndicators.ELS_Manual if DBL and !ent.VC_Indicators.ELS_Manual then VC_ApplyPoseParam(ent, DBL[1], DBL[3]) ent.VC_Indicators.ELS_Manual = table.Copy(DBL) end end
	ent.VC_ELS_ManualOn = true ent:SetNWBool("VC_ELS_ManualOn", ent.VC_ELS_ManualOn)
	end
end
function VC_ELS_ManualOff(ent)
	if ent.VC_ELS_ManualOn then
	if ent.VC_Indicators.ELS_Manual then VC_ApplyPoseParam(ent, ent.VC_Indicators.ELS_Manual[1], ent.VC_Indicators.ELS_Manual[2]) ent.VC_Indicators.ELS_Manual = nil end
	ent.VC_ELS_ManualOn = false ent:SetNWBool("VC_ELS_ManualOn", ent.VC_ELS_ManualOn)
	end
end

concommand.Add("vc_els_manual", function(ply, cmd, arg) if VC_Settings.VC_Enabled then local ent, HA = ply:GetVehicle(), tonumber(arg[1]) if IsValid(ent) and ent.VC_IsNotPrisonerPod then if HA == 1 and !ent.VC_ELS_ManualOn then VC_ELS_ManualOn(ent) elseif HA == 2 and ent.VC_ELS_ManualOn then VC_ELS_ManualOff(ent) end end end end)
concommand.Add("vc_els_lights", function(ply) if VC_Settings.VC_Enabled then local ent = ply:GetVehicle() VC_ELS_Lht_Cycle(ent) end end)
concommand.Add("vc_els_lights_onoff", function(ply) if VC_Settings.VC_Enabled then local ent = ply:GetVehicle() if IsValid(ent) and ent.VC_IsNotPrisonerPod then if ent.VC_ELS_L_Disabled then VC_ELS_LightsOn(ent) else VC_ELS_LightsOff(ent) end end end end)
concommand.Add("vc_els_sound", function(ply) if VC_Settings.VC_Enabled then local ent = ply:GetVehicle() VC_ELS_Snd_Cycle(ent) end end)
concommand.Add("vc_els_sound_onoff", function(ply) if VC_Settings.VC_Enabled then local ent = ply:GetVehicle() if IsValid(ent) and ent.VC_IsNotPrisonerPod then if ent.VC_Script.Siren and ent.VC_Script.Siren.Sounds then if !ent.VC_ELS_S_Disabled then VC_ELS_SoundOff(ent) else VC_ELS_SoundOn(ent) end end end end end)