function NOSWithdrawMenu()
	local tempFrame = vgui.Create( "DFrame" )
	tempFrame:SetSize( 250, 150 )
	tempFrame:SetPos( (ScrW() - tempFrame:GetWide()) / 2, ScrH() + tempFrame:GetTall() )
	tempFrame:MakePopup()
	tempFrame:MoveTo( (ScrW() - tempFrame:GetWide()) / 2, (ScrH() - tempFrame:GetTall()) / 2, 0.5, 0, 0.3 )
	
	local Button1 = vgui.Create( "DButton", tempFrame )
	Button1:SetPos( 175, 110 )
	Button1:SetSize( 65, 30 )
	Button1:SetText( "" )
	Button1.Paint = function( self )
		draw.RoundedBox( 4, 0, 0, self:GetWide(), self:GetTall(), HUD_SKIN.THEME_COLOR )

		surface.SetFont( "RPNormal_20" )
		local w, h = surface.GetTextSize( "Zurück" )
		draw.SimpleText( "Zurück", "RPNormal_20", (self:GetWide() - w) / 2, (self:GetTall() - h) / 2, Color( 255, 255, 255, 255 ) )
	end
	Button1.DoClick = function()
		tempFrame:Close()

		NOSBankMenu()
	end

	local Label1 = vgui.Create( "DLabel", tempFrame )
	Label1:SetPos( 8, 45 )
	Label1:SetFont( "RPNormal_22" )
	Label1:SetColor( Color(0, 0, 0) )
	Label1:SetText( "Gewünschter Betrag:" )
	Label1:SizeToContents()

	local AmountWang = vgui.Create( "DNumberWang", tempFrame )
	AmountWang:SetSize( 230, 25 )
	AmountWang:SetPos( 10, 75 )
	AmountWang:SetText( "0" )

	local Button2 = vgui.Create( "DButton", tempFrame )
	Button2:SetPos( 10, 110 )
	Button2:SetSize( 160, 30 )
	Button2:SetText( "" )
	Button2.Paint = function( self )
		draw.RoundedBox( 4, 0, 0, self:GetWide(), self:GetTall(), HUD_SKIN.THEME_COLOR )

		surface.SetFont( "RPNormal_20" )
		local w, h = surface.GetTextSize( "Abheben" )
		draw.SimpleText( "Abheben", "RPNormal_20", (self:GetWide() - w) / 2, (self:GetTall() - h) / 2, Color( 255, 255, 255, 255 ) )
	end
	Button2.DoClick = function()
		if tonumber( AmountWang:GetValue() ) > 0 then
			net.Start( "NOSBank_WithdrawMoney" )
				net.WriteString( AmountWang:GetValue() )
			net.SendToServer()

			tempFrame:Close()
		end
	end
end

function NOSDepositMenu()
	local tempFrame = vgui.Create( "DFrame" )
	tempFrame:SetSize( 250, 150 )
	tempFrame:SetPos( (ScrW() - tempFrame:GetWide()) / 2, ScrH() + tempFrame:GetTall() )
	tempFrame:MakePopup()
	tempFrame:MoveTo( (ScrW() - tempFrame:GetWide()) / 2, (ScrH() - tempFrame:GetTall()) / 2, 0.5, 0, 0.3 )
	
	local Button1 = vgui.Create( "DButton", tempFrame )
	Button1:SetPos( 175, 110 )
	Button1:SetSize( 65, 30 )
	Button1:SetText( "" )
	Button1.Paint = function( self )
		draw.RoundedBox( 4, 0, 0, self:GetWide(), self:GetTall(), HUD_SKIN.THEME_COLOR )

		surface.SetFont( "RPNormal_20" )
		local w, h = surface.GetTextSize( "Zurück" )
		draw.SimpleText( "Zurück", "RPNormal_20", (self:GetWide() - w) / 2, (self:GetTall() - h) / 2, Color( 255, 255, 255, 255 ) )
	end
	Button1.DoClick = function()
		tempFrame:Close()

		NOSBankMenu()
	end

	local Label1 = vgui.Create( "DLabel", tempFrame )
	Label1:SetPos( 8, 45 )
	Label1:SetFont( "RPNormal_22" )
	Label1:SetColor( Color(0, 0, 0) )
	Label1:SetText( "Gewünschter Betrag:" )
	Label1:SizeToContents()

	local AmountWang = vgui.Create( "DNumberWang", tempFrame )
	AmountWang:SetSize( 230, 25 )
	AmountWang:SetPos( 10, 75 )
	AmountWang:SetText( "0" )

	local Button2 = vgui.Create( "DButton", tempFrame )
	Button2:SetPos( 10, 110 )
	Button2:SetSize( 160, 30 )
	Button2:SetText( "" )
	Button2.Paint = function( self )
		draw.RoundedBox( 4, 0, 0, self:GetWide(), self:GetTall(), HUD_SKIN.THEME_COLOR )

		surface.SetFont( "RPNormal_20" )
		local w, h = surface.GetTextSize( "Einzahlen" )
		draw.SimpleText( "Einzahlen", "RPNormal_20", (self:GetWide() - w) / 2, (self:GetTall() - h) / 2, Color( 255, 255, 255, 255 ) )
	end
	Button2.DoClick = function()
		if tonumber( AmountWang:GetValue() ) > 0 then
			net.Start( "NOSBank_DepositMoney" )
				net.WriteString( AmountWang:GetValue() )
			net.SendToServer()

			tempFrame:Close()
		end
	end
end

function NOSTransferMenu()
	local tempFrame = vgui.Create( "DFrame" )
	tempFrame:SetSize( 250, 200 )
	tempFrame:SetPos( (ScrW() - tempFrame:GetWide()) / 2, ScrH() + tempFrame:GetTall() )
	tempFrame:MakePopup()
	tempFrame:MoveTo( (ScrW() - tempFrame:GetWide()) / 2, (ScrH() - tempFrame:GetTall()) / 2, 0.5, 0, 0.3 )
	
	local Button1 = vgui.Create( "DButton", tempFrame )
	Button1:SetPos( 175, 160 )
	Button1:SetSize( 65, 30 )
	Button1:SetText( "" )
	Button1.Paint = function( self )
		draw.RoundedBox( 4, 0, 0, self:GetWide(), self:GetTall(), HUD_SKIN.THEME_COLOR )

		surface.SetFont( "RPNormal_20" )
		local w, h = surface.GetTextSize( "Zurück" )
		draw.SimpleText( "Zurück", "RPNormal_20", (self:GetWide() - w) / 2, (self:GetTall() - h) / 2, Color( 255, 255, 255, 255 ) )
	end
	Button1.DoClick = function()
		tempFrame:Close()

		NOSBankMenu()
	end

	local Label1 = vgui.Create( "DLabel", tempFrame )
	Label1:SetPos( 8, 45 )
	Label1:SetFont( "RPNormal_22" )
	Label1:SetColor( Color(0, 0, 0) )
	Label1:SetText( "Spieler:" )
	Label1:SizeToContents()

	local List = vgui.Create( "DComboBox", tempFrame )
	List:SetSize( 230, 25 )
	List:SetPos( 10, 70 )
	List:SetValue( "-- Überweisung an --")
	for _, v in pairs( player.GetAll() ) do
		List:AddChoice( v:GetRPVar( "rpname" ) )
	end

	local Label2 = vgui.Create( "DLabel", tempFrame )
	Label2:SetPos( 8, 100 )
	Label2:SetFont( "RPNormal_22" )
	Label2:SetColor( Color(0, 0, 0) )
	Label2:SetText( "Gewünschter Betrag:" )
	Label2:SizeToContents()

	local AmountWang = vgui.Create( "DNumberWang", tempFrame )
	AmountWang:SetSize( 230, 25 )
	AmountWang:SetPos( 10, 125 )
	AmountWang:SetText( "0" )

	local Button2 = vgui.Create( "DButton", tempFrame )
	Button2:SetPos( 10, 160 )
	Button2:SetSize( 160, 30 )
	Button2:SetText( "" )
	Button2.Paint = function( self )
		draw.RoundedBox( 4, 0, 0, self:GetWide(), self:GetTall(), HUD_SKIN.THEME_COLOR )

		surface.SetFont( "RPNormal_20" )
		local w, h = surface.GetTextSize( "Überweisen" )
		draw.SimpleText( "Überweisen", "RPNormal_20", (self:GetWide() - w) / 2, (self:GetTall() - h) / 2, Color( 255, 255, 255, 255 ) )
	end
	Button2.DoClick = function()
		if tonumber( AmountWang:GetValue() ) > 0 then
			local target
			
			for _, v in pairs( player.GetAll() ) do
				if v:GetRPVar( "rpname" ) == AmountWang:GetValue() then
					target = v
					break
				end
			end

			net.Start( "NOSBank_TransferMoney" )
				net.WriteString( AmountWang:GetValue() )
				net.WriteEntity( target )
			net.SendToServer()

			tempFrame:Close()
		end
	end
end

function NOSBankMenu()
	local Frame = vgui.Create( "DFrame" )
	Frame:SetSize( 400, 200 )
	Frame:SetPos( (ScrW() - Frame:GetWide()) / 2, ScrH() + Frame:GetTall() )
	Frame:MakePopup()
	Frame:MoveTo( (ScrW() - Frame:GetWide()) / 2, (ScrH() - Frame:GetTall()) / 2, 0.5, 0, 0.3 )

	local Label1 = vgui.Create( "DLabel", Frame )
	Label1:SetPos( 8, 55 )
	Label1:SetFont( "RPNormal_25" )
	Label1:SetColor( Color(0, 0, 0) )
	Label1:SetText( "Account Information:" )
	Label1:SizeToContents()

	local Label2 = vgui.Create( "DLabel", Frame )
	Label2:SetPos( 8, 90 )
	Label2:SetFont( "RPNormal_22" )
	Label2:SetColor( Color(0, 0, 0) )
	Label2:SetText( "Inhaber: " .. LocalPlayer():GetRPVar( "rpname" ) .. "\nKontoguthaben: " .. LocalPlayer():GetRPVar( "bank_cash" ) .. ",-EUR" )
	Label2:SizeToContents()

	local Button1 = vgui.Create( "DButton", Frame )
	Button1:SetPos( 8, 160 )
	Button1:SetSize( 120, 30 )
	Button1:SetText( "" )
	Button1.Paint = function( self )
		draw.RoundedBox( 4, 0, 0, self:GetWide(), self:GetTall(), HUD_SKIN.THEME_COLOR )

		surface.SetFont( "RPNormal_20" )
		local w, h = surface.GetTextSize( "Geld abheben" )
		draw.SimpleText( "Geld abheben", "RPNormal_20", (self:GetWide() - w) / 2, (self:GetTall() - h) / 2, Color( 255, 255, 255, 255 ) )
	end
	Button1.DoClick = function()
		Frame:Close()

		NOSWithdrawMenu()
	end

	local Button2 = vgui.Create( "DButton", Frame )
	Button2:SetPos( 133, 160 )
	Button2:SetSize( 120, 30 )
	Button2:SetText( "" )
	Button2.Paint = function( self )
		draw.RoundedBox( 4, 0, 0, self:GetWide(), self:GetTall(), HUD_SKIN.THEME_COLOR )

		surface.SetFont( "RPNormal_20" )
		local w, h = surface.GetTextSize( "Geld einzahlen" )
		draw.SimpleText( "Geld einzahlen", "RPNormal_20", (self:GetWide() - w) / 2, (self:GetTall() - h) / 2, Color( 255, 255, 255, 255 ) )
	end
	Button2.DoClick = function()
		Frame:Close()

		NOSDepositMenu()
	end

	local Button3 = vgui.Create( "DButton", Frame )
	Button3:SetPos( 258, 160 )
	Button3:SetSize( 135, 30 )
	Button3:SetText( "" )
	Button3.Paint = function( self )
		draw.RoundedBox( 4, 0, 0, self:GetWide(), self:GetTall(), HUD_SKIN.THEME_COLOR )

		surface.SetFont( "RPNormal_20" )
		local w, h = surface.GetTextSize( "Geld überweisen" )
		draw.SimpleText( "Geld überweisen", "RPNormal_20", (self:GetWide() - w) / 2, (self:GetTall() - h) / 2, Color( 255, 255, 255, 255 ) )
	end
	Button3.DoClick = function()
		Frame:Close()

		NOSTransferMenu()
	end
end