
local SpeedMul = 50

include( "shared.lua" )

ENT.RenderGroup = RENDERGROUP_BOTH


function ENT:OpenEditor()
	local frame = vgui.Create( "DFrame" )
		frame:SetSize( 300, 300 )
		frame:SetTitle( "Ticker Editor" )
		frame:Center()
		frame:MakePopup()
		frame.OnRemove = function()
			if !IsValid( self ) then return end
			
			net.Start( "signs_ticker_send_data" )
				net.WriteEntity( self )

				self:WriteData()
			net.SendToServer()
		end

	local text = vgui.Create( "DTextEntry", frame )
		text:SetValue( self:GetText() )
		text:SetWide( frame:GetWide() - 10 )
		text:SetPos( 5, 27 )
		text.OnTextChanged = function()
			if !IsValid( self ) then return end

			if #text:GetValue() <= Signs.TextLengthMax then
				self:SetText( text:GetValue():Left( Signs.TextLengthMax ) )
			end
		end

	local font = vgui.Create( "DComboBox", frame )
		font:SetPos( 5, text.y + text:GetTall() + 2 )
		font:SetWide( frame:GetWide() - 10 )
		font.OnSelect = function()
			if !IsValid( self ) then return end

			self:SetFont( select( 2, font:GetSelected() ) )
		end

		for name, fontname in pairs( Signs.Fonts ) do
			font:AddChoice( name, fontname, fontname == self:GetFont() )
		end

	local bold = vgui.Create( "DCheckBoxLabel", frame )
		bold:SetText( "Bold" )
		bold:SetChecked( tobool( self:GetFontBold() ) )
		bold:SizeToContents()
		bold:SetPos( 5, font.y + font:GetTall() + 2 )
		bold.OnChange = function()
			if !IsValid( self ) then return end

			self:SetFontBold( bold:GetChecked() )
		end

	local italic = vgui.Create( "DCheckBoxLabel", frame )
		italic:SetText( "Italic" )
		italic:SetChecked( tobool( self:GetFontItalic() ) )
		italic:SizeToContents()
		italic:SetPos( (frame:GetWide() - italic:GetWide()) / 2, bold.y )
		italic.OnChange = function()
			if !IsValid( self ) then return end

			self:SetFontItalic( italic:GetChecked() )
		end

	local outline = vgui.Create( "DCheckBoxLabel", frame )
		outline:SetText( "Outline" )
		outline:SetChecked( tobool( self:GetFontOutline() ) )
		outline:SizeToContents()
		outline:SetPos( frame:GetWide() - outline:GetWide() - 5, bold.y )
		outline.OnChange = function()
			if !IsValid( self ) then return end

			self:SetFontOutline( outline:GetChecked() )
		end

	local speed = vgui.Create( "DNumSlider", frame )
		speed:SetWide( frame:GetWide() - 10 )
		speed:SetPos( 5, bold.y + bold:GetTall() )
		speed:SetText( "Text Speed" )
		speed:SetMin( -10 ) -- TODO
		speed:SetMax( 10 )
		speed:SetDecimals( 1 )
		speed:GetTextArea():SetTextColor( Color( 200, 200, 200, 255 ) )
		speed:SetValue( self:GetTextSpeed() )
		speed.OnValueChanged = function()
			if !IsValid( self ) then return end

			self:SetTextSpeed( speed:GetValue() )
		end

	local delay = vgui.Create( "DNumSlider", frame )
		delay:SetWide( frame:GetWide() - 10 )
		delay:SetPos( 5, speed.y + speed:GetTall() )
		delay:SetText( "Text Cycle Delay" )
		delay:SetMin( 0 )
		delay:SetMax( 10 )
		delay:SetDecimals( 1 )
		delay:GetTextArea():SetTextColor( Color( 200, 200, 200, 255 ) )
		delay:SetValue( self:GetTextCycleDelay() )
		delay.OnValueChanged = function()
			if !IsValid( self ) then return end

			self:SetTextCycleDelay( delay:GetValue() )
		end	

	local textColor = vgui.Create( "DColorMixer", frame )
		textColor:SetPos( 5, delay.y + delay:GetTall() + 2 )
		textColor:SetSize( frame:GetWide() - 10, 100 )
		textColor:SetPalette( false )
		textColor:SetAlphaBar( true )
		textColor:SetWangs( true )
		textColor:SetColor( self:GetTextColor() )
		textColor.ValueChanged = function()
			if !IsValid( self ) then return end

			self:SetTextColor( textColor:GetColor() )
		end

	local bgLbl = vgui.Create( "DLabel", frame )
		bgLbl:SetText( "Background Color" )
		bgLbl:SizeToContents()
		bgLbl:SetPos( 5, textColor.y + textColor:GetTall() + 5 )

	local bgColor = vgui.Create( "DColorMixer", frame )
		bgColor:SetPos( 5, bgLbl.y + bgLbl:GetTall() + 5 )
		bgColor:SetSize( textColor:GetSize() )
		bgColor:SetPalette( false )
		bgColor:SetAlphaBar( true )
		bgColor:SetWangs( true )
		bgColor:SetColor( self:GetBackgroundColor() )
		bgColor.ValueChanged = function()
			if !IsValid( self ) then return end

			self:SetBackgroundColor( bgColor:GetColor() )
		end

	frame:SetTall( bgColor.y + bgColor:GetTall() + 5 )
end

function ENT:Draw()
	if LocalPlayer():GetPos():Distance( self:GetPos() ) > Signs.FadeDistance then
		render.SetBlend( 0.1 ) -- mostly transparent

			self:DrawModel()

		render.SetBlend( 1 )
	else
		local pos = self:LocalToWorld( self.ScreenOffset )
		local ang = self:LocalToWorldAngles( self.ScreenRotation )

		local bgColor = self:GetBackgroundColor()
		local text = self:GetText()
		local font = Signs.GetFont( 
			self:GetFont(), self.FontSize,
			self:GetFontBold(), self:GetFontItalic(), self:GetFontOutline()
		)

		surface.SetFont( font )

		local tw, th = surface.GetTextSize( text )

		local t = ((self.ScreenWidth + tw) / (math.abs( self:GetTextSpeed() ) * SpeedMul)) + self:GetTextCycleDelay()

		render.SetStencilEnable( true ) -- prevents text from being rendered off the entity
			render.ClearStencil()

			render.SetStencilWriteMask( 255 )
			render.SetStencilTestMask( 255 )
			render.SetStencilReferenceValue( 1 )

			render.SetStencilFailOperation( STENCIL_KEEP )
			render.SetStencilZFailOperation( STENCIL_KEEP )
			render.SetStencilPassOperation( STENCIL_REPLACE )

			render.SetStencilCompareFunction( STENCIL_ALWAYS )
			
			render.SetBlend( 0.1 ) -- mostly transparent

				self:DrawModel()

			render.SetBlend( 1 )

			render.SetStencilCompareFunction(STENCIL_EQUAL )

			cam.Start3D2D( pos, ang, self.ScreenScale )
				if bgColor.a > 0 then
					surface.SetDrawColor( bgColor )
					surface.DrawRect( 0, 0, self.ScreenWidth, self.ScreenHeight )
				end

				if self:GetTextSpeed() > 0 then
					draw.SimpleText(
						self:GetText(),
						font,
						self.ScreenWidth - ((CurTime() % t) * self:GetTextSpeed() * SpeedMul), 
						(self.ScreenHeight - th) / 2,
						self:GetTextColor(),
						TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM
					)
				else
					draw.SimpleText(
						self:GetText(),
						font,
						-tw + ((CurTime() % t) * -self:GetTextSpeed() * SpeedMul), 
						(self.ScreenHeight - th) / 2,
						self:GetTextColor(),
						TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM
					)
				end
			cam.End3D2D()

			render.ClearStencilBufferRectangle( 0, 0, ScrW(), ScrH(), 1 ) -- circumvents halos
		render.SetStencilEnable( false )		
	end
end


net.Receive( "signs_ticker_edit", function( len )
	local ent = net.ReadEntity()

	if !IsValid( ent ) or ent.Base != "signs_ticker_base" then return end

	ent:OpenEditor()
end )

net.Receive( "signs_ticker_send_data", function( len )
	local ent = net.ReadEntity()

	if !IsValid( ent ) or ent.Base != "signs_ticker_base" then return end

	ent:ReadData()
end )
