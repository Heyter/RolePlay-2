// Copyright © 2012-2015 VCMod (freemmaann). All Rights Reserved. if you have any complaints or ideas contact me: email - freemmaann@gmail.com or skype - comman6.
local KBK = {["KEY_A"] = {}, ["KEY_B"] = {}, ["KEY_C"] = {}, ["KEY_D"] = {}, ["KEY_E"] = {}, ["KEY_F"] = {}, ["KEY_G"] = {}, ["KEY_H"] = {}, ["KEY_I"] = {}, ["KEY_J"] = {}, ["KEY_K"] = {}, ["KEY_L"] = {}, ["KEY_M"] = {}, ["KEY_N"] = {}, ["KEY_O"] = {}, ["KEY_P"] = {}, ["KEY_Q"] = {}, ["KEY_R"] = {}, ["KEY_S"] = {}, ["KEY_T"] = {}, ["KEY_U"] = {}, ["KEY_V"] = {}, ["KEY_W"] = {}, ["KEY_X"] = {}, ["KEY_Y"] = {}, ["KEY_Z"] = {}, ["KEY_PAD_0"] = {name = "Keypad 0"}, ["KEY_PAD_1"] = {name = "Keypad 1"}, ["KEY_PAD_2"] = {name = "Keypad 2"}, ["KEY_PAD_3"] = {name = "Keypad 3"}, ["KEY_PAD_4"] = {name = "Keypad 4"}, ["KEY_PAD_5"] = {name = "Keypad 5"}, ["KEY_PAD_6"] = {name = "Keypad 6"}, ["KEY_PAD_7"] = {name = "Keypad 7"}, ["KEY_PAD_8"] = {name = "Keypad 8"}, ["KEY_PAD_9"] = {name = "Keypad 9"}, ["KEY_PAD_DIVIDE"] = {name = "Keypad /"}, ["KEY_PAD_MULTIPLY"] = {name = "Keypad *"}, ["KEY_PAD_MINUS"] = {name = "Keypad -"}, ["KEY_PAD_PLUS"] = {name = "Keypad +"}, ["KEY_PAD_ENTER"] = {name = "Keypad Enter"}, ["KEY_PAD_DECIMAL"] = {name = "Keypad Del"}, ["KEY_LBRACKET"] = {name = "Left Bracket"}, ["KEY_RBRACKET"] = {name = "Right Bracket"}, ["KEY_SEMICOLON"] = {name = "Semicolon"}, ["KEY_APOSTROPHE"] = {name = 'Apostrophe'}, ["KEY_BACKQUOTE"] = {name = "Back quote"}, ["KEY_COMMA"] = {name = "Comma"}, ["KEY_PERIOD"] = {name = "Period"}, ["KEY_SLASH"] = {name = "Forward Slash"}, ["KEY_BACKSLASH"] = {name = "Back Slash"}, ["KEY_MINUS"] = {name = "Minus"}, ["KEY_EQUAL"] = {name = "Equal"}, ["KEY_ENTER"] = {name = "Enter"}, ["KEY_SPACE"] = {name = "Space"}, ["KEY_TAB"] = {name = "Tab"}, ["KEY_CAPSLOCK"] = {name = "Caps Lock"}, ["KEY_NUMLOCK"] = {name = "Num Lock"}, ["KEY_SCROLLLOCK"] = {name = "Scroll Lock"}, ["KEY_INSERT"] = {name = "Insert"}, ["KEY_DELETE"] = {name = "Delete"}, ["KEY_HOME"] = {name = "Home"}, ["KEY_END"] = {name = "End"}, ["KEY_PAGEUP"] = {name = "Page Up"}, ["KEY_PAGEDOWN"] = {name = "Page Down"}, ["KEY_BREAK"] = {name = "Break"}, ["KEY_LSHIFT"] = {name = "Shift"}, ["KEY_RSHIFT"] = {name = "Shift"}, ["KEY_LALT"] = {name = "Alt"}, ["KEY_RALT"] = {name = "Alt"}, ["KEY_LCONTROL"] = {name = "Control"}, ["KEY_RCONTROL"] = {name = "Control"}, ["KEY_UP"] = {name = "Arrow Up"}, ["KEY_LEFT"] = {name = "Arrow Left"}, ["KEY_DOWN"] = {name = "Arrow Down"},["KEY_RIGHT"] = {name = "Arrow Right"}, ["KEY_F1"] = {name = "Function 1"}, ["KEY_F2"] = {name = "Function 2"}, ["KEY_F3"] = {name = "Function 3"}, ["KEY_F4"] = {name = "Function 4"}, ["KEY_F5"] = {name = "Function 5"}, ["KEY_F6"] = {name = "Function 6"}, ["KEY_F7"] = {name = "Function 7"}, ["KEY_F8"] = {name = "Function 8"}, ["KEY_F9"] = {name = "Function 9"}, ["KEY_F10"] = {name = "Function 10"}, ["KEY_F11"] = {name = "Function 11"}, ["KEY_F12"] = {name = "Function 12"}}
local KBK_Mouse = {MOUSE_LEFT = {name = "Mouse 1"}, MOUSE_RIGHT = {name = "Mouse 2"}, MOUSE_MIDDLE = {name = "Mouse 3"}, MOUSE_4 = {name = "Mouse 4"}, MOUSE_5 = {name = "Mouse 5"}}

local Icon_Tick = Material("icon16/tick.png")
local Icon_Cross = Material("icon16/cross.png")
local Icon_Connect = Material("icon16/connect.png")

local El = {}

function El:Paint()
	local Sx, Sy = self:GetSize()

	if !self.VC_Btn then
	self.VC_Btn = vgui.Create("DButton") self.VC_Btn:SetPos(2, 2) self.VC_Btn:SetSize(93, Sy-30) self.VC_Btn:SetText("") self.VC_Btn:SetParent(self)
	self.VC_Btn.DoClick = function() if VCMod_Addons and VCMod_Addons[self.VCheck] and VCMod_Addons[self.VCheck] != "" then gui.OpenURL(VCMod_Addons[self.VCheck]) end end
		self.VC_Btn.Paint = function()
			if VCMod_Addons then
				if VCMod_Addons[self.VCheck] then
					if VCMod_Addons[self.VCheck] and VCMod_Addons[self.VCheck] != "" then
					local Hov = self.VC_Btn:IsHovered()
					draw.RoundedBox(0, 0, 0, self.VC_Btn:GetWide(), self.VC_Btn:GetTall(), Color(55,Hov and 255 or 155, Hov and 155 or 255, 255))
					draw.DrawText("Get it!", Hov and "VC_Treb24_Italic" or "VC_Treb24", self.VC_Btn:GetWide()/2, 10,  Color(255, 255, 255, 255), TEXT_ALIGN_CENTER)
					else
					draw.RoundedBox(0, 0, 0, self.VC_Btn:GetWide(), self.VC_Btn:GetTall(), Color(55, 100, 155, 255))
					draw.DrawText("Soon!", "VC_Treb24_Italic", self.VC_Btn:GetWide()/2, 10,  Color(255, 255, 255, 255), TEXT_ALIGN_CENTER)
					end
				else
				draw.RoundedBox(0, 0, 0, self.VC_Btn:GetWide(), self.VC_Btn:GetTall(), Color(24, 55, 100, 255))
				draw.DrawText("...", "VC_Treb24_Italic", self.VC_Btn:GetWide()/2, 10,  Color(255, 255, 255, 255), TEXT_ALIGN_CENTER)
				end
			else
			draw.RoundedBox(0, 0, 0, self.VC_Btn:GetWide(), self.VC_Btn:GetTall(), Color(24, 55, 75, 255))
			draw.DrawText("-", "VC_Treb24_Italic", self.VC_Btn:GetWide()/2, 10,  Color(255, 255, 255, 255), TEXT_ALIGN_CENTER)
			end
		end
	end

	if self.Trailer and !self.VC_BtnT then
	self.VC_BtnT = vgui.Create("DButton") self.VC_BtnT:SetPos(95, 29) self.VC_BtnT:SetSize(93, 20) self.VC_BtnT:SetText("") self.VC_BtnT:SetParent(self)
	self.VC_BtnT.DoClick = function() if self.Trailer then gui.OpenURL(self.Trailer) end end
		self.VC_BtnT.Paint = function()
		local Hov = self.VC_BtnT:IsHovered()
		draw.RoundedBox(4, 0, 0, self.VC_BtnT:GetWide(), self.VC_BtnT:GetTall(), self.Version and Color(0,155,0,255) or Color(255,0,0,255))
		draw.RoundedBox(4, 2, 2, self.VC_BtnT:GetWide()-4, self.VC_BtnT:GetTall()-4, Color(Hov and 155 or 255,255,Hov and 155 or 255,Hov and 255 or 225))
		draw.DrawText("Youtube", Hov and "VC_Menu_Header_Focused" or "VC_Menu_Header", self.VC_BtnT:GetWide()/2, 0,  Color(0, 0, 0, 255), TEXT_ALIGN_CENTER)
		end
	end

	if self.Version then
	draw.RoundedBox(4, 0, 0, Sx, Sy, Color(0,155,0,255))
	draw.RoundedBox(4, 2, 2, Sx-4, Sy-4, Color(255,255,255,155))

	draw.RoundedBox(4, 0, 0, 97, Sy-26, Color(0,155,0,255))

	draw.RoundedBox(4, 0, Sy-24, 97, 24, Color(0,155,0,255))
		if VCMod_Versions then
		local Ver = VCMod_Versions[self.VCheck]
			if Ver then
			Ver = math.Round(Ver*1000)/1000
				if self.Version == Ver then
				draw.RoundedBox(0, 2, Sy-22, 93, 20, Color(155,255,155,255))
				surface.SetDrawColor(255,255,255,255)
				surface.SetMaterial(Icon_Tick) surface.DrawTexturedRect(5, Sy-20, 15, 15)
				draw.DrawText("Up to date", "VC_Treb24_12", 25, Sy-16,  Color(0, 0, 0, 255), TEXT_ALIGN_LEFT)
				draw.DrawText("Version: "..self.Version, "VC_Treb24_12", 100, Sy-15,  Color(0, 0, 0, 255), TEXT_ALIGN_LEFT)
				elseif self.Version > Ver then
				draw.RoundedBox(0, 2, Sy-22, 93, 20, Color(200,255,200,255))
				surface.SetDrawColor(255,255,255,255)
				surface.SetMaterial(Icon_Tick) surface.DrawTexturedRect(5, Sy-20, 15, 15)
				draw.DrawText("Beta version", "VC_Treb24_12", 25, Sy-16,  Color(0, 0, 0, 255), TEXT_ALIGN_LEFT)
				draw.DrawText("Version: "..self.Version.." ("..Ver.." available)", "VC_Treb24_12", 100, Sy-15,  Color(0, 0, 0, 255), TEXT_ALIGN_LEFT)
				else
				draw.RoundedBox(0, 2, Sy-22, 93, 20, Color(255,155,155,255))
				surface.SetDrawColor(255,255,255,255)
				surface.SetMaterial(Icon_Cross) surface.DrawTexturedRect(5, Sy-20, 15, 15)
				draw.DrawText("Out of date", "VC_Treb24_12", 25, Sy-16,  Color(0, 0, 0, 255), TEXT_ALIGN_LEFT)
				draw.DrawText("Version: "..self.Version.." ("..Ver.." available)", "VC_Treb24_12", 100, Sy-15,  Color(0, 0, 0, 255), TEXT_ALIGN_LEFT)
				end
			else
			draw.RoundedBox(0, 2, Sy-22, 93, 20, Color(200,200,255,255))
			surface.SetDrawColor(255,255,255,255)
			surface.SetMaterial(Icon_Connect) surface.DrawTexturedRect(5, Sy-20, 15, 15)
			draw.DrawText("Connecting..", "VC_Treb24_12", 25, Sy-16,  Color(0, 0, 0, 255), TEXT_ALIGN_LEFT)
			draw.DrawText("Version: "..self.Version, "VC_Treb24_12", 100, Sy-15,  Color(0, 0, 0, 255), TEXT_ALIGN_LEFT)
			end
		else
		draw.RoundedBox(0, 2, Sy-22, 93, 20, Color(255,200,200,255))
		surface.SetDrawColor(255,255,255,255)
		surface.SetMaterial(Icon_Cross) surface.DrawTexturedRect(5, Sy-20, 15, 15)
		draw.DrawText("No connection", "VC_Treb24_12", 25, Sy-16,  Color(0, 0, 0, 255), TEXT_ALIGN_LEFT)
		draw.DrawText("Version: "..self.Version, "VC_Treb24_12", 100, Sy-15,  Color(0, 0, 0, 255), TEXT_ALIGN_LEFT)
		end
	else
	draw.RoundedBox(4, 0, 0, Sx, Sy, Color(255,0,0,255))
	draw.RoundedBox(4, 2, 2, Sx-4, Sy-4, Color(255,255,255,155))

	draw.RoundedBox(4, 0, 0, 97, Sy-26, Color(255,0,0,255))

	draw.RoundedBox(4, 0, Sy-24, 97, 24, Color(255,0,0,255))
	draw.RoundedBox(0, 2, Sy-22, 93, 20, Color(255,200,200,255))

	surface.SetDrawColor(255,255,255,255)
	surface.SetMaterial(Icon_Cross) surface.DrawTexturedRect(5, Sy-20, 15, 15)
	draw.DrawText("Not installed", "VC_Treb24_12", 25, Sy-16,  Color(0, 0, 0, 255), TEXT_ALIGN_LEFT)
	end
	surface.SetDrawColor(self.Color[1] or 255, self.Color[2] or 0, self.Color[3] or 0, 255)
	draw.NoTexture() surface.DrawPoly({{x=Sx-60,y=-50},{x=Sx+200,y=Sy},{x=Sx-130,y=Sy}})
	if self.Version then surface.SetDrawColor(0,155,0, 255) else surface.SetDrawColor(255,0,0, 255) end
	surface.DrawLine(Sx-150,0, Sx,0) surface.DrawLine(Sx-150,1, Sx,1)
	surface.DrawLine(Sx-1,0, Sx-1,Sy) surface.DrawLine(Sx-2,0, Sx-2,Sy)
	surface.DrawLine(Sx-150,Sy-1, Sx,Sy-1) surface.DrawLine(Sx-150,Sy-2, Sx,Sy-2)

	draw.DrawText(self.Title, "VC_Logo", Sx-10, Sy/2-20,  Color(255, 255, 255, 255), TEXT_ALIGN_RIGHT)

	draw.DrawText(self.Name or "", "VC_Treb24", 99, 4,  Color(0, 0, 0, 255), TEXT_ALIGN_LEFT)

	if self.Features then
		for k,v in pairs(self.Features) do
		surface.SetDrawColor(255,255,255,255)
		surface.SetMaterial(Icon_Tick) surface.DrawTexturedRect(315-k*7, 3+(k-1)*10, 11, 11)
		draw.DrawText(v, "VC_Treb24_12", 330-k*7, 2+(k-1)*10,  Color(0, 0, 0, 255), TEXT_ALIGN_LEFT)
		end
	end
end

vgui.Register("VC_Addon", El)

local El = {}

function El:Paint()
	local Sx, Sy = self:GetSize()

	if !self.VC_Btn then
	self.VC_Btn = vgui.Create("DButton") self.VC_Btn:SetPos(2, 2) self.VC_Btn:SetSize(93, Sy-4) self.VC_Btn:SetText("") self.VC_Btn:SetParent(self)
	self.VC_Btn.DoClick = function() if VCMod_Addons and VCMod_Addons[self.VCheck] and VCMod_Addons[self.VCheck] != "" then gui.OpenURL(VCMod_Addons[self.VCheck]) end end
		self.VC_Btn.Paint = function()
			if VCMod_Addons then
				if VCMod_Addons[self.VCheck] then
					if VCMod_Addons[self.VCheck] and VCMod_Addons[self.VCheck] != "" then
					local Hov = self.VC_Btn:IsHovered()
					draw.RoundedBox(0, 0, 0, self.VC_Btn:GetWide(), self.VC_Btn:GetTall(), Color(55,Hov and 255 or 155, Hov and 155 or 255, 255))
					draw.DrawText("Get it!", Hov and "VC_Treb24_Italic" or "VC_Treb24", self.VC_Btn:GetWide()/2, 3,  Color(255, 255, 255, 255), TEXT_ALIGN_CENTER)
					else
					draw.RoundedBox(0, 0, 0, self.VC_Btn:GetWide(), self.VC_Btn:GetTall(), Color(55, 100, 155, 255))
					draw.DrawText("Soon!", "VC_Treb24_Italic", self.VC_Btn:GetWide()/2, 3,  Color(255, 255, 255, 255), TEXT_ALIGN_CENTER)
					end
				else
				draw.RoundedBox(0, 0, 0, self.VC_Btn:GetWide(), self.VC_Btn:GetTall(), Color(24, 55, 100, 255))
				draw.DrawText("...", "VC_Treb24_Italic", self.VC_Btn:GetWide()/2, 3,  Color(255, 255, 255, 255), TEXT_ALIGN_CENTER)
				end
			else
			draw.RoundedBox(0, 0, 0, self.VC_Btn:GetWide(), self.VC_Btn:GetTall(), Color(24, 55, 75, 255))
			draw.DrawText("-", "VC_Treb24_Italic", self.VC_Btn:GetWide()/2, 3,  Color(255, 255, 255, 255), TEXT_ALIGN_CENTER)
			end
		end
	end

	if self.Version then
	draw.RoundedBox(4, 0, 0, Sx, Sy, Color(0,155,0,255))
	draw.RoundedBox(4, 2, 2, Sx-4, Sy-4, Color(255,255,255,155))

	draw.RoundedBox(4, 0, 0, 97, Sy, Color(0,155,0,255))
	else
	draw.RoundedBox(4, 0, 0, Sx, Sy, Color(255,0,0,255))
	draw.RoundedBox(4, 2, 2, Sx-4, Sy-4, Color(255,255,255,155))

	draw.RoundedBox(4, 0, 0, 97, Sy, Color(255,0,0,255))
	end

	surface.SetDrawColor(self.Color[1] or 255, self.Color[2] or 0, self.Color[3] or 0, 255)
	draw.NoTexture() surface.DrawPoly({{x=Sx-60,y=-50},{x=Sx+200,y=Sy},{x=Sx-130,y=Sy}})
	if self.Version then surface.SetDrawColor(0,155,0, 255) else surface.SetDrawColor(255,0,0, 255) end
	surface.DrawLine(Sx-150,0, Sx,0) surface.DrawLine(Sx-150,1, Sx,1)
	surface.DrawLine(Sx-1,0, Sx-1,Sy) surface.DrawLine(Sx-2,0, Sx-2,Sy)
	surface.DrawLine(Sx-150,Sy-1, Sx,Sy-1) surface.DrawLine(Sx-150,Sy-2, Sx,Sy-2)

	draw.DrawText(self.Title, "VC_Logo", Sx-10, Sy/2-20,  Color(255, 255, 255, 255), TEXT_ALIGN_RIGHT)

	draw.DrawText(self.Name or "", "VC_Treb24", 99, 4,  Color(0, 0, 0, 255), TEXT_ALIGN_LEFT)

	if self.Features then
		for k,v in pairs(self.Features) do
		surface.SetDrawColor(255,255,255,255)
		surface.SetMaterial(Icon_Tick) surface.DrawTexturedRect(315-k*7, 3+(k-1)*10, 11, 11)
		draw.DrawText(v, "VC_Treb24_12", 330-k*7, 2+(k-1)*10,  Color(0, 0, 0, 255), TEXT_ALIGN_LEFT)
		end
	end
end

vgui.Register("VC_Addon_Small", El)

local El_Lists = {}
function El_Lists:Init()
	self.VC_List1, self.VC_List2, self.VC_Button = vgui.Create("DListView", self), vgui.Create("DListView", self), vgui.Create("DImageButton", self)
	self.VC_Button:SetMaterial("VCMod/VGUI/Next.vmt")
end
function El_Lists:Think()
	local PWth = self:GetParent():GetWide()
	self.VC_List1:SetTall(self.VC_Tall) self.VC_List1:SetWide(PWth*0.47)
	self.VC_List2:SetWide(PWth*0.47) self.VC_List2:SetTall(self.VC_Tall) self.VC_List2:SetPos(PWth-PWth*0.47, 0)
	self.VC_Button:SetWide(PWth*0.06) local BtnHt = math.min(50, self.VC_Tall) self.VC_Button:SetPos(PWth*0.47, self.VC_Tall/2-BtnHt/2) self.VC_Button:SetTall(BtnHt)
end
vgui.Register("VC_Lists", El_Lists)

local El_TxtNtr = {} function El_TxtNtr:Init() self.VC_TxtNtr, self.VC_TxtNtrLbl = vgui.Create("DTextEntry", self), vgui.Create("DLabel", self) end function El_TxtNtr:Think() if !self.VC_AsnedChng and self.VC_TextChngd then self.VC_TxtNtr.OnTextChanged = self.VC_TextChngd self.VC_AsnedChng = true end if !self.VC_AsnedInfo then self.VC_TxtNtrLbl:SetText(self.VC_Text) self.VC_AsnedInfo = true end local PWth = self:GetParent():GetWide() local EWth = PWth*(self.VC_TxtNtrPrc or 0.7) self.VC_TxtNtr:SetWide(EWth) self.VC_TxtNtrLbl:SetPos(math.Clamp(EWth+6, 0, PWth), 0) self.VC_TxtNtrLbl:SetWide(math.Clamp(PWth-EWth-6, 0, PWth)) end vgui.Register("VC_TextEntry", El_TxtNtr)
local El_Line = {} function El_Line:Paint() draw.RoundedBox(1, 0, 0, self:GetWide(), self:GetTall(), self.VC_Color or Color(0, 0, 255, 255)) end function El_Line:Think() self:SetWide(self:GetParent():GetWide()) end vgui.Register("VC_Line", El_Line)

local El = {}
function El:Think()
	if !self.VC_Initialized and self.VC_ButtonInfo then
		local PS = self:GetWide()/table.Count(self.VC_ButtonInfo)
		for Btnk, Btnv in pairs(self.VC_ButtonInfo) do
		local Btn = vgui.Create("DButton", self) Btn:SetPos(PS*Btnk-PS/2-self:GetTall()/2, 2) Btn:SetSize(self:GetTall(), self:GetTall()) Btn:SetText("") Btn:SetToolTip(Btnv.Desc)
		Btn.DoClick = function() local ent = self.VC_GetCar and VC_GetVehicle(LocalPlayer()) or LocalPlayer():GetVehicle() if IsValid(ent) then LocalPlayer():ConCommand(Btnv.Cmd..(Btnv.arg and " "..Btnv.arg(ent) or "")) Btn.VC_PressTime = CurTime() end end

		local Icon = surface.GetTextureID(Btnv.Icon)
			Btn.Paint = function()
				local ent, TCol, OCol, Col, ColMult = LocalPlayer():GetVehicle(), Color(255, 255, 255, 155), Btnv.Flash and Color(0, 0, 255, 255) or Color(0, 255, 0, 255) , nil, nil
					if IsValid(ent) or self.VC_GetCar then
						if Btnv.Flash then
							if Btn.VC_PressTime then
							ColMult = 1-(CurTime()-Btn.VC_PressTime)
							if ColMult > 0 then Col = Color(Lerp(ColMult, TCol.r, OCol.r), Lerp(ColMult, TCol.g, OCol.g), Lerp(ColMult, TCol.b, OCol.b), Lerp(ColMult, TCol.a, OCol.a)) end
							end
						elseif Btnv.Func(ent) or self.VC_GetCar then
						Col = OCol
						end
					end
				if !Col then Col = TCol end
				surface.SetDrawColor(Col.r, Col.g, Col.b, Col.a)
				surface.SetTexture(Icon) surface.DrawTexturedRect(5, 1, Btn:GetWide()-10, Btn:GetTall()-10)
				draw.RoundedBox(2, 2, self:GetTall()-5, Btn:GetWide()-4, 2, Col)
			end
		end
	self.VC_Initialized = true
	end
end

function El:Paint() draw.RoundedBox(2, 0, 0, self:GetWide(), self:GetTall()+2, Color(0,0,0,255)) end

vgui.Register("VC_ControlLine", El)

local El_Cnt = {}
function El_Cnt:Paint() self.VC_BtnSlcTNm = self.VC_BtnSlcTNm or 0 local CMS, BW, BH = self.VC_BtnSlcTNm > 0 and ((80+ math.sin(CurTime()*10)*8)* self.VC_BtnSlcTNm) or 20, self:GetSize() if self.VC_AwaitInput and self.VC_BtnSlcTNm < 1 then self.VC_BtnSlcTNm = self.VC_BtnSlcTNm+ 0.05 elseif !self.VC_AwaitInput and self.VC_BtnSlcTNm > 0 then self.VC_BtnSlcTNm = self.VC_BtnSlcTNm- 0.03 end draw.RoundedBox(0, BW/2, 0, BW/2, BH, Color(CMS, self.VC_BtnInfo[2] and 65 or 50, 70- 80*self.VC_BtnSlcTNm, 255)) draw.RoundedBox(0, 0, 0, BW/2, BH, Color(90, 20, 20, 255)) end

function El_Cnt:OnMousePressed(MB)
	if MB == MOUSE_LEFT then
		if !self.VC_AwaitInput then
		self.VC_BtnKey:SetText(VC_Lng("EnterKey"))
		self.VC_AwaitInput_Time = CurTime()+5 self.VC_AwaitInput = true
		end
	end
end

function El_Cnt:Think()
	local Width = self:GetWide()/2+10
		if self.VC_BtnInfo and !self.VC_AsgndInf then
		self.VC_BtnInfLbl = vgui.Create("DLabel", self) self.VC_BtnInfLbl:SetSize(Width-18, 20) self.VC_BtnInfLbl:SetPos(8, 2) self.VC_BtnInfLbl:SetText(VC_Lng(self.VC_BtnInfo[1]))
		self.VC_BtnKey = vgui.Create("DLabel", self) self.VC_BtnKey:SetSize(Width, 20)
		local GCN = (VC_ControlTable[self.VC_BtnCmd] or {}).key or "None"
		self.VC_BtnKey:SetText((self.VC_BtnInfo[2] and "L ALT+ " or "")..VC_Lng(GCN == "None" and "None" or (KBK[GCN] or KBK_Mouse[GCN]).name or string.Explode("KEY_", VC_ControlTable[self.VC_BtnCmd].key)[2])) self.VC_AsgndInf = true
		end
	self.VC_BtnKey:SetPos(Width, 2)
	if self.VC_AwaitInput and vgui.CursorVisible() and self.VC_AwaitInput_Time and CurTime() < self.VC_AwaitInput_Time then
	self.VC_BtnInit = true
	if input.IsKeyDown(KEY_BACKSPACE) then RunConsoleCommand("VC_SetControl", self.VC_BtnCmd, "None") self.VC_BtnKey:SetText("None") self.VC_AwaitInput = nil self.VC_BtnTxt = nil end
	for KLk, KLv in pairs(KBK) do if input.IsKeyDown(_G[KLk]) and !KLv[self] then KLv[self] = true elseif !input.IsKeyDown(_G[KLk]) and KLv[self] and self.VC_BtnCmd then self.VC_BtnTxt = KLv.name or string.Explode("KEY_", KLk)[2] RunConsoleCommand("VC_SetControl", self.VC_BtnCmd, KLk) self.VC_BtnKey:SetText(self.VC_BtnTxt) self.VC_AwaitInput = nil end end
	if CurTime() >= (self.VC_AwaitInput_Time-4.8) then for KLk, KLv in pairs(KBK_Mouse) do if input.IsMouseDown(_G[KLk]) and !KLv[self] then KLv[self] = true elseif !input.IsMouseDown(_G[KLk]) and KLv[self] and self.VC_BtnCmd then self.VC_BtnTxt = KLv.name RunConsoleCommand("VC_SetControl", self.VC_BtnCmd, KLk, "0", "1") self.VC_BtnKey:SetText(self.VC_BtnTxt) self.VC_AwaitInput = nil end end end
	elseif self.VC_BtnInit then
	local GCN = (VC_ControlTable[self.VC_BtnCmd] or {}).key or "None"
	self.VC_BtnKey:SetText((self.VC_BtnInfo[2] and "L ALT+ " or "")..VC_Lng((self.VC_BtnTxt == "None" or GCN == "None") and "None" or (KBK[GCN] or KBK_Mouse[GCN]).name or string.Explode("KEY_", VC_ControlTable[self.VC_BtnCmd].key)[2]))
	for KLk, KLv in pairs(KBK) do KLv[self] = nil end
	for KLk, KLv in pairs(KBK_Mouse) do KLv[self] = nil end
	self.VC_AwaitInput = nil self.VC_BtnInit = nil
	end
end
vgui.Register("VC_Control", El_Cnt)

local El_Cnt_Chk = {}
function El_Cnt_Chk:Think()
	if self.VC_BtnInfo and !self.VC_AsgndInf then
	self.VC_Control = vgui.Create("VC_Control", self) self.VC_Control.VC_BtnInfo = self.VC_BtnInfo self.VC_Control.VC_BtnCmd = self.VC_BtnCmd
	self.VC_CheckBox = vgui.Create("DCheckBox", self) self.VC_CheckBox:SetValue(VC_ControlTable[self.VC_BtnCmd] and VC_ControlTable[self.VC_BtnCmd].hold or 0) self.VC_CheckBox:SetToolTip("Hold")
	self.VC_CheckBox.OnChange = function(CBP, CBV) RunConsoleCommand("VC_SetControl", self.VC_BtnCmd, "Hold", CBV and "1" or "0") end
	self.VC_AsgndInf = true
	end
	if self.VC_Control then self.VC_Control:SetSize(self:GetSize()) self.VC_CheckBox:SetPos(self:GetWide()-20, 4) end
end
vgui.Register("VC_Control_CheckBox", El_Cnt_Chk)

local El_PDV = {}
function El_PDV:Init()
	self.VC_VecLblX, self.VC_VecLblY, self.VC_VecLblZ, self.VC_VecX, self.VC_VecY, self.VC_VecZ = vgui.Create("DLabel", self), vgui.Create("DLabel", self), vgui.Create("DLabel", self), vgui.Create("DNumberWang", self), vgui.Create("DNumberWang", self), vgui.Create("DNumberWang", self)
	local Width = 75 self.VC_VecLblX:SetSize(Width,24) self.VC_VecLblY:SetSize(Width,24) self.VC_VecLblZ:SetSize(Width,24) self.VC_VecX:SetSize(Width, 20) self.VC_VecY:SetSize(Width, 20) self.VC_VecZ:SetSize(Width, 20)
end

function El_PDV:Think()
	if input.IsKeyDown(KEY_SPACE) then
		if !self.VC_KeySpacePressed then
			if self.VC_VecX:HasFocus() then
			self.VC_VecY:RequestFocus()
			elseif self.VC_VecY:HasFocus() then
			self.VC_VecZ:RequestFocus()
			end
		end
		self.VC_KeySpacePressed = true
	else
	self.VC_KeySpacePressed = false
	end
	if !self.VC_AsgndInf then
	local Min, Max, Dec = self.VC_SldMin or -300, self.VC_SldMax or 300, self.VC_SldDec or 2
	self.VC_VecX:SetMin(0) self.VC_VecX:SetMax(255) self.VC_VecX:SetDecimals(0) self.VC_VecY:SetMin(0) self.VC_VecY:SetMax(100) self.VC_VecY:SetDecimals(0) self.VC_VecZ:SetMin(0) self.VC_VecZ:SetMax(1) self.VC_VecZ:SetDecimals(0)

	self.VC_VecLblX:SetText("Pitch")
	self.VC_VecLblY:SetText("Distance")
	self.VC_VecLblZ:SetText("Volume")
	self.VC_VecX:SetValue(0) self.VC_VecY:SetValue(0) self.VC_VecZ:SetValue(0)
	self.VC_AsgndInf = true
	end

	if self.VC_Change then self.VC_VecX:SetValue(self.VC_Change[1]) self.VC_VecY:SetValue(self.VC_Change[2]) self.VC_VecZ:SetValue(self.VC_Change[3]) self.VC_Change = nil end
	local PWd = self:GetParent():GetWide() local PWd3 = PWd/3

	self.VC_VecX:SetPos(PWd3-75, 0) self.VC_VecY:SetPos(PWd3*2-75, 0) self.VC_VecZ:SetPos(PWd-75, 0)
	self.VC_VecLblX:SetPos(PWd3-75-25, 0) self.VC_VecLblY:SetPos(PWd3*2-75-43, 0) self.VC_VecLblZ:SetPos(PWd-75-35, 0)
end
vgui.Register("VC_PitchDistanceVolume", El_PDV)

local El_Vec = {}
function El_Vec:Init() self.VC_VecLbl, self.VC_VecX, self.VC_VecY, self.VC_VecZ = vgui.Create("DLabel", self), vgui.Create("DNumberWang", self), vgui.Create("DNumberWang", self), vgui.Create("DNumberWang", self) self.VC_VecLbl:SetSize(37,24) self.VC_VecX:SetSize(50, 20) self.VC_VecY:SetSize(50, 20) self.VC_VecZ:SetSize(50, 20) end
function El_Vec:Think()
		if input.IsKeyDown(KEY_SPACE) then
			if !self.VC_KeySpacePressed then
				if self.VC_VecX:HasFocus() then
				self.VC_VecY:RequestFocus()
				elseif self.VC_VecY:HasFocus() then
				self.VC_VecZ:RequestFocus()
				end
			end
			self.VC_KeySpacePressed = true
		else
		self.VC_KeySpacePressed = false
		end
	if !self.VC_AsgndInf and (self.VC_Text or self.VC_SldMin or self.VC_SldMax or self.VC_SldDec) then local Min, Max, Dec = self.VC_SldMin or -500, self.VC_SldMax or 500, self.VC_SldDec or 2 self.VC_VecX:SetMin(Min) self.VC_VecX:SetMax(Max) self.VC_VecX:SetDecimals(Dec) self.VC_VecY:SetMin(Min) self.VC_VecY:SetMax(Max) self.VC_VecY:SetDecimals(Dec) self.VC_VecZ:SetMin(Min) self.VC_VecZ:SetMax(Max) self.VC_VecZ:SetDecimals(Dec) self.VC_VecLbl:SetText(self.VC_Text or "") self.VC_VecX:SetValue(0) self.VC_VecY:SetValue(0) self.VC_VecZ:SetValue(0) self.VC_AsgndInf = true end
	if self.VC_Change then self.VC_VecX:SetValue(self.VC_Change[1]) self.VC_VecY:SetValue(self.VC_Change[2]) self.VC_VecZ:SetValue(self.VC_Change[3]) self.VC_Change = nil end
	local PWd = self:GetParent():GetWide() self.VC_VecLbl:SetWide(PWd-150) self.VC_VecX:SetPos(PWd-150, 0) self.VC_VecY:SetPos(PWd-100, 0) self.VC_VecZ:SetPos(PWd-50, 0)
end
vgui.Register("VC_Vector", El_Vec)

local El_VecImp = {}
function El_VecImp:Init()
	self.VC_Vector = vgui.Create("VC_Vector", self)
	self.VC_Button = vgui.Create("DButton", self)
end
function El_VecImp:Think()
	if !self.VC_AsgndInf and (self.VC_Text or self.VC_SldMin or self.VC_SldMax or self.VC_SldDec) then
	self.VC_Vector.VC_Text = self.VC_Text self.VC_Vector.VC_SldMin = self.VC_SldMin self.VC_Vector.VC_SldMax = self.VC_SldMax self.VC_Vector.VC_SldDec = self.VC_SldDec
	self.VC_Button:SetText("") self.VC_Button:SetSize(20,20) self.VC_Button:SetToolTip("Import from visual trace.\nRight click for more options.")
		local function ImpTrace(OnX, OnY, OnZ)
			local tr = LocalPlayer():GetEyeTraceNoCursor()
			-- if IsValid(tr.Entity) and tr.Entity:IsVehicle() then
			if IsValid(tr.Entity) then
			local vec = tr.Entity:WorldToLocal(tr.HitPos)
			local Norm = (LocalPlayer():EyePos()-tr.HitPos):GetNormalized()
				if LocalPlayer():EyePos():Distance(tr.HitPos) > 20 then
				VC_Dev_VisualTrace = {tr.HitPos+Norm*15, tr.HitPos-Norm*15, Norm, self, tr.Entity, OnlyX = OnX, OnlyY = OnY, OnlyZ = OnZ}
				else
				VCMsg("ERROR: Too close to car to trace, attempting.")
				VC_Dev_VisualTrace = {tr.HitPos+Norm*(LocalPlayer():EyePos():Distance(tr.HitPos)-10), tr.HitPos-Norm*15, Norm, self, tr.Entity, OnlyX = OnX, OnlyY = OnY, OnlyZ = OnZ}
				end
			end
		end

	self.VC_Button.DoClick = function() ImpTrace() end
		self.VC_Button.DoRightClick = function()
			local DDM = DermaMenu()
				local ISM = DDM:AddSubMenu("Import from visual Trace:")
				ISM:AddOption("All", function() ImpTrace() end):SetImage("icon16/arrow_out.png")
				ISM:AddSpacer()
				ISM:AddOption("Only X", function() ImpTrace(true) end):SetImage("icon16/arrow_left.png")
				ISM:AddOption("Only Y", function() ImpTrace(nil, true) end):SetImage("icon16/arrow_turn_left.png")
				ISM:AddOption("Only Z", function() ImpTrace(nil, nil, true) end):SetImage("icon16/arrow_up.png")
			DDM:AddOption("Import from trace", function()
				local tr = LocalPlayer():GetEyeTraceNoCursor()
				if IsValid(tr.Entity) and tr.Entity:IsVehicle() then
				local vec = tr.Entity:WorldToLocal(tr.HitPos)
				VC_Dev_Pos_Vector_Imp = Vector(math.Round(vec.x*10)/10, math.Round(vec.y*10)/10, math.Round(vec.z*10)/10)
				self.VC_Vector.VC_Change = VC_Dev_Pos_Vector_Imp
				end
			end):SetImage("icon16/zoom.png")
			DDM:AddOption("Import from Pos Tool", function() self.VC_Vector.VC_Change = VC_Dev_Pos_Vector_Imp or Vector(VC_Dev_Pos_X or 0, VC_Dev_Pos_Y or 0, VC_Dev_Pos_Z or 0) end):SetImage("icon16/cog.png")
			DDM:AddSpacer()
			DDM:AddOption("Switch Left/Right", function()
			if self.VC_Vector.VC_VecX:GetValue() != 0 then self.VC_Vector.VC_Change = Vector(-self.VC_Vector.VC_VecX:GetValue(), self.VC_Vector.VC_VecY:GetValue(), self.VC_Vector.VC_VecZ:GetValue()) end
			end):SetImage("icon16/arrow_refresh.png")
			DDM:Open()
		end
	self.VC_AsgndInf = true
	end
	if self.VC_Vector then self.VC_Vector:SetSize(self:GetSize()) self.VC_Button:SetPos(self:GetWide()-172, 0) end
end
vgui.Register("VC_Vector_Import", El_VecImp)

local El_Col = {}
function El_Col:Init()
	self.VC_Vector = vgui.Create("VC_Vector", self)
	self.VC_CheckBox = vgui.Create("DCheckBox", self)
end
function El_Col:Paint() if self.VC_Color then local Sx, Sy = self:GetSize() draw.RoundedBox(0, 0, 0, Sx, Sy, self.VC_Color) end end
function El_Col:Think()
	if !self.VC_AsgndInf and (self.VC_Text or self.VC_SldMin or self.VC_SldMax or self.VC_SldDec) then
	self.VC_Vector.VC_Text = self.VC_Text self.VC_Vector.VC_SldMin = self.VC_SldMin self.VC_Vector.VC_SldMax = self.VC_SldMax self.VC_Vector.VC_SldDec = self.VC_SldDec
	self.VC_CheckBox:SetValue(0) self.VC_CheckBox:SetToolTip("Use")
	
	local function Predict(Clr)
		if type(Clr) == "string" then
			if Clr == "Night" then
			Clr = {185+math.Rand(0,70),185+math.Rand(0,70),185+math.Rand(0,70)}
			elseif Clr == "Reverse" then
			Clr = {200,225,255}
			elseif Clr == "Brake" then
			Clr = {255,55,0}
			elseif Clr == "Headlight" then
			Clr = table.Random({{255,255,255},{255,225,225},{225,255,225},{225,225,255},{255,255,225},{255,225,255},{225,255,255}})
			elseif Clr == "Blinker" then
			Clr = {255,155,0}
			elseif Clr == "Siren" then
			Clr = table.Random({{255,55,0}, {0,55,255}})
			else
			Clr = {0,0,0}
			end
		end
	self.VC_Vector.VC_Change = Clr
	end

		self.VC_CheckBox.DoRightClick = function()
			local DDM = DermaMenu()
			DDM:AddOption("Red", function() Predict({255, 55, 0}) end):SetImage("icon16/user_red.png")
			DDM:AddOption("Green", function() Predict({55, 255, 0}) end):SetImage("icon16/user_green.png")
			DDM:AddOption("Blue", function() Predict({0, 55, 255}) end):SetImage("icon16/user.png")
			DDM:AddSpacer()
			DDM:AddOption("White", function() Predict({200, 225, 255}) end):SetImage("icon16/tux.png")
			DDM:AddOption("Yellow", function() Predict({255, 155, 0}) end):SetImage("icon16/user_orange.png")
			DDM:AddOption("Black", function() Predict({0, 0, 0}) end):SetImage("icon16/user_gray.png")
			DDM:AddSpacer()
			local ISM = DDM:AddSubMenu("Predict")
				ISM:AddOption("Night", function() Predict("Night") end)
				ISM:AddOption("Reverse", function() Predict("Reverse") end)
				ISM:AddOption("Brake", function() Predict("Brake") end)
				ISM:AddOption("Headlight", function() Predict("Headlight") end)
				ISM:AddOption("Blinker", function() Predict("Blinker") end)
				ISM:AddOption("Siren", function() Predict("Siren") end)
			DDM:Open()
		end
	self.VC_AsgndInf = true
	end
	if self.VC_Check_Change then self.VC_CheckBox:SetValue(self.VC_Check_Change) self.VC_Check_Change = nil end
	if self.VC_Vector then self.VC_Vector:SetSize(self:GetSize()) self.VC_CheckBox:SetPos(self:GetWide()-170, 4) end
end
vgui.Register("VC_Color", El_Col)

local function Init(self)
	local PosX = 0 self.VC_Panels = {}
	for k,v in pairs(VC_DevPanelDimentions) do self.VC_Panels[k] = vgui.Create("DPanelList") self.VC_Panels[k]:EnableVerticalScrollbar(true) self.VC_Panels[k]:SetParent(self) end
	self.VC_DevPanelDimentions = table.Copy(VC_DevPanelDimentions) VC_DevPanelDimentions = nil
end

local function Think(self) if self.VC_Panels and self.VC_Parent and self.VC_DevPanelDimentions then local PosX = 0 local Sx, Sy = self.VC_Parent:GetSize() for k,v in pairs(self.VC_DevPanelDimentions) do self.VC_Panels[k]:SetPos(PosX, 0) self.VC_Panels[k]:SetSize(Sx*v-(self.VC_Panels[k+1] and 2 or 0), Sy) PosX = PosX+Sx*v end end end

local El_Pnl = {}
function El_Pnl:Init() Init(self) end
function El_Pnl:Think() Think(self) end
function El_Pnl:Paint() for k,v in pairs(self.VC_Panels) do local Px, Py = v:GetPos() local Sx, Sy = v:GetSize() draw.RoundedBox(0, Px, Py, Sx, Sy-4, Color(0,0,0,120)) end end
vgui.Register("VC_Panel", El_Pnl)

local El_Pnl = {}
function El_Pnl:Init() Init(self) end
function El_Pnl:Think() Think(self) end
vgui.Register("VC_Panel_NoDraw", El_Pnl)

local El_Pnl = {}
function El_Pnl:Init() Init(self) end
function El_Pnl:Think() Think(self) end
function El_Pnl:Paint() local Sx, Sy = self:GetSize() draw.RoundedBox(0, 0, 0, Sx, Sy-4, Color(0,0,0,120)) end
vgui.Register("VC_Panel_Draw_Whole", El_Pnl)

local El_MBtn = {}
function El_MBtn:Think()
	if self.VC_BTbl then
		for Bk, Bv in pairs(self.VC_BTbl) do
		if !self.VC_BTbl[Bk].info then local Btn = vgui.Create("DButton", self) Btn:SetText(Bv.name) if Bv.tooltip then Btn:SetToolTip(Bv.tooltip) end if Bv.clk then Btn.DoClick = Bv.clk end self.VC_BTbl[Bk].btn = Btn self.VC_BTbl[Bk].info = true end
		local Sx, Sy = self:GetSize() Bv.btn:SetPos(Sx/#self.VC_BTbl*(Bk-1)) Bv.btn:SetSize(Sx/#self.VC_BTbl, Sy)
		end
	end
end
vgui.Register("VC_MultiButton", El_MBtn)

local El_Pnl = {}
function El_Pnl:Think()
	if self.VC_BTbl then
		for Bk, Bv in pairs(self.VC_BTbl) do
		if !self.VC_BTbl[Bk].info then
		local Btn = vgui.Create("DButton", self) Btn:SetText(Bv.name) if Bv.tooltip then Btn:SetToolTip(Bv.tooltip) end if Bv.clk then Btn.DoClick = Bv.clk end self.VC_BTbl[Bk].btn = Btn self.VC_BTbl[Bk].info = true
			if Bk == 1 then
				Btn.Paint = function()
				draw.RoundedBox(4, 0, 0, Btn:GetWide(), Btn:GetTall(), Color(0, 155, 0, 255))
				draw.RoundedBox(4, 2, 2, Btn:GetWide()-4, Btn:GetTall()-4, Color(255, 255, 255, 155))
				end
			elseif Bk == (self.RemoveButton or 2) then
				Btn.Paint = function()
				draw.RoundedBox(4, 0, 0, Btn:GetWide(), Btn:GetTall(), Color(155, 0, 0, 255))
				draw.RoundedBox(4, 2, 2, Btn:GetWide()-4, Btn:GetTall()-4, Color(255, 255, 255, 155))
				end
			end
		end
		local Sx, Sy = self:GetSize() Bv.btn:SetPos(Sx/#self.VC_BTbl*(Bk-1)) Bv.btn:SetSize(Sx/#self.VC_BTbl, Sy)
		end
	end
end

vgui.Register("VC_ARB", El_Pnl)

local VC_DComboBox = {}
function VC_DComboBox:Init()
	self.VC_List = vgui.Create("DComboBox", self)
	self.VC_Btn1 = vgui.Create("DImageButton", self) self.VC_Btn1:SetMaterial("VCMod/VGUI/Previous.vmt") self.VC_Btn1:SetToolTip("Select previous in the list.") self.VC_Btn1:SetWidth(50)
	self.VC_Btn2 = vgui.Create("DImageButton", self) self.VC_Btn2:SetMaterial("VCMod/VGUI/Next.vmt") self.VC_Btn2:SetToolTip("Select next in the list.") self.VC_Btn2:SetWidth(50)
	self.VC_Btn3 = vgui.Create("DImageButton", self) self.VC_Btn3:SetMaterial("icon16/eye.png") self.VC_Btn3:SetToolTip("Display all light positions.") self.VC_Btn3:SetWidth(25)
	self.VC_Btn1.DoClick = function() if self.VC_List.VC_Sel and self.VC_List.VC_Sel > 1 then self.VC_List:ChooseOptionID(self.VC_List.VC_Sel-1) end end
	self.VC_Btn2.DoClick = function() if !self.VC_List.VC_Sel or self.VC_List.VC_Max > self.VC_List.VC_Sel then self.VC_List:ChooseOptionID((self.VC_List.VC_Sel or 0)+1) end end
end

function VC_DComboBox:Think()
	if self.VC_List then
	local Sx,Sy = self:GetSize()
		if self.VC_DontDoView then
		self.VC_List:SetWidth(Sx-100)
		self.VC_Btn1:SetPos(Sx-100, 0)
		self.VC_Btn2:SetPos(Sx-50, 0)
		self.VC_Btn3:Remove()
		else
		self.VC_List:SetWidth(Sx-125)
		self.VC_Btn1:SetPos(Sx-125, 0)
		self.VC_Btn2:SetPos(Sx-75, 0)
		self.VC_Btn3:SetPos(Sx-25, 0)
		end
	end
end
vgui.Register("VC_DComboBox", VC_DComboBox)