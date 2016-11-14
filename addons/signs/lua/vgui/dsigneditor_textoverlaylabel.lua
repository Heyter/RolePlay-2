
local PANEL = {}

Signs.AccessorFunc( PANEL, "baseFont", "BaseFont", "Default" )
Signs.AccessorFunc( PANEL, "fontSize", "FontSize", 20 )
Signs.AccessorFunc( PANEL, "fontBold", "FontBold", false )
Signs.AccessorFunc( PANEL, "fontItalic", "FontItalic", false )
Signs.AccessorFunc( PANEL, "fontOutline", "FontOutline", false )


function PANEL:Init()
	self:SetMouseInputEnabled( true )

	self.dragging = false
end

function PANEL:GetTextOverlayInfo() -- reports x and y as center
	return {
		text = self:GetText(),
		font = self:GetBaseFont(),
		size = self:GetFontSize(),
		x = self.x + (self:GetWide() / 2),
		y = self.y + (self:GetTall() / 2),
		color = self:GetTextColor(),

		bold = tobool( self:GetFontBold() ),
		italic = tobool( self:GetFontItalic() ),
		outline = tobool( self:GetFontOutline() )
	}
end

function PANEL:UpdateFont()
	if !self:GetBaseFont() or !self:GetFontSize() then return end

	local font = Signs.GetFont( 
		self:GetBaseFont(), self:GetFontSize(),
		self:GetFontBold(), self:GetFontItalic(), self:GetFontOutline()
	)

	self:SetFont( font )
	self:SizeToContents()
end

function PANEL:SetBaseFont( font )
	if !table.HasValue( Signs.Fonts, font ) then return end

	self.baseFont = font

	self:UpdateFont()
end

function PANEL:SetFontSize( size )
	if size < Signs.TextOverlayFontSizeMin or size > Signs.TextOverlayFontSizeMax then return end

	self.fontSize = size

	self:UpdateFont()
end

function PANEL:SetFontBold( bold )
	self.fontBold = bold

	self:UpdateFont()
end

function PANEL:SetFontItalic( italic )
	self.fontItalic = italic

	self:UpdateFont()
end

function PANEL:SetFontOutline( outline )
	self.fontOutline = outline

	self:UpdateFont()
end

function PANEL:OpenEditor()
	if IsValid( self.editorFrame ) then
		self.editorFrame:Remove() -- close old editor window
	end

	local window = self:GetParent():GetParent() -- get containing window (parent's parent)

	local frame = vgui.Create( "DFrame" )
		frame:SetTitle( "Edit Text" )
		frame:SetSize( 300, 300 )
		frame:SetPos( window.x + window:GetWide(), window.y ) -- put by containing window's side
		frame:MakePopup()

	self.editorFrame = frame

	local text = vgui.Create( "DTextEntry", frame )
		text:SetValue( self:GetValue() )
		text:SetWide( frame:GetWide() - 10 )
		text:SetPos( 5, 27 )
		text.OnTextChanged = function()
			if #text:GetValue() <= Signs.TextLengthMax then
				self:SetText( text:GetValue():Left( Signs.TextLengthMax ) )
				self:SizeToContents()
			end
		end

	local font = vgui.Create( "DComboBox", frame )
		font:SetPos( 5, text.y + text:GetTall() )
		font.OnSelect = function()
			self:SetBaseFont( select( 2, font:GetSelected() ) )
		end

		for name, fontname in pairs( Signs.Fonts ) do
			font:AddChoice( name, fontname, fontname == self:GetBaseFont() )
		end

	local fontSize = vgui.Create( "DNumberWang", frame )		
		fontSize:SetMin( Signs.TextOverlayFontSizeMin )
		fontSize:SetMax( Signs.TextOverlayFontSizeMax )
		fontSize:SetValue( self:GetFontSize() )
		fontSize:SetWide( 60 )
		fontSize:SetPos( 
			frame:GetWide() - fontSize:GetWide() - 5, 
			font.y + (font:GetTall() - fontSize:GetTall()) / 2
		)
		fontSize.OnValueChanged = function()
			self:SetFontSize( fontSize:GetValue() )
		end

	local bold = vgui.Create( "DCheckBoxLabel", frame )
		bold:SetText( "Bold" )
		bold:SetChecked( tobool( self:GetFontBold() ) )
		bold:SizeToContents()
		bold:SetPos( 5, font.y + font:GetTall() + 2 )
		bold.OnChange = function()
			self:SetFontBold( bold:GetChecked() )
		end

	local italic = vgui.Create( "DCheckBoxLabel", frame )
		italic:SetText( "Italic" )
		italic:SetChecked( tobool( self:GetFontItalic() ) )
		italic:SizeToContents()
		italic:SetPos( (frame:GetWide() - italic:GetWide()) / 2, bold.y )
		italic.OnChange = function()
			self:SetFontItalic( italic:GetChecked() )
		end

	local outline = vgui.Create( "DCheckBoxLabel", frame )
		outline:SetText( "Outline" )
		outline:SetChecked( tobool( self:GetFontOutline() ) )
		outline:SizeToContents()
		outline:SetPos( frame:GetWide() - outline:GetWide() - 5, bold.y )
		outline.OnChange = function()
			self:SetFontOutline( outline:GetChecked() )
		end

	local mixer = vgui.Create( "DColorMixer", frame )
		mixer:SetPos( 5, bold.y + bold:GetTall() + 2 )
		mixer:SetWide( frame:GetWide() - 10 )
		mixer:SetPalette( false )
		mixer:SetAlphaBar( true )
		mixer:SetWangs( true )
		mixer:SetColor( table.Copy( self:GetTextColor() ) ) -- leave copy since GetTextColor() is not a custom accessor
		mixer:SetTall( 100 )
		mixer.ValueChanged = function()
			self:SetTextColor( table.Copy( mixer:GetColor() ) )
		end

	font:SetWide( frame:GetWide() - 10 - fontSize:GetWide() )
	frame:SetTall( mixer.y + mixer:GetTall() + 5 )
end

function PANEL:OnMousePressed( mc )
	if mc != MOUSE_LEFT or self.dragging then
		self.dragging = false

		return
	end

	local mx, my = gui.MousePos()
	local sx, sy = self:LocalToScreen( 0, 0 )
	
	self.rx, self.ry = sx - mx, sy - my
	self.dragging = true
end

function PANEL:OnMouseReleased( mc )
	if mc == MOUSE_LEFT and self.dragging then
		self.dragging = false
	elseif mc == MOUSE_RIGHT then
		local menu = DermaMenu()
			menu:AddOption( "Edit", function()
				self:OpenEditor()
			end )
			menu:AddOption( "Remove", function()
				self:Remove()
			end )
			menu:Open()
	end
end

function PANEL:Think()
	if !self.dragging then return end

	local parent = self:GetParent()

	local mx, my = gui.MousePos()
	local tlx, tly = parent:LocalToScreen( 0, 0 )
	local brx, bry = parent:LocalToScreen( parent:GetWide(), parent:GetTall() )

	if mx < tlx or mx > brx or my < tly or my > bry then
		self.dragging = false
	else
		self:SetPos( parent:ScreenToLocal( mx + self.rx, my + self.ry ) )
	end
end

function PANEL:OnRemove()
	if IsValid( self.editorFrame ) then 
		self.editorFrame:Remove() 
	end
end

derma.DefineControl( "DSignEditorTextOverlayLabel", "", PANEL, "DLabel" )
