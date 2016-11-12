// Copyright © 2012-2015 VCMod (freemmaann). All Rights Reserved. if you have any complaints or ideas contact me: email - freemmaann@gmail.com or skype - comman6.

VC_Anim_Lerp = {} if !VC_DrawFT then VC_DrawFT = {} end
if VCMod1 then include("VC_Data_HUD_Main.lua") end if VCMod1_ELS then include("VC_Data_HUD_ELS.lua") end

-- local function VC_DrawFT["Lerp"](On, Var, FTm, IncS, DecS)
VC_DrawFT["Lerp"] = function(On, Var, FTm, IncS, DecS)
	if On then
	if !VC_Anim_Lerp[Var] or VC_Anim_Lerp[Var] < 1 then VC_Anim_Lerp[Var] = math.Round(((VC_Anim_Lerp[Var] or 0)+ IncS*FTm)*100)/100 else VC_Anim_Lerp[Var] = 1 end
	elseif VC_Anim_Lerp[Var] then
	if VC_Anim_Lerp[Var] > 0 then VC_Anim_Lerp[Var] = math.Round((VC_Anim_Lerp[Var]- DecS*FTm)*100)/100 else VC_Anim_Lerp[Var] = nil end
	end
end

hook.Add("HUDPaint", "VC_HUDPaint", function()
	if VC_Settings.VC_Enabled and VC_Settings.VC_HUD then
		local ply, FTm = LocalPlayer(), FrameTime()*100 if FTm < 1 then FTm = 1 end
		local Veh = ply:GetVehicle() if !IsValid(Veh) or !Veh.VC_IsJeep then Veh = nil end local GVeh = Veh and Veh:GetNWBool("VC_ExtraSt") and Veh:GetParent() or Veh local DrvV = Veh and GetViewEntity() == LocalPlayer() and !ply.VC_ExitingV and (!Veh.VC_IDSOVET or CurTime() >= Veh.VC_IDSOVET)

		local AnChng = EyeAngles()-(VC_HUD_PAng or EyeAngles()) VC_HUD_PAng = EyeAngles() VC_HUD_AngRot = LerpAngle(0.2, VC_HUD_AngRot or AnChng, AnChng) local CARot = VC_Settings.VC_HUD_3D and {VC_HUD_AngRot.y*(VC_Settings.VC_HUD_3D_Mult or 1), VC_HUD_AngRot.p*(VC_Settings.VC_HUD_3D_Mult or 1)} or {0,0} if CARot[1] < 0.0001 and CARot[2] < 0.0001 then CARot = {0,0} end

		if !VC_Fonts["VC_Regular2"] then VC_Fonts["VC_Regular2"] = true surface.CreateFont("VC_Regular2", {font = "MenuLarge", size = 15, weight = 1000, blursize = 0, scanlines = 0, antialias = true, underline = false, italic = false, strikeout = false, symbol = false, rotary = false, shadow = false, additive = false,outline = false}) end
		if !VC_Fonts["VC_HUD_Bisgs"] then VC_Fonts["VC_HUD_Bisgs"] = true surface.CreateFont("VC_HUD_Bisgs", {font = "BudgetLabel", size = 17, weight = 1000, blursize = 0, scanlines = 0, antialias = true, underline = false, italic = false, strikeout = false, symbol = false, rotary = false, shadow = false, additive = false,outline = false}) end

		if !VC_Fonts["VC_Regular_S"] then VC_Fonts["VC_Regular_S"] = true surface.CreateFont("VC_Regular_S", {font = "MenuLarge", size = 10, weight = 1000, blursize = 0, scanlines = 0, antialias = true, underline = false, italic = false, strikeout = false, symbol = false, rotary = false, shadow = false, additive = false,outline = false}) end
		if !VC_Fonts["VC_Regular_SsS"] then VC_Fonts["VC_Regular_SsS"] = true surface.CreateFont("VC_Regular_SsS", {font = "MenuLarge", size = 12, weight = 1000, blursize = 0, scanlines = 0, antialias = true, underline = false, italic = false, strikeout = false, symbol = false, rotary = false, shadow = false, additive = false,outline = false}) end

		local Sart_Height = Lerp(VC_Settings.VC_HUD_Height and VC_Settings.VC_HUD_Height/100 or 0.35, 0, ScrH())
		if VCMod1 then
		if VC_Settings.VC_HUD_Repair then VC_DrawFT["Repair"](ply, FTm, CARot, GVeh, DrvV, Veh, Sart_Height) end
		if VC_Settings.VC_HUD_Name then VC_DrawFT["Name"](ply, FTm, CARot, GVeh, DrvV, Veh, Sart_Height) end
		if VC_Settings.VC_HUD_Cruise then VC_DrawFT["Cruise"](ply, FTm, CARot, GVeh, DrvV, Veh, Sart_Height) end
		if VC_Settings.VC_HUD_PickUp then VC_DrawFT["PickUp"](ply, FTm, CARot, GVeh, DrvV, Veh, Sart_Height) end
		end

		local Lrp = 1 local SrnTbl = GVeh and GVeh.VC_Model and VC_Global_Data[GVeh.VC_Model] and VC_Global_Data[GVeh.VC_Model].Siren
		if VCMod1 then
		if VC_Settings.VC_HUD_Icons then Sart_Height = VC_DrawFT["Icons"](ply, FTm, CARot, GVeh, DrvV, Veh, Sart_Height, Lrp, SrnTbl) Lrp = Lrp+1 end
		if VC_Settings.VC_HUD_Health then Sart_Height = VC_DrawFT["Health"](ply, FTm, CARot, GVeh, DrvV, Veh, Sart_Height, Lrp, SrnTbl) Lrp = Lrp+1 end
		end
		if VCMod1_ELS then
		if VC_Settings.VC_HUD_ELS_Siren then Sart_Height = VC_DrawFT["ELS_Siren"](ply, FTm, CARot, GVeh, DrvV, Veh, Sart_Height, Lrp, SrnTbl) Lrp = Lrp+1 end
		if VC_Settings.VC_HUD_ELS then Sart_Height = VC_DrawFT["ELS_Lights"](ply, FTm, CARot, GVeh, DrvV, Veh, Sart_Height, Lrp, SrnTbl) Lrp = Lrp+1 end
		end
	end
end)