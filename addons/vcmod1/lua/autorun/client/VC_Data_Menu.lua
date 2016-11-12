// Copyright © 2012-2015 VCMod (freemmaann). All Rights Reserved. if you have any complaints or ideas contact me: email - freemmaann@gmail.com or skype - comman6.

function VC_Menu_CreateList(Px,Py,Sx,Sy) local List = vgui.Create("DPanelList") List:EnableVerticalScrollbar(true) List:SetPos(Px, Py) List:SetSize(Sx, Sy) return List end
function VC_Menu_CreateCBox(Txt, TTip, CVar, Tbl, JustAdd) if !Tbl then Tbl = VC_Settings end local CBox = vgui.Create("DCheckBoxLabel") CBox:SetText(VC_Lng(Txt)) if CVar then CBox:SetValue(Tbl[CVar] or 0) CBox.OnChange = function(idx, val) if JustAdd then Tbl[CVar] = val else VC_SaveSetting_Cl(CVar, val) end end end if TTip then CBox:SetToolTip(TTip) end return CBox end
function VC_Menu_CreateSldr(Txt, Min, Max, Dec, TTip, CVar, Tbl, JustAdd) if !Tbl then Tbl = VC_Settings end local Sldr = vgui.Create("DNumSlider") Sldr:SetText(VC_Lng(Txt)) Sldr:SetMin(Min) Sldr:SetMax(Max) Sldr:SetDecimals(Dec) if TTip then Sldr:SetToolTip(TTip) end if CVar then Sldr:SetValue(Tbl[CVar] or 0) Sldr.OnValueChanged = function(idx, val) if JustAdd then Tbl[CVar] = val else VC_SaveSetting_Cl(CVar, val) end end end return Sldr end
function VC_DM_AddPanel(Prt, Tbl, Sy, NDraw) VC_DevPanelDimentions = Tbl local Pnl = vgui.Create(NDraw and (NDraw == 2 and "VC_Panel_Draw_Whole" or "VC_Panel_NoDraw") or "VC_Panel") Pnl.VC_Parent = Prt local Sx,_ = Prt:GetSize() Pnl:SetSize(Sx, Sy) Prt:AddItem(Pnl) return Pnl.VC_Panels end

local Int = 1

local function BuildMenu(Pnl)
	local Font = "VC_Treb24" if !VC_Fonts[Font] then VC_Fonts[Font] = true surface.CreateFont(Font, {font = "Trebuchet24", size = 26, weight = 10000, blursize = 0, scanlines = 0, antialias = true, underline = false, italic = false, strikeout = false, symbol = false, rotary = false, shadow = false, additive = false, outline = false}) end
	local Font_i = "VC_Treb24_Italic" if !VC_Fonts[Font_i] then VC_Fonts[Font_i] = true surface.CreateFont(Font_i, {font = "Trebuchet24", size = 26, weight = 10000, blursize = 0, scanlines = 0, antialias = true, underline = false, italic = true, strikeout = false, symbol = false, rotary = false, shadow = false, additive = false, outline = false}) end
	local Font2 = "VC_Treb24_Small" if !VC_Fonts[Font2] then VC_Fonts[Font2] = true surface.CreateFont(Font2, {font = "Trebuchet24", size = 17, weight = 500, blursize = 0, scanlines = 0, antialias = true, underline = false, italic = false, strikeout = false, symbol = false, rotary = false, shadow = false, additive = false, outline = false}) end
	local Font3 = "VC_Treb24_12" if !VC_Fonts[Font3] then VC_Fonts[Font3] = true surface.CreateFont(Font3, {font = "Trebuchet24", size = 12, weight = 500, blursize = 0, scanlines = 0, antialias = true, underline = false, italic = false, strikeout = false, symbol = false, rotary = false, shadow = false, additive = false, outline = false}) end
	local Font_Logo = "VC_Logo" if !VC_Fonts[Font_Logo] then VC_Fonts[Font_Logo] = true surface.CreateFont(Font_Logo, {font = "MenuLarge", size = 40, weight = 1000, blursize = 2, scanlines = 0, antialias = true, underline = false, italic = false, strikeout = false, symbol = false, rotary = false, shadow = false, additive = false, outline = false}) end

	if VCMod2 then
		Pnl.Paint = function()
		draw.RoundedBox(0, 0, 0, Pnl:GetWide(), Pnl:GetTall(), Color(255, 255, 255, 255))

		draw.DrawText("This is VCMod2, yep, thats right.", Font, Pnl:GetWide()/2, 10,  Color(0, 0, 0, 255), TEXT_ALIGN_CENTER)

		draw.DrawText(VC_Lng("CreatedBy")..": skype - comman6, steam - ", Font2, Pnl:GetWide()-78, Pnl:GetTall()-20,  Color(0, 0, 0, 255), TEXT_ALIGN_RIGHT)
		end
	else
		VCMod_Versions = {} http.Fetch("https://dl.dropboxusercontent.com/u/13116851/VCMod_Versions.txt", function(body) VCMod_Versions = util.KeyValuesToTable(body) end) timer.Simple(10, function() if table.Count(VCMod_Versions) < 1 then VCMod_Versions = nil end end)
		VCMod_Addons = {} http.Fetch("https://dl.dropboxusercontent.com/u/13116851/VCMod_Addons.txt", function(body) VCMod_Addons = util.KeyValuesToTable(body) end) timer.Simple(10, function() if table.Count(VCMod_Addons) < 1 then VCMod_Addons = nil end end)

		local List = VC_Menu_CreateList(7, 130, Pnl:GetWide()-14, Pnl:GetTall()-82) List:SetParent(Pnl) List:SetSpacing(7)

		Pnl.Paint = function()
		draw.RoundedBox(0, 0, 0, Pnl:GetWide(), Pnl:GetTall(), Color(255, 255, 255, 255))

		draw.DrawText(game.SinglePlayer() and VC_Lng("YouAreUsingVCMod") or VC_Lng("ServerIsUsingVCMod"), Font, Pnl:GetWide()/2, 10,  Color(0, 0, 0, 255), TEXT_ALIGN_CENTER)
		draw.DrawText("             "..VC_Lng("Info_EverThought"), Font2, 15, 50,  Color(0, 0, 0, 255), TEXT_ALIGN_LEFT)

		draw.DrawText(VC_Lng("Info_VCModHasFollowingAddons"), Font2, 15, 110,  Color(0, 0, 0, 255), TEXT_ALIGN_LEFT)

		draw.DrawText(VC_Lng("CreatedBy")..": skype - comman6, steam - ", Font2, Pnl:GetWide()-78, Pnl:GetTall()-20,  Color(0, 0, 0, 255), TEXT_ALIGN_RIGHT)
		end

		local El = vgui.Create("VC_Addon") List:AddItem(El) El:SetTall(75)
		El.Version = VCMod1
		El.VCheck = "vcmod1"
		El.Color = {255,0,0}
		El.Title = "Main"
		El.Name = "Main package"
		El.Features = {"Lights", "Passenger seats", "Damage system", "Horn", "Exhaust", "Third person dynamic view", "Cruise control and many more features"}
		El.Trailer = "http://www.youtube.com/watch?v=ElVOr4L9rhY"
		local El = vgui.Create("VC_Addon") List:AddItem(El) El:SetTall(75)
		El.Version = VCMod1_ELS
		El.VCheck = "vcmod1_els"
		El.Color = {255,200,0}
		El.Title = "ELS"
		El.Name = "Emergency"
		El.Features = {"(Police, taxi, road work, etc) lights", "HUD display", "Works on any vehicle", "Different codes", "HD Sounds", "Custom key selection", "Customisable"}
		El.Trailer = "http://www.youtube.com/watch?v=OpyPaAnpSM0"

		local El = vgui.Create("VC_Addon_Small") List:AddItem(El) El:SetTall(35)
		El.Version = VCMod1_Tool_Handling
		El.VCheck = "vcmod1_tool_handling"
		El.Color = {100,200,55}
		El.Title = "Tool"
		El.Name = "Handling Editor"
		El.Features = {"Edit handling script real time", "Export with one click", "Copy scripts part by part"}
		El.Trailer = nil

		local news = vgui.Create("DHTML", Pnl) news:OpenURL("http://vcmod.org/ingame/news/") news:SetPos(5, Pnl:GetTall()*0.65) news:SetSize(Pnl:GetWide()-10, 152)

		local Btn = vgui.Create("DButton") Btn:SetPos(Pnl:GetWide()-78, Pnl:GetTall()-23) Btn:SetSize(75, 20) Btn:SetText("freemmaann") Btn:SetParent(Pnl)
		Btn.DoClick = function() gui.OpenURL("http://steamcommunity.com/id/freemmaann/") end
		Btn.Paint = function()
		draw.RoundedBox(4, 0, 0, Btn:GetWide(), Btn:GetTall(), Color(0, 155, 0, 255))
		draw.RoundedBox(4, 2, 2, Btn:GetWide()-4, Btn:GetTall()-4, Color(255, 255, 255, 155))
		end
	end
end
VC_Menu_Info_Panel_Build = {"Info", BuildMenu}

function VC_CreateClSettingsTab_VC1(List, ListP)
	local SNLbl = vgui.Create("DLabel") SNLbl:SetText(VC_Lng("ThirdPView")) ListP:AddItem(SNLbl)
	local CBox = VC_Menu_CreateCBox("DynamicView", "Controls if VCMOd view controls are on or off.", "VC_ThirdPerson_Dynamic", VC_Settings) ListP:AddItem(CBox)
		local MPnl = VC_DM_AddPanel(ListP, {1/3,1/3,1/3}, 32, 2)
		local SNLbl = vgui.Create("DLabel") SNLbl:SetText("") SNLbl:SetTall(8) MPnl[1]:AddItem(SNLbl)
		local CBox = VC_Menu_CreateCBox("AutoFocus", "Focuses the camera behind the vehicle.", "VC_ThirdPerson_Auto", VC_Settings) MPnl[1]:AddItem(CBox)
		local SNLbl = vgui.Create("DLabel") SNLbl:SetText("") SNLbl:SetTall(8) MPnl[2]:AddItem(SNLbl)
		local CBox = VC_Menu_CreateCBox("Reverse", "Focuses the camera in front of the vehicle while reversing.", "VC_ThirdPerson_Auto_Back", VC_Settings) MPnl[2]:AddItem(CBox)
		local Sldr = VC_Menu_CreateSldr("Height", 0, 20, 0, "How high behind the car the camera will focus.", "VC_ThirdPerson_Auto_Pitch", VC_Settings) MPnl[3]:AddItem(Sldr)
	local Sldr = VC_Menu_CreateSldr("VectorStiffness", 0, 100, 0, "How far the view will stay behind before slowly returning to normal.", "VC_ThirdPerson_Vec_Stf", VC_Settings) ListP:AddItem(Sldr)
	local Sldr = VC_Menu_CreateSldr("AngleStiffness", 0, 100, 0, "How far the view will sway from side to side before slowly returning to normal.", "VC_ThirdPerson_Ang_Stf", VC_Settings) ListP:AddItem(Sldr)
	local CBox = VC_Menu_CreateCBox("IgnoreWorld", "Lets the view pass through objects.", "VC_ThirdPerson_Cam_World", VC_Settings) ListP:AddItem(CBox)
	local CBox = VC_Menu_CreateCBox("TruckView", "View focuses in between the trailer and the truck.", "VC_ThirdPerson_Cam_Trl", VC_Settings) ListP:AddItem(CBox)
end

if !VC_Menu_Items_P_Settings then
	local function BuildMenu(Pnl)
		local Font_Header = "VC_Menu_Header" if !VC_Fonts[Font_Header] then VC_Fonts[Font_Header] = true surface.CreateFont(Font_Header, {font = "MenuLarge", size = 18, weight = 1000, blursize = 2, scanlines = 0, antialias = true, underline = false, italic = false, strikeout = false, symbol = false, rotary = false, shadow = false, additive = false, outline = false}) end
		local Font_Header_Focused = "VC_Menu_Header_Focused" if !VC_Fonts[Font_Header_Focused] then VC_Fonts[Font_Header_Focused] = true surface.CreateFont(Font_Header_Focused, {font = "MenuLarge", size = 18, weight = 1000, blursize = 0, scanlines = 0, antialias = true, underline = false, italic = false, strikeout = false, symbol = false, rotary = false, shadow = false, additive = false, outline = false}) end
		local Font_Info = "VC_Info" if !VC_Fonts[Font_Info] then VC_Fonts[Font_Info] = true surface.CreateFont(Font_Info, {font = "MenuLarge", size = 24, weight = 1000, blursize = 0, scanlines = 0, antialias = true, underline = false, italic = false, strikeout = false, symbol = false, rotary = false, shadow = false, additive = false, outline = false}) end

		local List = VC_Menu_CreateList(0, 35, Pnl:GetWide(), Pnl:GetTall()-35) List:SetParent(Pnl)

		local CBox = VC_Menu_CreateCBox("Enabled_Cl", "Basically shuts down all the stuff bellow.", "VC_Enabled", VC_Settings) List:AddItem(CBox)
			local MPnl_M = VC_DM_AddPanel(List, {1}, 222)
			local SNLbl = vgui.Create("DLabel") SNLbl:SetText("Lights:") MPnl_M[1]:AddItem(SNLbl)
				local MPnl_M2 = VC_DM_AddPanel(MPnl_M[1], {1}, 202)
				local Sldr = VC_Menu_CreateSldr("VisDist", 0, 15000, 0, "How far the lights can be seen, reduces the lag a bit.", "VC_LightDistance", VC_Settings) MPnl_M2[1]:AddItem(Sldr)

				local MPnl = VC_DM_AddPanel(MPnl_M2[1], {0.25, 0.75}, 32, true)
				local SNLbl = vgui.Create("DLabel") SNLbl:SetText("") SNLbl:SetTall(8) MPnl[1]:AddItem(SNLbl)
				local CBox = VC_Menu_CreateCBox("Main", "Main texture to outline the light.", "VC_Light_Main", VC_Settings) MPnl[1]:AddItem(CBox)
				local Sldr = VC_Menu_CreateSldr("Multiplier", 0, 5, 2, "Will be multiplied by this amount.", "VC_Light_Main_M", VC_Settings) MPnl[2]:AddItem(Sldr)

				local MPnl = VC_DM_AddPanel(MPnl_M2[1], {0.25, 0.75}, 32, true)
				local SNLbl = vgui.Create("DLabel") SNLbl:SetText("") SNLbl:SetTall(8) MPnl[1]:AddItem(SNLbl)
				local CBox = VC_Menu_CreateCBox("Warmth", "Creates a new light in the middle, blends the two together.", "VC_Light_Warm", VC_Settings) MPnl[1]:AddItem(CBox)
				local Sldr = VC_Menu_CreateSldr("Multiplier", 0, 5, 2, "Will be multiplied by this amount.", "VC_Light_Warm_M", VC_Settings) MPnl[2]:AddItem(Sldr)

				local MPnl = VC_DM_AddPanel(MPnl_M2[1], {0.25, 0.75}, 32, true)
				local SNLbl = vgui.Create("DLabel") SNLbl:SetText("") SNLbl:SetTall(8) MPnl[1]:AddItem(SNLbl)
				local CBox = VC_Menu_CreateCBox("Lines", "The lines you see around lights if its bright enough.", "VC_Light_HD", VC_Settings) MPnl[1]:AddItem(CBox)
				local Sldr = VC_Menu_CreateSldr("Multiplier", 0, 5, 2, "Will be multiplied by this amount.", "VC_Light_HD_M", VC_Settings) MPnl[2]:AddItem(Sldr)

				local MPnl = VC_DM_AddPanel(MPnl_M2[1], {0.25, 0.75}, 32, true)
				local SNLbl = vgui.Create("DLabel") SNLbl:SetText("") SNLbl:SetTall(8) MPnl[1]:AddItem(SNLbl)
				local CBox = VC_Menu_CreateCBox("Glow", "The very transparent glow around the lights.", "VC_Light_Glow", VC_Settings) MPnl[1]:AddItem(CBox)
				local Sldr = VC_Menu_CreateSldr("Multiplier", 0, 5, 2, "Will be multiplied by this amount.", "VC_Light_Glow_M", VC_Settings) MPnl[2]:AddItem(Sldr)

				local CBox = VC_Menu_CreateCBox("3D", "This light object renders in 3D instead of dot based style.", "VC_Light_3D", VC_Settings) MPnl_M2[1]:AddItem(CBox)

					local MPnl = VC_DM_AddPanel(MPnl_M2[1], {0.25, 0.75}, 32, true)
					local SNLbl = vgui.Create("DLabel") SNLbl:SetText("") SNLbl:SetTall(8) MPnl[1]:AddItem(SNLbl)
					local CBox = VC_Menu_CreateCBox("DynamicLights", "If lights are lagging for you, uncheck this.", "VC_DynamicLights", VC_Settings) MPnl[1]:AddItem(CBox)
					local Sldr = VC_Menu_CreateSldr("FadeOutDistance", 1000, 10000, 0, "Dynamic lights will turn off at this distance (gradually). Fades from 1 to 0 in 1000 units.", "VC_DynamicLights_OffDist", VC_Settings) MPnl[2]:AddItem(Sldr)

			local Sheet = vgui.Create("DPropertySheet") Sheet:SetTall(200)
			local List_1_1, List_1_2 = nil, nil
			if VCMod1 then List_1_1 = VC_Menu_CreateList(0, 6, 450, 200) Sheet:AddSheet(VC_Lng("Main"), List_1_1, "icon16/user_red.png", false, false, "Controls for the VCMod Main Package.") end
			if VCMod1_ELS then List_1_2 = VC_Menu_CreateList(0, 6, 450, 200) Sheet:AddSheet(VC_Lng("ELS"), List_1_2, "icon16/user_orange.png", false, false, "Controls for the VCMod ELS package.") end
			List:AddItem(Sheet)

			if VC_CreateClSettingsTab_VC1 then VC_CreateClSettingsTab_VC1(List, List_1_1) end
			if VC_CreateClSettingsTab_VC1_ELS then VC_CreateClSettingsTab_VC1_ELS(List, List_1_2) end

		local Btn = vgui.Create("DButton") Btn:SetSize(75, 20) Btn:SetPos(Pnl:GetWide()/2-35, Pnl:GetTall()-24) Btn:SetText(VC_Lng("Reset")) Btn:SetParent(Pnl) Btn:SetToolTip("Reset all settings to their default values.")
		Btn.DoClick = function() VC_ResetSettings_Cl() if VC_Panel_Menu then VC_Panel_Menu.VC_Refresh_Panel = true end VCMsg("SettingsReset") end
		Btn.Paint = function()
		draw.RoundedBox(4, 0, 0, Btn:GetWide(), Btn:GetTall(), Color(155, 155, 0, 255))
		draw.RoundedBox(4, 2, 2, Btn:GetWide()-4, Btn:GetTall()-4, Color(255, 255, 255, 155))
		end

		local X, Y = List:GetPos() local Sx, Sy = List:GetSize()
		Pnl.Paint = function()
		draw.RoundedBox(0, X, Y, Sx, Sy, Color(0, 0, 0, 100))
		draw.DrawText(VC_Lng("OptOnly_You"), Font_Info, List:GetWide()/2, 5,  Color(255 , 155, 155, 255), TEXT_ALIGN_CENTER)
		end

		return Draw
	end
	list.Set("VC_Menu_Items_P", Int, {"Options", BuildMenu}) Int = Int+1
VC_Menu_Items_P_Settings = true
end

if !VC_Menu_Items_P_Controls then
	local function BuildMenu(Pnl)
		local List = VC_Menu_CreateList(0, 6, 450, 550) List:SetParent(Pnl)
		local List2 = VC_Menu_CreateList(459, 6, 146, 458) List2:SetParent(Pnl)

		local Sldr = VC_Menu_CreateSldr("HoldDuration", 0.1, 1, 1, "Buttons with checkbox checked will only work after this hold delay.", "VC_Keyboard_Input_Hold", VC_Settings) Sldr:SetSize(450, 30) List:AddItem(Sldr)

		local Sheet = vgui.Create("DPropertySheet") Sheet:SetTall(455)
		local List_1_1, List_1_2 = nil, nil
		if VCMod1 then List_1_1 = VC_Menu_CreateList(0, 6, 450, 505) Sheet:AddSheet(VC_Lng("Main"), List_1_1, "icon16/user_red.png", false, false, "Controls for the VCMod Main Package.") end
		if VCMod1_ELS then List_1_2 = VC_Menu_CreateList(0, 6, 450, 505) Sheet:AddSheet(VC_Lng("ELS"), List_1_2, "icon16/user_orange.png", false, false, "Controls for the VCMod ELS package.") end
		List:AddItem(Sheet)

		if VCMod1 then for _, Cmd in pairs(VC_MControls) do if Cmd.menu == "controls" then local VCBtn = vgui.Create(Cmd.NoCheckBox and "VC_Control" or "VC_Control_CheckBox") VCBtn.VC_BtnInfo = {Cmd.info, Cmd.keyhold} VCBtn.VC_BtnCmd = Cmd.cmd if Cmd.desk then VCBtn:SetToolTip(Cmd.desk) end List_1_1:AddItem(VCBtn) end end end
		if VCMod1_ELS then for _, Cmd in pairs(VC_MControls) do if Cmd.menu == "controls_els" then local VCBtn = vgui.Create(Cmd.NoCheckBox and "VC_Control" or "VC_Control_CheckBox") VCBtn.VC_BtnInfo = {Cmd.info, Cmd.keyhold} VCBtn.VC_keyhold = Cmd.keyhold VCBtn.VC_BtnCmd = Cmd.cmd if Cmd.desk then VCBtn:SetToolTip(Cmd.desk) end List_1_2:AddItem(VCBtn) end end end

		local CBox = VC_Menu_CreateCBox("KeyboardInput", "Toggles all controls, excluding the mouse buttons.", "VC_Keyboard_Input", VC_Settings) List2:AddItem(CBox)
		local CBox = VC_Menu_CreateCBox("MouseInput", "Toggles mouse button controls.", "VC_MouseControl", VC_Settings) List2:AddItem(CBox)
		local SNLbl = vgui.Create("DLabel") SNLbl:SetText("Switch first 9 seats: '1-9', '0'.") List2:AddItem(SNLbl)
		local SNLbl = vgui.Create("DLabel") SNLbl:SetText("Kick people out: L ALT+ ('1-9', '0').") List2:AddItem(SNLbl)
		local SNLbl = vgui.Create("DLabel") SNLbl:SetText("Scroll up/down to zoom in/out.") List2:AddItem(SNLbl)

		local Btn = vgui.Create("DButton") Btn:SetSize(75, 20) Btn:SetPos(187.5, Pnl:GetTall()-20) Btn:SetText(VC_Lng("Reset")) Btn:SetParent(Pnl) Btn:SetToolTip("Reset all controls to their default values, changes settings of all addons, not just this one.")
		Btn.DoClick = function() VC_Create_ControlScript() if VC_Panel_Menu then VC_Panel_Menu.VC_Refresh_Panel = true end VCMsg("ControlsReset") end
		Btn.Paint = function()
		draw.RoundedBox(4, 0, 0, Btn:GetWide(), Btn:GetTall(), Color(155, 155, 0, 255))
		draw.RoundedBox(4, 2, 2, Btn:GetWide()-4, Btn:GetTall()-4, Color(255, 255, 255, 155))
		end

		Pnl.Paint = function()
		draw.RoundedBox(0, 453, 0, 152, Pnl:GetTall(), Color(0, 0, 0, 100))
		end
	end
list.Set("VC_Menu_Items_P", Int, {"Controls", BuildMenu}) Int = Int+1
VC_Menu_Items_P_Controls = true
end

if !VC_Menu_Items_P_HUD then
	local function BuildMenu(Pnl)
		local Font_Header = "VC_Menu_Header" if !VC_Fonts[Font_Header] then VC_Fonts[Font_Header] = true surface.CreateFont(Font_Header, {font = "MenuLarge", size = 18, weight = 1000, blursize = 2, scanlines = 0, antialias = true, underline = false, italic = false, strikeout = false, symbol = false, rotary = false, shadow = false, additive = false, outline = false}) end
		local Font_Header_Focused = "VC_Menu_Header_Focused" if !VC_Fonts[Font_Header_Focused] then VC_Fonts[Font_Header_Focused] = true surface.CreateFont(Font_Header_Focused, {font = "MenuLarge", size = 18, weight = 1000, blursize = 0, scanlines = 0, antialias = true, underline = false, italic = false, strikeout = false, symbol = false, rotary = false, shadow = false, additive = false, outline = false}) end
		local Font_Info = "VC_Info" if !VC_Fonts[Font_Info] then VC_Fonts[Font_Info] = true surface.CreateFont(Font_Info, {font = "MenuLarge", size = 24, weight = 1000, blursize = 0, scanlines = 0, antialias = true, underline = false, italic = false, strikeout = false, symbol = false, rotary = false, shadow = false, additive = false, outline = false}) end

		local List = VC_Menu_CreateList(0, 35, Pnl:GetWide(), Pnl:GetTall()-35) List:SetParent(Pnl)

			local MPnl = VC_DM_AddPanel(List, {0.5,0.5}, 32, true)
			local SNLbl = vgui.Create("DLabel") SNLbl:SetText("") SNLbl:SetTall(8) MPnl[1]:AddItem(SNLbl)
			local CBox = VC_Menu_CreateCBox("Effect3D", "When you sway your mouse around the HUD tries to stay with the view.", "VC_HUD_3D", VC_Settings) MPnl[1]:AddItem(CBox)
			local Sldr = VC_Menu_CreateSldr("Multiplier", 0, 3, 2, "How much the view will sway.", "VC_HUD_3D_Mult", VC_Settings) MPnl[2]:AddItem(Sldr)

		local Sldr = VC_Menu_CreateSldr("HUDHeight", 0, 100, 0, "How high on your screen the HUD will be on the right.", "VC_HUD_Height", VC_Settings) List:AddItem(Sldr)

		local CBox = VC_Menu_CreateCBox("HUD_Name", "When entering a car the name of the car will appear on the bottom left of the screen.", "VC_HUD_Name", VC_Settings) List:AddItem(CBox)
		local CBox = VC_Menu_CreateCBox("Health", "Indicator of the vehicles health on the middle right of the screen.", "VC_HUD_Health", VC_Settings) List:AddItem(CBox)
		local CBox = VC_Menu_CreateCBox("HUD_Icons", "Icons of what is active on the vehicle.", "VC_HUD_Icons", VC_Settings) List:AddItem(CBox)
			local MPnl = VC_DM_AddPanel(List, {0.5,0.5}, 24, true)
			local CBox = VC_Menu_CreateCBox("HUD_Cruise", "Will show up when the cruise control is active, middle bottom of the screen.", "VC_HUD_Cruise", VC_Settings) MPnl[1]:AddItem(CBox)
			local CBox = VC_Menu_CreateCBox("HUD_Cruise_MPH", "Show miles per hour instead of kilometers per hour.", "VC_HUD_Cruise_MPh", VC_Settings) MPnl[2]:AddItem(CBox)
		local CBox = VC_Menu_CreateCBox("HUD_Repair", "This will show up when repairing a vehicle, middle bottom of the screen.", "VC_HUD_Repair", VC_Settings) List:AddItem(CBox)
		local CBox = VC_Menu_CreateCBox("HUD_ELS_Siren", "ELS HUD element, which will show the siren's.", "VC_HUD_ELS_Siren", VC_Settings) List:AddItem(CBox)
		local CBox = VC_Menu_CreateCBox("HUD_ELS_Lights", "ELS HUD element, which will show the light codes and sequences.", "VC_HUD_ELS", VC_Settings) List:AddItem(CBox)

		local X, Y = List:GetPos() local Sx, Sy = List:GetSize()
		Pnl.Paint = function()
		draw.RoundedBox(0, X, Y, Sx, Sy, Color(0, 0, 0, 100))
		draw.DrawText(VC_Lng("OptOnly_You"), Font_Info, List:GetWide()/2, 5,  Color(255 , 155, 155, 255), TEXT_ALIGN_CENTER)
		end

		return Draw
	end
	list.Set("VC_Menu_Items_P", Int, {"HUD", BuildMenu}) Int = Int+1
VC_Menu_Items_P_HUD = true
end

if !VC_Menu_Items_P_Lang_Created then
local function BuildMenu(Pnl)
	local Font_Info = "VC_Info" if !VC_Fonts[Font_Info] then VC_Fonts[Font_Info] = true surface.CreateFont(Font_Info, {font = "MenuLarge", size = 24, weight = 1000, blursize = 0, scanlines = 0, antialias = true, underline = false, italic = false, strikeout = false, symbol = false, rotary = false, shadow = false, additive = false, outline = false}) end
	local Font_Info_Small = "VC_Info_Small" if !VC_Fonts[Font_Info_Small] then VC_Fonts[Font_Info_Small] = true surface.CreateFont(Font_Info_Small, {font = "MenuLarge", size = 19, weight = 1000, blursize = 0, scanlines = 0, antialias = true, underline = false, italic = false, strikeout = false, symbol = false, rotary = false, shadow = false, additive = false, outline = false}) end
	local Font_Info_Smaller = "VC_Info_Smaller" if !VC_Fonts[Font_Info_Smaller] then VC_Fonts[Font_Info_Smaller] = true surface.CreateFont(Font_Info_Smaller, {font = "MenuLarge", size = 17, weight = 1000, blursize = 0, scanlines = 0, antialias = true, underline = false, italic = false, strikeout = false, symbol = false, rotary = false, shadow = false, additive = false, outline = false}) end
	local Font_Link = "VC_Link" if !VC_Fonts[Font_Link] then VC_Fonts[Font_Link] = true surface.CreateFont(Font_Link, {font = "MenuLarge", size = 14, weight = 0, blursize = 0, scanlines = 0, antialias = true, underline = true, italic = false, strikeout = false, symbol = false, rotary = false, shadow = false, additive = false, outline = false}) end

	local PW = Pnl:GetWide()
	local List = VC_Menu_CreateList(5, 40, PW, Pnl:GetTall()-100) List:SetParent(Pnl)

		local MPnl = VC_DM_AddPanel(List, {0.3,0.3,0.15}, 25, true)
		local SNLbl = vgui.Create("DLabel") SNLbl:SetText('Language') SNLbl:SetWide(PW*0.3) SNLbl:SetColor(Color(200,200,255,255)) SNLbl:SetFont("VC_Info_Small") MPnl[1]:AddItem(SNLbl)
		local SNLbl = vgui.Create("DLabel") SNLbl:SetText('Author') SNLbl:SetWide(PW*0.3) SNLbl:SetFont("VC_Info_Smaller") MPnl[2]:AddItem(SNLbl)
		local SNLbl = vgui.Create("DLabel") SNLbl:SetText('Date') SNLbl:SetWide(PW*0.3) SNLbl:SetFont("VC_Info_Smaller") MPnl[3]:AddItem(SNLbl)

		if VC_Lng_T then
			for k,v in SortedPairs(VC_Lng_T) do
			local MPnl = VC_DM_AddPanel(List, {0.3,0.3,0.25, 0.1}, 20, 2)
			local SNLbl = vgui.Create("DLabel") SNLbl:SetText(k.."  "..v.Name) SNLbl:SetWide(PW*0.3) SNLbl:SetColor(Color(200,200,255,255)) MPnl[1]:AddItem(SNLbl)
			local Btn = vgui.Create("DButton") Btn:SetSize(50, 15) Btn:SetText("") MPnl[2]:AddItem(Btn)
				Btn.DoClick = function() if v.Translated_By_Link then gui.OpenURL(v.Translated_By_Link) else VCMsg("Sorry, no link found") end end
				Btn.Paint = function()
				if Btn:IsHovered() then draw.RoundedBox(0, 0, 0, Btn:GetWide(), Btn:GetTall(), Color(0, 25, 55, 255)) end
				draw.DrawText((v.Translated_By_Link and "(link) " or "")..(v.Translated_By_Name or "-"), Font_Link, 0, 2,  Color(255,255,255,255), TEXT_ALIGN_LEFT)
				end
			local SNLbl = vgui.Create("DLabel") SNLbl:SetText(v.Translated_Date or "-") SNLbl:SetWide(PW*0.3) MPnl[3]:AddItem(SNLbl)
			end
		end

		local Btn = vgui.Create("DButton") Btn:SetSize(35, 20) Btn:SetPos(530, 475) Btn:SetText("") Btn:SetParent(Pnl)
		Btn.DoClick = function() gui.OpenURL("http://steamcommunity.com//id/freemmaann/") end
		Btn.Paint = function()
		if Btn:IsHovered() then draw.RoundedBox(0, 0, 0, Btn:GetWide(), Btn:GetTall(), Color(0, 155, 100, 55)) end
		draw.DrawText("here", Font_Info_Smaller, Btn:GetWide()/2, 0, Color(255,255,255,255), TEXT_ALIGN_CENTER)
		end

		local X, Y = List:GetPos() local Sx, Sy = List:GetSize()
		Pnl.Paint = function()
		draw.RoundedBox(0, X-5, Y, Sx, 21, Color(0, 0, 0, 150))
		draw.RoundedBox(0, X-5, Y, Sx, Sy, Color(0, 0, 0, 150))
		draw.RoundedBox(0, X-5, Pnl:GetTall()-57, Sx, 57, Color(0, 0, 0, 150))
		draw.DrawText("Big thank you to all who helped translate VCMod", Font_Info, List:GetWide()/2, 5,  Color(255 , 155, 155, 255), TEXT_ALIGN_CENTER)
		draw.DrawText("If you want to help translate VCMod to your own language, contact me", Font_Info_Smaller, List:GetWide()/2-20, 475,  Color(200, 225, 255, 255), TEXT_ALIGN_CENTER)
		end

	return Draw
end
list.Set("VC_Menu_Items_P", Int, {"Language", BuildMenu}) Int = Int+1
VC_Menu_Items_P_Lang_Created = true
end

local function BuildMenu(Pnl)
	local Font_Header = "VC_Menu_Header" if !VC_Fonts[Font_Header] then VC_Fonts[Font_Header] = true surface.CreateFont(Font_Header, {font = "MenuLarge", size = 18, weight = 1000, blursize = 2, scanlines = 0, antialias = true, underline = false, italic = false, strikeout = false, symbol = false, rotary = false, shadow = false, additive = false, outline = false}) end
	local Font_Header_Focused = "VC_Menu_Header_Focused" if !VC_Fonts[Font_Header_Focused] then VC_Fonts[Font_Header_Focused] = true surface.CreateFont(Font_Header_Focused, {font = "MenuLarge", size = 18, weight = 1000, blursize = 0, scanlines = 0, antialias = true, underline = false, italic = false, strikeout = false, symbol = false, rotary = false, shadow = false, additive = false, outline = false}) end
	local Font_Info = "VC_Info" if !VC_Fonts[Font_Info] then VC_Fonts[Font_Info] = true surface.CreateFont(Font_Info, {font = "MenuLarge", size = 24, weight = 1000, blursize = 0, scanlines = 0, antialias = true, underline = false, italic = false, strikeout = false, symbol = false, rotary = false, shadow = false, additive = false, outline = false}) end

	local List = VC_Menu_CreateList(0, 35, Pnl:GetWide(), Pnl:GetTall()-60) List:SetParent(Pnl)

	local ElTbl = {}

	local Settings_Sv = {}

	local CBox = VC_Menu_CreateCBox("Enabled_Sv", "Basically shuts down all the stuff bellow.", "VC_Enabled", Settings_Sv, true) List:AddItem(CBox) ElTbl.VC_Enabled = CBox

		local Sheet = vgui.Create("DPropertySheet") Sheet:SetTall(435)
		local List_1_1 = VC_Menu_CreateList(0, 6, 450, 435) Sheet:AddSheet(VC_Lng("Lights"), List_1_1, "icon16/lightbulb.png", false, false, "Light options.")
		local List_1_2 = VC_Menu_CreateList(0, 6, 450, 435) Sheet:AddSheet(VC_Lng("Health"), List_1_2, "icon16/exclamation.png", false, false, "Health and damage controls.")
		local List_1_3 = VC_Menu_CreateList(0, 6, 450, 435) Sheet:AddSheet(VC_Lng("Sound"), List_1_3, "icon16/sound.png", false, false, "Sound options.")
		local List_1_4 = VC_Menu_CreateList(0, 6, 450, 800) Sheet:AddSheet(VC_Lng("Other"), List_1_4, "icon16/anchor.png", false, false, "Other options.")
		List:AddItem(Sheet)
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

		local CBox = VC_Menu_CreateCBox("Enabled", "Enables/Disables lights on vehicles including: emergency lights, night lights, reverse lights, blinkers, hazards, head lights.", "VC_Lights", Settings_Sv, true) ElTbl.VC_Lights = CBox List_1_1:AddItem(CBox)

			local MPnl = VC_DM_AddPanel(List_1_1, {0.5,0.5}, 32, true)
			local SNLbl = vgui.Create("DLabel") SNLbl:SetText("") SNLbl:SetTall(8) MPnl[1]:AddItem(SNLbl)
			local CBox = VC_Menu_CreateCBox("NightLights", "Enables/Disables night lights on vehicles.", "VC_Lights_Night", Settings_Sv, true) ElTbl.VC_Lights_Night = CBox MPnl[1]:AddItem(CBox)
			local Sldr = VC_Menu_CreateSldr("OffTime", 0, 600, 0, "Lights will turn off if the car is left alone after this time.", "VC_LightsOffTime", Settings_Sv, true) ElTbl.VC_LightsOffTime = Sldr MPnl[2]:AddItem(Sldr)

			local MPnl = VC_DM_AddPanel(List_1_1, {1/3,1/3,1/3}, 32, true)
			local SNLbl = vgui.Create("DLabel") SNLbl:SetText("") SNLbl:SetTall(8) MPnl[1]:AddItem(SNLbl)
			local CBox = VC_Menu_CreateCBox("HeadLights", "Enables/Disables headlights on vehicles.", "VC_HeadLights", Settings_Sv, true) ElTbl.VC_HeadLights = CBox MPnl[1]:AddItem(CBox)
			local Sldr = VC_Menu_CreateSldr("DistMultiplier", 0, 2, 2, "How far the headlights will lights up the world.", "VC_HLights_Dist_M", Settings_Sv, true) ElTbl.VC_HLights_Dist_M = Sldr MPnl[2]:AddItem(Sldr)
			local Sldr = VC_Menu_CreateSldr("OffTime", 0, 120, 0, "Headlights will turn off if the car is left alone after this time.", "VC_HLightsOffTime", Settings_Sv, true) ElTbl.VC_HLightsOffTime = Sldr MPnl[3]:AddItem(Sldr)

		local CBox = VC_Menu_CreateCBox("HandbrakeLights", "Should the brake light turn on when pressing the handbrake too [SPACE] key.", "VC_Lights_HandBrake", Settings_Sv, true) ElTbl.VC_Lights_HandBrake = CBox List_1_1:AddItem(CBox)
		local CBox = VC_Menu_CreateCBox("InteriorLights", "If the door is opened the interior lights will turn on.", "VC_Lights_Interior", Settings_Sv, true) ElTbl.VC_Lights_Interior = CBox List_1_1:AddItem(CBox)
		local CBox = VC_Menu_CreateCBox("BlinkersOffExit", "Should the blinkers auto turn off when a player leaves the driver seat.", "VC_Lights_Blinker_OffOnExit", Settings_Sv, true) ElTbl.VC_Lights_Blinker_OffOnExit = CBox List_1_1:AddItem(CBox)
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

		local CBox = VC_Menu_CreateCBox("DamageEnabled", "With this the vehicle will receive physical and weapon based damage.", "VC_Damage", Settings_Sv, true) List_1_2:AddItem(CBox) ElTbl.VC_Damage = CBox

		local Sldr = VC_Menu_CreateSldr("StartHealthMultiplier", 0, 5, 1, "Starting health multiplier, applied to a car when it is spawned.", "VC_Health_Multiplier", Settings_Sv, true) List_1_2:AddItem(Sldr) ElTbl.VC_Health_Multiplier = Sldr

			local MPnl = VC_DM_AddPanel(List_1_2, {0.5,0.5}, 32, true)
			local SNLbl = vgui.Create("DLabel") SNLbl:SetText("") SNLbl:SetTall(8) MPnl[1]:AddItem(SNLbl)
			local CBox = VC_Menu_CreateCBox("PhysicalDamage", "Vehicle will take damage when colliding with things.", "VC_PhysicalDamage", Settings_Sv, true) MPnl[1]:AddItem(CBox) ElTbl.VC_PhysicalDamage = CBox
			local Sldr = VC_Menu_CreateSldr("Multiplier", 0, 5, 1, "Damage will be multiplied by this amount.", "VC_PhysicalDamage_Mult", Settings_Sv, true) MPnl[2]:AddItem(Sldr) ElTbl.VC_PhysicalDamage_Mult = Sldr

			local Sldr = VC_Menu_CreateSldr("FireDuration", 0, 600, 1, "For how long the fire will last after the vehicle has exploded.", "VC_Dmg_Fire_Duration", Settings_Sv, true) List_1_2:AddItem(Sldr) ElTbl.VC_Dmg_Fire_Duration = Sldr

			local MPnl = VC_DM_AddPanel(List_1_2, {0.5,0.5}, 32, true)
			local SNLbl = vgui.Create("DLabel") SNLbl:SetText("") SNLbl:SetTall(8) MPnl[1]:AddItem(SNLbl)
			local CBox = VC_Menu_CreateCBox("RemoveCarAfterExplosion", "Vehicle will be removed after it has exploded.", "VC_Damage_Expl_Rem", Settings_Sv, true) MPnl[1]:AddItem(CBox) ElTbl.VC_Damage_Expl_Rem = CBox
			local Sldr = VC_Menu_CreateSldr("Time", 0, 600, 0, "Vehicle will be removed in this amount of time.", "VC_Damage_Expl_Rem_Time", Settings_Sv, true) MPnl[2]:AddItem(Sldr) ElTbl.VC_Damage_Expl_Rem_Time = Sldr

			local MPnl = VC_DM_AddPanel(List_1_2, {0.5,0.5}, 32, true)
			local SNLbl = vgui.Create("DLabel") SNLbl:SetText("") SNLbl:SetTall(8) MPnl[1]:AddItem(SNLbl)
			local CBox = VC_Menu_CreateCBox("ReducePlayerDmgWhileInCar", "If you hit a wall the damage you will get will be multiplied by multiplier.", "VC_Reduce_Ply_Dmg_InVeh", Settings_Sv, true) MPnl[1]:AddItem(CBox) ElTbl.VC_Reduce_Ply_Dmg_InVeh = CBox
			local Sldr = VC_Menu_CreateSldr("Multiplier", 0, 1, 2, "Damage will be multiplied by this amount.", "VC_Reduce_Ply_Dmg_InVeh_Mult", Settings_Sv, true) MPnl[2]:AddItem(Sldr) ElTbl.VC_Reduce_Ply_Dmg_InVeh_Mult = Sldr
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

			local MPnl = VC_DM_AddPanel(List_1_3, {0.5,0.5}, 32, 2)
			local SNLbl = vgui.Create("DLabel") SNLbl:SetText("") SNLbl:SetTall(8) MPnl[1]:AddItem(SNLbl)
			local CBox = VC_Menu_CreateCBox("Horn", "This will allow people to use cars horn.", "VC_Horn_Enabled", Settings_Sv, true) MPnl[1]:AddItem(CBox) ElTbl.VC_Horn_Enabled = CBox
			local Sldr = VC_Menu_CreateSldr("Volume", 0, 1, 1, "How loud the horn will be.", "VC_Horn_Volume", Settings_Sv, true) MPnl[2]:AddItem(Sldr) ElTbl.VC_Horn_Volume = Sldr

			local CBox = VC_Menu_CreateCBox("DoorSounds", "Emit sounds when a door is being open/closed.", "VC_Door_Sounds", Settings_Sv, true) List_1_3:AddItem(CBox) ElTbl.VC_Door_Sounds = CBox

			local CBox = VC_Menu_CreateCBox("TruckRevBeep", "While a truck (vehicle bigger than usual or is supporting a truck socket type is considered a truck) it emits a sound.", "VC_Truck_BackUp_Sounds", Settings_Sv, true) List_1_3:AddItem(CBox) ElTbl.VC_Truck_BackUp_Sounds = CBox
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

			local MPnl = VC_DM_AddPanel(List_1_4, {0.5,0.5}, 18, 2)
			local CBox = VC_Menu_CreateCBox("SteeringWheelLOnExit", "Locks the cars steering wheel when a driver exits a vehicle.", "VC_Wheel_Lock", Settings_Sv, true) MPnl[1]:AddItem(CBox) ElTbl.VC_Wheel_Lock = CBox
			local CBox = VC_Menu_CreateCBox("BrakesLOnExit", "Locks the cars handbrake when a driver exits.", "VC_Brake_Lock", Settings_Sv, true) MPnl[2]:AddItem(CBox) ElTbl.VC_Brake_Lock = CBox

			local MPnl = VC_DM_AddPanel(List_1_4, {0.5,0.5}, 18, 2)
			local CBox = VC_Menu_CreateCBox("WheelDust", "Emit an effect from the wheels when driving around.", "VC_Wheel_Dust", Settings_Sv, true) MPnl[1]:AddItem(CBox) ElTbl.VC_Wheel_Dust = CBox
			local CBox = VC_Menu_CreateCBox("WheelDustWhileBraking", "Emit an effect from the wheels when driving around.", "VC_Wheel_Dust_Brakes", Settings_Sv, true) MPnl[2]:AddItem(CBox) ElTbl.VC_Wheel_Dust_Brakes = CBox

			local MPnl = VC_DM_AddPanel(List_1_4, {0.5,0.5}, 18, 2)
			local CBox = VC_Menu_CreateCBox("MatchPlayerSpeedExit", "Players speed gets set to the ones of a car when they exit a vehicle.", "VC_Exit_Velocity", Settings_Sv, true) MPnl[1]:AddItem(CBox) ElTbl.VC_Exit_Velocity = CBox
			local CBox = VC_Menu_CreateCBox("NoCollidePlyOnExit", "This allows for more stable exit.", "VC_Exit_NoCollision", Settings_Sv, true) MPnl[2]:AddItem(CBox) ElTbl.VC_Exit_NoCollision = CBox

			local MPnl = VC_DM_AddPanel(List_1_4, {0.5,0.5}, 18, 2)
			local CBox = VC_Menu_CreateCBox("Cruise", "This will allow people to use cars cruise.", "VC_Cruise_Enabled", Settings_Sv, true) MPnl[1]:AddItem(CBox) ElTbl.VC_Cruise_Enabled = CBox
			local CBox = VC_Menu_CreateCBox("OffOnExit", "Turn off the cruise control when the driver exits the vehicle.", "VC_Cruise_OffOnExit", Settings_Sv, true) MPnl[2]:AddItem(CBox) ElTbl.VC_Cruise_OffOnExit = CBox

			local CBox = VC_Menu_CreateCBox("Exhaust", "Exhaust effect when a vehicle is idle or in movement.", "VC_Exhaust_Effect", Settings_Sv, true) List_1_4:AddItem(CBox) ElTbl.VC_Exhaust_Effect = CBox

			local CBox = VC_Menu_CreateCBox("PassengerSeats", "Allows a vehicle to have passenger seats.", "VC_Passenger_Seats", Settings_Sv, true) List_1_4:AddItem(CBox) ElTbl.VC_Passenger_Seats = CBox

			local MPnl = VC_DM_AddPanel(List_1_4, {0.5,0.5}, 32, 2)
			local SNLbl = vgui.Create("DLabel") SNLbl:SetText("") SNLbl:SetTall(8) MPnl[1]:AddItem(SNLbl)
			local CBox = VC_Menu_CreateCBox("TrailerAttach", "This will allow you to attach trailers to trucks.", "VC_Trl_Enabled", Settings_Sv, true) MPnl[1]:AddItem(CBox) ElTbl.VC_Trl_Enabled = CBox
			local Sldr = VC_Menu_CreateSldr("Distance", 0, 1, 1, "How far the trailer should be from the truck to attempt to attach?", "VC_Trl_Dist", Settings_Sv, true) MPnl[2]:AddItem(Sldr) ElTbl.VC_Trl_Dist = Sldr

			local Sldr = VC_Menu_CreateSldr("TrailerAttachConStrengthM", 0, 5, 2, "How strong the connection is, before it breaks. Multiplier.", "VC_Trl_Mult", Settings_Sv, true) List_1_4:AddItem(Sldr) ElTbl.VC_Trl_Mult = Sldr

			local CBox = VC_Menu_CreateCBox("TrailersCanAtchToReg", "All regular (none big) vehicles will have an attachment point setup near its end, to simulate a hook.", "VC_Trl_Enabled_Reg", Settings_Sv, true) List_1_4:AddItem(CBox) ElTbl.VC_Trl_Enabled_Reg = CBox

			local Sldr = VC_Menu_CreateSldr("RepairToolSpeedMult", 0, 5, 2, "This multiplies how fast the tool repair a vehicle", "VC_RepairTool_Speed_M", Settings_Sv, true) List_1_4:AddItem(Sldr) ElTbl.VC_RepairTool_Speed_M = Sldr
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	local Btn = vgui.Create("DButton") Btn:SetSize(75, 20) Btn:SetPos(Pnl:GetWide()/2-112.25, Pnl:GetTall()-20) Btn:SetText(VC_Lng("Save")) Btn:SetParent(Pnl) Btn:SetToolTip("Save the settings.")
	Btn.DoClick = function()
		if VC_CanEditAdminSettings(LocalPlayer()) then
		net.Start("VC_SendSettingsToServer")
		net.WriteEntity(LocalPlayer())
		net.WriteTable(Settings_Sv)
		net.SendToServer()
		VCMsg("SettingsSaved")
		end
	end
	Btn.Paint = function()
	draw.RoundedBox(4, 0, 0, Btn:GetWide(), Btn:GetTall(), Color(0, 155, 0, 255))
	draw.RoundedBox(4, 2, 2, Btn:GetWide()-4, Btn:GetTall()-4, Color(255, 255, 255, 155))
	end
	local Btn = vgui.Create("DButton") Btn:SetSize(75, 20) Btn:SetPos(Pnl:GetWide()/2-37.25, Pnl:GetTall()-20) Btn:SetText(VC_Lng("Reset")) Btn:SetParent(Pnl) Btn:SetToolTip("Reset all settings to their default values.")
	Btn.DoClick = function() if VC_CanEditAdminSettings(LocalPlayer()) then RunConsoleCommand("VC_ResetSettings_Sv") if VC_Panel_Menu then VC_Panel_Menu.VC_Refresh_Panel = true end VCMsg("SettingsReset") end end
	Btn.Paint = function()
	draw.RoundedBox(4, 0, 0, Btn:GetWide(), Btn:GetTall(), Color(155, 155, 0, 255))
	draw.RoundedBox(4, 2, 2, Btn:GetWide()-4, Btn:GetTall()-4, Color(255, 255, 255, 155))
	end
	local Btn = vgui.Create("DButton") Btn:SetPos(Pnl:GetWide()/2+37.25, Pnl:GetTall()-20) Btn:SetSize(75, 20) Btn:SetText(VC_Lng("Load")) Btn:SetParent(Pnl) Btn:SetToolTip("Load settings from the server.")
	Btn.DoClick = function() if VC_CanEditAdminSettings(LocalPlayer()) then RunConsoleCommand("VC_GetSettings_Sv") VCMsg("LoadedSettingsFromServer") end end
	Btn.Paint = function()
	draw.RoundedBox(4, 0, 0, Btn:GetWide(), Btn:GetTall(), Color(55, 155, 255, 255))
	draw.RoundedBox(4, 2, 2, Btn:GetWide()-4, Btn:GetTall()-4, Color(255, 255, 255, 155))
	end
	if VC_CanEditAdminSettings(LocalPlayer()) then RunConsoleCommand("VC_GetSettings_Sv") end

	local X, Y = List:GetPos() local Sx, Sy = List:GetSize()
		Pnl.Paint = function()
		draw.RoundedBox(0, X, Y, Sx, Sy, Color(0, 0, 0, 100))
		draw.DrawText(VC_Lng("OptOnly_Admin"), Font_Info, List:GetWide()/2, 5,  Color(255 , 155, 155, 255), TEXT_ALIGN_CENTER)
		end

	Pnl.Think = function() if VC_Settings_TempTbl then for k,v in pairs(VC_Settings_TempTbl) do if ElTbl[k] then ElTbl[k]:SetValue(v) end Settings_Sv[k] = v end VC_Settings_TempTbl = nil end end

	return Draw
end
list.Set("VC_Menu_Items_A", Int, {"Options", BuildMenu}) Int = Int+1

local function BuildMenu(Pnl)
file.CreateDir("vcmod/npc_vc1/")
	local Font_Info = "VC_Info" if !VC_Fonts[Font_Info] then VC_Fonts[Font_Info] = true surface.CreateFont(Font_Info, {font = "MenuLarge", size = 24, weight = 1000, blursize = 0, scanlines = 0, antialias = true, underline = false, italic = false, strikeout = false, symbol = false, rotary = false, shadow = false, additive = false, outline = false}) end

	local NPC_Settings = {}

	local Settings_Sv = {} local ElTbl = {}
	local List = VC_Menu_CreateList(0, 35, Pnl:GetWide(), Pnl:GetTall()-35) List:SetParent(Pnl)

	-- local SNLbl = vgui.Create("DLabel") SNLbl:SetText('NPC settings for the current map: "'..game.GetMap()..'".') List:AddItem(SNLbl)
	
	-- local SLst = vgui.Create("DListView") SLst:SetSize(0, 200) SLst:SetMultiSelect(false) SLst:SetSortable(true) SLst:AddColumn("Car") List:AddItem(SLst)

	-- local Btn = vgui.Create("DButton") Btn:SetSize(75, 20) Btn:SetPos(Pnl:GetWide()/2-75, Pnl:GetTall()-20) Btn:SetText("Save") Btn:SetParent(Pnl)

	-- local Btn = vgui.Create("DButton") Btn:SetPos(Pnl:GetWide()/2, Pnl:GetTall()-20) Btn:SetSize(75, 20) Btn:SetText("Load") Btn:SetParent(Pnl)

	-- if VC_CanEditAdminSettings(LocalPlayer()) then
	-- RunConsoleCommand("VC_GetSettings_NPC_Sv", game.GetMap())
	-- end

	local CBox = VC_Menu_CreateCBox("Auto Spawn", "NPC spawns automatically at a give position.", "VC_NPC_AutoSpawn", Settings_Sv, true) List:AddItem(CBox) ElTbl.VC_NPC_AutoSpawn = CBox

	local Sldr = VC_Menu_CreateSldr("Refund Price %", 0, 100, 0, "When selling a car, what the refund price should be from the original price.", "VC_NPC_RefundPrice", Settings_Sv, true) List:AddItem(Sldr) ElTbl.VC_NPC_RefundPrice = Sldr

		local MPnl = VC_DM_AddPanel(List, {0.5,0.5}, 32, true)
		local SNLbl = vgui.Create("DLabel") SNLbl:SetText("") SNLbl:SetTall(8) MPnl[1]:AddItem(SNLbl)
		local CBox = VC_Menu_CreateCBox("Remove left alone vehicles", "When a player leaves a vehicle that is spawned from the NPC it will be removed.", "VC_NPC_Remove", Settings_Sv, true) MPnl[1]:AddItem(CBox) ElTbl.VC_NPC_Remove = CBox
		local Sldr = VC_Menu_CreateSldr("Remove Time", 10, 600, 0, "The car will be removed in this time.", "VC_NPC_Remove_Time", Settings_Sv, true) MPnl[2]:AddItem(Sldr) ElTbl.VC_NPC_Remove_Time = Sldr

		local SNLbl = vgui.Create("DLabel") SNLbl:SetText('') List:AddItem(SNLbl)
		local SNLbl = vgui.Create("DLabel") SNLbl:SetText('This section is still a work in progress.') List:AddItem(SNLbl)
		local SNLbl = vgui.Create("DLabel") SNLbl:SetText('For other settings you will have to do it manually, open the "/autorun/VC_DarkRP_NPC.lua" file.') List:AddItem(SNLbl)

		Pnl.Paint = function()
		draw.DrawText(VC_Lng("NPC_Settings"), Font_Info, List:GetWide()/2, 5,  Color(255 , 155, 155, 255), TEXT_ALIGN_CENTER)
		end

		Pnl.Think = function()
			if VC_Settings_TempTbl_NPC then
			-- for k,v in pairs(VC_Settings_TempTbl_NPC) do SLst:AddLine(v.name) end
			-- NPC_Settings = VC_Settings_TempTbl_NPC
			-- VC_Settings_TempTbl_NPC = nil
			end
		end

	local Btn = vgui.Create("DButton") Btn:SetSize(75, 20) Btn:SetPos(Pnl:GetWide()/2-112.25, Pnl:GetTall()-20) Btn:SetText(VC_Lng("Save")) Btn:SetParent(Pnl) Btn:SetToolTip("Save the settings.")
	Btn.DoClick = function()
		if VC_CanEditAdminSettings(LocalPlayer()) then
		net.Start("VC_SendSettingsToServer")
		net.WriteEntity(LocalPlayer())
		net.WriteTable(Settings_Sv)
		net.SendToServer()
		VCMsg("SettingsSaved")
		end
	end
	Btn.Paint = function()
	draw.RoundedBox(4, 0, 0, Btn:GetWide(), Btn:GetTall(), Color(0, 155, 0, 255))
	draw.RoundedBox(4, 2, 2, Btn:GetWide()-4, Btn:GetTall()-4, Color(255, 255, 255, 155))
	end
	local Btn = vgui.Create("DButton") Btn:SetSize(75, 20) Btn:SetPos(Pnl:GetWide()/2-37.25, Pnl:GetTall()-20) Btn:SetText(VC_Lng("Reset")) Btn:SetParent(Pnl) Btn:SetToolTip("Reset all settings to their default values.")
	Btn.DoClick = function() if VC_CanEditAdminSettings(LocalPlayer()) then RunConsoleCommand("VC_ResetSettings_Sv") if VC_Panel_Menu then VC_Panel_Menu.VC_Refresh_Panel = true end VCMsg("SettingsReset") end end
	Btn.Paint = function()
	draw.RoundedBox(4, 0, 0, Btn:GetWide(), Btn:GetTall(), Color(155, 155, 0, 255))
	draw.RoundedBox(4, 2, 2, Btn:GetWide()-4, Btn:GetTall()-4, Color(255, 255, 255, 155))
	end
	local Btn = vgui.Create("DButton") Btn:SetPos(Pnl:GetWide()/2+37.25, Pnl:GetTall()-20) Btn:SetSize(75, 20) Btn:SetText(VC_Lng("Load")) Btn:SetParent(Pnl) Btn:SetToolTip("Load settings from the server.")
	Btn.DoClick = function() if VC_CanEditAdminSettings(LocalPlayer()) then RunConsoleCommand("VC_GetSettings_Sv") VCMsg("LoadedSettingsFromServer") end end
	Btn.Paint = function()
	draw.RoundedBox(4, 0, 0, Btn:GetWide(), Btn:GetTall(), Color(55, 155, 255, 255))
	draw.RoundedBox(4, 2, 2, Btn:GetWide()-4, Btn:GetTall()-4, Color(255, 255, 255, 155))
	end
	if VC_CanEditAdminSettings(LocalPlayer()) then RunConsoleCommand("VC_GetSettings_Sv") end

	Pnl.Think = function() if VC_Settings_TempTbl then for k,v in pairs(VC_Settings_TempTbl) do if ElTbl[k] then ElTbl[k]:SetValue(v) end Settings_Sv[k] = v end VC_Settings_TempTbl = nil end end

	return Draw
end
list.Set("VC_Menu_Items_A", Int, {"NPC", BuildMenu}) Int = Int+1

if !VC_Menu_Items_A_MENU then
local function BuildMenu(Pnl)
	local Font_Info = "VC_Info" if !VC_Fonts[Font_Info] then VC_Fonts[Font_Info] = true surface.CreateFont(Font_Info, {font = "MenuLarge", size = 24, weight = 1000, blursize = 0, scanlines = 0, antialias = true, underline = false, italic = false, strikeout = false, symbol = false, rotary = false, shadow = false, additive = false, outline = false}) end

	local NPC_Settings = {}

	local List = VC_Menu_CreateList(0, 35, Pnl:GetWide(), Pnl:GetTall()-35) List:SetParent(Pnl)

		local SNLbl = vgui.Create("DLabel") SNLbl:SetText('From this menu you will be able to adjust what users can adjust VCMods "Admin" settings.') List:AddItem(SNLbl)
		local SNLbl = vgui.Create("DLabel") SNLbl:SetText('') List:AddItem(SNLbl)
		local SNLbl = vgui.Create("DLabel") SNLbl:SetText('This section is still a work in progress.') List:AddItem(SNLbl)
		local SNLbl = vgui.Create("DLabel") SNLbl:SetText('You can adjust who controls what in thsi file: "vcmod1/lua/autorun/VC_Adjust_Settings_Here.lua" file.') List:AddItem(SNLbl)

	local X, Y = List:GetPos() local Sx, Sy = List:GetSize()
		Pnl.Paint = function()
		draw.RoundedBox(0, X, Y, Sx, Sy, Color(0, 0, 0, 100))
		draw.DrawText(VC_Lng("OptOnly_Admin"), Font_Info, List:GetWide()/2, 5,  Color(255 , 155, 155, 255), TEXT_ALIGN_CENTER)
		end

	return Draw
end
list.Set("VC_Menu_Items_A", Int, {"Menu", BuildMenu}) Int = Int+1
VC_Menu_Items_A_MENU = true
end