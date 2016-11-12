include('shared.lua') -- At this point the contents of shared.lua are ran on the client only.

function ENT:Draw()
	self:DrawModel()
end

local DLabel3
local DLabel2
local DLabel1
local DLabel4
local DButton3
local DButton2
local DButton1
local DPanel4
local DPanel3
local DPanel2
local DPanel1
local DFrame1

local not_purchasing = {"'Ich hab immoment kein Geld um dir Cocain abzukaufen!'"}
local not_selling = {"'Ich habe keine Samen mehr. Die Leute sind alle die totalen Druggies.'"}
local anfangs_satz = {"'Was willst du?'", "'Mein Gott, was ist denn?'", "'Was kann ich fuer dich tun?'", "'Ja Bitte?'", "'Ahh, Willkommen mein Freund. Was willst du denn heute?'"} // Anfangs Satz.
local verkauft_satz = {"Es war mir ein Vergnuegen mit dir Geschaefte zu machen. Hier sind deine $"} // Wenn man was verkaufen will.
local drogen_verkaufen = {"Ich will all meine Drogen verkaufen. Bitte.", "Ich habe ein paar Gramm in der Tasche die ich loswerden will.", "Ich habe viel investiert und will jetzt endlich erfolg sehen. Brauchst du noch ein paar Gramm?"}
local seeds_kaufen = {"*Bin ich wirklich schon so tief gesunken? ... Egal* Ich will ein paar Cocaine Samen haben. Bitte.", "Hast du noch ein paar Cocaine Samen auf Lager?"}


net.Receive( "NewDialogBtn1", function( len, ply )
	local tbl = net.ReadTable()
	DButton1:SetText(drogen_verkaufen[math.Round(math.Rand(1,#drogen_verkaufen))])
	DLabel1:SetText(verkauft_satz[math.Round(math.Rand(1,#verkauft_satz))] .. tbl.money .. "!" )
	DLabel1:SizeToContents( true )
end)

net.Receive( "NewDialogBtn2", function( len, ply )
	local tbl = net.ReadTable()
	DButton1:SetText(seeds_kaufen[math.Round(math.Rand(1,#seeds_kaufen))])
	DLabel1:SetText("Hier sind deine " .. tbl.seeds .. " Samen!" )
	DLabel1:SizeToContents( true )
end)

net.Receive( "NotSelling", function( len, ply )
	DButton1:SetText(seeds_kaufen[math.Round(math.Rand(1,#seeds_kaufen))])
	DLabel1:SetText( not_selling[math.Round(math.Rand(1,#not_selling))] )
	DLabel1:SizeToContents( true )
end)


net.Receive( "NotPurchasing", function( len, ply )
	DButton1:SetText(drogen_verkaufen[math.Round(math.Rand(1,#drogen_verkaufen))])
	DLabel1:SetText( not_purchasing[math.Round(math.Rand(1,#not_purchasing))] )
	DLabel1:SizeToContents( true )
end)



usermessage.Hook("ShowDrugshopMenu", function()
local function ButtonPaint( de, txt, col )
	draw.RoundedBox( 4, 0, 0, de:GetWide(), de:GetTall(), Color( 0, 0, 0, 150 ))
	draw.RoundedBox( 4, 2, 2, de:GetWide() - 4, de:GetTall() - 4, col)
	--draw.SimpleTextOutlined( txt , "IMP22", (de:GetTall() / 2) + 2, (de:GetTall() / 2) - 12, Color( 255, 255, 255, 255 ), false, false, 0, Color( 0, 0, 0, 255 ) )
	--draw.DrawText(txt , "GmodNotify", de:GetWide()/2, de:GetTall()/2-15, Color(255, 255, 255, 200),TEXT_ALIGN_CENTER)
end

DFrame1 = vgui.Create('DFrame')
DFrame1:SetSize(680, 320)
DFrame1:Center()
DFrame1:SetTitle('                 ')
DFrame1:SetSizable(true)
DFrame1:SetDeleteOnClose(false)
DFrame1:ShowCloseButton(false)
DFrame1:SetDeleteOnClose( true )
DFrame1:MakePopup()
DFrame1.Paint = function()
	draw.RoundedBox( 4 , 0, 0, DFrame1:GetWide(), DFrame1:GetTall(), Color( 0, 0, 0, 100 ) )
	draw.RoundedBox( 4, 0, 0, DFrame1:GetWide(), 25, Color( 50, 110, 180, 220 ) )
	draw.SimpleTextOutlined( 'Drug Dealer' , "RPNormal_25", 8, 0, Color( 255, 255, 255, 255 ), false, false, 0, Color( 0, 0, 0, 255 ) )
end

DPanel1 = vgui.Create('DPanel')
DPanel1:SetParent(DFrame1)
DPanel1:SetSize(180, 170)
DPanel1:SetPos(10, 40)
DPanel1.Paint = function()
	draw.RoundedBox(4, 0, 0, DPanel1:GetWide(), DPanel1:GetTall(), Color(0,0,0,180))
end

DPanel2 = vgui.Create('DPanel')
DPanel2:SetParent(DFrame1)
DPanel2:SetSize(470, 50)
DPanel2:SetPos(200, 40)
DPanel2.Paint = function()
	draw.RoundedBox(4, 0, 0, DPanel2:GetWide(), DPanel2:GetTall(), Color(0,0,0,180))
end

DLabel4 = vgui.Create('DLabel')
DLabel4:SetParent(DPanel2)
DLabel4:SetPos(10, 20)
DLabel4:SetText('Gioseppe:')
DLabel4:SizeToContents()
DLabel4:SetTextColor(Color(0, 161, 255, 255))

DLabel1 = vgui.Create('DLabel')
DLabel1:SetParent(DPanel2)
DLabel1:SetPos(70, 20)
DLabel1:SetTextColor(Color(255, 255, 255, 200))
DLabel1:SetText(anfangs_satz[math.Round(math.Rand(1,#anfangs_satz))])
DLabel1:SizeToContents()

DPanel3 = vgui.Create('DPanel')
DPanel3:SetParent(DFrame1)
DPanel3:SetSize(470, 100)
DPanel3:SetPos(200, 110)
DPanel3.Paint = function()
	draw.RoundedBox(4, 0, 0, DPanel3:GetWide(), DPanel3:GetTall(), Color(0,0,0,180))
end

DLabel2 = vgui.Create('DLabel')
DLabel2:SetParent(DPanel3)
DLabel2:SetPos(10, 10)
DLabel2:SetText('Information:')
DLabel2:SizeToContents()
DLabel2:SetTextColor(Color(0, 161, 255, 255))

DLabel3 = vgui.Create('DLabel')
DLabel3:SetParent(DPanel3)
DLabel3:SetPos(10, 30)
DLabel3:SetText('Hier kannst du Cocaine Samen kaufen oder ein paar Gramm\naus deiner Tasche los werden, wenn du weisst was ich meine. Aber ich bin nicht immer hier,\ndenn ich hab auch noch andere Ecken wo ich was unter die Leute bringe. Also, beeile dich\ndenn ich steh nicht nur fuer dich hier rum andere wollen auch noch was kaufen.\nEntscheide dich!')
DLabel3:SizeToContents()
DLabel3:SetTextColor(Color(255, 255, 255, 200))

DPanel4 = vgui.Create('DPanel')
DPanel4:SetParent(DFrame1)
DPanel4:SetSize(660, 70)
DPanel4:SetPos(10, 230)
DPanel4.Paint = function()
	draw.RoundedBox(4, 0, 0, DPanel4:GetWide(), DPanel4:GetTall(), Color(0,0,0,180))
end

DButton1 = vgui.Create('DButton')
DButton1:SetParent(DPanel4)
DButton1:SetSize(530, 20)
DButton1:SetPos(20, 10)
DButton1:SetText(drogen_verkaufen[math.Round(math.Rand(1,#drogen_verkaufen))])
DButton1.DoClick = function() 
	net.Start( "SellAllDrugs" )
	net.SendToServer( )
end
DButton1:SetColor(Color(255,255,255,200))
DButton1.OnIt = false
DButton1.Paint = function()
	if DButton1.OnIt then
		ButtonPaint(DButton1,"",Color(50, 110, 180, 220), true)
	else
		ButtonPaint(DButton1,"",Color(50, 110, 230, 220), false)
	end
end

DButton2 = vgui.Create('DButton')
DButton2:SetParent(DPanel4)
DButton2:SetSize(530, 20)
DButton2:SetPos(20, 40)
DButton2:SetText(seeds_kaufen[math.Round(math.Rand(1,#seeds_kaufen))])
DButton2.DoClick = function() 
	Derma_Query("Wie viele Cocain Samen willst du haben?", "Drogen Dealer",
			"1", function() net.Start( "PurchaseSeeds" ) net.WriteTable( {seeds = 1} ) net.SendToServer( ) end,
			"5", function() net.Start( "PurchaseSeeds" ) net.WriteTable( {seeds = 5} ) net.SendToServer( ) end,
			"10", function() net.Start( "PurchaseSeeds" ) net.WriteTable( {seeds = 10} ) net.SendToServer( ) end,
			"30", function()  net.Start( "PurchaseSeeds" ) net.WriteTable( {seeds = 30} ) net.SendToServer( ) end)
end
DButton2:SetColor(Color(255,255,255,200))
DButton2.OnIt = false
DButton2.Paint = function()
	if DButton2.OnIt then
		ButtonPaint(DButton2,"",Color(50, 110, 180, 220), true)
	else
		ButtonPaint(DButton2,"",Color(50, 110, 230, 220), false)
	end
end

DButton3 = vgui.Create('DButton')
DButton3:SetParent(DPanel4)
DButton3:SetSize(80, 50)
DButton3:SetPos(560, 10)
DButton3:SetText('Gehen')
DButton3.DoClick = function() DFrame1:Close() end
DButton3:SetColor(Color(255,255,255,200))
DButton3.OnIt = false
DButton3.Paint = function()
	if DButton3.OnIt then
		ButtonPaint(DButton3,"",Color(50, 110, 180, 220), true)
	else
		ButtonPaint(DButton3,"",Color(50, 110, 230, 220), false)
	end
end

local mdl = LocalPlayer():GetEyeTrace().Entity or {}

if (IsValid(mdl)) then
	local modelpanel = vgui.Create("DModelPanel")
	modelpanel:SetModel(LocalPlayer():GetEyeTrace().Entity:GetModel())
	modelpanel:SetPos( 35, 80 )
	modelpanel:SetParent(DFrame1)
	modelpanel:SetSize(128,128)
	modelpanel:SetAnimated(true)
	modelpanel:SetFOV(15)
	modelpanel:SetCamPos(Vector(150,150,150))
	modelpanel:SetAnimSpeed(1)
end

end)