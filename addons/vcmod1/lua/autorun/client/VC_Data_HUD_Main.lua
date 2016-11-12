// Copyright © 2012-2015 VCMod (freemmaann). All Rights Reserved. if you have any complaints or ideas contact me: email - freemmaann@gmail.com or skype - comman6.

if !VC_DrawFT then VC_DrawFT = {} end

VC_DrawFT["Repair"] = function(ply, FTm, CARot, GVeh, DrvV, Veh, Sart_Height)
	local TVeh, TPos = nil, nil local Wep = ply:GetActiveWeapon() if !IsValid(Wep) then Wep = nil end local On = !IsValid(ply:GetVehicle()) and Wep and (Wep:GetClass() == "vc_wrench" or Wep:GetClass() == "vc_repair")
	if On then TVeh, TPos = VC_GetVehicle(ply) if !TVeh or !TVeh:IsVehicle() then On = false end if TPos:Distance(ply:GetPos()) > 70 then On = nil end end
	local Lrp = "Repair" VC_DrawFT["Lerp"](On, Lrp, FTm, 0.05, 0.05)

	if VC_Anim_Lerp[Lrp] then
	local Int = 0
		if On and IsValid(TVeh) then
		Int = TVeh:GetNWInt("VC_Health")
		if Int < 0 then Int = 0 end
		if TVeh:GetNWInt("VC_MaxHealth") > 0 then Int = Int/TVeh:GetNWInt("VC_MaxHealth") end
		ply.VC_HUD_Rep_LastInt = Lerp(0.1, ply.VC_HUD_Rep_LastInt or 0, Int)
		end

	Int = ply.VC_HUD_Rep_LastInt or 0

	draw.RoundedBox(4, ScrW()/2- 300/2+CARot[1], ScrH()/1.1-15+CARot[2], 300, 45, Color(0, 0, 0, 150*VC_Anim_Lerp[Lrp]))
	if !VC_Fonts["VC_Cruise"] then VC_Fonts["VC_Cruise"] = true surface.CreateFont("VC_Cruise", {font = "MenuLarge", size = 26, weight = 1000, blursize = 0, scanlines = 0, antialias = true, underline = false, italic = false, strikeout = false, symbol = false, rotary = false, shadow = false, additive = false,outline = false}) end
	if !VC_Fonts["VC_RepairSmall"] then VC_Fonts["VC_RepairSmall"] = true surface.CreateFont("VC_RepairSmall", {font = "MenuLarge", size = 16, weight = 1000, blursize = 0, scanlines = 0, antialias = true, underline = false, italic = false, strikeout = false, symbol = false, rotary = false, shadow = false, additive = false,outline = false}) end
	draw.SimpleText("Repairing vehicle", "VC_Cruise", ScrW()/2+CARot[1], ScrH()/1.1-3+CARot[2], Color(255, 255, 255, 255*VC_Anim_Lerp[Lrp]), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

	draw.RoundedBox(0, ScrW()/2- 295/2+CARot[1], ScrH()/1.1+13+CARot[2], 295, 15, Color(0, 0, 0, 150*VC_Anim_Lerp[Lrp]))
	draw.RoundedBox(0, ScrW()/2- 295/2+CARot[1], ScrH()/1.1+13+CARot[2], 295*Int, 15, Int < 0.125 and Color(255,0,0,150*VC_Anim_Lerp[Lrp]) or Int < 0.4 and Color(255,155,0,150*VC_Anim_Lerp[Lrp]) or Color(0, 100+155*Int, 100+155*(1-Int), 150*VC_Anim_Lerp[Lrp]))
	draw.SimpleText("Health: "..math.Round(Int*100).."%", "VC_RepairSmall", ScrW()/2+CARot[1], ScrH()/1.1+19+CARot[2], Color(255, 255, 255, 255*VC_Anim_Lerp[Lrp]), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	end
end

VC_DrawFT["Name"] = function(ply, FTm, CARot, GVeh, DrvV, Veh, Sart_Height)
	if !ply.VC_HUD_Name_Tm and IsValid(GVeh) and GVeh.VC_IsNotPrisonerPod then ply.VC_HUD_PNam = GVeh:GetNWString("VC_Name") ply.VC_HUD_PNam = ply.VC_HUD_PNam == "" and "Unknown Vehicle" or ply.VC_HUD_PNam ply.VC_HUD_Name_Tm = CurTime()+2 elseif ply.VC_HUD_Name_Tm and !IsValid(GVeh) then ply.VC_HUD_Name_Tm = nil end
	local Lrp = "Name" VC_DrawFT["Lerp"](ply.VC_HUD_Name_Tm and CurTime() < ply.VC_HUD_Name_Tm, Lrp, FTm, 0.05, 0.05)

	if VC_Anim_Lerp[Lrp] then
	local Num = VC_EaseInOut(VC_Anim_Lerp[Lrp])
	CARot = CARot or CalcRot()
	local EIVal, Wth = 50*Num-50, (table.Count(string.Explode("", ply.VC_HUD_PNam))+10)*12 Wth = Wth < 64 and 64 or Wth
	draw.RoundedBox(0, EIVal-5, ScrH()/1.2+CARot[2]+15, Wth+CARot[1]-20, 2, Color(100, 255, 55, 255*Num))
	if !VC_Fonts["VC_Name"] then VC_Fonts["VC_Name"] = true surface.CreateFont("VC_Name", {font = "tahoma", size = 30, weight = 1000, blursize = 0, scanlines = 0, antialias = true, underline = false, italic = false, strikeout = false, symbol = false, rotary = false, shadow = false, additive = false,outline = false}) end
	draw.SimpleText(ply.VC_HUD_PNam, "VC_Name", Wth+CARot[1]-35+EIVal, ScrH()/1.2+CARot[2], Color(255, 255, 255, 255*Num), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
	end
end

VC_DrawFT["Cruise"] = function(ply, FTm, CARot, GVeh, DrvV, Veh, Sart_Height)
	local Lrp = "Cruise" VC_DrawFT["Lerp"](DrvV and GVeh == Veh and GVeh:GetNWInt("VC_Cruise_Spd") > 0, Lrp, FTm, 0.05, 0.05)

	if VC_Anim_Lerp[Lrp] then
	CARot = CARot or CalcRot()
	local CCVel = GVeh and GVeh:GetNWInt("VC_Cruise_Spd") or 0
	if DrvV and (ply:KeyDown(IN_FORWARD) or ply:KeyDown(IN_BACK)) then if !ply.VC_Cruise_KDV or ply.VC_Cruise_KDV < 1 then ply.VC_Cruise_KDV = math.Round(((ply.VC_Cruise_KDV or 0)+ 0.1)*100)/100 end CCVel = -GVeh:GetVelocity():Dot(GVeh:GetRight()) elseif ply.VC_Cruise_KDV then if ply.VC_Cruise_KDV > 0 then ply.VC_Cruise_KDV = math.Round((ply.VC_Cruise_KDV- 0.1)*100)/100 end end
	local SCVr = math.Clamp((ply.VC_Cruise_HUD_L or 0)/5-5, 0, 20)*(1-(ply.VC_Cruise_KDV or 0))
	local Miles = VC_Settings.VC_HUD_Cruise_MPh
	CCVel = (CCVel > 10 and CCVel or 10)* (Miles and 0.0568181818 or 0.09144) ply.VC_Cruise_HUD_L = Lerp(0.05*FTm, ply.VC_Cruise_HUD_L or 0, CCVel)

	draw.RoundedBox(0, ScrW()/2- (300/2+15*(ply.VC_Cruise_KDV or 0))*VC_Anim_Lerp[Lrp]+CARot[1], ScrH()/1.1+ (20+ (15-VC_Anim_Lerp[Lrp]*15)+CARot[2]), (300+25*(ply.VC_Cruise_KDV or 0))*VC_Anim_Lerp[Lrp], 2, Color(100, 255, 55, 255*VC_Anim_Lerp[Lrp]))
	if !VC_Fonts["VC_Cruise"] then VC_Fonts["VC_Cruise"] = true surface.CreateFont("VC_Cruise", {font = "MenuLarge", size = 26, weight = 1000, blursize = 0, scanlines = 0, antialias = true, underline = false, italic = false, strikeout = false, symbol = false, rotary = false, shadow = false, additive = false,outline = false}) end
	draw.SimpleText("Cruising at "..tostring(math.Round(ply.VC_Cruise_HUD_L)).." "..(Miles and "mi/h" or "km/h")..".", "VC_Cruise", ScrW()/2+CARot[1], ScrH()/1.1+(10-VC_Anim_Lerp[Lrp]*10)+CARot[2], Color(255, 255-200*(ply.VC_Cruise_KDV or 0), 255-200*(ply.VC_Cruise_KDV or 0), 180*VC_Anim_Lerp[Lrp]+math.sin(CurTime()*5+SCVr/3)*35), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	elseif ply.VC_Cruise_HUD_L then
	ply.VC_Cruise_HUD_L = nil ply.VC_Cruise_KDV = nil
	end
end

VC_DrawFT["PickUp"] = function(ply, FTm, CARot, GVeh, DrvV, Veh, Sart_Height)
	for k,v in pairs(ents.FindByClass("vc_pickup*")) do
	local Vis = util.PixelVisible(v:GetPos()+Vector(0,0,25), 1, v.VC_PVsb) local Dist = nil
		if Vis > 0 then Dist = EyePos():Distance(v:GetPos()) end
		local Lrp = "Pickup_"..k VC_DrawFT["Lerp"](Vis > 0 and Dist < 2500, Lrp, FTm, 0.05, 0.05)
		if VC_Anim_Lerp[Lrp] then
		local VisM = VC_Anim_Lerp[Lrp]*255
		surface.SetDrawColor(v.VC_Color.r, v.VC_Color.g, v.VC_Color.b, VisM)
		local Pos = v:GetPos():ToScreen() local PSx,PSy = Pos.x, Pos.y local PEx,PEy = Pos.x+20, Pos.y-15
		surface.DrawLine(PSx, PSy, PEx+1, PEy) surface.DrawLine(PSx, PSy+1, PEx, PEy+1) surface.DrawLine(PSx, PSy+2, PEx, PEy+2)
		draw.RoundedBox(0, PEx, PEy, v.VC_Length, 2, Color(v.VC_Color.r, v.VC_Color.g, v.VC_Color.b, VisM))
		surface.DrawTexturedRect(PSx-4, PSy-4, 8, 8)
		local Fnt = "VC_HealthKit" if !VC_Fonts[Fnt] then VC_Fonts[Fnt] = true surface.CreateFont(Fnt, {font = "MenuLarge", size = 18, weight = 1000, blursize = 0, scanlines = 0, antialias = true, underline = false, italic = false, strikeout = false, symbol = false, rotary = false, shadow = false, additive = false,outline = false}) end
		draw.SimpleText(v.VC_Text, Fnt, PEx+5, PEy-10, Color(255, 255, 255, VisM), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
		end
	end
end

local icon_head = surface.GetTextureID("vcmod/dash/hightlights")
local icon_blnk_l = surface.GetTextureID("vcmod/dash/turnarrow_left")
local icon_blnk_r = surface.GetTextureID("vcmod/dash/turnarrow_right")
local icon_nrml = surface.GetTextureID("vcmod/dash/lights")
local icon_trl = surface.GetTextureID("vcmod/vgui/speedo/trailer")

local AnimCT = 500
VC_DrawFT["Icons"] = function(ply, FTm, CARot, GVeh, DrvV, Veh, Sart_Height, Lrp, SrnTbl)
	local Lrp = Lrp VC_DrawFT["Lerp"](GVeh and Veh == GVeh, Lrp, FTm, (0.02+Lrp/AnimCT), (0.01+Lrp/AnimCT))
	local MainSz = 38

	if VC_Anim_Lerp[Lrp] then
	local Rat_L = VC_Anim_Lerp[Lrp]*2 if Rat_L > 1 then Rat_L = 1 end local Rat_B = VC_Anim_Lerp[Lrp]*3 if Rat_B > 1 then Rat_B = 1 end local Rat_T = VC_Anim_Lerp[Lrp]*2-1 if Rat_T < 0 then Rat_T = 0 end
	draw.RoundedBox(4-4*(VC_Anim_Lerp["Trl"] or 0), ScrW()-170+CARot[1], Sart_Height+CARot[2], 180-CARot[1], MainSz, Color(0, 0, 0, 225*Rat_B))

	local Lrp2 = "Trl" VC_DrawFT["Lerp"](Veh and IsValid(Veh:GetNWEntity("VC_HookedVh")) and VC_Anim_Lerp[Lrp] == 1, Lrp2, FTm, 0.05, 0.02)

// Trailer
	if VC_Anim_Lerp["Trl"] then
	local Rat_L = VC_Anim_Lerp["Trl"]*2 if Rat_L > 1 then Rat_L = 1 end local Rat_BT = VC_Anim_Lerp["Trl"]*3 if Rat_BT > 1 then Rat_BT = 1 end local Rat_TT = VC_Anim_Lerp["Trl"]*2-1 if Rat_TT < 0 then Rat_TT = 0 end
	draw.RoundedBox(0, ScrW()-210+CARot[1], Sart_Height+CARot[2], 40, MainSz, Color(0, 0, 0, 255*Rat_BT))
	surface.SetDrawColor(100,255,55,255*Rat_TT) surface.SetTexture(icon_trl) surface.DrawTexturedRect(ScrW()-210+CARot[1], Sart_Height+CARot[2]+4, 40, 40)
	end

// Lights
	local On = IsValid(Veh) local BL, BR, Hd, Nrm, Haz
	if On then BL, BR, Hd, Nrm, Haz = Veh:GetNWBool("VC_Lights_Blinker_Created_Left"), Veh:GetNWBool("VC_Lights_Blinker_Created_Right"), Veh:GetNWBool("VC_Lights_Head_Created"), Veh:GetNWBool("VC_Lights_Normal_Created"), Veh:GetNWBool("VC_Lights_Hazards_Created") end
	local Temp_Sart_Height = Sart_Height+3
	local PX,PY = ScrW()-160+CARot[1], Temp_Sart_Height+CARot[2]

	if On and BL or Haz then surface.SetDrawColor(100,255,55,255*Rat_T) else surface.SetDrawColor(255,255,255,255*Rat_T) end surface.SetTexture(icon_blnk_l)

	surface.DrawTexturedRect(PX, PY, 35, 25)
	if On and Hd then if Veh:GetNWBool("VC_HighBeam") then surface.SetDrawColor(120,205,255,255*Rat_T) else surface.SetDrawColor(100,255,55,255*Rat_T) end else surface.SetDrawColor(255,255,255,255*Rat_T) end surface.SetTexture(icon_head) surface.DrawTexturedRect(ScrW()-Lerp(2/3.2,160,30)+CARot[1], Temp_Sart_Height+CARot[2], 25, 25)
	if On and Nrm then surface.SetDrawColor(100,255,55,255*Rat_T) else surface.SetDrawColor(255,255,255,255*Rat_T) end surface.SetTexture(icon_nrml) surface.DrawTexturedRect(ScrW()-Lerp(1/2.8,160,30)+CARot[1], Temp_Sart_Height+CARot[2]+1, 25, 25)
	if On and BR or Haz then surface.SetDrawColor(100,255,55,255*Rat_T) else surface.SetDrawColor(255,255,255,255*Rat_T) end surface.SetTexture(icon_blnk_r) surface.DrawTexturedRect(ScrW()-40+CARot[1], Temp_Sart_Height+CARot[2], 35, 25)

	local Trl = (VC_Anim_Lerp["Trl"] or 0)*40 local Clr = Color(255,255,255,255) if On and (BL or BR or Hd or Nrm or Haz) then Clr = Color(100,255,55,255) end
	draw.RoundedBox(0, ScrW()-165*Rat_L+CARot[1]-Trl, Sart_Height+30+CARot[2], 170-CARot[1]+Trl, 2, Clr)
	end
	if VC_Anim_Lerp[Lrp] then Sart_Height=Sart_Height+MainSz+2 end return Sart_Height
end

VC_DrawFT["Health"] = function(ply, FTm, CARot, GVeh, DrvV, Veh, Sart_Height, Lrp, SrnTbl)
	local Lrp = Lrp VC_DrawFT["Lerp"](GVeh and Veh == GVeh, Lrp, FTm, (0.02+Lrp/AnimCT), (0.01+Lrp/AnimCT))
	local MainSz = 32

	if VC_Anim_Lerp[Lrp] then
	local Rat_L = VC_Anim_Lerp[Lrp]*2 if Rat_L > 1 then Rat_L = 1 end local Rat_B = VC_Anim_Lerp[Lrp]*3 if Rat_B > 1 then Rat_B = 1 end local Rat_T = VC_Anim_Lerp[Lrp]*2-1 if Rat_T < 0 then Rat_T = 0 end
	draw.RoundedBox(4, ScrW()-170+CARot[1], Sart_Height+CARot[2], 180-CARot[1], MainSz, Color(0, 0, 0, 225*Rat_B))

	local Max = GVeh and GVeh:GetNWInt("VC_MaxHealth") or 0
	draw.SimpleText("Health", "VC_Regular2", ScrW()-160+CARot[1], Sart_Height+22+CARot[2], Color(255, 255,255,255*Rat_T), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)

	local Num = (GVeh and GVeh:GetNWInt("VC_Health") or 0)/Max if Num < 0 then Num = 0 end if Max == 0 then Num = 1 end draw.SimpleText(math.ceil(Num*100).."%", "VC_Regular2", ScrW()-25+CARot[1], Sart_Height+22+CARot[2], Color(255-155*Num, 100+155*Num,55,255*Rat_T), TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)
	local Clr = Color(100,255,55,255) if Num < 0.4 then if Num < 0.125 then if math.sin(CurTime()*30) > 0 then Clr = Color(255,55,55,255) end else Clr = Color(255,155,0,255) end end
	draw.RoundedBox(0, ScrW()-165*Rat_L+CARot[1], Sart_Height+24+CARot[2], 170-CARot[1], 2, Clr)
	end
	if VC_Anim_Lerp[Lrp] then Sart_Height=Sart_Height+MainSz+2 end return Sart_Height
end