// Copyright © 2012-2015 VCMod (freemmaann). All Rights Reserved. if you have any complaints or ideas contact me: email - freemmaann@gmail.com or skype - comman6.

VCMod1_ELS = 1.123 vcmod1_els = VCMod1_ELS

file.CreateDir("vcmod")

VC_Fonts = {}

local HoldKey = "KEY_LALT"
VC_Controls_ELS = {
	{cmd = "vc_horn", menu = "controls_els", NoCheckBox = true, carg1 = "1", carg2 = "2", info = "Horn", default = {key = "KEY_R", hold = "1"}},
	{cmd = "vc_els_manual", menu = "controls_els", NoCheckBox = true, carg1 = "1", carg2 = "2", info = "ManulSiren", default = {key = "KEY_T", hold = "1"}},
	{cmd = "vc_els_sound", menu = "controls_els", info = "ELS_SirenSwitch", default = {key = "MOUSE_RIGHT", hold = "0", mouse = "1"}},
	{cmd = "vc_els_sound_onoff", menu = "controls_els", info = "ELS_SirenToggle", default = {key = "MOUSE_RIGHT", hold = "1", mouse = "1"}},
	{cmd = "vc_els_lights", menu = "controls_els", info = "ELS_LightsSwitch", default = {key = "MOUSE_LEFT", hold = "0", mouse = "1"}},
	{cmd = "vc_els_lights_onoff", menu = "controls_els", info = "ELS_LightsToggle", default = {key = "MOUSE_LEFT", hold = "1", mouse = "1"}},
}

if !VC_Controls_ELS_Added then if !VC_MControls then VC_MControls = VC_Controls_ELS or {} else table.Add(VC_MControls, VC_Controls_ELS or {}) end VC_Controls_ELS_Added = true end

function VC_Read_ControlScript() VC_ControlTable = util.KeyValuesToTable(file.Read("Data/vcmod/Controls_vc1.txt", "GAME")) end
function VC_Create_ControlScript() local CntTbl = {} for _, Ctr in pairs(VC_MControls) do if !Ctr.default.hold then Ctr.default.hold = "0" end CntTbl[Ctr.cmd] = Ctr.default end file.Write("vcmod/Controls_vc1.txt", util.TableToKeyValues(CntTbl)) VC_Read_ControlScript() end //local vbitasmj = 76561252636330179

if !file.Exists("vcmod/Controls_vc1.txt", "DATA") then VC_Create_ControlScript() else VC_Read_ControlScript() for k,v in pairs(VC_MControls) do if !VC_ControlTable[v.cmd] then VC_Create_ControlScript() end end end

function VCMsg(msg) msg = VC_Lng(msg) if type(msg) != table then msg = {msg} end for _, PM in pairs(msg) do if type(PM) != string then PM = tostring(PM) end chat.AddText(Color(100, 255, 55, 255), "VCMod: "..tostring(PM)) end end

function VC_FTm() local FTm = FrameTime()*100 return FTm end 

function VC_MakeScripts() end

VC_Global_Data = VC_Global_Data or {}

local function Chatter_Stop() if VC_ELS_Chatter_Sound then VC_ELS_Chatter_Sound[1]:Stop() end VC_ELS_Chatter_Sound = nil end
local function Chatter_Play(ent, url, name, vol)
Chatter_Stop()
	sound.PlayURL(url, "", function(sta)
		if IsValid(sta) then
		sta:SetVolume(vol or 1) sta:Play() VC_ELS_Chatter_Sound = {sta, ent} VCMsg(VC_Lng("ELS_TuningIntoPoliceC")..": "..name..".")
		else
		VCMsg("ELS_NoPoliceRCFound")
		end
	end)
end

hook.Add("InitPostEntity", "VC_InitPE_Cl", function()
	usermessage.Hook("VCMsg", function(dt) VCMsg(dt:ReadString()) end)
	net.Receive("VC_SendToClient_Options", function(len) local Tbl = net.ReadTable() VC_Settings_TempTbl = Tbl end)
	net.Receive("VC_SendToClient_Options_NPC", function(len) local Tbl = net.ReadTable() VC_Settings_TempTbl_NPC = Tbl end)

	net.Receive("VC_SendToClient_Model", function(len) local ent, mdl = net.ReadEntity(), net.ReadString() if IsValid(ent) then ent.VC_Model = mdl end end)
	net.Receive("VC_SendToClient_Init", function(len) local mdl = net.ReadString() VC_Global_Data[mdl] = {} end)
	net.Receive("VC_SendToClient_Lights", function(len) local mdl, kill = net.ReadString(), net.ReadString() if kill == "A" then VC_Global_Data[mdl] = {} else local type, key, tbl = net.ReadString(), net.ReadInt(32), net.ReadTable() if !VC_Global_Data[mdl].LightTable then VC_Global_Data[mdl].LightTable = {} end if !VC_Global_Data[mdl].LightTable[type] then VC_Global_Data[mdl].LightTable[type] = {} end VC_Global_Data[mdl].LightTable[type][key] = tbl end end)
end)

local function ELS_Convert_Section_Data(mdl)
	if VC_Global_Data[mdl].Siren and VC_Global_Data[mdl].Siren.Sections and VC_Global_Data[mdl].LightTable and VC_Global_Data[mdl].LightTable.Siren then
		for k,v in pairs(VC_Global_Data[mdl].Siren.Sections) do
			for k2,v2 in pairs(v) do
				if VC_Global_Data[mdl].LightTable.Siren[k2] then
				VC_Global_Data[mdl].Siren.Sections[k][k2] = VC_Global_Data[mdl].LightTable.Siren[k2].Pos.x
				else
				VC_Global_Data[mdl].Siren.Sections[k][k2] = nil
				end
			end
		end

		local FixedT = nil if VC_Global_Data[mdl].Siren.InterSec then FixedT = {}
			for k,v in pairs(VC_Global_Data[mdl].Siren.InterSec) do
				if v.Section and VC_Global_Data[mdl].Siren.Sections[v.Section] then
				FixedT[k] = v FixedT[k].Lights = {}
				local Am = v.Am or 10 local Min, Max = 0,0 for k2,v2 in pairs(VC_Global_Data[mdl].Siren.Sections[v.Section]) do if v2 < Min then Min = v2 end if v2 > Max then Max = v2 end end local MMax = (math.abs(Max)+math.abs(Min))/Am
					for k2,v2 in pairs(VC_Global_Data[mdl].Siren.Sections[v.Section]) do
					for i=1,Am do if (Max-v2) >= MMax*(i-1) and (Max-v2) <= MMax*i then FixedT[k].Lights[k2] = {i} break end end
					end
				end
			end
		end

		for k,v in pairs(VC_Global_Data[mdl].Siren.Sections) do
		local LTbl, Min, Max = {}, nil, nil
		local TTbl = {} for k2,v2 in pairs(v) do if !TTbl[v2] then TTbl[v2] = {} end TTbl[v2][k2] = v2 end
		local NTbl = {} local int = 1 for k2,v2 in SortedPairs(TTbl) do NTbl[int] = v2 int = int+1 end
		VC_Global_Data[mdl].Siren.Sections[k] = NTbl
		end
	end
end

hook.Add("InitPostEntity", "VC_InitPE_Cl_ELS", function()
	net.Receive("VC_SendToClient_Srn_Lht_Sel", function(len) local ent, code, nocodes = net.ReadEntity(), net.ReadInt(32), net.ReadInt(32) ent.VC_ELS_Lht_Sel = code ent.VC_ELS_Lht_Sel_NCodes = tobool(nocodes) end)
	-- net.Receive("VC_SendToClient_Siren", function(len) local mdl, tbl = net.ReadString(), net.ReadTable() VC_Global_Data[mdl].Siren = tbl end)
	net.Receive("VC_SendToClient_Siren_Seq", function(len) local mdl, tbl = net.ReadString(), net.ReadTable() if !VC_Global_Data[mdl].Siren then VC_Global_Data[mdl].Siren = {} end VC_Global_Data[mdl].Siren.Sequences = tbl end)
	net.Receive("VC_SendToClient_Siren_Rest", function(len) local mdl, tbl = net.ReadString(), net.ReadTable() if !VC_Global_Data[mdl].Siren then VC_Global_Data[mdl].Siren = {} end tbl.Sequences = VC_Global_Data[mdl].Sequences VC_Global_Data[mdl].Siren = tbl ELS_Convert_Section_Data(mdl) end)
	net.Receive("VC_SendToClient_ClearSiren", function(len) net.ReadEntity().VC_SirenTable = nil end)
	net.Receive("VC_ELS_Chatter", function(dt) local Tbl = net.ReadTable() Chatter_Play(Tbl[4], Tbl[1], Tbl[2], Tbl[3]) end)
end)

hook.Add("OnPlayerChat", "VC_OnPlayerChat", function(ply, txt)
	txt = string.lower(txt)
	if txt == "!vcmod" or txt == "!vc" then
	RunConsoleCommand("vc_open_menu", ply:EntIndex())
	return true
	end
end)

local function GetVersions(Tbl)
	timer.Simple(1, function()
		VCMod_Versions = {} http.Fetch("https://dl.dropboxusercontent.com/u/13116851/VCMod_Versions.txt", function(body) VCMod_Versions = util.KeyValuesToTable(body) end)
			timer.Simple(10, function()
				if table.Count(VCMod_Versions) > 1 then
					for k,v in pairs(Tbl) do
						if v[2] then
						local Ver = VCMod_Versions[v[1]]
						if Ver then
						Ver = math.Round(Ver*1000)/1000
							if v[2] < Ver then
							VCMsg('Your copy of "'..v[3]..'" is outdated, please update (type "!vcmod" in chat).')
							end
						end
					end
				end
			end
		end)
	end)
end

function VC_Initialize(ent)
	if IsValid(ent) then
	ent.VC_Class = string.lower(ent:GetClass())
	ent.VC_IsJeep = ent.VC_Class == "prop_vehicle_jeep"
	ent.VC_IsPrisonerPod = ent.VC_Class == "prop_vehicle_prisoner_pod"
	ent.VC_IsAirboat = ent.VC_Class == "prop_vehicle_airboat"
	ent.VC_ExtraSeat = ent.VC_IsPrisonerPod and ent:GetNWBool("VC_ExtraSt")
	if LocalPlayer():IsAdmin() and !LocalPlayer().VC_Data_Update_Checked then GetVersions({{"vcmod1", VCMod1, "VCMod Main"}, {"vcmod1_els", VCMod1_ELS, "VCMod ELS"}}) LocalPlayer().VC_Data_Update_Checked = true end
	local MEnt = ent.VC_ExtraSeat and ent:GetParent() or ent local Atc = MEnt:LookupAttachment("vehicle_driver_eyes") if Atc != 0 then ent.VC_EyePos = MEnt:WorldToLocal(MEnt:GetAttachment(Atc).Pos) MEnt.VC_DoorLightPos = MEnt.VC_EyePos*Vector(0,1,1)+Vector(0,0,8) MEnt.VC_LeftSteer = MEnt.VC_EyePos.x < 0 end
	end
end

hook.Add("CalcView", "VC_ViewCalc_ELS", function(ply, pos, ang, fov)
	local FTm = FrameTime()*100

	local OV = ply:GetVehicle()

	if VC_ELS_Chatter_Sound and !IsValid(OV) then Chatter_Stop() end

	if VC_Settings.VC_Enabled and IsValid(OV) and (!OV.VC_IsPrisonerPod or OV:GetNWBool("VC_ExtraSt")) then
			if VC_Settings.VC_Keyboard_Input then
				local HTm = VC_Settings.VC_Keyboard_Input_Hold or 0.2
				for _, Cmd in pairs(VC_MControls) do
					if !Cmd.cursor and !vgui.CursorVisible() or Cmd.cursor and vgui.CursorVisible() then
						if VC_ControlTable[Cmd.cmd] and VC_ControlTable[Cmd.cmd].key != "None" then
						local Key, Hold, SKHE, KHB, KHld = VC_ControlTable[Cmd.cmd].key, tobool(VC_ControlTable[Cmd.cmd].hold or "1"), nil, true, true
						local GK = nil if Key then GK = _G[Key] end
							if GK then
							local GKey = VC_ControlTable[Cmd.cmd].mouse and input.IsMouseDown(_G[Key]) or input.IsKeyDown(_G[Key])
								if Cmd.keyhold then
								KHld = nil if input.IsKeyDown(_G[HoldKey]) then KHld = true end
								else
								local OtherHasHold = nil
									for k, v in pairs(VC_MControls) do if VC_ControlTable[v.cmd] and VC_ControlTable[v.cmd].key == Key and v.keyhold and input.IsKeyDown(_G[HoldKey]) then OtherHasHold = true break end end
									if OtherHasHold then
									KHB = nil
									else
										for _, KHK in pairs(VC_MControls) do
											if KHK.cmd and VC_ControlTable[KHK.cmd] and Cmd != KHK and Key == VC_ControlTable[KHK.cmd].key and VC_ControlTable[Cmd.cmd].hold == VC_ControlTable[KHK.cmd].hold and KHK.keyhold and Key != "None" then
											if input.IsKeyDown(_G[HoldKey]) then KHB = nil end
											end
										end
									end
								end
							for _, GV in pairs(VC_ControlTable) do if Key != "None" and !Hold and tobool(GV.hold) and GV.key == Key then SKHE = true break end end
								if GKey then
									if !Cmd.VC_KeyDT then
									Cmd.VC_KeyDT = CurTime()+ (SKHE and HTm or Hold and HTm or 0) Cmd.VC_KeyAP = true
									elseif KHB and KHld and Cmd.VC_KeyAP and (Cmd.carg1 and Hold or !SKHE and CurTime() >= Cmd.VC_KeyDT) then
									RunConsoleCommand(Cmd.cmd, Cmd.carg1) Cmd.VC_KeyAP = nil
									end
								elseif Cmd.VC_KeyDT and !GKey then
								if KHld and KHB and (Cmd.carg2 and Hold or SKHE and CurTime() < Cmd.VC_KeyDT) then RunConsoleCommand(Cmd.cmd, Cmd.carg2) end
								Cmd.VC_KeyAP = nil Cmd.VC_KeyDT = nil
								end
							end
						end
					end
				end
			end

	if (!VC_PrintedChatMsgT or CurTime() >= VC_PrintedChatMsgT) and (OV:GetClass() != "prop_vehicle_prisoner_pod" or OV:GetNWBool("VC_ExtraSt")) then VCMsg("Chat") VC_PrintedChatMsgT = CurTime()+400 end

	local Veh = OV:GetNWBool("VC_ExtraSt") and OV:GetParent() or OV if !Veh.VC_Initialized then VC_Initialize(Veh) Veh.VC_Initialized = true end
	end
end)

concommand.Add("VC_SetControl", function(ply, cmd, arg)
	if arg[1] and arg[2] then
	local CTbl = util.KeyValuesToTable(file.Read("Data/vcmod/Controls_vc1.txt", "GAME"))
	if !CTbl[arg[1]] then CTbl[arg[1]] = {} end
	CTbl[arg[1]].mouse = nil if arg[4] then CTbl[arg[1]].mouse = "1" end
	if arg[2] == "Hold" then CTbl[arg[1]].hold = arg[3] else CTbl[arg[1]].key = arg[2] end
	file.Write("vcmod/Controls_vc1.txt", util.TableToKeyValues(CTbl)) VC_ControlTable = CTbl
	end
end)

function VC_IsDrawn() return IsValid(LocalPlayer():GetVehicle()) and LocalPlayer():GetVehicle():GetThirdPersonMode() end