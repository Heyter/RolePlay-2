include('shared.lua')
surface.CreateFont( "dialogueFont", {
	font = "Open Sans",
	size = 18,
	weight = 400,
	antialias = true
} )

net.Receive( "orgmenudialogue", function()
	local mainFrame = vgui.Create("DFrame")
	mainFrame:SetSize(500, 190)
	mainFrame:SetPos(ScrW() / 2 - (500 / 2), ScrH() / 1.5)
	mainFrame:SetDraggable( true )
	mainFrame:MakePopup()
	mainFrame:ShowCloseButton( false )
	mainFrame:SetTitle("Organisation Menu")
	mainFrame.Paint = function( panel )
		draw.RoundedBox( 0, 0, 0, panel:GetWide(), 25, Color(52, 73, 94) )
		draw.RoundedBox( 0, 0, 25, panel:GetWide(), panel:GetTall() - 25, Color(226,226,226) )
	end

	local closeButton = vgui.Create("DButton", mainFrame)
	closeButton:SetSize( 75, 25 )
	closeButton:SetPos( 425 , 0 )
	closeButton:SetColor( Color( 255, 255, 255 ))
	closeButton:SetText("X")

	closeButton.Paint = function( )
		if closeButton.isHover then
			draw.RoundedBox( 0, 0, 0, closeButton:GetWide(), closeButton:GetTall(), Color( 192, 57, 43 ) )
		else
			draw.RoundedBox( 0, 0, 0, closeButton:GetWide(), closeButton:GetTall(), Color( 231, 76, 60 ) )
		end
	end

	closeButton.OnCursorEntered = function()
		closeButton.isHover = true
	end

	closeButton.OnCursorExited = function()
		closeButton.isHover = false
	end

	closeButton.DoClick = function()
		mainFrame:Close()
	end


	local panel = vgui.Create("DPanel", mainFrame)
	panel:SetSize(488, 105)
	panel:SetPos(6, 30)
	local dialogueTextLabel = vgui.Create("DLabel", mainFrame)
	dialogueTextLabel:SizeToContents()
	dialogueTextLabel:SetPos(10, 38)
	dialogueTextLabel:SetColor(Color(50, 50, 50))
	dialogueTextLabel:SetFont("dialogueFont")
	dialogueTextLabel:SetText( ORGS_Lang.npcLine )
	dialogueTextLabel:SetWrap( true )
	dialogueTextLabel:SetWide( 470 )
	dialogueTextLabel:SetAutoStretchVertical( true )

	local dialogueButton2 = vgui.Create("DFlatButton", mainFrame)
	dialogueButton2:SetSize(488, 25)
	dialogueButton2:SetPos(6, 155)
	dialogueButton2:SetText( ORGS_Lang.npcleave )
	dialogueButton2.DoClick = function()
		LocalPlayer():ConCommand("org_leave")
		mainFrame:Close()
	end

	local dialogueButton1 = vgui.Create("DFlatButton", mainFrame)
	dialogueButton1:SetSize(488, 25)
	dialogueButton1:SetPos(6, 128)
	if LocalPlayer():canAfford(ORGS_Config.createPrice) then
		dialogueButton1:SetText( ORGS_Lang.npcnew )
	else
		dialogueButton1:SetText( ORGS_Lang.npcgetmoney )
		dialogueButton1:SetDisabled( true )
	end
	dialogueButton1.DoClick = function()
		dialogueTextLabel:SetText( ORGS_Lang.npccallorg )
		dialogueTextLabel:SizeToContents()
		dialogueButton1:Hide()
		local orgnametext = vgui.Create("DTextEntry", mainFrame)
		orgnametext:SetSize(488, 20)
		orgnametext:SetPos(6, 128)
		orgnametext:SetText( ORGS_Lang.npcnametext )
		dialogueButton2:SetText( ORGS_Lang.npccreate )
		dialogueButton2:SetDisabled( true )
		orgnametext:SetFont("FlatButtonsFont")
		orgnametext.OnTextChanged = function(text)
			if string.match(orgnametext:GetValue(),"%d") or orgnametext:GetValue() == ORGS_Lang.npcnametext or string.match(orgnametext:GetValue(),"([']+)") or string.match(orgnametext:GetValue(),'(["]+)') or string.match(orgnametext:GetValue(),"%d") or string.match(orgnametext:GetValue(),"%p") or string.len(orgnametext:GetValue()) > 25 then
				dialogueButton2:SetDisabled( true )
			else
				dialogueButton2:SetDisabled( false )
			end
		end
		orgnametext.Paint = function( )
			draw.RoundedBox( 0, 0, 0, orgnametext:GetWide(), orgnametext:GetTall(), Color( 255, 255, 255 ) )
			surface.SetDrawColor(189, 195, 199, 255)
			surface.DrawOutlinedRect(0, 0, orgnametext:GetWide(), orgnametext:GetTall())
			orgnametext:DrawTextEntryText(Color(52, 73, 94, 255), Color(52, 73, 94, 255), Color(52, 73, 94, 255))
		end
		dialogueButton2.DoClick = function()
			net.Start("orgcheckname")
				net.WriteString(orgnametext:GetValue())
			net.SendToServer()
		end
		net.Receive("returnorgcheckname", function()
			if net.ReadBool() then
				LocalPlayer():ConCommand('org_neworg "' ..orgnametext:GetValue().. '"')
				mainFrame:Close()
			else
				Derma_Query( ORGS_Lang.inuse, "Sorry but..", "Ok" )
			end
		end)
	end
end)