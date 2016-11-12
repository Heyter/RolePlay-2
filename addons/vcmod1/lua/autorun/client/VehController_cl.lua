// Copyright © 2012-2015 VCMod (freemmaann). All Rights Reserved. if you have any complaints or ideas contact me: email - freemmaann@gmail.com or skype - comman6.

VCMod1 = 1.735 vcmod1 = VCMod1

VC_Fonts = {}

file.CreateDir("vcmod")

local HoldKey = "KEY_LALT"
VC_Controls = {
	{cmd = "vc_lights_onoff", menu = "controls", info = "NightLights", default = {key = "KEY_F", hold = "1"}, desk = "Night lights, combined to this are fog lights and day lights."},
	{cmd = "vc_headlights_onoff", menu = "controls", info = "HeadLights", default = {key = "KEY_F", hold = "0"}, desk = "High beams."},
	{cmd = "vc_headlights_modes", menu = "controls", keyhold = true, info = "LowHigh", default = {key = "KEY_F", hold = "0"}},
	{cmd = "vc_hazards_onoff", menu = "controls", keyhold = true, info = "HazardLights", default = {key = "MOUSE_MIDDLE", hold = "0", mouse = "1"}},
	{cmd = "vc_blinker_left", menu = "controls", keyhold = true, info = "BlinkerLeft", default = {key = "MOUSE_LEFT", hold = "0", mouse = "1"}},
	{cmd = "vc_blinker_right", menu = "controls", keyhold = true, info = "BlinkerRight", default = {key = "MOUSE_RIGHT", hold = "0", mouse = "1"}},
	{cmd = "vc_horn", menu = "controls", NoCheckBox = true, carg1 = "1", carg2 = "2", info = "Horn", default = {key = "KEY_R", hold = "1"}, desk = "Emit car horn."},
	{cmd = "vc_cruise_onoff", menu = "controls", info = "Cruise", default = {key = "KEY_B", hold = "0"}, desk = "Keeps the vehicle at constant speed."},
	{cmd = "vc_inside_doors_onoff", menu = "controls", info = "LockUnlock", keyhold = true, default = {key = "KEY_N", hold = "0"}, desk = "Lock the vehicle from within."},
	{cmd = "vc_viewlookbehind", menu = "controls", NoCheckBox = true, carg1 = "1", carg2 = "2", info = "LookBehind", default = {key = "MOUSE_MIDDLE", hold = "1", mouse = "1"}, desk = "Look behind the vehicle."},
	{cmd = "vc_trailer_detach", menu = "controls", info = "DetachTrl", default = {key = "KEY_B", hold = "1"}},
}

if !VC_Controls_Added then if !VC_MControls then VC_MControls = VC_Controls or {} else table.Add(VC_MControls, VC_Controls or {}) end VC_Controls_Added = true end

function VC_Read_ControlScript() VC_ControlTable = util.KeyValuesToTable(file.Read("Data/vcmod/Controls_vc1.txt", "GAME")) end
function VC_Create_ControlScript() local CntTbl = {} for _, Ctr in pairs(VC_MControls) do if !Ctr.default.hold then Ctr.default.hold = "0" end CntTbl[Ctr.cmd] = Ctr.default end file.Write("vcmod/Controls_vc1.txt", util.TableToKeyValues(CntTbl)) VC_Read_ControlScript() end

if !file.Exists("vcmod/Controls_vc1.txt", "DATA") then VC_Create_ControlScript() else VC_Read_ControlScript() for k,v in pairs(VC_MControls) do if !VC_ControlTable[v.cmd] then VC_Create_ControlScript() end end end

function VCMsg(msg) msg = VC_Lng(msg) if type(msg) != table then msg = {msg} end for _, PM in pairs(msg) do if type(PM) != string then PM = tostring(PM) end chat.AddText(Color(100, 255, 55, 255), "VCMod: "..tostring(PM)) end end

function VC_EaseInOut(num) return (math.sin(math.pi*(num-0.5))+1)/2 end
function VC_FTm() local FTm = FrameTime()*100 return FTm end 

concommand.Add("vc_getparticles", function(ply, cmd, arg) ply:ChatPrint('VCMod: Particle effects are not bundled with VCMod for legal matters.\nYou can still get particle effects from here: "http://www.filedropper.com/vcmodparticles".') end)
local function CheckForEffects() if !file.Exists("models/vehicle.mdl", "GAME") and !file.Exists("particles/vehicle.pcf", "GAME") then if isfunction(GAMEMODE.AddNotify) then GAMEMODE:AddNotify('VCMod: you appear to be missing particle effects, enter "vc_getparticles" in console to get them.', 1, 6) end end end //local xcgsd = 76561252654015101
timer.Create("vcmod_pcheck", 30, 4, function() CheckForEffects() end) timer.Simple(10, function() CheckForEffects() end)

game.AddParticles("particles/vehicle.pcf") game.AddParticles("particles/weapon_fx.pcf")

function VC_AngleInBounds(BNum, ang1, ang2) return math.abs(math.AngleDifference(ang1.p, ang2.p)) < BNum and math.abs(math.AngleDifference(ang1.y, ang2.y)) < BNum and math.abs(math.AngleDifference(ang1.r, ang2.r)) < BNum end
function VC_AngleDifference(ang1, ang2) return math.max(math.max(math.abs(math.AngleDifference(ang1.p, ang2.p)), math.abs(math.AngleDifference(ang1.y, ang2.y))), math.abs(math.AngleDifference(ang1.r, ang2.r))) end

function VC_MakeScript(id) end function VC_MakeScripts(id) end

hook.Add("ShouldDrawLocalPlayer", "VC_ShouldDrawLocalPlayer", function(ply) if VC_Settings.VC_Enabled and IsValid(ply:GetVehicle()) and ply:GetVehicle():GetThirdPersonMode() then return true end end)

VC_Global_Data = VC_Global_Data or {}

hook.Add("InitPostEntity", "VC_InitPE_Cl", function()
	usermessage.Hook("VCMsg", function(dt) VCMsg(dt:ReadString()) end)
	net.Receive("VC_SendToClient_Options", function(len) local Tbl = net.ReadTable() VC_Settings_TempTbl = Tbl end)
	net.Receive("VC_SendToClient_Options_NPC", function(len) local Tbl = net.ReadTable() VC_Settings_TempTbl_NPC = Tbl end)

	net.Receive("VC_SendToClient_Model", function(len) local ent, mdl = net.ReadEntity(), net.ReadString() if IsValid(ent) then ent.VC_Model = mdl end end)
	net.Receive("VC_SendToClient_Init", function(len) local mdl = net.ReadString() VC_Global_Data[mdl] = {} end)
	net.Receive("VC_SendToClient_Lights", function(len) local mdl, kill = net.ReadString(), net.ReadString() if kill == "A" then VC_Global_Data[mdl] = {} else local type, key, tbl = net.ReadString(), net.ReadInt(32), net.ReadTable() if !VC_Global_Data[mdl].LightTable then VC_Global_Data[mdl].LightTable = {} end if !VC_Global_Data[mdl].LightTable[type] then VC_Global_Data[mdl].LightTable[type] = {} end VC_Global_Data[mdl].LightTable[type][key] = tbl end end)
end)

hook.Add("OnPlayerChat", "VC_OnPlayerChat", function(ply, txt) txt = string.lower(txt) if txt == "!vcmod" or txt == "!vc" then RunConsoleCommand("vc_open_menu", ply:EntIndex()) return true end end)

local VVAS = 0

function VC_HandleInput(ply, OV)
	if VC_Settings.VC_Keyboard_Input then
		if !vgui.CursorVisible() and (!ply.VC_UpKeysPressTime or CurTime() >= ply.VC_UpKeysPressTime) then
			if input.IsKeyDown(KEY_LALT) then
			if !OV.VC_ExtraSeat then for i=1, 10 do local Ib = (i == 10 and 0 or i) if input.IsKeyDown(_G["KEY_"..Ib]) then RunConsoleCommand("VC_ClearSeat", Ib) ply.VC_UpKeysPressTime = CurTime()+0.2 end end end
			else
			for i=1, 10 do local Ib = (i == 10 and 0 or i) if input.IsKeyDown(_G["KEY_"..Ib]) then if Ib > 0 then RunConsoleCommand("VC_Switch_Seats_"..Ib) else RunConsoleCommand("VC_Switch_Seats") end ply.VC_UpKeysPressTime = CurTime()+0.2 end end
			end
		end

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
end

hook.Add("CalcView", "VC_ViewCalc", function(ply, pos, ang, fov)
	if !ply.VC_TPRCU then ply.VC_TPRCU = true end
	local FTm = FrameTime()*100 if FTm < 1 then FTm = 1 end
	
	local OV = ply:GetVehicle()
	if VC_Settings.VC_Enabled and IsValid(OV) and (!OV.VC_IsPrisonerPod or OV:GetNWBool("VC_ExtraSt")) then
	VC_TPDV = math.Clamp(VC_Settings.VC_ThirdPerson_Vec_Stf, 0, 100) VC_TPDA = math.Clamp(VC_Settings.VC_ThirdPerson_Ang_Stf, 0, 100)

	if (!VC_PrintedChatMsgT or CurTime() >= VC_PrintedChatMsgT) and (OV:GetClass() != "prop_vehicle_prisoner_pod" or OV:GetNWBool("VC_ExtraSt")) then VCMsg("Chat") VC_PrintedChatMsgT = CurTime()+400 end

	VC_HandleInput(ply, OV)
	local Veh, MMvd = OV:GetNWBool("VC_ExtraSt") and OV:GetParent() or OV, false if !Veh.VC_Initialized then VC_Initialize(Veh) Veh.VC_Initialized = true end
		if ply:ShouldDrawLocalPlayer() and OV:GetThirdPersonMode() and GetViewEntity() == LocalPlayer() then
				if VC_Settings.VC_ThirdPerson_Dynamic and VC_TPDA < 100 or VC_Settings.VC_ThirdPerson_Auto or VC_Settings.VC_MouseControl then
					if !ply.VC_LEASBC or !VC_AngleInBounds(0.0001, ply.VC_LEASBC, ply:EyeAngles()) then
					ply.VC_CnstAV = (ply.VC_CnstAV or ply:EyeAngles())+ (ply:EyeAngles()- (ply.VC_LEASBC or ply:EyeAngles()))
					ply.VC_LEASBC = ply.VC_CnstAV MMvd = true VVAS = 0
					end
					if MMvd or !vgui.CursorVisible() and (input.IsMouseDown(MOUSE_LEFT) or input.IsMouseDown(MOUSE_RIGHT) or VC_View_LookingBehind) then
					ply.VC_LEAACT = CurTime() ply.VC_LEAACR = math.random(4.5, 6)
					end
				elseif ply.VC_CnstAV then
				ply.VC_CnstAV = nil ply.VC_LEASBC = nil
				end
				if VC_Settings.VC_ThirdPerson_Auto and !Veh.VC_IsPrisonerPod and VC_Settings.VC_ThirdPerson_Ang_Stf > 0 and CurTime() >= ply.VC_LEAACT+ (Veh:GetVelocity():Length() >= 50 and 1.5 or ply.VC_LEAACR) then
				local FAng = VC_Settings.VC_ThirdPerson_Auto_Back and Veh:GetVelocity():Dot(Veh:GetRight()) > 150 and -90 or 90
					if !VC_AngleInBounds(0.1, ply.VC_CnstAV or ply:EyeAngles(), Angle(VC_Settings.VC_ThirdPerson_Auto_Pitch,FAng,0)) then
						local AVel = math.Clamp(Veh:GetVelocity():Length()/(FAng > 0 and 25000 or 13000), 0, 0.0775)
						if ply.VC_APLBP and ply.VC_APLBP != FAng then VVAS = 0 end
						ply.VC_APLBP = FAng if VVAS < 1 then VVAS = VVAS+ 0.005+ AVel*FTm end if VVAS > 1 then VVAS = 1 end
						local CAng = LerpAngle((0.003+ AVel*FTm)*VVAS, ply.VC_CnstAV, (Veh:GetAngles()- OV:GetAngles())+ Angle(VC_Settings.VC_ThirdPerson_Auto_Pitch,FAng,0))
						local PAng = ply:EyeAngles()- (ply.VC_CnstAV- CAng)
						ply:SetEyeAngles(Angle(PAng.p, PAng.y, ply:EyeAngles().r))
						ply.VC_CnstAV = Angle(CAng.p, CAng.y, ply:EyeAngles().r)
						ply.VC_LEASBC = ply:EyeAngles()
						ply.VC_LEAACT = 1
					end
				end

			if VC_Settings.VC_ThirdPerson_Dynamic and (VC_TPDA < 100 or VC_TPDV < 100) or VC_Settings.VC_MouseControl or VC_Settings.VC_ThirdPerson_Cam_World then
			local View, Fltr, APos, CFOV, APVD = {}, Veh, pos, fov, 250
			if !Veh.VC_CVTPVOU then local WSmin, WSmax = Veh:WorldSpaceAABB() local Size = WSmax - WSmin Veh.VC_CVTPVOO = (Size.x + Size.y + Size.z)* 0.31 Veh.VC_CVTPVOU = Size.z end APos = Veh:GetPos()+ ang:Up()* Veh.VC_CVTPVOU* 0.645 APVD = Veh.VC_CVTPVOO
				if VC_Settings.VC_MouseControl then
					if VC_View_LookingBehind and !vgui.CursorVisible() then
					if !ply.VC_TPVLB and VC_Settings.VC_ThirdPerson_Ang_Stf > 0 then ply.VC_TPVLB = ply.VC_CnstAV or ply:EyeAngles() ply.VC_TPVEAS = (Veh:GetAngles()- OV:GetAngles())+ Angle(0,-90,0) end
					elseif ply.VC_TPVLB then ply.VC_TPVEAS = ply.VC_TPVLB ply.VC_TPVLB = nil
					end
					if ply.VC_TPVEAS then
						if !MMvd and !VC_AngleInBounds(0.3, ply.VC_CnstAV or ply:EyeAngles(), ply.VC_TPVEAS) then
						local CAng = LerpAngle(0.3*FTm, ply.VC_CnstAV or ply:EyeAngles(), ply.VC_TPVEAS) local PAng = ply:EyeAngles()- (ply.VC_CnstAV- CAng) ply:SetEyeAngles(Angle(PAng.p, PAng.y, ply:EyeAngles().r))
						ply.VC_CnstAV = Angle(CAng.p, CAng.y, ply:EyeAngles().r) ply.VC_LEASBC = ply:EyeAngles()
						else ply.VC_TPVEAS = nil
						end
					end
					APVD = APVD* (ply.VC_TPVDM or 1)
				end
local HMlt = 1
if !IsNotPod then HMlt = HMlt+100 end
if VC_Settings.VC_ThirdPerson_Cam_Trl and IsValid(Veh:GetNWEntity("VC_HookedVh")) then
if !Veh.VC_TrlVwMult or Veh.VC_TrlVwMult < 1 then Veh.VC_TrlVwMult = math.Round(((Veh.VC_TrlVwMult or 0)+ 0.01*FTm)*100)/100 end
elseif Veh.VC_TrlVwMult then
if Veh.VC_TrlVwMult > 0 then Veh.VC_TrlVwMult = math.Round((Veh.VC_TrlVwMult- 0.01*FTm)*100)/100 else Veh.VC_TrlVwMult = nil end
end
if Veh.VC_TrlVwMult then APos = APos+ang:Up()*(HMlt)*Veh.VC_TrlVwMult if IsValid(Veh:GetNWEntity("VC_HookedVh")) then ply.VC_TrlAPos = Veh:GetNWEntity("VC_HookedVh"):LocalToWorld(Veh:GetNWEntity("VC_HookedVh"):OBBCenter()) ply.VC_TrlAPVD = math.Max(150, Veh:GetNWEntity("VC_HookedVh"):BoundingRadius()) end local VwMul = (math.sin(math.pi*(Veh.VC_TrlVwMult-0.5))+1)/2 APos = LerpVector(VwMul, APos, (APos+ ply.VC_TrlAPos)/2) APVD = APVD+ply.VC_TrlAPVD*VwMul*0.8 Fltr = {Veh, Veh:GetNWEntity("VC_HookedVh")} end

			if VC_Settings.VC_ThirdPerson_Dynamic then
			if VC_TPDA < 100 then local TAng = LerpAngle(VC_TPDA/100*FTm, ((ply.VC_CCAng or Veh:GetAngles())- Veh:GetAngles())+ ply:EyeAngles(), (ply.VC_CnstAV or ply:EyeAngles())) ply:SetEyeAngles(Angle(VC_Settings.VC_ThirdPerson_Ang_Pitch and TAng.p or ply:EyeAngles().p, TAng.y, ply:EyeAngles().r)) ply.VC_CCAng = Veh:GetAngles() ply.VC_LEASBC = ply:EyeAngles() else if ply.VC_CCAng then ply:SetEyeAngles(ply.VC_CnstAV or ply:EyeAngles()) ply.VC_CCAng = nil end end
			if VC_TPDV < 100 then APos = LerpVector(VC_TPDV/100*FTm, ply.VC_CnstVV or APos, APos) ply.VC_CnstVV = APos else ply.VC_CnstVV = nil end
			ply.VC_TPVDC = ply.VC_TPVDC or APVD*1.02
			else
			if ply.VC_CCAng then ply:SetEyeAngles(ply.VC_CnstAV or ply:EyeAngles()) ply.VC_CCAng = nil end ply.VC_CnstVV = nil
			end
				ply.VC_TPVDC = ply.VC_TPVDC or APVD if ply.VC_TPVDC > APVD+ 0.05 or ply.VC_TPVDC < APVD- 0.05 then ply.VC_TPVDC = Lerp(0.05*FTm, ply.VC_TPVDC, APVD) end
				local TTTr = util.TraceLine({start = APos, endpos = APos+ ang:Forward()* -ply.VC_TPVDC, filter = Fltr, mask = VC_Settings.VC_ThirdPerson_Cam_World and MASK_NPCWORLDSTATIC or nil})
				View.origin = TTTr.HitPos+ TTTr.HitNormal* (3+ ply.VC_TPVDC/600)
				return View
			end
		elseif ply.VC_TPRCU then
		ply.VC_APLBP = nil ply.VC_LEAACT = nil ply.VC_TPTCAS = nil ply.VC_TPVDC = nil ply.VC_CCAng = nil ply.VC_LEASBC = nil if ply.VC_CnstAV and IsValid(ply:GetVehicle()) then ply:SetEyeAngles(ply.VC_CnstAV) end ply.VC_CnstVV = nil ply.VC_CnstAV = nil ply.VC_TPRCU = false
		end
	elseif ply.VC_TPRCU then
	ply.VC_APLBP = nil ply.VC_LEAACT = nil ply.VC_TPTCAS = nil ply.VC_TPVDC = nil ply.VC_CCAng = nil ply.VC_LEASBC = nil if ply.VC_CnstAV and IsValid(ply:GetVehicle()) then ply:SetEyeAngles(ply.VC_CnstAV) end ply.VC_CnstVV = nil ply.VC_CnstAV = nil ply.VC_TPRCU = false
	end
end)

concommand.Add("vc_viewlookbehind", function(ply, cmd, arg) local HA = tonumber(arg[1]) if HA == 1 and !VC_View_LookingBehind then VC_View_LookingBehind = true elseif HA == 2 and VC_View_LookingBehind then VC_View_LookingBehind = false end end)

hook.Add("PlayerBindPress", "VC_BindPress", function(ply, bind)
	if VC_Settings.VC_Enabled and !vgui.CursorVisible() then
		if VC_Settings.VC_MouseControl and IsValid(ply:GetVehicle()) and (!ply:GetVehicle().VC_IsPrisonerPod or ply:GetVehicle():GetNWBool("VC_ExtraSt")) and ply:ShouldDrawLocalPlayer() and GetViewEntity() == LocalPlayer() then
		local InK = 0 if string.find(bind, "invprev") then InK = -0.1 elseif string.find(bind, "invnext") then InK = 0.1 end
		ply.VC_TPVDM = math.Clamp((ply.VC_TPVDM or 1)+ InK, 1, 2.5)
		end
		if !IsValid(ply:GetVehicle()) and string.find(bind, "use") and (!ply.VC_CheckVehicleEnter or CurTime() >= ply.VC_CheckVehicleEnter) then
		local tr = ply:GetEyeTraceNoCursor() if IsValid(tr.Entity) and tr.Entity:IsVehicle() and ply:GetShootPos():Distance(tr.HitPos) <= 75 then net.Start("VC_PlayerScanForSeats") net.WriteEntity(ply) net.WriteEntity(tr.Entity) net.WriteVector(tr.HitPos) net.SendToServer() end
		ply.VC_CheckVehicleEnter = CurTime()+0.5
		end
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
	ent.VC_IsPrisonerPod = ent.VC_Class == "prop_vehicle_prisoner_pod" ent.VC_IsNotPrisonerPod = !ent.VC_IsPrisonerPod
	ent.VC_IsAirboat = ent.VC_Class == "prop_vehicle_airboat"
	ent.VC_ExtraSeat = ent.VC_IsPrisonerPod and ent:GetNWBool("VC_ExtraSt")
	if LocalPlayer():IsAdmin() and !LocalPlayer().VC_Data_Update_Checked then GetVersions({{"vcmod1", VCMod1, "VCMod Main"}, {"vcmod1_els", VCMod1_ELS, "VCMod ELS"}}) LocalPlayer().VC_Data_Update_Checked = true end
	local MEnt = ent.VC_ExtraSeat and ent:GetParent() or ent local Atc = MEnt:LookupAttachment("vehicle_driver_eyes") if Atc != 0 then ent.VC_EyePos = MEnt:WorldToLocal(MEnt:GetAttachment(Atc).Pos) MEnt.VC_DoorLightPos = MEnt.VC_EyePos*Vector(0,1,1)+Vector(0,0,8) MEnt.VC_LeftSteer = MEnt.VC_EyePos.x < 0 end
	end
end

function VC_GetVehicle(ply)
	local ent, pos = ply:GetVehicle(), nil
	-- if !IsValid(ent) then ent = ply:GetEyeTraceNoCursor() pos = ent.HitPos ent = ent.Entity if !ent:IsVehicle() then if string.lower(ent:GetClass()) == "prop_physics" then else ent = nil end end end
	if !IsValid(ent) then ent = ply:GetEyeTraceNoCursor() pos = ent.HitPos ent = ent.Entity if !ent:IsVehicle() then ent = nil end end
	if ent and ent.VC_ExtraSeat then ent = ent:GetParent() end
	return ent, pos
end

function VC_IsDrawn() return IsValid(LocalPlayer():GetVehicle()) and LocalPlayer():GetVehicle():GetThirdPersonMode() end