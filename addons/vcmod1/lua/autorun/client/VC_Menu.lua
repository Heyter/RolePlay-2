// Copyright © 2012-2015 VCMod (freemmaann). All Rights Reserved. if you have any complaints or ideas contact me: email - freemmaann@gmail.com or skype - comman6.

list.Set("DesktopWindows", "VCMod", {title = "VCMod Menu", icon = "vcmod/icon.png", init = function(icon, window) window:Close() RunConsoleCommand("vc_open_menu") end})

hook.Add("PopulateToolMenu", "VC_Menu", function() spawnmenu.AddToolMenuOption("Utilities", "VCMod", "VC_Menu", "Menu", "", "", function(Pnl) local Btn = vgui.Create("DButton") Btn:SetText("Open VCMod menu") Btn:SetToolTip('You can also open this menu by:\nConsole command: "vc_open_menu"\nIn chat: "!vcmod"\nUsing the "C" menu') Pnl:AddItem(Btn) Btn.DoClick = function() RunConsoleCommand("vc_open_menu") end end) end)

hook.Add("OnTextEntryGetFocus", "VC_OnTextEntryGetFocus", function(pnl) if IsValid(VC_Panel_Menu) then VC_Panel_Menu.VC_CantRemove = true end end)
hook.Add("OnTextEntryLoseFocus", "VC_OnTextEntryGetFocus", function(pnl) if IsValid(VC_Panel_Menu) then VC_Panel_Menu.VC_CantRemove = false end end)

VC_Menu_Info_Panel = true if !VC_Fonts then VC_Fonts = {} end

local function OpenMenu(ply, cmd, arg)
	if arg[1] and ply:EntIndex() != tonumber(arg[1]) then return end

	if IsValid(VC_Panel_Menu) then VC_Panel_Menu:SetVisible(true) return end

	local MenuItemsA = list.Get("VC_Menu_Items_A") or {} local MenuItemsP = list.Get("VC_Menu_Items_P") or {}

	local CL_Body = Color(0, 0, 45, 200)
	local CL_Selection = Color(255, 255, 200, 25)
	local CL_Button = Color(0, 0, 0, 205)
	local CL_Button_Hov = Color(0, 0, 0, 180)
	local CL_Button_Sel_Hov = Color(200, 200, 155, 25)

	local SideButtons, SizeX, SizeY = {}, 750, 550
	VC_Panel_Menu = vgui.Create("DFrame") if !VC_MenuPosX then VC_MenuPosX = ScrW()/2-SizeX/2 end if !VC_MenuPosY then VC_MenuPosY = ScrH()/2-SizeY/2 end VC_Panel_Menu:SetPos(VC_MenuPosX, VC_MenuPosY) VC_Panel_Menu:SetSize(SizeX, SizeY) VC_Panel_Menu:SetTitle("") VC_Panel_Menu:NoClipping(true) VC_Panel_Menu:MakePopup()
	VC_Panel_Menu.VC_Refresh = true VC_Panel_Menu.VC_Refresh_Side = true

	local Font_Logo = "VC_Logo" if !VC_Fonts[Font_Logo] then VC_Fonts[Font_Logo] = true surface.CreateFont(Font_Logo, {font = "MenuLarge", size = 40, weight = 1000, blursize = 2, scanlines = 0, antialias = true, underline = false, italic = false, strikeout = false, symbol = false, rotary = false, shadow = false, additive = false, outline = false}) end
	local Font_SideBtn = "VC_Menu_Side" if !VC_Fonts[Font_SideBtn] then VC_Fonts[Font_SideBtn] = true surface.CreateFont(Font_SideBtn, {font = "MenuLarge", size = 20, weight = 1000, blursize = 0, scanlines = 0, antialias = true, underline = false, italic = false, strikeout = false, symbol = false, rotary = false, shadow = false, additive = false, outline = false}) end
	local Font_SideBtn_Focused = "VC_Menu_Side_Focused" if !VC_Fonts[Font_SideBtn_Focused] then VC_Fonts[Font_SideBtn_Focused] = true surface.CreateFont(Font_SideBtn_Focused, {font = "MenuLarge", size = 20, weight = 1000, blursize = 0, scanlines = 0, antialias = true, underline = false, italic = true, strikeout = false, symbol = false, rotary = false, shadow = false, additive = false, outline = false}) end
	local Font_Header = "VC_Menu_Header" if !VC_Fonts[Font_Header] then VC_Fonts[Font_Header] = true surface.CreateFont(Font_Header, {font = "MenuLarge", size = 18, weight = 1000, blursize = 0, scanlines = 0, antialias = true, underline = false, italic = false, strikeout = false, symbol = false, rotary = false, shadow = false, additive = false, outline = false}) end
	local Font_Header_Focused = "VC_Menu_Header_Focused" if !VC_Fonts[Font_Header_Focused] then VC_Fonts[Font_Header_Focused] = true surface.CreateFont(Font_Header_Focused, {font = "MenuLarge", size = 18, weight = 1000, blursize = 0, scanlines = 0, antialias = true, underline = false, italic = true, strikeout = false, symbol = false, rotary = false, shadow = false, additive = false, outline = false}) end

	local logo = nil if VCMod2 then logo = surface.GetTextureID("vcmod/logo") end
	VC_Panel_Menu.Paint = function()
	draw.RoundedBox(8, 0, 0, SizeX, SizeY, CL_Body)
		if logo then
		surface.SetDrawColor(255, 255, 255, 255) surface.SetTexture(logo) surface.DrawTexturedRect(-30, -35, 175, 75)
		else
		draw.DrawText("VCMod", Font_Logo, -10, -20,  Color(255, 0, 0, 255), TEXT_ALIGN_LEFT)
		end
	draw.RoundedBox(0, 135, 26, 611, SizeY-30, CL_Selection)
	end

	local Button_personal = vgui.Create("DButton") Button_personal:SetParent(VC_Panel_Menu) Button_personal:SetPos(135, 3) Button_personal:SetSize(226, 20) Button_personal:SetText("") Button_personal:NoClipping(true)
	Button_personal.DoClick = function() if VC_Menu_AdminPanelSel or VC_Menu_Info_Panel then VC_Menu_Info_Panel = nil if !VC_Menu_AdminPanelSel_Side_P then VC_Menu_AdminPanelSel_Side_P = 1 end VC_Panel_Menu.VC_Refresh_Side = true VC_Panel_Menu.VC_Refresh = true end VC_Menu_AdminPanelSel = false end
	Button_personal.Paint = function()
	local IsHovered = Button_personal:IsHovered()
	draw.RoundedBox(0, 0, 0, Button_personal:GetWide(), Button_personal:GetTall()+(VC_Menu_AdminPanelSel and 0 or 3), (VC_Menu_Info_Panel or VC_Menu_AdminPanelSel) and (IsHovered and CL_Button_Hov or CL_Button) or (IsHovered and CL_Button_Sel_Hov or CL_Selection))
	draw.DrawText(VC_Lng("Personal"), IsHovered and Font_Header_Focused or Font_Header, Button_personal:GetWide()/2, 0,  Color((VC_Menu_Info_Panel or VC_Menu_AdminPanelSel) and 255 or 155, 255, (VC_Menu_Info_Panel or VC_Menu_AdminPanelSel) and 255 or 155, 255), TEXT_ALIGN_CENTER)
	end

	local Button_admin = vgui.Create("DButton") Button_admin:SetParent(VC_Panel_Menu) Button_admin:SetPos(364, 3) Button_admin:SetSize(226, 20) Button_admin:SetText("") Button_admin:NoClipping(true)
	Button_admin.DoClick = function() if !VC_Menu_AdminPanelSel or VC_Menu_Info_Panel then VC_Menu_Info_Panel = nil if !VC_Menu_AdminPanelSel_Side_A then VC_Menu_AdminPanelSel_Side_A = 3 end VC_Panel_Menu.VC_Refresh_Side = true VC_Panel_Menu.VC_Refresh = true end VC_Menu_AdminPanelSel = true end
	Button_admin.Paint = function()
	local IsHovered = Button_admin:IsHovered()
	draw.RoundedBox(0, 0, 0, Button_admin:GetWide(), Button_admin:GetTall()+(VC_Menu_AdminPanelSel and 3 or 0), (VC_Menu_Info_Panel or !VC_Menu_AdminPanelSel) and (IsHovered and CL_Button_Hov or CL_Button) or (IsHovered and CL_Button_Sel_Hov or CL_Selection))
	draw.DrawText(VC_Lng("Administrator"), IsHovered and Font_Header_Focused or Font_Header, Button_admin:GetWide()/2, 0,  Color(!VC_Menu_Info_Panel and VC_Menu_AdminPanelSel and 155 or 255, 255, !VC_Menu_Info_Panel and VC_Menu_AdminPanelSel and 155 or 255, 255), TEXT_ALIGN_CENTER)
	end

	local Tbl = {} local TblR = {} local Int = 1 local Lng_CBox = vgui.Create("DComboBox", Pnl) Lng_CBox:SetParent(VC_Panel_Menu) Lng_CBox:SetPos(593, 3) Lng_CBox:SetSize(120, 20)
	for k,v in pairs(VC_Lng_T) do Lng_CBox:AddChoice(v.Language_Code.."  "..v.Name) Tbl[Int] = v.Language_Code TblR[v.Language_Code] = Int Int = Int+1 end
	Lng_CBox.OnSelect = function(idx, val) if Lng_CBox.Ignore then Lng_CBox.Ignore = nil return end if VC_Lng_Sel == Tbl[val] then return end VC_Lng_Save(Tbl[val]) VC_Panel_Menu:Close() OpenMenu(ply, {}, {}) end
	VC_Lng_Get() if VC_Lng_Sel and TblR[VC_Lng_Sel] then Lng_CBox:ChooseOptionID(TblR[VC_Lng_Sel]) else Lng_CBox.Ignore = true Lng_CBox:ChooseOptionID(1) end
	Lng_CBox:SetColor(Color(255,255,255,255))

	Lng_CBox.Paint = function() local IsHovered = Lng_CBox:IsHovered() draw.RoundedBox(0, 0, 0, Lng_CBox:GetWide(), Lng_CBox:GetTall(), IsHovered and Color(35,135,100,245) or Color(35,100,135,245)) end

	VC_Panel_Menu_SelectedPnl = nil

	local Btn = vgui.Create("DButton") Btn:SetParent(VC_Panel_Menu) Btn:SetPos(3, VC_Panel_Menu:GetTall()-40) Btn:SetSize(129, 40) Btn:SetText("") Btn:NoClipping(true)
	Btn.DoClick = function() if !VC_Menu_Info_Panel then VC_Panel_Menu.VC_Refresh_Side = true end VC_Menu_Info_Panel = true end
	Btn.Paint = function()
	local IsHovered = Btn:IsHovered()
	draw.RoundedBox(0, 0, 0, Btn:GetWide()+(VC_Menu_Info_Panel and 3 or 0), Btn:GetTall()-4, VC_Menu_Info_Panel and (IsHovered and CL_Button_Sel_Hov or CL_Selection) or (IsHovered and CL_Button_Hov or CL_Button))
	draw.DrawText(VC_Lng("Info"), IsHovered and Font_SideBtn_Focused or Font_SideBtn, Btn:GetWide()/2, Btn:GetTall()/2-14,  Color(VC_Menu_Info_Panel and 200 or 255, VC_Menu_Info_Panel and 155 or 255, 255, 255), TEXT_ALIGN_CENTER)
	end

	Button_personal.Think = function()
		if VC_Panel_Menu.VC_Refresh then
		for btnk, btnv in pairs(SideButtons) do if IsValid(btnv) then btnv:Remove() end end SideButtons = {}
			if VC_Menu_AdminPanelSel then
			local Int = 0
				for ItemK, Table in pairs(MenuItemsA) do
				local Name = Table[1]
					if Name then
					local Btn = vgui.Create("DButton") Btn:SetParent(VC_Panel_Menu) Btn:SetPos(3, 26+Int) Btn:SetSize(129, (Table[3] or 45)-(Table[4] or 5)) Btn:SetText("") Btn:NoClipping(true)
					Btn.DoClick = function() if VC_Menu_AdminPanelSel_Side_A != ItemK or VC_Menu_Info_Panel then VC_Panel_Menu.VC_Refresh_Side = true end VC_Menu_AdminPanelSel_Side_A = ItemK VC_Menu_Info_Panel = nil end
					Btn.Paint = function()
					local IsHovered = Btn:IsHovered() local On = VC_Menu_AdminPanelSel_Side_A == ItemK and !VC_Menu_Info_Panel
					draw.RoundedBox(0, 0, 0, Btn:GetWide()+(On and 3 or 0), Btn:GetTall(), On and (IsHovered and CL_Button_Sel_Hov or CL_Selection) or (IsHovered and CL_Button_Hov or CL_Button))
					draw.DrawText(VC_Lng(Name), IsHovered and Font_SideBtn_Focused or Font_SideBtn, Btn:GetWide()/2, Btn:GetTall()/2-11,  Color(On and 200 or 255, (On and 155 or 255), 255, 255), TEXT_ALIGN_CENTER)
					end
					SideButtons[Name] = Btn
					end
				Int = Int+(Table[3] or 43)
				end
			else
			local Int = 0

				for ItemK, Table in pairs(MenuItemsP) do
				local Name = Table[1]
					if Name then
					local Btn = vgui.Create("DButton") Btn:SetParent(VC_Panel_Menu) Btn:SetPos(3, 26+Int) Btn:SetSize(129, (Table[3] or 45)-(Table[4] or 5)) Btn:SetText("") Btn:NoClipping(true)
					Btn.DoClick = function() if VC_Menu_AdminPanelSel_Side_P != ItemK or VC_Menu_Info_Panel then VC_Panel_Menu.VC_Refresh_Side = true end VC_Menu_AdminPanelSel_Side_P = ItemK VC_Menu_Info_Panel = nil end
					Btn.Paint = function()
					local IsHovered = Btn:IsHovered() local On = VC_Menu_AdminPanelSel_Side_P == ItemK and !VC_Menu_Info_Panel
					draw.RoundedBox(0, 0, 0, Btn:GetWide()+(On and 3 or 0), Btn:GetTall(), On and (IsHovered and CL_Button_Sel_Hov or CL_Selection) or (IsHovered and CL_Button_Hov or CL_Button))
					draw.DrawText(VC_Lng(Name), IsHovered and Font_SideBtn_Focused or Font_SideBtn, Btn:GetWide()/2, Btn:GetTall()/2-11,  Color(On and 200 or 255, On and 155 or 255, 255, 255), TEXT_ALIGN_CENTER)
					end
					SideButtons[Name] = Btn
					end
				Int = Int+(Table[3] or 43)
				end
			end
		VC_Panel_Menu.VC_Refresh = nil
		end
		if VC_Panel_Menu.VC_Refresh_Panel then
		if VC_Panel_Menu_SelectedPnl then VC_Panel_Menu_SelectedPnl:Remove() VC_Panel_Menu_SelectedPnl = nil end
		local function HandlePanel(Table) if Table then local Pnl = VC_Menu_CreateList(138,29,605,SizeY-36) Pnl:SetParent(VC_Panel_Menu) Table.Panel = Pnl VC_Panel_Menu_SelectedPnl = Pnl Table[2](Pnl) end end
		HandlePanel(VC_Menu_Info_Panel and VC_Menu_Info_Panel_Build or VC_Menu_AdminPanelSel and MenuItemsA[VC_Menu_AdminPanelSel_Side_A] or VC_Menu_AdminPanelSel_Side_P and MenuItemsP[VC_Menu_AdminPanelSel_Side_P]) VC_Panel_Menu.VC_Refresh_Panel = nil
		end
		if VC_Panel_Menu.VC_Refresh_Side then
		if VC_Panel_Menu_SelectedPnl then VC_Panel_Menu_SelectedPnl:SetVisible(false) VC_Panel_Menu_SelectedPnl = nil end
		local function HandlePanel(Table) if Table then if IsValid(Table.Panel) then Table.Panel:SetVisible(true) VC_Panel_Menu_SelectedPnl = Table.Panel else local Pnl = VC_Menu_CreateList(138,29,605,SizeY-36) Pnl:SetParent(VC_Panel_Menu) Table.Panel = Pnl VC_Panel_Menu_SelectedPnl = Pnl Table[2](Pnl) end end end
		HandlePanel(VC_Menu_Info_Panel and VC_Menu_Info_Panel_Build or VC_Menu_AdminPanelSel and MenuItemsA[VC_Menu_AdminPanelSel_Side_A] or VC_Menu_AdminPanelSel_Side_P and MenuItemsP[VC_Menu_AdminPanelSel_Side_P]) VC_Panel_Menu.VC_Refresh_Side = nil
		end
	end
end

concommand.Add("vc_open_menu", function(...) OpenMenu(...) end) concommand.Add("vc_menu", function(...) OpenMenu(...) end) concommand.Add("vc_menu_null", function(ply, cmd, arg) end)