include('shared.lua')
ENT.RenderGroup = RENDERGROUP_BOTH

function ENT:Draw() self.Entity:DrawModel() end

surface.CreateFont("NPCHUD", {size = 12, weight = 600, antialias = true, shadow = false, font = "DejaVu Sans"})

local Font_Logo = "VC_Logo" if !VC_Fonts[Font_Logo] then VC_Fonts[Font_Logo] = true surface.CreateFont(Font_Logo, {font = "MenuLarge", size = 40, weight = 1000, blursize = 2, scanlines = 0, antialias = true, underline = false, italic = false, strikeout = false, symbol = false, rotary = false, shadow = false, additive = false, outline = false}) end
local Font_VIP = "VC_VIP" if !VC_Fonts[Font_VIP] then VC_Fonts[Font_VIP] = true surface.CreateFont(Font_VIP, {font = "MenuLarge", size = 30, weight = 1000, blursize = 1, scanlines = 0, antialias = true, underline = false, italic = false, strikeout = false, symbol = false, rotary = false, shadow = false, additive = false, outline = false}) end

local CurrentCars = {}
local HasCars = false
local isTesting = false
net.Receive("SendCurrentCars", function() local id = net.ReadInt(8) if(id == -1) then HasCars = true else table.insert(CurrentCars, id) end end)

local function GetCurrentCars() HasCars = false CurrentCars = {} net.Start("RequestCurrentCars") net.SendToServer() end
local function AttemptBuyCar(id) if(id > #VC_NPC_Cars) then return end net.Start("AttemptBuyCar") net.WriteInt(id, 8) net.SendToServer() end
local function AttemptSellCar(id) if(id > #VC_NPC_Cars) then return end net.Start("AttemptSellCar") net.WriteInt(id, 8) net.SendToServer() end
local function AttemptSpawnCar(id) if(id > #VC_NPC_Cars) then return end net.Start("AttemptSpawnCar") net.WriteInt(id, 8) net.SendToServer() end
local function AttemptRemoveCar() net.Start("AttemptRemoveCar") net.SendToServer() end
local function AttemptTestCar(id) if(id > #VC_NPC_Cars) then return end net.Start("AttemptTestCar") net.WriteInt(id, 8) net.SendToServer() end

local function DoDraw(DermaPanel, v)
	local LClr = VC_NPC_Settings and VC_NPC_Settings.LineColor or Color(100, 255, 55, 255)
	if v.vip then
		DermaPanel.Paint = function()
			draw.RoundedBox(0, 0, 0, DermaPanel:GetWide(), DermaPanel:GetTall(), LClr)
			draw.RoundedBox(0, 2, 2, DermaPanel:GetWide()-4, DermaPanel:GetTall()-4, VC_NPC_Settings and VC_NPC_Settings.VIPColor or Color(150, 150, 255, 255))
			draw.DrawText("VIP", Font_VIP, 5, 0,  Color(255, 200, 0, 255), TEXT_ALIGN_LEFT)
		end	
	else
		if(v.price <= 70000) then
			DermaPanel.Paint = function()
			draw.RoundedBox(0, 0, 0, DermaPanel:GetWide(), DermaPanel:GetTall(), LClr)
			draw.RoundedBox(0, 2, 2, DermaPanel:GetWide()-4, DermaPanel:GetTall()-4, Color(225, 200, 200, 255))
			end	
		elseif(v.price <= 150000) then
			DermaPanel.Paint = function()
			draw.RoundedBox(0, 0, 0, DermaPanel:GetWide(), DermaPanel:GetTall(), LClr)
			draw.RoundedBox(0, 2, 2, DermaPanel:GetWide()-4, DermaPanel:GetTall()-4, Color(255, 175, 175, 255))
			end	
		else
			DermaPanel.Paint = function()
			draw.RoundedBox(0, 0, 0, DermaPanel:GetWide(), DermaPanel:GetTall(), LClr)
			draw.RoundedBox(0, 2, 2, DermaPanel:GetWide()-4, DermaPanel:GetTall()-4, Color(255, 150, 150, 255))
			end	
		end
	end
end

local function DoBtnPaint(Btn)
	Btn.Paint = function()
		local IsHovered = Btn:IsHovered()
		draw.RoundedBox(0, 0, 0, Btn:GetWide(), Btn:GetTall(), VC_NPC_Settings and VC_NPC_Settings.LineColor or Color(100, 255, 55, 255))
		draw.RoundedBox(0, 2, 2, Btn:GetWide()-4, Btn:GetTall()-4, IsHovered and (VC_NPC_Settings and VC_NPC_Settings.BtnColor or Color(225, 225, 255, 255)) or (VC_NPC_Settings and VC_NPC_Settings.BtnColor or Color(255, 255, 255, 255)))
	end
end

function AttemptDraw()
	if(HasCars == false) then
		timer.Simple(0.05, function()
			AttemptDraw()
		end)
		return
	end
	local MainFrame = vgui.Create("DFrame")
	MainFrame:SetPos(ScrW() / 2 - 250,  ScrH() / 2 - 200)
	MainFrame:SetSize(VC_NPC_Settings and VC_NPC_Settings.Width or 550, VC_NPC_Settings and VC_NPC_Settings.Height or 425)
	MainFrame:SetTitle("")
	MainFrame:NoClipping(true)
	MainFrame:MakePopup()
	MainFrame.Paint = function()
		draw.RoundedBox(0, 0, 0, MainFrame:GetWide(), MainFrame:GetTall(), VC_NPC_Settings and VC_NPC_Settings.BGColor or Color(245, 245, 255, 255))
		draw.RoundedBox(0, 0, 0, MainFrame:GetWide(), 2, VC_NPC_Settings and VC_NPC_Settings.LineColor or Color(100, 255, 55, 255))
		draw.RoundedBox(0, 0, 43, 200, 2, VC_NPC_Settings and VC_NPC_Settings.LineColor or Color(100, 255, 55, 255))
		draw.RoundedBox(0, 0, MainFrame:GetTall()-2, MainFrame:GetWide(), 2, VC_NPC_Settings and VC_NPC_Settings.LineColor or Color(100, 255, 55, 255))
		draw.RoundedBox(0, 0, 0, 2, MainFrame:GetTall(), VC_NPC_Settings and VC_NPC_Settings.LineColor or Color(100, 255, 55, 255))
		draw.RoundedBox(0, MainFrame:GetWide()-2, 0, 2, MainFrame:GetTall(), VC_NPC_Settings and VC_NPC_Settings.LineColor or Color(100, 255, 55, 255))
		draw.DrawText("Car Dealer", Font_Logo, 10, 5,  Color(255, 0, 0, 255), TEXT_ALIGN_LEFT)
	end

	local Putawayyourcarbutton = vgui.Create("DButton")
	Putawayyourcarbutton:SetParent(MainFrame)
	Putawayyourcarbutton:SetFont("NPCHUD")
	Putawayyourcarbutton:SetTextColor(Color(0,0,0,255))
	Putawayyourcarbutton:SetPos(MainFrame:GetWide()-137, 32)
	Putawayyourcarbutton:SetSize(125, 25)
	Putawayyourcarbutton:SetText("Put away your car!")
	Putawayyourcarbutton.DoClick = function()	
		AttemptRemoveCar()
		MainFrame:Close()
	end

	DoBtnPaint(Putawayyourcarbutton)

	local Tabs = vgui.Create("DPropertySheet")
	Tabs:SetParent(MainFrame)
	Tabs:SetPos(5, 50)
	Tabs:SetSize(MainFrame:GetWide()-10, MainFrame:GetTall()-55)

	local Spawn = vgui.Create("DPanelList")
	Spawn:SetSize(Tabs:GetWide(), Tabs:GetTall())
	Spawn:SetPos(5, 15)
	Spawn:SetSpacing(5)
	Spawn:EnableHorizontal(false)
	Spawn:EnableVerticalScrollbar(true)

	local Buy = vgui.Create("DPanelList")
	Buy:SetSize(Tabs:GetWide(), Tabs:GetTall())
	Buy:SetPos(5, 15)
	Buy:SetSpacing(5)
	Buy:EnableHorizontal(false)
	Buy:EnableVerticalScrollbar(true)

	local Sell = vgui.Create("DPanelList")
	Sell:SetSize(Tabs:GetWide(), Tabs:GetTall())
	Sell:SetPos(5, 15)
	Sell:SetSpacing(5)
	Sell:EnableHorizontal(false)
	Sell:EnableVerticalScrollbar(true)

	Tabs:AddSheet("Spawn", Spawn, nil, false, false, "Spawn")
	Tabs:AddSheet("Buy", Buy, nil, false, false, "Buy")
	Tabs:AddSheet("Sell", Sell, nil, false, false, "Sell")

	for k,v in pairs(VC_NPC_Cars) do
		local hascar = false
		for k2, v2 in pairs(CurrentCars) do
			if(k == v2) then
				hascar = true
			end
		end
		if(hascar == true) then
		local DermaPanel = vgui.Create("DPanel", Spawn)
		DermaPanel:SetSize(Tabs:GetWide(), 67)
			
		DoDraw(DermaPanel, v)
			local DermaButton = vgui.Create("DButton")
			DermaButton:SetParent(DermaPanel)
			DermaButton:SetFont("NPCHUD")
			DermaButton:SetTextColor(Color(0,0,0,255))
			DermaButton:SetPos(Tabs:GetWide()-190, 20)
			DermaButton:SetSize(150, 25)
			DermaButton:SetText("Spawn")
			DermaButton.DoClick = function()	
				AttemptSpawnCar(k)
				MainFrame:Close()
			end

			DoBtnPaint(DermaButton)

			local DermaIcon = vgui.Create("SpawnIcon")
			DermaIcon:SetParent(DermaPanel)
			DermaIcon:SetPos(2, 2)
			DermaIcon:SetModel(v.model)
			DermaIcon:SetToolTip(v.name)
		
			local DermaLabel = vgui.Create("DLabel")
			DermaLabel:SetText(v.name.."\n"..v.info)
			DermaLabel:SetFont("NPCHUD")
			DermaLabel:SetTextColor(Color(0,0,0,255))
			DermaLabel:SetParent(DermaPanel)
			DermaLabel:SetPos(100, 5)
			DermaLabel:SetSize(Tabs:GetWide()-10, 25)
			Spawn:AddItem(DermaPanel)
		end
	end

	for k,v in pairs(VC_NPC_Cars) do
		local hascar = false
		for k2, v2 in pairs(CurrentCars) do
			if(k == v2) then
				hascar = true
			end
		end
		if(hascar == false) then
		local DermaPanel = vgui.Create("DPanel", Buy)
		DermaPanel:SetSize(Tabs:GetWide(), 67)
			
		DoDraw(DermaPanel, v)
			local DermaButton = vgui.Create("DButton")
			DermaButton:SetParent(DermaPanel)
			DermaButton:SetFont("NPCHUD")
			DermaButton:SetTextColor(Color(0,0,0,255))
			DermaButton:SetPos(Tabs:GetWide()-190, 20)
			DermaButton:SetSize(150, 25)
			DermaButton:SetText("$"..v.price)
			DoBtnPaint(DermaButton)
			DermaButton.DoClick = function()
				local DermaButton = DermaMenu()
				DermaButton:AddOption("Test Drive", function() 
					AttemptTestCar(k)
					MainFrame:Close()
				end)
				DermaButton:AddOption("Buy", function() 
					AttemptBuyCar(k)
					MainFrame:Close()
				end)
				DermaButton:AddOption("Cancel", function() 
				end)
				DermaButton:Open()
			end

			local DermaIcon = vgui.Create("SpawnIcon")
			DermaIcon:SetParent(DermaPanel)
			DermaIcon:SetPos(2, 2)
			DermaIcon:SetModel(v.model)
			DermaIcon:SetToolTip(v.name)
		
			local DermaLabel = vgui.Create("DLabel")
			DermaLabel:SetText(v.name.."\n"..v.info)
			DermaLabel:SetFont("NPCHUD")
			DermaLabel:SetTextColor(Color(0,0,0,255))
			DermaLabel:SetParent(DermaPanel)
			DermaLabel:SetPos(100, 5)
			DermaLabel:SetSize(150, 25)
			Buy:AddItem(DermaPanel)
		end
	end
	--Selling
	for k,v in pairs(VC_NPC_Cars) do
		local hascar = false
		for k2, v2 in pairs(CurrentCars) do
			if(k == v2) then
				hascar = true
			end
		end
		if(hascar == true) then
		local DermaPanel = vgui.Create("DPanel", Sell)
		DermaPanel:SetSize(Tabs:GetWide(), 67)
			
		DoDraw(DermaPanel, v)
			local DermaButton = vgui.Create("DButton")
			DermaButton:SetParent(DermaPanel)
			DermaButton:SetFont("NPCHUD")
			DermaButton:SetTextColor(Color(0,0,0,255))
			DermaButton:SetPos(Tabs:GetWide()-190, 20)
			DermaButton:SetSize(150, 25)
			DermaButton:SetText("Original price: $"..v.price)
			DoBtnPaint(DermaButton)
			DermaButton.DoClick = function()	
				local DermaButton = DermaMenu()
				DermaButton:AddOption("Sell", function() 
					AttemptSellCar(k)
					MainFrame:Close()
				end)
				DermaButton:AddOption("Cancel", function() 
				end)
				DermaButton:Open()
			end

			local DermaIcon = vgui.Create("SpawnIcon")
			DermaIcon:SetParent(DermaPanel)
			DermaIcon:SetPos(2, 2)
			DermaIcon:SetModel(v.model)
			DermaIcon:SetToolTip(v.name)
		
			local DermaLabel = vgui.Create("DLabel")
			DermaLabel:SetText(v.name.."\n"..v.info)
			DermaLabel:SetFont("NPCHUD")
			DermaLabel:SetTextColor(Color(0,0,0,255))
			DermaLabel:SetParent(DermaPanel)
			DermaLabel:SetPos(100, 5)
			DermaLabel:SetSize(150, 25)
			Sell:AddItem(DermaPanel)
		end
	end
end
net.Receive("OpenCarMenu", function()
	GetCurrentCars()
	AttemptDraw()
end)