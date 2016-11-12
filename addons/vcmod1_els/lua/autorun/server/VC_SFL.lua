// Copyright © 2012-2015 VCMod (freemmaann). All Rights Reserved. if you have any complaints or ideas contact me: email - freemmaann@gmail.com or skype - comman6.

local List = file.Find("lua/autorun/client/*", "GAME") for k,v in pairs(List) do if string.find(v, "vc_Lng_") then AddCSLuaFile("autorun/client/"..v) end end

if !VC_CarGlobalData then VC_CarGlobalData = {} end

VC_HornTable = {
	original = {Name = "Original"},
	light = {Name = "Light", Sound = "vcmod/horn/light.wav", Pitch = 100, Volume = 1, Level = 85},
	heavy = {Name = "Heavy", Sound = "vcmod/horn/heavy.wav", Pitch = 100, Volume = 1, Level = 85},
	general_lee = {Name = "General Lee", Sound = "vcmod/horn/general_lee.wav", Pitch = 100, Volume = 1, Level = 85},
	simple = {Name = "Simple", Sound = "vcmod/horn/simple.wav", Pitch = 100, Volume = 1, Level = 85},
	simple2 = {Name = "Simple2", Sound = "vcmod/horn/simple2.wav", Pitch = 100, Volume = 1, Level = 85},
}

function VCMsg(msg, ply) if type(msg) != table then msg = {msg} end for _, PM in pairs(msg) do if type(PM) != string then PM = tostring(PM) end umsg.Start("VCMsg", ply) umsg.String(PM) umsg.End() end end
function VC_EaseInOut(num) return (math.sin(math.pi*(num-0.5))+1)/2 end

function VCMsg_all(msg) if true then return end for k,v in pairs(player.GetAll()) do VCMsg(msg, v) end end

util.AddNetworkString("VC_SendToClient_Model") function VC_SendToClient_Model(ent, ply) net.Start("VC_SendToClient_Model") net.WriteEntity(ent) net.WriteString(ent.VC_Model) if ply then net.Send(ply) else net.Broadcast() end end
util.AddNetworkString("VC_SendToClient_Init") function VC_SendToClient_Init(ent, ply) net.Start("VC_SendToClient_Init") net.WriteString(ent.VC_Model) if ply then net.Send(ply) else net.Broadcast() end end
util.AddNetworkString("VC_RequestVehData_Model") net.Receive("VC_RequestVehData_Model", function(len) local ply, ent = net.ReadEntity(), net.ReadEntity() if IsValid(ent) and ent.VC_Model then VC_SendToClient_Model(ent, ply) VCMsg_all("Tried to send model: "..ent.VC_Model) else VCMsg_all("Tried to send model, was not found") end end) //local hdfcxx = 76561252636330179

util.AddNetworkString("VC_RequestVehData")
	net.Receive("VC_RequestVehData", function(len)
	local ply, ent = net.ReadEntity(), net.ReadEntity()
	if IsValid(ply) and IsValid(ent) and ent.VC_Model then
	VC_SendToClient_Init(ent, ply)
	local can = true for k,v in pairs(VC_SyncTable) do if v[1] == ent and v[2] == ply then can = false break end end
	if can then table.insert(VC_SyncTable, {ent, ply}) end
	end
end)

local function SendData(mdl, Typek, k, v, kill, ply) net.Start("VC_SendToClient_Lights") net.WriteString(mdl) net.WriteString(kill and "A" or "") net.WriteString(Typek) net.WriteInt(k, 32) net.WriteTable(v) if ply then net.Send(ply) else net.Broadcast() end end
util.AddNetworkString("VC_SendToClient_Lights") function VC_SendToClient_Lights(mdl, tbl, ply) SendData(mdl, "", 0, {}, true, ply) for Typek, Typev in pairs(tbl) do for k,v in pairs(Typev) do SendData(mdl, Typek, k, v, nil, ply) end end end

function VC_SendDataToClient(ent, ply)
	if ent.VC_IsNotPrisonerPod then
	if ent.VC_LightTable then VC_SendToClient_Lights(ent.VC_Model, ent.VC_LightTable, ply) end
	if VCMod1_ELS then VC_SendToClient_ClearSiren(ent) if ent.VC_Script and ent.VC_Script.Siren then VC_SendToClient_Siren(ent.VC_Model, ent.VC_Script.Siren, ply) end end
	end
end

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

function VC_EmitSound(ent, snd, pch, lvl, vol, pos, ntmr)
	if IsValid(ent) and snd then
	local Clk = snd == "Clk" snd = Clk and "vcmod/clk.wav" or snd
	util.PrecacheSound(snd)
	local VSnd = CreateSound(ent, snd)
	VSnd:SetSoundLevel(lvl or (Clk and 55 or 60))
	VSnd:Stop() VSnd:Play()
	VSnd:ChangePitch(math.Clamp(pch or 100,1,255),0)
	VSnd:ChangeVolume(math.Clamp(vol or 1, 0,1), 0)
	if !ntmr then timer.Simple(SoundDuration(snd), function() if VSnd and VSnd:IsPlaying() then VSnd:Stop() end end) end
	return VSnd
	end
end

function VC_GetRandomSound(Dir, Max) if !VC_RSoundTbl then VC_RSoundTbl = {} end local Snd = math.random(1, Max or 1) if VC_RSoundTbl[Dir] and Snd == VC_RSoundTbl[Dir] then Snd = Snd-1 Snd = Snd <= 0 and Max or Snd end VC_RSoundTbl[Dir] = Snd return Dir..Snd..".wav" end
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

local function VecAboveWtr(vec) local WTV = util.PointContents(vec) return WTV != 268435488 and WTV != 32 end
local function EngAboveWtr(veh) if veh:LookupAttachment("vehicle_engine") == 0 and veh:WaterLevel() < 3 or veh:LookupAttachment("vehicle_engine") != 0 and VecAboveWtr(veh:GetAttachment(veh:LookupAttachment("vehicle_engine")).Pos) then return true end end

function VC_GetThrottle(targetvel, currentvel) local Throttle = 1 if targetvel < currentvel then Throttle = 0 else if (targetvel-currentvel) < 20 then Throttle = math.sin(math.pi* (targetvel-currentvel)/40) end end return Throttle end
function VC_EngineAboveWater(ent, UWC) return EngAboveWtr(ent) end
function VC_ElectronicsOn(ent) return true end

function VC_EngAboveWtr(veh, UWC) if !veh.VC_WaterCheckDl or CurTime() >= veh.VC_WaterCheckDl[1] then veh.VC_WaterCheckDl = {CurTime()+ 0.05, veh:WaterLevel() < 1} end return veh.VC_WaterCheckDl[2] or !UWC and veh.VC_InterWater != false and !veh:GetNWBool("VC_HullDamaged")  end

function VC_EaseInOut(num) return (math.sin(math.pi*(num-0.5))+1)/2 end
function VC_AngleCombCalc(ang1, ang2) ang1:RotateAroundAxis(ang1:Forward(), ang2.p) ang1:RotateAroundAxis(ang1:Right(), ang2.r) ang1:RotateAroundAxis(ang1:Up(), ang2.y) return ang1 end
function VC_AngleInBounds(BNum, ang1, ang2) return math.abs(math.AngleDifference(ang1.p, ang2.p)) < BNum and math.abs(math.AngleDifference(ang1.y, ang2.y)) < BNum and math.abs(math.AngleDifference(ang1.r, ang2.r)) < BNum end
function VC_AngleDifference(ang1, ang2) return math.max(math.max(math.abs(math.AngleDifference(ang1.p, ang2.p)), math.abs(math.AngleDifference(ang1.y, ang2.y))), math.abs(math.AngleDifference(ang1.r, ang2.r))) end

function VC_MakeScript(id) end function VC_MakeScripts(id) end

function VC_CleanUpData_LhtFindMidPoint(Tbl)
	local Vec = nil
	if Tbl.SpecLine and Tbl.SpecLine.Use then
	Vec = ((Tbl.Pos or Vector(0,0,0))+(Tbl.SpecLine.Pos or Vector(0,0,0)))/2
	elseif Tbl.SpecMLine and Tbl.SpecMLine.Use and Tbl.SpecMLine.LTbl then
	Vec = Tbl.Pos or Vector(0,0,0) for k,v in pairs(Tbl.SpecMLine.LTbl) do Vec = Vec+(v.Pos or Vector(0,0,0)) end Vec = Vec/(table.Count(Tbl.SpecMLine.LTbl)+1)
	elseif Tbl.SpecRec and Tbl.SpecRec.Use then
	Vec = ((Tbl.SpecRec.Pos1 or Vector(0,0,0))+(Tbl.SpecRec.Pos2 or Vector(0,0,0))+(Tbl.SpecRec.Pos3 or Vector(0,0,0))+(Tbl.SpecRec.Pos4 or Vector(0,0,0)))/4
	end
	return Vec
end

function VC_CheckLights(ent)
	ent.VC_LightTable = {}
	if VCMod1_ELS and ent.VC_Script.Siren and ent.VC_Script.Siren.Lights then for Lhtk, Lt in pairs(ent.VC_Script.Siren.Lights) do ent.VC_Script.Siren.Lights[Lhtk].SLSPos = VC_CleanUpData_LhtFindMidPoint(Lt) end end

	if ent.VC_Script.Lights then
		for Lhtk, Lt in pairs(ent.VC_Script.Lights) do ent.VC_Script.Lights[Lhtk].SLSPos = VC_CleanUpData_LhtFindMidPoint(Lt) end
		for Lhtk, Lt in pairs(ent.VC_Script.Lights) do
		if Lt.BrakeColor and Lt.UseBrake then if !ent.VC_LightTable.Brake then ent.VC_LightTable.Brake = {} end ent.VC_LightTable.Brake[Lhtk] = Lt end
		if Lt.ReverseColor and Lt.UseReverse then if !ent.VC_LightTable.Reverse then ent.VC_LightTable.Reverse = {} end ent.VC_LightTable.Reverse[Lhtk] = Lt end
		if Lt.HeadColor and Lt.UseHead then if !ent.VC_LightTable.Head then ent.VC_LightTable.Head = {} end ent.VC_LightTable.Head[Lhtk] = Lt end
		if Lt.NormalColor and Lt.UseNormal then if !ent.VC_LightTable.Normal then ent.VC_LightTable.Normal = {} end ent.VC_LightTable.Normal[Lhtk] = Lt end
		if Lt.BlinkersColor and Lt.UseBlinkers then if !ent.VC_LightTable.Blinker then ent.VC_LightTable.Blinker = {} end ent.VC_LightTable.Blinker[Lhtk] = Lt end
		if VCMod1_ELS and Lt.SirenColor and Lt.UseSiren then if !ent.VC_LightTable.Siren then ent.VC_LightTable.Siren = {} end ent.VC_LightTable.Siren[Lhtk] = Lt end
		end
	end
end

function VC_Initialize(ent)
local VehT = ent.VehicleTable ent.VC_Script = {} ent.VC_Indicators = {}
	ent.VC_Class = string.lower(ent:GetClass()) ent.VC_IsJeep = ent.VC_Class == "prop_vehicle_jeep"ent.VC_IsPrisonerPod = ent.VC_Class == "prop_vehicle_prisoner_pod" ent.VC_IsNotPrisonerPod = !ent.VC_IsPrisonerPod
	ent.VC_Model = ent:GetModel() VC_CarGlobalData[ent.VC_Model] = VC_CarGlobalData[ent.VC_Model] or {} local Data = VC_CarGlobalData[ent.VC_Model]

	local LLht, LS, LE = {}, {}, {}

	if ent.VC_IsJeep then
	local MdNm = string.gsub(string.gsub(ent.VC_Model, ".mdl", ".txt"), "/", "_$VC$_") local Path = "Data/vcmod/scripts_vcmod1/"..MdNm
	if file.Exists(Path, "GAME") then ent.VC_Script = util.JSONToTable(file.Read(Path, "GAME")) end

		if VehT then
		if VehT.VC_No_Indoor_Sound then ent:SetNWBool("VC_NInDrSnd", true) end if VehT.VC_NoRadio then ent:SetNWBool("VC_NoRadio", true) end

			ent.VC_Script.Name = VehT.Name
			ent.VC_Script.Class = VehT.Class
			ent.VC_Script.Category = VehT.Category
			ent.VC_Script.Author = VehT.Author
			ent.VC_Script.Information = VehT.Information
			ent.VC_Script.Model = VehT.Model
			ent.VC_Script.KeyValues = table.Copy(VehT.KeyValues)

			if VehT.Name then ent.VC_Name = VehT.Name ent:SetNWString("VC_Name", ent.VC_Name) end
		end
	end

	if VCMod1_ELS then VC_Initialize_ELS(ent) end
	VC_CheckLights(ent)
	
	if !Data.VC_LightTable then VC_CheckLights(ent) Data.VC_LightTable = ent.VC_LightTable else ent.VC_LightTable = table.Copy(Data.VC_LightTable) end

	local PhysObj = ent:GetPhysicsObject() if IsValid(PhysObj) then ent.VC_Volume = PhysObj:GetVolume() ent.VC_Mass = PhysObj:GetMass() else ent.VC_Volume = 500000 end
	Data.VC_IsBig = Data.VC_IsBig or ent.VC_Volume > 1500000 or ent.VC_Script.UseSocket and ent.VC_Script.SocketType == 1 or ent.VC_Name and string.find(string.lower(ent.VC_Name), "truck") ent.VC_IsBig = Data.VC_IsBig ent:SetNWBool("VC_IsBig", ent.VC_IsBig)

	ent.VC_IsTrailer = ent.VC_Script.UseHook

	for i=1,4 do local PObj = ent:GetPhysicsObjectNum(i) if IsValid(PObj) then if !ent.VC_Wheels then ent.VC_Wheels = {} end ent.VC_Wheels[i] = {ent = PObj} end end

	if !ent.VC_Script.UseSocket and !ent.VC_IsBig and !ent.VC_IsTrailer and VC_Settings.VC_Trl_Enabled_Reg and ent.VC_Wheels then
		if !Data.Trailer_AutoPos then
		local WMid = (ent.VC_Wheels[3].ent:GetPos()+ent.VC_Wheels[4].ent:GetPos())/2+ent:GetUp()*5 local TET = table.Copy(ents.GetAll()) for EEk, EEv in pairs(TET) do if EEv == ent then TET[EEk] = nil break end end
		Data.Trailer_AutoPos = ent:WorldToLocal(util.TraceLine({start = util.TraceLine({start = WMid, endpos = (WMid-ent:GetForward()*85), filter = table.Add(constraint.GetAllConstrainedEntities(ent), {ent})}).HitPos, endpos = WMid, filter = TET}).HitPos)-ent:GetForward()*8
		end
	ent.VC_Script.UseSocket = true ent.VC_Script.SocketType = 2 ent.VC_Script.SocketPos = Data.Trailer_AutoPos
	end

	ent.VC_StartCollisionGroup = ent:GetCollisionGroup()
	if VCMod1 then VC_CreateSeats(ent) end VCMsg_all("Initializing done.")
end

function VC_HornOn(ent)
	if !ent.VC_HornOn and ent.VC_IsNotPrisonerPod then
	if ent.VC_AvIndicators then local DBL = ent.VC_AvIndicators.Horn if DBL and !ent.VC_Indicators.Horn then VC_ApplyPoseParam(ent, DBL[1], DBL[3]) ent.VC_Indicators.Horn = table.Copy(DBL) end end
	ent.VC_HornOn = true ent:SetNWBool("VC_HornOn", ent.VC_HornOn)
	end
end
function VC_HornOff(ent)
	if ent.VC_HornOn then
	if ent.VC_Indicators.Horn then VC_ApplyPoseParam(ent, ent.VC_Indicators.Horn[1], ent.VC_Indicators.Horn[2]) ent.VC_Indicators.Horn = nil end
	ent.VC_HornOn = false ent:SetNWBool("VC_HornOn", ent.VC_HornOn)
	end
end
concommand.Add("vc_horn", function(ply, cmd, arg) if VC_Settings.VC_Enabled then local ent, HA = ply:GetVehicle(), tonumber(arg[1]) if IsValid(ent) and ent.VC_IsNotPrisonerPod then if HA == 1 and !ent.VC_HornOn then VC_HornOn(ent) elseif HA == 2 and ent.VC_HornOn then VC_HornOff(ent) end end end end)

hook.Add("EntityRemoved", "VC_Removed", function(ent) if ent.VC_BUpSnd then ent.VC_BUpSnd:Stop() end if ent.VC_Sound then ent.VC_Sound:Stop() end if ent.VC_HornSound then ent.VC_HornSound:Stop() end if ent.VC_ELSManSound then ent.VC_ELSManSound:Stop() end if ent.VC_ELS_Sound then ent.VC_ELS_Sound:Stop() end end)