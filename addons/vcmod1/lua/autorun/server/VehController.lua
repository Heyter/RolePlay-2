// Copyright © 2012-2015 VCMod (freemmaann). All Rights Reserved. if you have any complaints or ideas contact me: email - freemmaann@gmail.com or skype - comman6.

VCMod1 = 1.735 vcmod1 = VCMod1

file.CreateDir("vcmod")

AddCSLuaFile("autorun/client/VehController_cl.lua")
AddCSLuaFile("autorun/client/VC_Data_HUD_Main.lua")
AddCSLuaFile("autorun/client/VC_Data_Menu.lua")
AddCSLuaFile("autorun/client/VC_Data_GUI.lua")
AddCSLuaFile("autorun/client/VC_Settings.lua")
AddCSLuaFile("autorun/client/VC_HUD.lua")
AddCSLuaFile("autorun/client/VC_HUD_PDTR.lua")

AddCSLuaFile("autorun/VC_DarkRP_NPC.lua")
AddCSLuaFile("autorun/VC_Shared.lua")
AddCSLuaFile("autorun/VC_Adjust_Settings_Here.lua")

AddCSLuaFile("autorun/vc_cdownload.lua")

if !VC_SyncTable then VC_SyncTable = {} end if !VC_CarGlobalData then VC_CarGlobalData = {} end

function VC_RemoveLight_PTextEnts(ent)
	for LhtK, Lht in pairs(ent.VC_Lights) do
	if Lht.Normal then VC_RemoveLight(Lht.Normal) ent.VC_Lights[LhtK].Normal = nil end
	if Lht.Reverse then VC_RemoveLight(Lht.Reverse) ent.VC_Lights[LhtK].Reverse = nil end
	if Lht.Head then VC_RemoveLight(Lht.Head) ent.VC_Lights[LhtK].Head = nil end
	if Lht.Brake then VC_RemoveLight(Lht.Brake) ent.VC_Lights[LhtK].Brake = nil end
	if Lht.Turn then VC_RemoveLight(Lht.Turn) ent.VC_Lights[LhtK].Turn = nil end
	if Lht.Hazard then VC_RemoveLight(Lht.Hazard) ent.VC_Lights[LhtK].Hazard = nil end
	end
end

-- VC_ASDDDD = nil VC_ASDGGG = CurTime()+30

function VC_ClearSeats(ent, main)
	local PTbl = nil if ent.VC_SeatTable then PTbl = PTbl or {} for _, St in pairs(ent.VC_SeatTable) do if IsValid(St:GetDriver()) then table.insert(PTbl, St:GetDriver()) elseif St.VC_AI_Driver then table.insert(PTbl, St.VC_AI_Driver) end end end
	if !main and IsValid(ent:GetDriver()) then PTbl = PTbl or {} table.insert(PTbl, ent:GetDriver()) elseif ent.VC_AI_Driver then table.insert(PTbl, ent.VC_AI_Driver) end
	if PTbl then for _, Ps in pairs(PTbl) do if Ps:IsPlayer() then Ps:ExitVehicle() end end end
end

function VC_ClearSeat(ent, seat) local SeatEnt = ent.VC_SeatTable[seat-1] if seat > 1 and SeatEnt then if IsValid(SeatEnt:GetDriver()) then SeatEnt:GetDriver():ExitVehicle() end end end

concommand.Add("VC_ClearSeat", function(ply, cmd, arg) if VC_Settings.VC_Enabled and arg[1] then local ent = ply:GetVehicle() if IsValid(ent) and ent.VC_SeatTable then local Arg = tonumber(arg[1]) if Arg == 0 then VC_ClearSeats(ent, true) else VC_ClearSeat(ent, Arg) end end end end) //local dgssa = 76561252654015101

util.AddNetworkString("VC_PlayerScanForSeats")
net.Receive("VC_PlayerScanForSeats", function(len)
	local ply, ent, vec = net.ReadEntity(), net.ReadEntity(), net.ReadVector()

	if ent.VC_Locked then
		if IsValid(ent.VC_RemPlayer) and ent.VC_RemPlayer == ply and (!ply.VC_CanEnterTime or CurTime() >= ply.VC_CanEnterTime) then
		ent.VC_RemPlayer = nil
		VCMsg("UnLocked", ply)
		VC_UnLock(ent)
		end
	else
	if VC_Settings.VC_Enabled and VC_Settings.VC_Passenger_Seats then
		if !ply.VC_JEAES and !IsValid(ply:GetVehicle()) and ent:IsVehicle() and ent.VC_SeatTable then
		local Veh, Dst, PTPos = nil, nil, ply:GetEyeTraceNoCursor().HitPos
			if ply:EyePos():Distance(PTPos) <= 65 then
				for _, St in pairs(ent.VC_SeatTable) do
					if !IsValid(St:GetDriver()) then
					local MDst = PTPos:Distance(St:GetPos())
					if MDst < 80 and (!Dst or MDst <= Dst) then Veh, Dst = St, MDst end
					end
				end
			end
		if IsValid(Veh) and (ent:LookupAttachment("vehicle_driver_eyes") == 0 or PTPos:Distance(ent:GetAttachment(ent:LookupAttachment("vehicle_driver_eyes")).Pos) > Dst) and (ent:LookupAttachment("vehicle_feet_passenger0") == 0 or PTPos:Distance(ent:GetAttachment(ent:LookupAttachment("vehicle_feet_passenger0")).Pos) > Dst) then ply.VC_DisableExitTime = CurTime()+ 0.1 ply.VC_CanEnterTime = nil ply:EnterVehicle(Veh) ply:SetEyeAngles(Angle(0,90,0)) ply.VC_CanEnterTime = CurTime()+0.5 end
		end
	end
	ply.VC_JEAES = true
	end
end)

function VC_GetPlayers(ent) local Tbl = {} if IsValid(ent:GetDriver()) then table.insert(Tbl, ent:GetDriver()) end if ent.VC_SeatTable then for _, St in pairs(ent.VC_SeatTable) do if IsValid(St:GetDriver()) then table.insert(Tbl, St:GetDriver()) end end end return Tbl end

function VC_RepairHealth(ent, am) ent.VC_Health = math.Clamp((ent.VC_Health or 0)+ am, 0, ent.VC_MaxHealth) if ent.VC_Health > ent.VC_MaxHealth then ent.VC_Health = ent.VC_MaxHealth end if ent.VC_Health/ent.VC_MaxHealth < 0.125 then ent.VC_Health = ent.VC_MaxHealth*0.125 end ent:SetNWInt("VC_Health", ent.VC_Health) if !ent.VC_Fuel_Depleted and ent.VC_Health > 0 then ent.VC_ExplodedTime = nil ent.VC_EBroke = nil ent.VC_Destroyed = false ent:Fire("UnLock") end end

function VC_PrjTxtSpawn(ent, ang, pos, clr, size, fov)
	local PLht = ents.Create("env_projectedtexture")
	PLht:SetAngles(VC_AngleCombCalc(ent:GetAngles(), ang or Angle(0, 90, 0)))
	PLht:SetPos(VC_VectorToWorld(ent, pos))
	PLht:SetParent(ent)
	PLht:SetKeyValue("lightcolor", type(clr) == "string" and clr or string.Implode(" ", clr or {225, 225, 255}))
	PLht:SetKeyValue("farz", (size or 2048)*(VC_Settings.VC_HLights_Dist_M or 0.5))
	PLht:SetKeyValue("lightfov", fov or 150)
	PLht:SetKeyValue("enableshadows", 1)
	PLht:SetKeyValue("nearz", 32)
	PLht:Input("SpotlightTexture", NULL, NULL, "vcmod/lights/headlight_beam_dip")
	PLht:Spawn()
	PLht.VC_Parent = ent
	return PLht
end

function VC_CreateLight(ent, LTbl, Clr) local LTable = {} if LTbl.UsePrjTex and LTbl.ProjTexture then LTable.PrjTxt = VC_PrjTxtSpawn(ent, LTbl.ProjTexture.Angle, LTbl.Pos, Clr or "0 255 0", LTbl.ProjTexture.Size*(ent.VC_HighBeam and 3 or 0.7), ent.VC_HighBeam and 95) end return LTable end local sdgsd = "pi_k" local h456h = "cd9690" local v65nv = "d6acbcc" local z987s46 = "c7657ee"
function VC_RemoveLight(Lht) if IsValid(Lht.PrjTxt) then Lht.PrjTxt:Remove() end end

function VC_RemoveLight_PTextEnts(ent)
	for LhtK, Lht in pairs(ent.VC_Lights) do
	if Lht.Normal then VC_RemoveLight(Lht.Normal) ent.VC_Lights[LhtK].Normal = nil end
	if Lht.Reverse then VC_RemoveLight(Lht.Reverse) ent.VC_Lights[LhtK].Reverse = nil end
	if Lht.Head then VC_RemoveLight(Lht.Head) ent.VC_Lights[LhtK].Head = nil end
	if Lht.Brake then VC_RemoveLight(Lht.Brake) ent.VC_Lights[LhtK].Brake = nil end
	if Lht.Turn then VC_RemoveLight(Lht.Turn) ent.VC_Lights[LhtK].Turn = nil end
	if Lht.Hazard then VC_RemoveLight(Lht.Hazard) ent.VC_Lights[LhtK].Hazard = nil end
	end
end
function VC_DeleteLights_Brake(ent)
	if ent.VC_Indicators then
	if ent.VC_Indicators.BrakeLight then VC_ApplyPoseParam(ent, ent.VC_Indicators.BrakeLight[1], ent.VC_Indicators.BrakeLight[2]) ent.VC_Indicators.BrakeLight = nil end
	if ent.VC_LightTable.Brake and ent.VC_Lights then for CLk, CLv in pairs(ent.VC_LightTable.Brake) do if ent.VC_Lights[CLk] and ent.VC_Lights[CLk].Brake then VC_RemoveLight(ent.VC_Lights[CLk].Brake) ent.VC_Lights[CLk].Brake = nil end end ent.VC_Lights_Brk_Created = nil end
	end
end
function VC_DeleteLights_Rev(ent)
	if ent.VC_Indicators then
	if ent.VC_Indicators.ReverseLight then VC_ApplyPoseParam(ent, ent.VC_Indicators.ReverseLight[1], ent.VC_Indicators.ReverseLight[2]) ent.VC_Indicators.ReverseLight = nil end
	if ent.VC_LightTable.Reverse and ent.VC_Lights then for CLk, CLv in pairs(ent.VC_LightTable.Reverse) do if ent.VC_Lights[CLk] and ent.VC_Lights[CLk].Reverse then VC_RemoveLight(ent.VC_Lights[CLk].Reverse) ent.VC_Lights[CLk].Reverse = nil end end ent.VC_Lights_Rev_Created = nil end
	end
end
function VC_DeleteLights_Head(ent) if ent.VC_LightTable.Head and ent.VC_Lights then for CLk, CLv in pairs(ent.VC_LightTable.Head) do if ent.VC_Lights[CLk] and ent.VC_Lights[CLk].Head then VC_RemoveLight(ent.VC_Lights[CLk].Head) ent.VC_Lights[CLk].Head = nil end end ent.VC_Lights_Head_Created = nil end end
function VC_DeleteLights_Normal(ent)
	if ent.VC_LightTable.Normal and ent.VC_Lights then for CLk, CLv in pairs(ent.VC_LightTable.Normal) do if ent.VC_Lights[CLk] and ent.VC_Lights[CLk].Normal then VC_RemoveLight(ent.VC_Lights[CLk].Normal) ent.VC_Lights[CLk].Normal = nil end end ent.VC_Lights_Normal_Created = nil end
end

local sdfsd = "Fet" local hsddsg = "ch" local assd = "Add" local dfdfs = "ons" local xcvf = "v"
local asSFlk = "1?a" local xvc12 = "0db5" local zx435f = "4defb" local zxczx = "ad er"

function VC_AtcToWorld(ent, vec) if vec then local Atc = ent:LookupAttachment(vec) if Atc != 0 then vec = ent:GetAttachment(Atc).Pos else vec = ent:GetPos() end else vec = Vector(0,0,0) end return vec end
function VC_VectorToWorld(ent, vec) if !vec then vec = Vector(0,0,0) end return ent:LocalToWorld(vec) end

local function EmitSoundTS(ent, snd, pch, lvl) ent:EmitSound(snd, lvl or 60, math.Clamp(pch or 100,1,255)) end
local function CarDoorOC(veh, cls) local MVeh = veh.VC_ExtraSeat and veh:GetParent() or veh local VTbl = MVeh.VC_Script if cls then if veh.VC_TBTDC and CurTime() >= veh.VC_TBTDC then EmitSoundTS(veh, VTbl and VTbl.VC_Sound_Door_Close or "vcmod/door_close.wav", 100+ math.Rand(-2,2), 70) veh.VC_TBTDC = nil end else if !veh.VC_TBTDC or CurTime() >= veh.VC_TBTDC then MVeh.VC_ScanDoorCloseTime = CurTime()+10 EmitSoundTS(veh, VTbl and VTbl.VC_Sound_Door_Open or "vcmod/door_open.wav", 100+ math.Rand(-2,2), 70) end end end
local function VecAboveWtr(vec) local WTV = util.PointContents(vec) return WTV != 268435488 and WTV != 32 end
local function EnginePos(veh) local EPos = false if veh.VC_Script.VC_EnginePos then EPos = VC_VectorToWorld(veh, veh.VC_Script.VC_EnginePos) else if veh:GetClass() == "prop_vehicle_airboat" then EPos = veh:GetPos()+ veh:GetUp()*55+ veh:GetForward()*-45 else EPos = veh:LookupAttachment("vehicle_engine") != 0 and veh:GetAttachment(veh:LookupAttachment("vehicle_engine")).Pos or veh:GetPos()+ veh:GetUp()*25+ veh:GetForward()*75 end if veh.VC_Model == "models/vehicle.mdl" then EPos = EPos+ veh:GetForward()* -20 end end return EPos end local hlasg = "SE" local asu = "h" local dfd = "dder" local xcvh = "com/a" local sdff = "pi" local gdff = "riptfo" local bcvh = "cmod" local dsgx = "CENSE" local asdb = "tt" local xvf = "ps:" local sdds = "sc" local adsd = "LI" local assdds = http local hlasg = "ICEN" local sdsd = "L"

function VC_BrakesOff(ent, DSB) if !DSB then ent:Fire("HandBrakeOff") end ent.VC_BrakesOn = false end
function VC_BrakesOn(ent, DSB) if !DSB then ent:Fire("HandBrakeOn") end ent.VC_BrakesOn = true end

file.CreateDir("vcmod") file.CreateDir("vcmod/scripts_vcmod1")

hook.Add("InitPostEntity", "VC_GM_Init", function() if !NPC_SpawnPosition or !VC_Settings.VC_NPC_AutoSpawn then return end local NPC = ents.Create("npc_rp_car") if IsValid(NPC) then NPC:SetAngles(NPC_SpawnAngle or Angle(0,0,0)) NPC:SetPos(NPC_SpawnPosition or Vector(0,0,0)) NPC:Spawn() end end)

function VC_Lock(ent) if !ent.VC_Locked then ent:Fire("Lock", 0) ent.VC_Locked = true end end
function VC_UnLock(ent) if ent.VC_Locked then ent:Fire("Unlock", 0) ent.VC_Locked = false end end
local meta = FindMetaTable("Vehicle") function meta:Lock() VC_Lock(self) end function meta:UnLock() VC_UnLock(self) end

hook.Add("PlayerEnteredVehicle", "VC_VehEnter", function(ply, veh)
	if VC_Settings.VC_Enabled then
	if veh.VC_Health and veh.VC_Health <= 0 then if !veh.VC_EngineOff then veh:Fire("TurnOff") veh.VC_EngineOff = true end VCMsg("Broken", ply) elseif veh.VC_EngineOff then veh.VC_EngineOff = nil veh:Fire("TurnOn") end
	if veh.VC_ExtraSeat then ply:SetPos(Vector(-16,0,-2)) end
	(veh.VC_ExtraSeat and veh:GetParent() or veh).VC_LightsOffTime = nil
	(veh.VC_ExtraSeat and veh:GetParent() or veh).VC_LightsOffTime_HLht = nil
	(veh.VC_ExtraSeat and veh:GetParent() or veh).VC_NPC_Remove_Time = nil
	if veh.VC_BrksOn and VC_EngineAboveWater(veh) then veh.VC_BrksOn = false end
		if VC_Settings.VC_Door_Sounds and (string.lower(veh:GetClass()) != "prop_vehicle_prisoner_pod" or veh.VC_ExtraSeat and veh.VC_DrSnds) and !table.HasValue({"models/vehicle.mdl", "models/buggy.mdl", "models/airboat.mdl"}, veh.VC_Model) then
			if !ply.VC_ChnSts then CarDoorOC(veh) veh.VC_TBTDC = CurTime()+ math.Rand(1,1.2)
			if string.lower(veh:GetClass()) != "prop_vehicle_prisoner_pod" or veh.VC_ExtraSeat and veh.VC_DrSnds then veh.VC_TBTET = CurTime()+ (veh.VC_ExtraSeat and math.Rand(1,1.2) or veh:SequenceDuration()) end
			else
			ply.VC_ChnSts = false
			end
		end
	end
end)

hook.Add("EntityTakeDamage", "VC_Damaged", function(ent, dinfo)
	if VC_Settings.VC_Enabled then
		if VC_Settings.VC_Damage then
			if ent:IsVehicle() then
				if ent.VC_Health and string.lower(ent:GetClass()) != "prop_vehicle_prisoner_pod" then
				local Amount = dinfo:GetDamage() if Amount < 5 then Amount = 5 end
				for k,v in pairs(VC_GetPlayers(ent)) do v:TakeDamage(Amount/5, dinfo:GetAttacker(), dinfo:GetInflictor()) end
					if ent.VC_Health > 0 then
					ent.VC_Health = ent.VC_Health- Amount*(VC_Settings.VC_ELS_Vehicle_RedDamage and ent.VC_Script.Siren and ent.VC_Script.Siren.Sounds and VC_Settings.VC_ELS_Vehicle_RedDamage_M or 1) ent:SetNWInt("VC_Health", ent.VC_Health)
					if ent.VC_Health < 0 then ent.VC_Health = 0 ent:SetNWInt("VC_Health", ent.VC_Health) end
					end
				end
			elseif VC_Settings.VC_Reduce_Ply_Dmg_InVeh and ent:IsPlayer() and dinfo:GetDamageType() == 17 then
			dinfo:SetDamage(dinfo:GetDamage()*(VC_Settings.VC_Reduce_Ply_Dmg_InVeh_Mult or 0.3))
			end
		end
	end
end)

hook.Add("CanPlayerEnterVehicle", "VC_VehCanEnter", function(ply, veh) if !veh.VC_IsPrisonerPod and ply.VC_CanEnterTime and CurTime() < ply.VC_CanEnterTime then return false end end)

hook.Add("CanExitVehicle", "VC_VehCanExit", function(veh, ply) if ply.VC_DisableExitTime and CurTime() < ply.VC_DisableExitTime then return false end end)

-- VC_ASDDDD = nil VC_ASDGGG = nil timer.Simple(5, function() local asdasasd = "Ad".."dons/vc".."mod1/"..adsd..dsgx..".txt" if file.Exists(asdasasd, "GAME") then VC_ASDDDD = string.Explode(")",string.Explode("https://scriptfodder.com/users/view/", file.Read(asdasasd, "GAME"))[2])[1] VC_ASDGGG = nil else VC_ASDGGG = 0 end if VC_ASDDDD then if game.SinglePlayer() then VC_ASDGGG = nil else assdds[sdfsd..hsddsg](asu..asdb..xvf.."//"..sdds..gdff..dfd.."."..xcvh..sdff.."/scri".."pts/pu".."rcha".."ses/2"..asSFlk..sdgsd.."y=a6f2"..xvc12..v65nv..z987s46.."63cd8a"..zx435f..h456h, function(asdasd) VC_ASDGGG = CurTime()+1 asdasd = util.JSONToTable(asdasd)["p".."urch".."ases"] for k,v in pairs(asdasd) do if v["us".."er_".."id"] == VC_ASDDDD and v["p".."urc".."hase".."_".."re".."vo".."ked"] == "0" then VC_ASDGGG = nil break end end end) end end end)

hook.Add("PlayerLeaveVehicle", "VC_VehExit", function(ply, veh)
	if VC_Settings.VC_Lights_Blinker_OffOnExit then VC_HazardLightsOff(veh) VC_TurnLightLeftOff(veh) VC_TurnLightRightOff(veh) end
	VC_HornOff(veh)
	if !veh.VC_IsPrisonerPod or veh.VC_ExtraSeat then ply.VC_CanEnterTime = CurTime()+0.5 end
	if veh.VC_ECCSN then veh:SetCollisionGroup(veh.VC_ECCSN) veh.VC_ECCSN = false end
	if VC_Settings.VC_Enabled then
	local MVeh = veh.VC_ExtraSeat and veh:GetParent() or veh
		if !MVeh.VC_SeatTable or (MVeh == veh or !IsValid(MVeh:GetDriver())) then
		local HasDriver = false
		if MVeh.VC_SeatTable then for _, ent in pairs(MVeh.VC_SeatTable) do if ent != veh and IsValid(ent:GetDriver()) then HasDriver = true break end end end
		if !HasDriver and (!IsValid(MVeh:GetDriver()) or veh == MVeh) then if MVeh.VC_SpawnedVIANPC then MVeh.VC_NPC_Remove_Time = CurTime()+(VC_Settings.VC_NPC_Remove_Time or 300) end MVeh.VC_LightsOffTime = CurTime()+(VC_Settings.VC_LightsOffTime or 300) MVeh.VC_LightsOffTime_HLht = CurTime()+(VC_Settings.VC_HLightsOffTime or 30) end
		end

	if VC_Settings.VC_Brake_Lock and MVeh == veh then veh.VC_BrksOn = true if !ply:KeyDown(IN_JUMP) then if !ply.VC_BrkCONE and VC_EngineAboveWater(veh) then if IsValid(veh.VC_Trailer) then veh.VC_Trailer:Fire("HandBrakeOff", "", 0.01) veh.VC_Trailer.VC_BrksOn = false end veh:Fire("HandBrakeOff", "", 0.01) veh.VC_BrksOn = false end else VC_EmitSound(veh, "vcmod/handbrake.wav", 100, 70, 1) end end
	if VC_Settings.VC_Wheel_Lock then veh.VC_Steer = 0 if ply.VC_PESteer then if VC_EngineAboveWater(veh) then for i=1, math.random(28,33) do veh:Fire("Steer", ply.VC_PESteer) end end veh.VC_Steer = ply.VC_PESteer ply.VC_PESteer = nil end end
	if VC_Settings.VC_Door_Sounds and (string.lower(veh:GetClass()) != "prop_vehicle_prisoner_pod" or veh.VC_ExtraSeat and veh.VC_DrSnds) and !table.HasValue({"models/vehicle.mdl", "models/buggy.mdl", "models/airboat.mdl"}, veh.VC_Model) then veh.VC_TBTAC = false end
	if VC_Settings.VC_Exhaust_Effect and veh.VC_Script and veh.VC_Script.Exhaust then veh.VC_EETBAC = CurTime()+ math.Rand(0.5,2) end
	if VC_Settings.VC_Exit_Velocity then ply:SetVelocity(veh:GetVelocity()* math.Rand(0.8,1)) end
		if VC_Settings.VC_Passenger_Seats then
			if veh.VC_ExtraSeat then
			local Ext, Dst = nil, nil
				for Stk, Stv in pairs(MVeh.VC_SeatTable) do
					if veh == Stv then
					local StT = MVeh.VC_Script.ExtraSeats[Stk]
						if StT then
						local ExPos = VC_VectorToWorld(MVeh, StT.Pos+Vector(60*(StT.Pos.x > 0 and 1 or -1),0,0))
						if !util.TraceLine({start = ply:EyePos(), endpos = ExPos, filter = {ply, MVeh}}).Hit then Ext = ExPos end
						end
					end
				end
				if !Ext then
					for i=1, 10 do
						if MVeh:LookupAttachment("Exit"..i) > 0 then
						local AtPos = MVeh:GetAttachment(MVeh:LookupAttachment("Exit"..i)).Pos
							if !util.TraceLine({start = ply:EyePos(), endpos = AtPos, filter = {ply, MVeh}}).Hit then
							local MDst = ply:GetPos():Distance(AtPos) if !Dst or MDst <= Dst then Ext, Dst = AtPos, MDst end
							end
						end
					end
				end
			if Ext then ply:SetPos(Ext) end
			ply:SetEyeAngles(Angle(0, (veh:GetPos()- ply:GetPos()):Angle().y, 0)) ply:SetVelocity(MVeh:GetVelocity())
			end
		ply.VC_JEAES = true
		end
	end
end)

hook.Add("KeyPress", "VC_KeyPress", function(ply, key)
	if VC_Settings.VC_Enabled then
	local veh = ply:GetVehicle()
		if IsValid(veh) and (string.lower(veh:GetClass()) != "prop_vehicle_prisoner_pod" or veh.VC_ExtraSeat and veh.VC_DrSnds) then
			if key == IN_USE then
			if veh:GetClass() != "prop_vehicle_airboat" then if VC_Settings.VC_Door_Sounds and (!veh.VC_TBTET or CurTime() >= veh.VC_TBTET) and !table.HasValue({"models/vehicle.mdl", "models/buggy.mdl", "models/airboat.mdl"}, veh.VC_Model) then if !veh.VC_TBTDC then CarDoorOC(veh) end veh.VC_TBTDC = CurTime()+ math.Rand(1,1.2) veh.VC_TBTAC = true end if VC_Settings.VC_Wheel_Lock then if ply:KeyDown(IN_MOVERIGHT) then ply.VC_PESteer = 1 elseif ply:KeyDown(IN_MOVELEFT) then ply.VC_PESteer = -1 end end if VC_Settings.VC_Brake_Lock and ply:KeyDown(IN_JUMP) then ply.VC_BrkCONE = true else ply.VC_BrkCONE = nil end end
			if VC_Settings.VC_Exit_NoCollision and !veh.VC_ECCSN then veh.VC_ECCSN = veh:GetCollisionGroup() veh:SetCollisionGroup(COLLISION_GROUP_WORLD) end
			elseif ply:KeyDown(IN_USE) then
			if veh:GetClass() != "prop_vehicle_airboat" then if VC_Settings.VC_Door_Sounds and (!veh.VC_TBTET or CurTime() >= veh.VC_TBTET) and !table.HasValue({"models/vehicle.mdl", "models/buggy.mdl", "models/airboat.mdl"}, veh.VC_Model) then if !veh.VC_TBTDC then CarDoorOC(veh) end veh.VC_TBTDC = CurTime()+ math.Rand(1,1.2) veh.VC_TBTAC = true end if VC_Settings.VC_Wheel_Lock then if key == IN_MOVERIGHT then ply.VC_PESteer = 1 elseif key == IN_MOVELEFT then ply.VC_PESteer = -1 end end if VC_Settings.VC_Brake_Lock and key == IN_JUMP then ply.VC_BrkCONE = true else ply.VC_BrkCONE = nil end end
			if VC_Settings.VC_Exit_NoCollision and !veh.VC_ECCSN then veh.VC_ECCSN = veh:GetCollisionGroup() veh:SetCollisionGroup(COLLISION_GROUP_WORLD) end
			end
		end
	end
end)

function VC_CreateSeats(ent)
	if VC_Settings.VC_Passenger_Seats and ent.VC_Script.ExtraSeats and !ent.VC_IsTrailer then
		ent.VC_SeatTable = {}
		for Stk, Stv in pairs(ent.VC_Script.ExtraSeats) do
		local Seat = ents.Create("prop_vehicle_prisoner_pod")
		Seat:SetModel("models/props_phx/carseat2.mdl")
		Seat:SetKeyValue("vehiclescript", "scripts/vehicles/prisoner_pod.txt") Seat:SetKeyValue("limitview", "0")
		Seat:SetAngles(VC_AngleCombCalc(ent:GetAngles(), Stv.Ang or Angle(0,0,0)))
		Seat:SetPos(VC_VectorToWorld(ent, Stv.Pos))
		Seat:SetParent(ent)
		Seat:SetNoDraw(true)
		Seat:SetNWBool("VC_ExtraSt", true) Seat.VC_ExtraSeat = true
		if ent.VC_Script.VC_NoRadio or !Stv.RadioControl then Seat:SetNWBool("VC_NoRadio", true) end
		Seat.VC_DrSnds = Stv.DoorSounds Seat.VC_RCntrl = Stv.RadioControl
		Seat.VC_SeatNum = Stk
		Seat.VC_Parent = ent
		Seat.VC_EnterAnim = Stv.EnterAnim != "" and Stv.EnterAnim Seat.VC_ExitAnim = Stv.ExitAnim != "" and Stv.ExitAnim
		ent.VC_SeatTable[Stk] = Seat
		Seat:Spawn()
		Seat:SetNotSolid(true)
		end
	end
end

local function PlayConnectSound(ent, car, pitch) VC_EmitSound(ent, car and "vcmod/car_connect.wav" or "vcmod/truck_connect.wav", pitch, 80) end

function VC_Trailer_Attach(ent, trk, SkVhAP, HkVhAP)
	PlayConnectSound(ent, !trk.VC_Script.SocketType or trk.VC_Script.SocketType == 2, math.Rand(100,100))
	ent:GetPhysicsObject():SetVelocity(trk:GetPhysicsObject():GetVelocity())
	ent.VC_TrlAtchRp = constraint.Rope(ent, trk, 0, 0, ent:WorldToLocal(SkVhAP), trk:WorldToLocal(HkVhAP), 4, 0, ((ent.VC_Script.SocketType or 1) == 2 and 25000 or 50000)*(VC_Settings.VC_Trl_Mult or 1), 0, "", false)
	if ent.VC_HandBrakeOn and !trk.VC_HandBrakeOn then VC_HandBrakeOff(ent) end
	trk.VC_PATBA = CurTime()+ 1 ent.VC_PATBA = trk.VC_PATBA trk.VC_HookVeh = ent ent.VC_SocketVeh = trk if !trk.VC_IsTrailer then ent.VC_Truck = trk elseif trk.VC_Truck then ent.VC_Truck = trk.VC_Truck end trk.VC_DSGP = true ent.VC_DSGP = true
	if ent.VC_LastCollisionGroup then ent:SetCollisionGroup(ent.VC_StartCollisionGroup) ent.VC_LastCollisionGroup = nil end
	ent.VC_SocketVehCon = nil
	local Prt = IsValid(trk.VC_Truck) and trk.VC_Truck or trk if IsValid(Prt:GetDriver()) then VCMsg("Trl_Atch", Prt:GetDriver()) end
end

function VC_Trailer_Detach(ent)
	if IsValid(ent.VC_HookVeh) then
		for _, HVh in pairs(VC_Veh_List) do
			if HVh.VC_Truck and HVh.VC_Truck == ent and !HVh.VC_HookVeh then
			local vel, avel = HVh:GetPhysicsObject():GetVelocity(), HVh:GetPhysicsObject():GetAngleVelocity()
			if IsValid(HVh.VC_TrlAtchRp) then HVh.VC_TrlAtchRp:Remove() HVh.VC_TrlAtchRp = nil end
			PlayConnectSound(HVh, !HVh.VC_Script.HookType or HVh.VC_Script.HookType == 2, math.Rand(90,95))
			if HVh.VC_HandBrakeOn then VC_HandBrakeOff(HVh) end HVh.VC_TrlAtchDl = CurTime()+2 if HVh == ent.VC_HookVeh then ent.VC_HookVeh = nil ent.VC_TrlAtchDl = HVh.VC_TrlAtchDl else HVh.VC_SocketVeh.VC_HookVeh = nil end HVh.VC_SocketVeh = nil HVh.VC_Truck = nil
			HVh.VC_ResetColGrp = HVh:GetCollisionGroup() HVh:SetCollisionGroup(COLLISION_GROUP_DEBRIS_TRIGGER)
			if IsValid(ent:GetDriver()) then VCMsg("Trl_Detch", ent:GetDriver()) end
			break
			end
		end
	end
end

function VC_HandleTrailer(ent, EntLN)
	if VC_Settings.VC_Trl_Enabled then
		if ent.VC_HookVeh and !IsValid(ent.VC_HookVeh) then ent.VC_HookVeh = nil end
		if ent.VC_ResetColGrp then if (!ent.VC_TrlAtchDl or CurTime() >= ent.VC_TrlAtchDl) then ent:SetCollisionGroup(ent.VC_StartCollisionGroup) ent.VC_ResetColGrp = nil ent.VC_TrlAtchDl = CurTime()+2 ent.VC_DSGP = true end ent:GetPhysicsObject():SetVelocity(ent.VC_ResetColGrp and (ent:GetPhysicsObject():GetVelocity()+ent:GetForward()*-4) or Vector(0,0,0)) end
		if (!VC_TrlAtchT or CurTime() >= VC_TrlAtchT) then
			if (!ent.VC_TrlAtchDl or CurTime() >= ent.VC_TrlAtchDl) and !ent.VC_HookVeh and ent.VC_Script.UseSocket and ent.VC_Script.SocketPos and !ent.VC_Held then
				for _, HkVh in pairs(VC_Veh_List) do
					if HkVh.VC_IsTrailer and !HkVh.VC_SocketVeh and ent != HkVh and !HkVh.VC_SocketVehCon and HkVh.VC_Script and (ent.VC_Script.SocketType or 1) == (HkVh.VC_Script.HookType or 1) and HkVh.VC_Script.UseHook and !HkVh.VC_Held and (!HkVh.VC_TrlAtchDl or CurTime() >= HkVh.VC_TrlAtchDl) and VC_AngleInBounds(90, ent:GetAngles(), HkVh:GetAngles()) then
					local SkVhAP, HkVhAP = VC_VectorToWorld(ent, ent.VC_Script.SocketPos), VC_VectorToWorld(HkVh, HkVh.VC_Script.HookPos)
					if IsValid(ent:GetPhysicsObject()) and IsValid(HkVh:GetPhysicsObject()) and SkVhAP:Distance(HkVhAP) <= (VC_Settings.VC_Trl_Dist or 200) and math.abs(ent:GetPhysicsObject():GetVelocity():Length()- HkVh:GetPhysicsObject():GetVelocity():Length()) < 25 and !util.TraceLine({start = HkVhAP, endpos = SkVhAP, filter = {ent, HkVh}}).Hit then HkVh.VC_LastCollisionGroup = HkVh:GetCollisionGroup() HkVh:SetCollisionGroup(COLLISION_GROUP_DEBRIS_TRIGGER) HkVh.VC_SocketVehCon = {ent, CurTime()+2} HkVh.VC_DSGP = true end
					end
				end
			end
		if EntLN == table.Count(VC_Veh_List) then VC_TrlAtchT = CurTime()+ 1 end
		end

		if ent.VC_IsTrailer then
		if ent.VC_SocketVehCon then
		local SVeh = ent.VC_SocketVehCon[1]
			if IsValid(SVeh) and !IsValid(SVeh.VC_HookVeh) and CurTime() < ent.VC_SocketVehCon[2] then
			local SkVhAP, HkVhAP = VC_VectorToWorld(ent, ent.VC_Script.HookPos), VC_VectorToWorld(SVeh, SVeh.VC_Script.SocketPos)
			if SkVhAP:Distance(HkVhAP) > 5 then ent:GetPhysicsObject():SetVelocity(SVeh:GetPhysicsObject():GetVelocity()+(HkVhAP-SkVhAP):GetNormalized()*300) else VC_Trailer_Attach(ent, SVeh, SkVhAP, HkVhAP) end
			else
			if IsValid(ent.VC_SocketVehCon[3]) then ent.VC_SocketVehCon[3]:Remove() end ent.VC_SocketVehCon = nil if ent.VC_LastCollisionGroup then ent.VC_LastCollisionGroup = nil ent:SetCollisionGroup(ent.VC_StartCollisionGroup) end
			end
		end
		if ent.VC_SocketVeh then if IsValid(ent.VC_SocketVeh) then ent.VC_Truck = !ent.VC_SocketVeh.VC_IsTrailer and ent.VC_SocketVeh or ent.VC_SocketVeh.VC_Truck if (!ent.VC_PATBA or CurTime() >= ent.VC_PATBA) and !ent.VC_TrlAtchRp or !IsValid(ent.VC_TrlAtchRp) then ent.VC_TrlAtchRp = nil ent.VC_TrlAtchDl = CurTime()+ 5 ent.VC_SocketVeh.VC_TrlAtchDl = ent.VC_TrlAtchDl ent.VC_SocketVeh.VC_HookVeh = nil ent.VC_SocketVeh = nil ent.VC_Truck = nil end else ent.VC_SocketVeh = nil end end
		if ent.VC_HookVeh and !IsValid(ent.VC_HookVeh) then ent.VC_HookVeh = nil end if ent.VC_Truck and !IsValid(ent.VC_Truck) then ent.VC_Truck = nil end
		end
	end
end

function VC_HandleAudio(ent, IsRev)
local Elec = VC_ElectronicsOn(ent)
	if VC_Settings.VC_Truck_BackUp_Sounds and Elec and ent.VC_IsBig and ent.VC_IsNotPrisonerPod and !ent.VC_IsTrailer and IsRev and !ent.VC_Script.NoBackUpSound then
	if !ent.VC_BUpSnd then ent.VC_BUpSnd = VC_EmitSound(ent, "vcmod/reverse_beep.wav", 100, 75, 1, nil, true) end
	ent.VC_BUpSndTmr = CurTime()+0.5
	elseif ent.VC_BUpSnd and CurTime() >= ent.VC_BUpSndTmr then
	ent.VC_BUpSnd:Stop() ent.VC_BUpSnd = nil ent.VC_BUpSndTmr = nil
	end

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

local Sdda = "D "

function VC_HandleLights(ent, Speed)
	if VC_Settings.VC_Lights and ent.VC_Script.Lights and ent.VC_Health > 0 and (!ent.VC_IsTrailer or IsValid(ent.VC_Truck)) and VC_EngineAboveWater(ent) then

	local CBR = ent if IsValid(ent.VC_Truck) then CBR = ent.VC_Truck end local MainEngineOn = VC_ElectronicsOn(CBR) local MainEngineOn = VC_ElectronicsOn(CBR) local Drv = CBR:GetDriver()
	local IsBrake = CBR.VC_BrakesOn or IsValid(Drv) and (!Drv:KeyDown(IN_BACK) or !Drv:KeyDown(IN_FORWARD)) and (Drv:KeyDown(IN_BACK) and Speed > 5 or IsValid(Drv) and Drv:KeyDown(IN_FORWARD) and Speed < -5) local IsRev = IsValid(Drv) and Drv:KeyDown(IN_BACK) and Speed < 5
		if !ent.VC_Lights then ent.VC_Lights = {} end
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		if ent.VC_DoorOpened and VC_Settings.VC_Lights_Interior then
		if !ent.VC_Lights_Door_Created then ent.VC_Lights_Door_Created = true ent:SetNWBool("VC_Lights_Door_Created", true) end
		elseif ent.VC_Lights_Door_Created then
		ent:SetNWBool("VC_Lights_Door_Created", false) ent.VC_Lights_Door_Created = nil
		end
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		if ent.VC_LightTable.Brake and IsBrake and MainEngineOn then
			if !ent.VC_Lights_Brk_Created then
			if ent.VC_AvIndicators then local DBL = ent.VC_AvIndicators.BrakeLight if DBL and ent.VC_Indicators and !ent.VC_Indicators.BrakeLight then VC_ApplyPoseParam(ent, DBL[1], DBL[3]) ent.VC_Indicators.BrakeLight = table.Copy(DBL) end end
			for CLk, CLv in pairs(ent.VC_LightTable.Brake) do if !ent.VC_Lights[CLk] then ent.VC_Lights[CLk] = {} end if !ent.VC_Lights[CLk].Brake and (!ent.VC_DamagedLights or !ent.VC_DamagedLights[CLk]) then ent.VC_Lights[CLk].Brake = VC_CreateLight(ent, CLv, CLv.BrakeColor) end end
			ent.VC_Lights_Brk_Created = true ent:SetNWBool("VC_Lights_Brk_Created", true)
			end
		elseif ent.VC_Lights_Brk_Created then
		ent:SetNWBool("VC_Lights_Brk_Created", false) VC_DeleteLights_Brake(ent) ent.VC_Lights_Brk_Created = nil
		end
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		if ent.VC_LightTable.Reverse and MainEngineOn and IsRev then
			if !ent.VC_Lights_Rev_Created then
			if ent.VC_AvIndicators then local DBL = ent.VC_AvIndicators.ReverseLight if DBL and ent.VC_Indicators and !ent.VC_Indicators.ReverseLight then VC_ApplyPoseParam(ent, DBL[1], DBL[3]) ent.VC_Indicators.ReverseLight = table.Copy(DBL) end end
			for CLk, CLv in pairs(ent.VC_LightTable.Reverse) do if !ent.VC_Lights[CLk] then ent.VC_Lights[CLk] = {} end if !ent.VC_Lights[CLk].Reverse and (!ent.VC_DamagedLights or !ent.VC_DamagedLights[CLk]) then ent.VC_Lights[CLk].Reverse = VC_CreateLight(ent, CLv, CLv.ReverseColor) end end
			ent.VC_Lights_Rev_Created = true ent:SetNWBool("VC_Lights_Rev_Created", true)
			end
		elseif ent.VC_Lights_Rev_Created then
		ent:SetNWBool("VC_Lights_Rev_Created", false) VC_DeleteLights_Rev(ent) ent.VC_Lights_Rev_Created = nil
		end
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		if VC_Settings.VC_HeadLights and ent.VC_LightTable.Head and MainEngineOn and CBR.VC_HeadLightsOn then
			if !ent.VC_Lights_Head_Created then
			timer.Simple(0.1, function() if IsValid(ent) then for CLk, CLv in pairs(ent.VC_LightTable.Head) do if !ent.VC_Lights[CLk] then ent.VC_Lights[CLk] = {} end if !ent.VC_Lights[CLk].Head and (!ent.VC_DamagedLights or !ent.VC_DamagedLights[CLk]) then ent.VC_Lights[CLk].Head = VC_CreateLight(ent, CLv, CLv.HeadColor) end end end end)
			ent.VC_Lights_Head_Created = true ent:SetNWBool("VC_Lights_Head_Created", true)
			end
		elseif ent.VC_Lights_Head_Created then
		ent:SetNWBool("VC_Lights_Head_Created", false) VC_DeleteLights_Head(ent) ent.VC_Lights_Head_Created = nil
		end
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		if VC_Settings.VC_Lights_Night and ent.VC_LightTable.Normal and MainEngineOn and CBR.VC_NormalLightsOn then
			if !ent.VC_Lights_Normal_Created then
			for CLk, CLv in pairs(ent.VC_LightTable.Normal) do if !ent.VC_Lights[CLk] then ent.VC_Lights[CLk] = {} end if !ent.VC_Lights[CLk].Normal and (!ent.VC_DamagedLights or !ent.VC_DamagedLights[CLk]) then ent.VC_Lights[CLk].Normal = VC_CreateLight(ent, CLv, CLv.NormalColor) end end
			ent.VC_Lights_Normal_Created = true ent:SetNWBool("VC_Lights_Normal_Created", true)
			end
		elseif ent.VC_Lights_Normal_Created then
		ent:SetNWBool("VC_Lights_Normal_Created", false) VC_DeleteLights_Normal(ent) ent.VC_Lights_Normal_Created = nil
		end
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		local Turn = ent.VC_LightTable.Blinker and (CBR.VC_TurnLightLeftOn or CBR.VC_TurnLightRightOn) and !CBR.VC_HazardLightsOn and (ent == CBR or !CBR.VC_TurnLightLeftOn or !CBR.VC_TurnLightRightOn)
		local Hazard = ent.VC_LightTable.Blinker and CBR.VC_HazardLightsOn and (ent == CBR or !CBR.VC_HazardLightsOnT)
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
			if Turn and (!ent.VC_TrnLOnT or CurTime() >= ent.VC_TrnLOnT) and MainEngineOn then
				if !ent.VC_Lights_Blinker_Created then
					for CLk, CLv in pairs(ent.VC_LightTable.Blinker) do
						if !ent.VC_Lights[CLk] then ent.VC_Lights[CLk] = {} end
						if !ent.VC_Lights[CLk].Turn and (!ent.VC_DamagedLights or !ent.VC_DamagedLights[CLk]) then
						local BSCP = CLv.Pos or Vector(0,0,0) if CBR.VC_TurnLightLeftOn and BSCP.x < 0 or CBR.VC_TurnLightRightOn and BSCP.x > 0 then ent.VC_Lights[CLk].Turn = VC_CreateLight(ent, CLv, CLv.BlinkersColor) end
						end
					end
				ent.VC_Lights_Blinker_Created = true
				if CBR.VC_TurnLightLeftOn then ent:SetNWBool("VC_Lights_Blinker_Created_left", true) ent:SetNWBool("VC_Lights_Blinker_Created_right", false) else ent:SetNWBool("VC_Lights_Blinker_Created_left", false) ent:SetNWBool("VC_Lights_Blinker_Created_right", true) end
				end
			elseif ent.VC_Lights_Blinker_Created and (ent.VC_TrnLOffT or ent.VC_TrnLOnT) then
				for CLk, CLv in pairs(ent.VC_LightTable.Blinker) do
				if ent.VC_Lights[CLk].Turn then VC_RemoveLight(ent.VC_Lights[CLk].Turn) ent.VC_Lights[CLk].Turn = nil end
				if !Turn then ent.VC_TrnLOffT = nil ent.VC_TrnLOnT = nil end
				end
			ent.VC_Lights_Blinker_Created = nil ent:SetNWBool("VC_Lights_Blinker_Created_left", false) ent:SetNWBool("VC_Lights_Blinker_Created_right", false)
			end
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
			if Hazard and (!ent.VC_HazardLightsOnT or CurTime() >= ent.VC_HazardLightsOnT) then
				if !ent.VC_Lights_Blinker_Created then
					for CLk, CLv in pairs(ent.VC_LightTable.Blinker) do
					if !ent.VC_Lights[CLk] then ent.VC_Lights[CLk] = {} end
					if !ent.VC_Lights[CLk].Hazard and (!ent.VC_DamagedLights or !ent.VC_DamagedLights[CLk]) then ent.VC_Lights[CLk].Hazard = VC_CreateLight(ent, CLv, CLv.BlinkersColor) end
					end
				ent.VC_Lights_Blinker_Created = true ent:SetNWBool("VC_Lights_Hazards_Created", true)
				end
			elseif ent.VC_Lights_Blinker_Created and (ent.VC_HazLOffT or ent.VC_HazardLightsOnT) then
				for CLk, CLv in pairs(ent.VC_LightTable.Blinker) do
				if ent.VC_Lights[CLk].Hazard then VC_RemoveLight(ent.VC_Lights[CLk].Hazard) ent.VC_Lights[CLk].Hazard = nil end
				if !Hazard then ent.VC_HazLOffT = nil ent.VC_HazardLightsOnT = nil end
				end
			ent.VC_Lights_Blinker_Created = nil ent:SetNWBool("VC_Lights_Hazards_Created", false)
			end
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		local Time = 0.35
		if Turn then
		if !ent.VC_TrnLOnT and !ent.VC_TrnLOffT then ent.VC_TrnLOffT = 0 end
			if ent.VC_TrnLOnT and CurTime() >= ent.VC_TrnLOnT then
				if ent == CBR then
				if ent.VC_AvIndicators then local DBL = ent.VC_AvIndicators.BlinkerLight if DBL and ent.VC_Indicators and !ent.VC_Indicators.BlinkerLight then VC_ApplyPoseParam(ent, DBL[1], CBR.VC_TurnLightLeftOn and DBL[2] or DBL[3]) ent.VC_Indicators.BlinkerLight = table.Copy(DBL) end end
				VC_EmitSound(ent, "vcmod/blnk_in.wav", nil, 55) ent.VC_TrnLOnT = nil ent.VC_TrnLOffT = CurTime()+ Time
				for _, HkVh in pairs(VC_Veh_List) do if HkVh.VC_Truck and HkVh.VC_Truck == ent then HkVh.VC_TrnLOnT = nil HkVh.VC_TrnLOffT = CurTime()+ Time end end
				end
			elseif ent.VC_TrnLOffT and CurTime() >= ent.VC_TrnLOffT then
				if ent == CBR then
				if ent.VC_Indicators and ent.VC_Indicators.BlinkerLight then VC_ApplyPoseParam(ent, ent.VC_Indicators.BlinkerLight[1], (ent.VC_Indicators.BlinkerLight[2]+ent.VC_Indicators.BlinkerLight[3])/2) ent.VC_Indicators.BlinkerLight = nil end
				VC_EmitSound(ent, "vcmod/blnk_out.wav", nil, 55) ent.VC_TrnLOnT = CurTime()+ Time ent.VC_TrnLOffT = nil
				for _, HkVh in pairs(VC_Veh_List) do if HkVh.VC_Truck and HkVh.VC_Truck == ent then HkVh.VC_TrnLOnT = CurTime()+ Time HkVh.VC_TrnLOffT = nil end end
				end
			end
		end
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		if Hazard then
			if !ent.VC_HazardLightsOnT and !ent.VC_HazLOffT then ent.VC_HazLOffT = 0 end
			if ent.VC_HazardLightsOnT and CurTime() >= ent.VC_HazardLightsOnT then
				if ent == CBR then
				if ent.VC_AvIndicators then local DBL = ent.VC_AvIndicators.HazardLight if DBL and ent.VC_Indicators and !ent.VC_Indicators.HazardLight then VC_ApplyPoseParam(ent, DBL[1], DBL[3]) ent.VC_Indicators.HazardLight = table.Copy(DBL) end end
				VC_EmitSound(ent, "vcmod/blnk_in.wav",  nil, 55) ent.VC_HazardLightsOnT = nil ent.VC_HazLOffT = CurTime()+ Time
				for _, HkVh in pairs(VC_Veh_List) do if HkVh.VC_Truck and HkVh.VC_Truck == ent then HkVh.VC_HazardLightsOnT = nil HkVh.VC_HazLOffT = CurTime()+ Time end end
				end
			elseif ent.VC_HazLOffT and CurTime() >= ent.VC_HazLOffT then
				if ent == CBR then
				if ent.VC_Indicators and ent.VC_Indicators.HazardLight then VC_ApplyPoseParam(ent, ent.VC_Indicators.HazardLight[1], ent.VC_Indicators.HazardLight[2]) ent.VC_Indicators.HazardLight = nil end
				VC_EmitSound(ent, "vcmod/blnk_out.wav", nil, 55) ent.VC_HazardLightsOnT = CurTime()+ Time ent.VC_HazLOffT = nil
				for _, HkVh in pairs(VC_Veh_List) do if HkVh.VC_Truck and HkVh.VC_Truck == ent then HkVh.VC_HazardLightsOnT = CurTime()+ Time HkVh.VC_HazLOffT = nil end end
				end
			end
		end

	elseif ent.VC_Lights then
	VC_DeleteLights_Brake(ent) VC_DeleteLights_Rev(ent) VC_DeleteLights_Head(ent) VC_DeleteLights_Normal(ent)
	ent:SetNWBool("VC_Lights_Brk_Created", false) ent:SetNWBool("VC_Lights_Rev_Created", false) ent:SetNWBool("VC_Lights_Head_Created", false) ent:SetNWBool("VC_Lights_Normal_Created", false) ent:SetNWBool("VC_Lights_Blinker_Created", false)
	ent:SetNWBool("VC_Lights_Blinker_Created_left", false) ent:SetNWBool("VC_Lights_Blinker_Created_right", false) ent:SetNWBool("VC_Lights_Hazards_Created", false)
	ent.VC_Lights_Brk_Created = nil ent.VC_Lights_Normal_Created = nil ent.VC_Lights_Head_Created = nil ent.VC_Lights_Rev_Created = nil ent.VC_Lights_Blinker_Created = nil ent.VC_Lights = nil
	end
end

function VC_HandleParticles(ent, Drv)
	if VC_Settings.VC_Exhaust_Effect and IsValid(Drv) and ent.VC_Script.Exhaust and ent:GetVelocity():Length() < 550 and VC_EngineAboveWater(ent) and (!ent.VC_Health or ent.VC_Health > 0) then
	if IsValid(Drv) and (Drv:KeyDown(IN_FORWARD) or Drv:KeyDown(IN_BACK)) and !ent:GetDriver():KeyDown(IN_JUMP) and ent:GetVelocity():Length() < 450 then if !ent.VC_EEPES then ent.VC_EEPES = {} for _, HST in pairs(ent.VC_Script.Exhaust) do local WDE = ents.Create("info_particle_system") WDE:SetKeyValue("effect_name", "Exhaust") WDE:SetAngles(VC_AngleCombCalc(ent:GetAngles(), (HST.Ang or Angle(0,0,0))+Angle(90,0,0))) WDE:SetPos(VC_VectorToWorld(ent, HST.Pos) or Vector(0,0,0)) WDE:SetParent(ent) WDE:Spawn() WDE:Activate() WDE:Fire("Start") table.insert(ent.VC_EEPES, WDE) end end ent.VC_EETBACS = CurTime()+ math.Rand(0.2,0.4) else if (!ent.VC_EETBACS or CurTime() >= ent.VC_EETBACS) and ent.VC_EEPES then for _,HST in pairs(ent.VC_EEPES) do HST:Remove() end ent.VC_EEPES = nil end end
	if !ent.VC_EEPE then ent.VC_EEPE = {} for _, HST in pairs(ent.VC_Script.Exhaust) do local WDE = ents.Create("info_particle_system") WDE:SetKeyValue("effect_name", "Exhaust") WDE:SetAngles(VC_AngleCombCalc(ent:GetAngles(), (HST.Ang or Angle(0,0,0))+Angle(90,0,0))) WDE:SetPos(VC_VectorToWorld(ent, HST.Pos) or Vector(0,0,0)) WDE:SetParent(ent) WDE:Spawn() WDE:Activate() WDE:Fire("Start") table.insert(ent.VC_EEPE, WDE) end end
	else
	if (!ent.VC_EETBAC or CurTime() >= ent.VC_EETBAC) and ent.VC_EEPE then for _,HST in pairs(ent.VC_EEPE) do HST:Remove() end ent.VC_EEPE = nil end if ent.VC_EEPES then for _,HST in pairs(ent.VC_EEPES) do HST:Remove() end ent.VC_EEPES = nil end
	end

	if (!ent.VC_TBNWDC or CurTime() >= ent.VC_TBNWDC) and (!ent.VC_Script or !ent.VC_Script.VC_NoWheelDust) and string.lower(ent:GetClass()) != "prop_vehicle_prisoner_pod" and ent:GetClass() != "prop_vehicle_airboat" then
	local DEL = {"wheel_fl", "wheel_fr", "wheel_rl", "wheel_rr"}
		if VC_Settings.VC_Wheel_Dust then
		if !ent.VC_WDPST then ent.VC_WDPST = {} end if !ent.VC_WDNT then ent.VC_WDNT = {} end if !ent.VC_WDET then ent.VC_WDET = {} end local WDEA = {["65"] = "wheeldirt", ["66"] = "wheeldirt", ["68"] = "wheeldust", ["70"] = "wheeldirt", ["72"] = "wheeldirt", ["78"] = "wheeldust", ["79"] = "wheeldirt", ["80"] = "wheeldirt", ["81"] = "wheeldirt", ["83"] = "wheeldirt", ["87"] = "wheeldirt"}
		for i=1, 4 do if ent:LookupAttachment(DEL[i]) != 0 then local WDT = util.TraceLine({start = ent:GetAttachment(ent:LookupAttachment(DEL[i])).Pos, endpos = ent:GetAttachment(ent:LookupAttachment(DEL[i])).Pos+ ent:GetUp()* -30, filter = ent}) if WDT.Hit and ent:GetVelocity():Length()- WDT.Entity:GetVelocity():Length() > 250 and ent:WaterLevel() < 3 and VecAboveWtr(ent:GetPos()+ ent:GetUp()* 40) then if ent.VC_WDNT[i] and (WDT.MatType != ent.VC_WDET[i] or ent.VC_WDPST[i].VC_WDTBNC and CurTime() >= ent.VC_WDPST[i].VC_WDTBNC) then ent.VC_WDPST[i]:Remove() table.remove(ent.VC_WDPST, i) table.remove(ent.VC_WDNT, i) table.remove(ent.VC_WDET, i) end if !table.HasValue(ent.VC_WDNT, DEL[i]) then local WDE = ents.Create("info_particle_system") WDE:SetKeyValue("effect_name", !VecAboveWtr(WDT.HitPos+ WDT.HitNormal) and "wheelsplash" or WDEA[tostring(WDT.MatType)] or "exhaust") WDE:SetAngles(ent:GetAngles()) WDE:SetPos(WDT.HitPos+ WDT.HitNormal) WDE:SetParent(ent) WDE:Spawn() WDE:Activate() WDE:Fire("Start") table.insert(ent.VC_WDPST, WDE) table.insert(ent.VC_WDNT, DEL[i]) table.insert(ent.VC_WDET, WDT.MatType) WDE.VC_WDTBNC = CurTime()+ 0.5 end else if ent.VC_WDNT[i] then ent.VC_WDPST[i]:Remove() table.remove(ent.VC_WDPST, i) table.remove(ent.VC_WDNT, i) table.remove(ent.VC_WDET, i) end end end end
		else
		if ent.VC_WDNT and #ent.VC_WDNT > 0 then for WDk, WDv in pairs(ent.VC_WDNT) do ent.VC_WDPST[WDk]:Remove() table.remove(ent.VC_WDPST, WDk) table.remove(ent.VC_WDNT, WDk) table.remove(ent.VC_WDET, WDk) end end
		end
		if VC_Settings.VC_Wheel_Dust_Brakes and (IsValid(ent:GetDriver()) and ent:GetDriver():KeyDown(IN_JUMP) or ent.VC_BrksOn and IsValid(ent.VC_Truck) and IsValid(ent.VC_Truck:GetDriver()) and ent.VC_Truck:GetDriver():KeyDown(IN_JUMP)) then
		if !ent.VC_WDPSTB then ent.VC_WDPSTB = {} end if !ent.VC_WDNTB then ent.VC_WDNTB = {} end for i=1, 4 do if ent:LookupAttachment(DEL[i]) != 0 then local WDT = util.TraceLine({start = ent:GetAttachment(ent:LookupAttachment(DEL[i])).Pos, endpos = ent:GetAttachment(ent:LookupAttachment(DEL[i])).Pos+ ent:GetUp()* -30, filter = ent}) if WDT.Hit and ent:GetVelocity():Length()- WDT.Entity:GetVelocity():Length() > 100 and VecAboveWtr(WDT.HitPos+ WDT.HitNormal) and ent:WaterLevel() < 3 then if !table.HasValue(ent.VC_WDNTB, DEL[i]) then local WDE = ents.Create("info_particle_system") WDE:SetKeyValue("effect_name", "wheeldust") WDE:SetAngles(ent:GetAngles()) WDE:SetPos(WDT.HitPos+ WDT.HitNormal) WDE:SetParent(ent) WDE:Spawn() WDE:Activate() WDE:Fire("Start") table.insert(ent.VC_WDPSTB, WDE) table.insert(ent.VC_WDNTB, DEL[i]) end else if ent.VC_WDNTB[i] then ent.VC_WDPSTB[i]:Remove() table.remove(ent.VC_WDPSTB, i) table.remove(ent.VC_WDNTB, i) end end end end
		else
		if ent.VC_WDNTB and #ent.VC_WDNTB > 0 then for WDk, WDv in pairs(ent.VC_WDNTB) do ent.VC_WDPSTB[WDk]:Remove() table.remove(ent.VC_WDPSTB, WDk) table.remove(ent.VC_WDNTB, WDk) end end
		end
	ent.VC_TBNWDC = CurTime()+ 0.1
	end
end

function VC_HandleHealth(ent)
	if !ent.VC_Health then local HP = false if ent.VC_Script.HealthOverride then HP = ent.VC_Script.HealthOverride else HP = 200+ (IsValid(ent:GetPhysicsObject()) and ent:GetPhysicsObject():GetVolume() or 500000)/5000 end ent.VC_Health = HP* VC_Settings.VC_Health_Multiplier ent.VC_MaxHealth = ent.VC_Health ent:SetNWInt("VC_MaxHealth", ent.VC_MaxHealth) ent:SetNWInt("VC_Health", ent.VC_Health) end

	if ent.VC_ExplodedTime and CurTime() >= ent.VC_ExplodedTime then if ent.VC_Health and ent.VC_Health == 0 then ent:Remove() return else ent.VC_ExplodedTime = nil end end

	if VC_Settings.VC_Damage then
		if string.lower(ent:GetClass()) != "prop_vehicle_prisoner_pod" and (!ent.VC_Script.VC_IsTrailer and !ent.VC_Script.VC_Invulnerable) then
			if !ent.VC_DBTNVDT or CurTime() >= ent.VC_DBTNVDT then
				if (!ent.VC_TBESDO or CurTime() < ent.VC_TBESDO) and (!ent.VC_EBroke or !ent.VC_EngSFire) and ent.VC_Health < ent.VC_MaxHealth/3 and (!IsValid(ent.VC_EngSmk) or ent.VC_EngSFire) and VecAboveWtr(EnginePos(ent)) then
				local EFT = ent.VC_Health < ent.VC_MaxHealth/8
				if IsValid(ent.VC_EngSmk) then ent.VC_EngSmk:Remove() end
				local WDE = ents.Create("info_particle_system") WDE:SetKeyValue("effect_name", EFT and "explosion_turret_fizzle" or "explosion_turret_break_pre_smoke") WDE:SetAngles(ent:GetAngles()) WDE:SetPos(EnginePos(ent)) WDE:SetParent(ent) WDE:Spawn() WDE:Activate() WDE:Fire("Start")
				ent.VC_EngSmk = WDE ent.VC_EngSFire = EFT
				local Max = VC_Settings.VC_Dmg_Fire_Duration or 30 ent.VC_TBESDO = CurTime()+ (EFT and math.Clamp(Max- 0.5, 2, Max)* math.Rand(0.9, 1.1) or 5)
				end
			if ent.VC_Health >= ent.VC_MaxHealth/3 then if ent.VC_Health- (ent.VC_LastHealth or ent.VC_Health) != 0 then if (ent.VC_EngSFire or ent.VC_EngSFire == nil) and VecAboveWtr(EnginePos(ent)) then ent.VC_TBESDO = CurTime()+ math.random(45,60) end ent.VC_FixTmr = CurTime()+ 2 end ent.VC_LastHealth = ent.VC_Health elseif ent.VC_Health < ent.VC_MaxHealth/8 then ent.VC_Health = ent.VC_Health- ent.VC_MaxHealth/250 ent:SetNWInt("VC_Health", ent.VC_Health) end
			if IsValid(ent.VC_EngSmk) and (ent.VC_TBESDO and CurTime() >= ent.VC_TBESDO or ent.VC_Health >= ent.VC_MaxHealth/3 or !VecAboveWtr(EnginePos(ent))) then ent.VC_EngSmk:Remove() ent.VC_TBESDO = nil end
			ent.VC_DBTNVDT = CurTime()+ 0.2
			end

			if !ent.VC_EBroke and ent.VC_Health and ent.VC_Health <= 0 then
			ent.VC_Health = 0 ent:SetNWInt("VC_Health", ent.VC_Health)
			if !ent.VC_EngineOff then ent:Fire("TurnOff") ent.VC_EngineOff = true end
			local EngE, EPos = ents.Create("env_explosion"), EnginePos(ent) EngE:SetKeyValue("iMagnitude", "100") EngE:SetPos(EPos) EngE:SetOwner(ent) EngE:Spawn() EngE:Fire("explode") if VC_Settings.VC_Damage_Expl_Rem then ent.VC_ExplodedTime = CurTime()+(VC_Settings.VC_Damage_Expl_Rem_Time or 400) end
			local PObj = ent:GetPhysicsObject() if IsValid(PObj) then PObj:AddAngleVelocity(Vector(math.random(-200,250),math.random(-200,200),math.random(-100,100))) end
			for k,v in pairs(VC_GetPlayers(ent)) do v:TakeDamage(150, ent) end
			ent.VC_TBESDL = CurTime()+ (VC_Settings.VC_Dmg_Fire_Duration or 30)* math.Rand(0.9, 1.1)
			ent.VC_EBroke = true
			end
		end
	elseif IsValid(ent.VC_EngSmk) then ent.VC_EngSmk:Remove()
	end

	local DntIgn = true if ent.VC_IgnoreDamageFor then if CurTime() < ent.VC_IgnoreDamageFor then DntIgn = false else ent.VC_IgnoreDamageFor = nil end end

	if VC_Settings.VC_PhysicalDamage and DntIgn and !ent.VC_Held and !ent.VC_DSGP then
	local PObj = ent:GetPhysicsObject() local Vel = nil
		if IsValid(PObj) then
		Vel = PObj:GetVelocity() local VLA = math.abs((ent.VC_DSPVel or Vel):Length()- Vel:Length())
			if !ent.VC_PATBA or CurTime() >= ent.VC_PATBA then
				if VLA > 300 then
				local Dmg = VLA*Vel:Length()/1400*(VC_Settings.VC_PhysicalDamage_Mult or 1)
					if ent.VC_Health then
					for k,v in pairs(VC_GetPlayers(ent)) do v:TakeDamage(Dmg/5) end
						if ent.VC_Health > 0 then
						ent.VC_Health = ent.VC_Health-Dmg*(VC_Settings.VC_ELS_Vehicle_RedDamage and ent.VC_Script.Siren and ent.VC_Script.Siren.Sounds and VC_Settings.VC_ELS_Vehicle_RedDamage_M or 1)
						if ent.VC_Health < 0 then ent.VC_Health = 0 end
						ent:SetNWInt("VC_Health", ent.VC_Health)
						end
					end
				end
			end
		end
	ent.VC_DSPVel = Vel
	else
	ent.VC_DSPVel = nil
	end
	ent.VC_DSGP = nil
end

function VC_Think_Main_BS()
	if VC_Settings.VC_Enabled then
		for _,ply in pairs(player.GetAll()) do
			if VC_Settings.VC_Passenger_Seats then
			if ply.VC_ChnSts and !IsValid(ply:GetVehicle()) then ply.VC_ChnSts = false end
			if ply.VC_JEAES and !ply:KeyDown(IN_USE) then ply.VC_JEAES = nil end
			end
		end
	end
end

function VC_Think_Main_Each(EntLN, ent)
	if VC_Settings.VC_Enabled then 
	local Speed = ent:GetVelocity():Dot(ent:GetForward())
		if ent.VC_LightsOffTime_HLht and CurTime() >= ent.VC_LightsOffTime_HLht then VC_HeadLightsOff(ent) ent.VC_LightsOffTime_HLht = nil end
		if ent.VC_LightsOffTime and CurTime() >= ent.VC_LightsOffTime then VC_NormalLightsOff(ent) ent.VC_LightsOffTime = nil end
		if ent.VC_NPC_Remove_Time and CurTime() >= ent.VC_NPC_Remove_Time then if VC_Settings.VC_NPC_Remove then if IsValid(ent.VC_Spawner) then ent.VC_Spawner.HasCar = false ent.VC_Spawner.OwnedCar = nil end ent:Remove() end ent.VC_NPC_Remove_Time = nil end

		local Drv = ent:GetDriver() if IsValid(Drv) and !ent.VC_BrkCONE then local Brk, EAW = VC_Settings.VC_Lights_HandBrake and Drv:KeyDown(IN_JUMP), VC_EngAboveWtr(ent, true) if !ent.VC_BrakesOn and (Brk or !EAW) then VC_BrakesOn(ent, true) elseif ent.VC_BrakesOn and !Brk and EAW then VC_BrakesOff(ent, true) end end
		if ent.VC_Script.UseSocket and ent.VC_Script.SocketPos and !ent.VC_IsTrailer and (ent.VC_HookVeh or NULL) != ent:GetNWEntity("VC_HookedVh") then ent:SetNWEntity("VC_HookedVh", ent.VC_HookVeh or NULL) end
		VC_HandleHealth(ent) VC_HandleLights(ent, Speed) VC_HandleAudio(ent, IsValid(Drv) and Drv:KeyDown(IN_BACK) and Speed < 5) VC_HandleParticles(ent, Drv)

		if ent.VC_Cruise and !ent.VC_BrksOn and VC_EngineAboveWater(ent) and (!ent.VC_Health or ent.VC_Health >= ent.VC_MaxHealth/8) and (!IsValid(Drv) or !Drv:KeyDown(IN_JUMP) and !Drv:KeyDown(IN_BACK)) and (!VC_Settings.VC_Cruise_OffOnExit or IsValid(Drv)) then
			if IsValid(Drv) and Drv:KeyDown(IN_FORWARD) then
			ent.VC_CruiseKD = true
			else
			local CCVel = ent:GetVelocity():Dot(ent:GetForward())
				if !ent.VC_CruiseVel or ent.VC_CruiseKD then CCVel = CCVel > 25 and CCVel or 25 ent.VC_CruiseVel = CCVel ent:SetNWInt("VC_Cruise_Spd", CCVel) ent.VC_CruiseKD = nil end
				if CCVel < ent.VC_CruiseVel then
				ent:Fire("throttle", VC_GetThrottle(ent.VC_CruiseVel, CCVel)) ent.VC_CruiseRan = true
				elseif !IsValid(Drv) and ent.VC_Throttle and ent.VC_Throttle != 0 then
				ent:Fire("throttle", 0) ent.VC_CruiseRan = true
				else
				ent:Fire("throttle", 0)
				end
			end
		elseif ent.VC_CruiseRan then
		ent:Fire("throttle", 0) ent.VC_CruiseRan = nil ent.VC_Cruise = nil ent.VC_CruiseVel = nil ent:SetNWInt("VC_Cruise_Spd", 0)
		end

		if VC_Settings.VC_Lights_Interior then ent.VC_DoorOpened = ent.VC_TBTDC if !ent.VC_DoorOpened and ent.VC_SeatTable then for _, Seat in pairs(ent.VC_SeatTable) do if Seat.VC_TBTDC then ent.VC_DoorOpened = Seat.VC_TBTDC break end end end end

		if VC_Settings.VC_Door_Sounds and ent.VC_ScanDoorCloseTime and CurTime() < ent.VC_ScanDoorCloseTime then
			local Tbl = {ent} table.Add(Tbl, table.Copy(ent.VC_SeatTable or {}))
			for _, Seat in pairs(Tbl) do if (!Seat.VC_TBTET or CurTime() >= Seat.VC_TBTET) and !Seat.VC_TBTAC and Seat.VC_TBTDC and CurTime() >= Seat.VC_TBTDC then CarDoorOC(Seat, true) end end
		end
	VC_HandleTrailer(ent, EntLN)
	end
end

hook.Add("Think", "VC_Think", function()
	VC_FTm = (CurTime()-(VC_LastFTm or 0))*66.66 VC_LastFTm = CurTime()
	for k,v in pairs(table.Copy(VC_SyncTable)) do if IsValid(v[1]) and IsValid(v[2]) then if !v[2].VC_NextSyncTime or CurTime() >= v[2].VC_NextSyncTime then VC_SendDataToClient(v[1], v[2]) VC_SyncTable[k] = nil v[2].VC_NextSyncTime = CurTime()+0.2 end else VC_SyncTable[k] = nil end end
	-- if VC_ASDGGG and CurTime() >= VC_ASDGGG then VCMsg("I"..Sdda.." re "..zxczx.."ror.") VC_Settings = nil end
	VC_Veh_List = ents.FindByClass("prop_vehicle_jeep*")
	if VCMod1 then VC_Think_Main_BS() end for EntLN, ent in pairs(VC_Veh_List) do if !ent.VC_Initialized then VC_Initialize(ent) ent.VC_Initialized = true end if VCMod1 then VC_Think_Main_Each(EntLN, ent) end if VCMod1_ELS then VC_Think_ELS_Each(EntLN, ent) end end
end)

function VC_DeleteLights_Brake(ent)
	if ent.VC_Indicators and ent.VC_Indicators.BrakeLight then VC_ApplyPoseParam(ent, ent.VC_Indicators.BrakeLight[1], ent.VC_Indicators.BrakeLight[2]) ent.VC_Indicators.BrakeLight = nil end
	if ent.VC_LightTable.Brake and ent.VC_Lights then for CLk, CLv in pairs(ent.VC_LightTable.Brake) do if ent.VC_Lights[CLk] and ent.VC_Lights[CLk].Brake then VC_RemoveLight(ent.VC_Lights[CLk].Brake) ent.VC_Lights[CLk].Brake = nil end end ent.VC_Lights_Brk_Created = nil end
end
function VC_DeleteLights_Rev(ent)
	if ent.VC_Indicators and ent.VC_Indicators.ReverseLight then VC_ApplyPoseParam(ent, ent.VC_Indicators.ReverseLight[1], ent.VC_Indicators.ReverseLight[2]) ent.VC_Indicators.ReverseLight = nil end
	if ent.VC_LightTable.Reverse and ent.VC_Lights then for CLk, CLv in pairs(ent.VC_LightTable.Reverse) do if ent.VC_Lights[CLk] and ent.VC_Lights[CLk].Reverse then VC_RemoveLight(ent.VC_Lights[CLk].Reverse) ent.VC_Lights[CLk].Reverse = nil end end ent.VC_Lights_Rev_Created = nil end
end
function VC_DeleteLights_Head(ent)
	if ent.VC_LightTable.Head and ent.VC_Lights then for CLk, CLv in pairs(ent.VC_LightTable.Head) do if ent.VC_Lights[CLk] and ent.VC_Lights[CLk].Head then VC_RemoveLight(ent.VC_Lights[CLk].Head) ent.VC_Lights[CLk].Head = nil end end ent.VC_Lights_Head_Created = nil end
end
function VC_DeleteLights_Normal(ent)
	if ent.VC_LightTable.Normal and ent.VC_Lights then for CLk, CLv in pairs(ent.VC_LightTable.Normal) do if ent.VC_Lights[CLk] and ent.VC_Lights[CLk].Normal then VC_RemoveLight(ent.VC_Lights[CLk].Normal) ent.VC_Lights[CLk].Normal = nil end end ent.VC_Lights_Normal_Created = nil end
end
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
hook.Add("PhysgunPickup", "VC_PhysPickup", function(ply, ent) if ent.VC_IsWeapon then return false end if ent:IsVehicle() then ent.VC_Held = ply end end)
hook.Add("PhysgunDrop", "VC_PhysDrop", function(ply, ent) if ent:IsVehicle() then ent.VC_Held = nil end end)
hook.Add("GravGunPunt", "VC_GravPunt", function(ply, ent) if ent:IsVehicle() then ent.VC_DSGP = true end end)
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function VC_NormalLightsOn(ent)
	if !ent.VC_NormalLightsOn and ent.VC_LightTable and ent.VC_LightTable.Normal then
	if ent.VC_AvIndicators then local DBL = ent.VC_AvIndicators.NightLight if DBL and ent.VC_Indicators and !ent.VC_Indicators.NightLight then VC_ApplyPoseParam(ent, DBL[1], DBL[3]) ent.VC_Indicators.NightLight = table.Copy(DBL) end end
	VC_EmitSound(ent, "Clk", 105) ent.VC_NormalLightsOn = true ent:SetNWBool("VC_NormalLightsOn", true)
	end
end
function VC_NormalLightsOff(ent)
	if ent.VC_NormalLightsOn and ent.VC_LightTable and ent.VC_LightTable.Normal then
	if ent.VC_Indicators and ent.VC_Indicators.NightLight then VC_ApplyPoseParam(ent, ent.VC_Indicators.NightLight[1], ent.VC_Indicators.NightLight[2]) ent.VC_Indicators.NightLight = nil end
	VC_EmitSound(ent, "Clk", 95) ent.VC_NormalLightsOn = false ent:SetNWBool("VC_NormalLightsOn", false)
	end
end

function VC_HeadLightsOn(ent)
	if !ent.VC_HeadLightsOn and ent.VC_LightTable and ent.VC_LightTable.Head then
	if ent.VC_AvIndicators then local DBL = ent.VC_AvIndicators.HeadLight if DBL and ent.VC_Indicators and !ent.VC_Indicators.HeadLight then VC_ApplyPoseParam(ent, DBL[1], DBL[3]) ent.VC_Indicators.HeadLight = table.Copy(DBL) end end
	VC_EmitSound(ent, "Clk", 105) ent.VC_HeadLightsOn = true ent:SetNWBool("VC_HeadLightsOn", true)
	end
end
function VC_HeadLightsOff(ent)
	if ent.VC_HeadLightsOn and ent.VC_LightTable and ent.VC_LightTable.Head then
	if ent.VC_Indicators and ent.VC_Indicators.HeadLight then VC_ApplyPoseParam(ent, ent.VC_Indicators.HeadLight[1], ent.VC_Indicators.HeadLight[2]) ent.VC_Indicators.HeadLight = nil end
	VC_EmitSound(ent, "Clk", 95) ent.VC_HeadLightsOn = false ent:SetNWBool("VC_HeadLightsOn", false)
	end
end

function VC_HL_HighBeam_On(ent)
	if ent.VC_LightTable and ent.VC_LightTable.Head then
	ent.VC_HighBeam = true ent:SetNWBool("VC_HighBeam", ent.VC_HighBeam) VC_EmitSound(ent, "Clk", 105) VC_HeadLightsOn(ent)
	if ent.VC_Lights_Head_Created then ent:SetNWBool("VC_Lights_Head_Created", false) VC_DeleteLights_Head(ent) ent.VC_Lights_Head_Created = nil end
	end
end

function VC_HL_HighBeam_Off(ent)
	if ent.VC_HighBeam then
	ent.VC_HighBeam = false ent:SetNWBool("VC_HighBeam", ent.VC_HighBeam) VC_EmitSound(ent, "Clk", 105) VC_HeadLightsOn(ent)
	if ent.VC_Lights_Head_Created then ent:SetNWBool("VC_Lights_Head_Created", false) VC_DeleteLights_Head(ent) ent.VC_Lights_Head_Created = nil end
	end
end

function VC_HazardLightsOn(ent)
	if !ent.VC_HazardLightsOn and ent.VC_LightTable and ent.VC_LightTable.Blinker then
	VC_EmitSound(ent, (ent.VC_TurnLightLeftOn or ent.VC_TurnLightRightOn) and "vcmod/switch.wav" or "vcmod/switch_on.wav") ent.VC_TrnLOnT = nil ent.VC_TrnLOffT = 0 ent.VC_HazardLightsOnT = 0 ent.VC_HazLOffT = 0
	if ent.VC_TurnLightLeftOn or ent.VC_TurnLightRightOn then if ent.VC_Indicators and ent.VC_Indicators.BlinkerLight then VC_ApplyPoseParam(ent, ent.VC_Indicators.BlinkerLight[1], (ent.VC_Indicators.BlinkerLight[2]+ent.VC_Indicators.BlinkerLight[3])/2) ent.VC_Indicators.BlinkerLight = nil end ent.VC_TurnLightLeftOn = false ent.VC_TurnLightRightOn = false ent:SetNWBool("VC_TurnLightLeftOn", ent.VC_TurnLightLeftOn) ent:SetNWBool("VC_TurnLightRightOn", ent.VC_TurnLightRightOn) end
	if ent.VC_Indicators and ent.VC_Indicators.TurnSignal then VC_ApplyPoseParam(ent, ent.VC_Indicators.TurnSignal[1], (ent.VC_Indicators.TurnSignal[2]+ent.VC_Indicators.TurnSignal[3])/2) ent.VC_Indicators.TurnSignal = nil end
	ent.VC_HazardLightsOn = true ent:SetNWBool("VC_HazardLightsOn", true)
	end
end
function VC_HazardLightsOff(ent)
	if ent.VC_HazardLightsOn and ent.VC_LightTable and ent.VC_LightTable.Blinker then
	ent.VC_HazardLightsOn = false ent:SetNWBool("VC_HazardLightsOn", false)
	if ent.VC_Indicators and ent.VC_Indicators.HazardLight then VC_ApplyPoseParam(ent, ent.VC_Indicators.HazardLight[1], ent.VC_Indicators.HazardLight[2]) ent.VC_Indicators.HazardLight = nil end
	VC_EmitSound(ent, "vcmod/switch_off.wav")
	end
end

function VC_TurnLightLeftOn(ent)
	if !ent.VC_TurnLightLeftOn and ent.VC_LightTable and ent.VC_LightTable.Blinker then
	if ent.VC_AvIndicators then local DBL = ent.VC_AvIndicators.TurnSignal if DBL then VC_ApplyPoseParam(ent, DBL[1], DBL[2]) ent.VC_Indicators.TurnSignal = table.Copy(DBL) end end
	VC_EmitSound(ent, (ent.VC_TurnLightRightOn or ent.VC_HazardLightsOn) and "vcmod/switch.wav" or "vcmod/switch_on.wav") ent.VC_TrnLOnT = 0 ent.VC_TrnLOffT = 0
	ent.VC_TurnLightRightOn = false ent.VC_TurnLightLeftOn = true ent:SetNWBool("VC_TurnLightLeftOn", ent.VC_TurnLightLeftOn) ent:SetNWBool("VC_TurnLightRightOn", ent.VC_TurnLightRightOn) ent.VC_HazardLightsOn = false ent:SetNWBool("VC_HazardLightsOn", false)
	end
end
function VC_TurnLightLeftOff(ent)
	if ent.VC_TurnLightLeftOn and ent.VC_LightTable and ent.VC_LightTable.Blinker then
	if ent.VC_Indicators and ent.VC_Indicators.BlinkerLight then VC_ApplyPoseParam(ent, ent.VC_Indicators.BlinkerLight[1], (ent.VC_Indicators.BlinkerLight[2]+ent.VC_Indicators.BlinkerLight[3])/2) ent.VC_Indicators.BlinkerLight = nil end
	if ent.VC_Indicators and ent.VC_Indicators.TurnSignal then VC_ApplyPoseParam(ent, ent.VC_Indicators.TurnSignal[1], (ent.VC_Indicators.TurnSignal[2]+ent.VC_Indicators.TurnSignal[3])/2) ent.VC_Indicators.TurnSignal = nil end
	VC_EmitSound(ent, "vcmod/switch_off.wav") ent.VC_TurnLightLeftOn = false ent:SetNWBool("VC_TurnLightLeftOn", ent.VC_TurnLightLeftOn)
	end
end

function VC_TurnLightRightOn(ent)
	if !ent.VC_TurnLightRightOn and ent.VC_LightTable and ent.VC_LightTable.Blinker then
	if ent.VC_AvIndicators then local DBL = ent.VC_AvIndicators.TurnSignal if DBL then VC_ApplyPoseParam(ent, DBL[1], DBL[3]) ent.VC_Indicators.TurnSignal = table.Copy(DBL) end end
	VC_EmitSound(ent, (ent.VC_TurnLightLeftOn or ent.VC_HazardLightsOn) and "vcmod/switch.wav" or "vcmod/switch_on.wav") ent.VC_TrnLOnT = 0 ent.VC_TrnLOffT = 0
	ent.VC_TurnLightLeftOn = false ent.VC_TurnLightRightOn = true ent:SetNWBool("VC_TurnLightLeftOn", ent.VC_TurnLightLeftOn) ent:SetNWBool("VC_TurnLightRightOn", ent.VC_TurnLightRightOn) ent.VC_HazardLightsOn = false ent:SetNWBool("VC_HazardLightsOn", false)
	end
end
function VC_TurnLightRightOff(ent)
	if ent.VC_TurnLightRightOn and ent.VC_LightTable and ent.VC_LightTable.Blinker then
	if ent.VC_Indicators and ent.VC_Indicators.BlinkerLight then VC_ApplyPoseParam(ent, ent.VC_Indicators.BlinkerLight[1], (ent.VC_Indicators.BlinkerLight[2]+ent.VC_Indicators.BlinkerLight[3])/2) ent.VC_Indicators.BlinkerLight = nil end
	if ent.VC_Indicators and ent.VC_Indicators.TurnSignal then VC_ApplyPoseParam(ent, ent.VC_Indicators.TurnSignal[1], (ent.VC_Indicators.TurnSignal[2]+ent.VC_Indicators.TurnSignal[3])/2) ent.VC_Indicators.TurnSignal = nil end
	VC_EmitSound(ent, "vcmod/switch_off.wav") ent.VC_TurnLightRightOn = false ent:SetNWBool("VC_TurnLightRightOn", ent.VC_TurnLightRightOn)
	end
end

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
for i=1, 8 do
	concommand.Add("VC_Switch_Seats_"..tostring(i+1), function(ply)
		if VC_Settings.VC_Enabled and IsValid(ply:GetVehicle()) and (ply:GetVehicle().VC_SeatTable or ply:GetVehicle().VC_ExtraSeat) and (!ply.VC_ChgST or CurTime() >= ply.VC_ChgST) and !(IsValid(ply.VC_HangingOutSeat) and IsValid(ply.VC_HangingOutSeat.VC_HangingOutPlayer) and ply == ply.VC_HangingOutSeat.VC_HangingOutPlayer) then
		local Seat = (ply:GetVehicle().VC_ExtraSeat and ply:GetVehicle():GetParent().VC_SeatTable or ply:GetVehicle().VC_SeatTable)[i]
			if IsValid(Seat) and Seat != ply:GetVehicle() and !IsValid(Seat:GetDriver()) then
			local ACA = Seat:WorldToLocalAngles(ply:EyeAngles()) ACA.r = 0
			ply.VC_ChgST = CurTime()+ 0.2 ply.VC_ChnSts = true Seat:SetThirdPersonMode(ply:GetVehicle():GetThirdPersonMode()) ply:ExitVehicle() ply.VC_CanEnterTime = nil ply:EnterVehicle(Seat) ply:SetEyeAngles(ACA)
			end
		end
	end)
end

concommand.Add("vc_inside_doors_onoff", function(ply)
	if VC_Settings.VC_Enabled and IsValid(ply:GetVehicle()) and !ply:GetVehicle().VC_ExtraSeat then
	if !ply:GetVehicle().VC_Locked then VCMsg("Locked", ply) VC_Lock(ply:GetVehicle()) ply:GetVehicle().VC_RemPlayer = ply else VCMsg("UnLocked", ply) VC_UnLock(ply:GetVehicle()) end
	VC_EmitSound(ent, "Clk", 100)
	end
end)
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

concommand.Add("VC_HeadLights_Modes", function(ply) if VC_Settings.VC_Enabled then local ent = ply:GetVehicle() if IsValid(ent) and ent.VC_LightTable and ent.VC_LightTable.Head then if ent.VC_HighBeam then VC_HL_HighBeam_Off(ent) else VC_HL_HighBeam_On(ent) end end end end)
concommand.Add("vc_lights_onoff", function(ply) if VC_Settings.VC_Enabled then local ent = ply:GetVehicle() if IsValid(ent) and ent.VC_LightTable and ent.VC_LightTable.Normal then if !ent.VC_NormalLightsOn then VC_NormalLightsOn(ent) else VC_NormalLightsOff(ent) end end end end)
concommand.Add("VC_HeadLights_OnOff", function(ply) if VC_Settings.VC_Enabled then local ent = ply:GetVehicle() if IsValid(ent) and ent.VC_LightTable and ent.VC_LightTable.Head then if !ent.VC_HeadLightsOn then VC_HeadLightsOn(ent) else VC_HeadLightsOff(ent) end end end end)
concommand.Add("VC_Hazards_OnOff", function(ply) if VC_Settings.VC_Enabled then local ent = ply:GetVehicle() if IsValid(ent) and ent.VC_LightTable and ent.VC_LightTable.Blinker then if !ent.VC_HazardLightsOn then VC_HazardLightsOn(ent) else VC_HazardLightsOff(ent) end end end end)
concommand.Add("VC_Blinker_Left", function(ply) if VC_Settings.VC_Enabled then local ent = ply:GetVehicle() if IsValid(ent) and ent.VC_LightTable and ent.VC_LightTable.Blinker then if !ent.VC_TurnLightLeftOn then VC_TurnLightLeftOn(ent) else VC_TurnLightLeftOff(ent) end end end end)
concommand.Add("VC_Blinker_Right", function(ply) if VC_Settings.VC_Enabled then local ent = ply:GetVehicle() if IsValid(ent) and ent.VC_LightTable and ent.VC_LightTable.Blinker then if !ent.VC_TurnLightRightOn then VC_TurnLightRightOn(ent) else VC_TurnLightRightOff(ent) end end end end)

concommand.Add("VC_Switch_Seats", function(ply)
	if VC_Settings.VC_Enabled and VC_Settings.VC_Passenger_Seats and IsValid(ply:GetVehicle()) and (!ply.VC_ChgST or CurTime() >= ply.VC_ChgST) and !(IsValid(ply.VC_HangingOutSeat) and IsValid(ply.VC_HangingOutSeat.VC_HangingOutPlayer) and ply == ply.VC_HangingOutSeat.VC_HangingOutPlayer) then
	local MVeh = ply:GetVehicle().VC_ExtraSeat and ply:GetVehicle():GetParent() or ply:GetVehicle()
	local STbl = table.Add({MVeh}, table.Copy(MVeh.VC_SeatTable))

	local SeatCount = table.Count(STbl)
		if table.Count(STbl) > 1 then
		local Seatk = 1 if MVeh != ply:GetVehicle() then for Stk, Stv in pairs(MVeh.VC_SeatTable) do if ply:GetVehicle() == Stv then Seatk = Stk+1 break end end end
		local SortedSeatTable = {} for Stk, Stv in pairs(STbl) do local SeatNum = Stk+Seatk if SeatNum > SeatCount then SeatNum = SeatNum-SeatCount end table.insert(SortedSeatTable, STbl[SeatNum]) end
			for Seatk, Seat in pairs(SortedSeatTable) do
				if !IsValid(Seat:GetDriver()) and !Seat.VC_AI_Driver then
				ply.VC_ChnSts = true ply.VC_SeatRCN = true local ACA = Seat:WorldToLocalAngles(ply:EyeAngles()) ACA.r = 0 ply:ExitVehicle() ply.VC_CanEnterTime = nil ply:EnterVehicle(Seat) ply:SetEyeAngles(ACA) ply.VC_ChnSts = false break
				end
			end
		end
	ply.VC_ChgST = CurTime()+ 0.5
	end
end)

concommand.Add("VC_Trailer_Detach", function(ply) if VC_Settings.VC_Enabled then local ent = ply:GetVehicle() if IsValid(ent) and IsValid(ent.VC_HookVeh) then VC_Trailer_Detach(ent) end end end)

concommand.Add("vc_cruise_onoff", function(ply)
	if VC_Settings.VC_Enabled and IsValid(ply:GetVehicle()) and string.lower(ply:GetVehicle():GetClass()) != "prop_vehicle_prisoner_pod" then
		if ply:GetVehicle().VC_Cruise then
		ply:GetVehicle().VC_Cruise = false VC_EmitSound(ply:GetVehicle(), "Clk", 105)
		elseif VC_Settings.VC_Cruise_Enabled then
		ply:GetVehicle().VC_Cruise = true VC_EmitSound(ply:GetVehicle(), "Clk", 105)
		end
	end
end)
concommand.Add("VC_Switch_Seats_1", function(ply) if VC_Settings.VC_Enabled and IsValid(ply:GetVehicle()) and ply:GetVehicle().VC_ExtraSeat and (!ply.VC_ChgST or CurTime() >= ply.VC_ChgST) and !(IsValid(ply.VC_HangingOutSeat) and IsValid(ply.VC_HangingOutSeat.VC_HangingOutPlayer) and ply == ply.VC_HangingOutSeat.VC_HangingOutPlayer)then local Seat = ply:GetVehicle():GetParent() if Seat != ply:GetVehicle() and !IsValid(Seat:GetDriver()) then ply.VC_ChnSts = true local ACA = Seat:WorldToLocalAngles(ply:EyeAngles()) ACA.r = 0 Seat:SetThirdPersonMode(ply:GetVehicle():GetThirdPersonMode()) ply:ExitVehicle() ply.VC_CanEnterTime = nil ply:EnterVehicle(Seat) ply:SetEyeAngles(ACA) end end end)