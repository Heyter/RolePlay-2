
local CheckerSize = 15
local TutorialText = [[Welcome to the Sign Editor!

To edit the canvas, right click.

You can add text, change the background color,
and set the background image using a URL.

To modify text later, right click it and hit Edit, 
or Remove to delete it. You can also drag it 
around by holding left click.

When you're done, just close this window and
your sign will update.

Don't forget to save when you're done!]]
local TutorialFontSize = 25 -- NOTE: this sort of counts on the editor being at least 512x512, any smaller and it will not fit

local PANEL = {}

Signs.AccessorFunc( PANEL, "bgColor", "BackgroundColor", Color( 0, 0, 0, 0 ), true )
Signs.AccessorFunc( PANEL, "imgUrl", "ImageUrl", '' )
Signs.AccessorFunc( PANEL, "imgCropMode", "ImageCropMode", 0 )


function PANEL:Init()
	self.overlayLabels = {}
	self.childFrames = {}
	self.useImage = false

	self.doTutorial = !file.Exists( "sign_editor_tutorial.txt", "DATA" )
end

function PANEL:AddChildFrame( frame )
	table.insert( self.childFrames, frame )
end

function PANEL:CloseChildFrames()
	for _, frame in pairs( self.childFrames ) do
		if IsValid( frame ) then
			frame:Remove()
		end
	end

	self.childFrames = {}
end

function PANEL:CreateChildFrame( title, w, h ) -- track child frames for easy removal
	for _, frame in pairs( self.childFrames ) do
		if IsValid( frame ) and frame._title == title then
			frame:Remove() -- remove duplicate child windows (in case they reopen them for whatever stupid reason)
		end
	end

	local window = self:GetParent() -- get containing window (parent)

	local frame = vgui.Create( "DFrame" )
		frame:SetTitle( title )
		frame:SetSize( w, h )
		frame:SetPos( window.x + window:GetWide(), window.y )
		frame:MakePopup()

	frame._title = title -- keep track of title names to remove duplicate windows

	self:AddChildFrame( frame )

	return frame
end

function PANEL:CreateTextOverlayLabel( text, font, size, x, y, color, bold, italic, outline ) -- x and y are the center
	if self:GetTextOverlayCount() >= Signs.TextOverlayMax then
		Derma_Message( "Maximum text overlays reached.", "Error", "OK" )

		return
	end

	local lbl = vgui.Create( "DSignEditorTextOverlayLabel", self )
		lbl:SetText( text )
		lbl:SetBaseFont( font )
		lbl:SetFontSize( size )
		lbl:SetFontBold( bold )
		lbl:SetFontItalic( italic )
		lbl:SetFontOutline( outline )
		lbl:SizeToContents()
		lbl:SetTextColor( color )
		lbl:SetPos( x - (lbl:GetWide() / 2), y - (lbl:GetTall() / 2) ) -- convert from center to top-left

	table.insert( self.overlayLabels, lbl )

	return lbl
end

function PANEL:ReloadHtml()
	local url = self:GetImageUrl()
	local mode = self:GetImageCropMode()

	if !url or #url == 0 then return end

	self.htmlPanel:SetHTML( Signs.GetImageHtml( url, mode ) )
end

function PANEL:SetImageUrl( url )
	if !Signs.ImagesAllowed then return end

	if !url or #url == 0 then
		self.useImage = false
		self.imgUrl = ''
	elseif #url > 256 then
		Derma_Message( "URL too long.", "Error", "OK" )

		self.useImage = false
		self.imgUrl = ''
	else
		if !IsValid( self.htmlPanel ) then
			self.htmlPanel = vgui.Create( "DHTML" )
				self.htmlPanel:SetSize( self:GetSize() )
				self.htmlPanel:SetPaintedManually( true )
				self.htmlPanel:Hide()
		end

		self.useImage = false
		self.imgUrl = url

		self:ReloadHtml()

		timer.Simple( 1.5, function() -- DHTML completion hooks are broken
			if IsValid( self ) then self.useImage = true end
		end )

		http.Fetch( url, function( _, len ) -- check if exceeds size limit
			if len > Signs.ImageFileSizeMax * 1000 then
				Derma_Message( 
					("The image you're trying to load is too large. The limit is %s."):format(
						string.NiceSize( Signs.ImageFileSizeMax * 1000 )
					), 
					"Error", "OK"
				)
			end
		end )
	end
end

function PANEL:SetImageCropMode( mode )
	self.imgCropMode = mode

	self:ReloadHtml()
end

function PANEL:SetTextOverlays( overlays )
	for _, lbl in pairs( self.overlayLabels ) do
		if IsValid( lbl ) then lbl:Remove() end
	end

	for _, overlay in ipairs( overlays ) do
		local lbl = self:CreateTextOverlayLabel(
			overlay.text,
			overlay.font, overlay.size,
			overlay.x, overlay.y,
			overlay.color,
			overlay.bold, overlay.italic, overlay.outline
		)

		if !lbl then break end -- in case maximum overlay count reached
	end
end

function PANEL:GetTextOverlays()
	local ret = {}

	for _, lbl in pairs( self.overlayLabels ) do
		if IsValid( lbl ) then -- make sure it's still valid (they are not removed from the table when deleted)
			table.insert( ret, lbl:GetTextOverlayInfo() )
		end
	end

	return ret
end

function PANEL:GetTextOverlayCount()
	local cnt = 0

	for _, lbl in pairs( self.overlayLabels ) do
		if IsValid( lbl ) then 
			cnt = cnt + 1
		end
	end

	return cnt
end

function PANEL:OnMouseReleased( mc )
	if mc != MOUSE_RIGHT then return end

	if self.doTutorial then
		self.doTutorial = false

		file.Write( "sign_editor_tutorial.txt", "" )
	end

	local menu = DermaMenu()
		menu:AddOption( "Add Text", function()
			local x, y = self:ScreenToLocal( menu.x, menu.y )

			local lbl = self:CreateTextOverlayLabel( -- add text using default values
				"New Text",
				Signs.TextOverlayFontDefault, Signs.TextOverlayFontSizeDefault,
				x, y,
				Signs.TextOverlayColorDefault
			)
			
			if lbl then lbl:OpenEditor() end
		end )
		menu:AddSpacer()
		menu:AddOption( "Set Background", function()
			local frame = self:CreateChildFrame( "Background Color", 300, 175 )

			local mixer = vgui.Create( "DColorMixer", frame )
				mixer:Dock( FILL )
				mixer:SetPalette( false )
				mixer:SetAlphaBar( true )
				mixer:SetWangs( true )
				mixer:SetColor( self:GetBackgroundColor() )
				mixer.ValueChanged = function()
					self:SetBackgroundColor( mixer:GetColor() )
				end
		end )
		if Signs.ImagesAllowed then
			menu:AddOption( "Set Image", function()
				local frame = self:CreateChildFrame( "Image URL", 300, 50 )

				local urlEntry = vgui.Create( "DTextEntry", frame )
					urlEntry:SetPos( 5, 27 )
					urlEntry:SetValue( self:GetImageUrl() )

				local cropMode = vgui.Create( "DComboBox", frame )
					cropMode:SetSize( 70, urlEntry:GetTall() )
					cropMode:SetPos( frame:GetWide() - 5 - cropMode:GetWide(), urlEntry.y )
					cropMode:AddChoice( "FILL", 0, self:GetImageCropMode() == 0 ) -- select the current value
					cropMode:AddChoice( "FIT",  1, self:GetImageCropMode() == 1 )

				local setUrl = vgui.Create( "DButton", frame )
					setUrl:SetText( "Set" )
					setUrl:SetPos( 5, urlEntry.y + urlEntry:GetTall() + 2 )
					setUrl:SetWide( frame:GetWide() - 10 )
					setUrl.DoClick = function()
						if !IsValid( self ) then return end

						local url = urlEntry:GetValue()

						self:SetImageCropMode( select( 2, cropMode:GetSelected() ) )
						self:SetImageUrl( url )
					end

				urlEntry:SetWide( frame:GetWide() - cropMode:GetWide() - 10 - 2 )
				frame:SetTall( setUrl.y + setUrl:GetTall() + 5 )
			end )
		end
		menu:AddSpacer()
		menu:AddOption( "Save", function()
			local frame = self:CreateChildFrame( "Save", 250, 100 )

			local nameLbl = vgui.Create( "DLabel", frame )
				nameLbl:SetText( "File name: " )
				nameLbl:SetPos( 5, 27 + 2 )
				nameLbl:SizeToContents()

			local nameEntry = vgui.Create( "DTextEntry", frame )
				nameEntry:SetPos( 5 + nameLbl:GetWide(), 27 )
				nameEntry:SetWide( frame:GetWide() - nameLbl:GetWide() - 10 )

			local save = vgui.Create( "DButton", frame )
				save:SetPos( 5, nameEntry.y + nameEntry:GetTall() + 5 )
				save:SetWide( frame:GetWide() - 10 )
				save:SetText( "Save" )
				save.DoClick = function()
					local fname = nameEntry:GetValue()

					if #fname < 1 then return end
					if !fname:EndsWith( ".txt" ) then fname = fname .. ".txt" end

					local overlays = self:GetTextOverlays()

					for _, overlay in pairs( overlays ) do
						overlay.x = overlay.x / self:GetWide() -- convert to relative coordinates for saving
						overlay.y = overlay.y / self:GetTall()
					end

					local json = util.TableToJSON {
						backgroundColor = self:GetBackgroundColor(),
						imageUrl = self:GetImageUrl(),
						imageCropMode = self:GetImageCropMode(),
						textOverlays = overlays
					}

					if !file.Exists( "signs/", "DATA" ) then
						file.CreateDir( "signs" )
					end

					file.Write( "signs/" .. fname, json )

					frame:Close()
				end

			frame:SetTall( save.y + save:GetTall() + 5 )
		end )
		menu:AddOption( "Load", function()
			local frame = self:CreateChildFrame( "Image", 200, 250 )

			local saved = vgui.Create( "DListView", frame )
				saved:Dock( FILL )
				saved:SetMultiSelect( false )
				saved:AddColumn( "Saved Sign" )
				saved.DoDoubleClick = function( _, lineId )
					local line = saved:GetLine( lineId )
					local fname = line:GetColumnText( 1 )

					local tbl = util.JSONToTable( file.Read(
						"signs/" .. fname
					) )

					if tbl then
						for _, overlay in pairs( tbl.textOverlays ) do
							overlay.x = math.floor( overlay.x * self:GetWide() ) -- convert to absolute coordinates
							overlay.y = math.floor( overlay.y * self:GetTall() )
						end

						self:SetBackgroundColor( tbl.backgroundColor )
						self:SetImageCropMode( tbl.imageCropMode ) -- this first so it's set before loading the URL
						self:SetImageUrl( tbl.imageUrl )
						self:SetTextOverlays( tbl.textOverlays )

						frame:Close()
					end
				end
				saved.OnRowRightClick = function( _, lineId, line )
					local menu = DermaMenu()
						menu:AddOption( "Delete", function()
							Derma_Query(
								"Are you sure you would like to delete this file?",
								"Pending",
								"Yes",
								function()
									if !IsValid( saved ) or !IsValid( line ) then return end
									
									local fname = line:GetColumnText( 1 )

									file.Delete( "signs/" .. fname )

									saved.ReloadSigns()
								end,
								"No"
							)
						end )
						menu:Open()
				end
				saved.ReloadSigns = function()
					saved:Clear()

					for _, fname in ipairs( file.Find( "signs/*.txt", "DATA", "namedesc" ) ) do
						saved:AddLine( fname )
					end
				end

			saved.ReloadSigns()
		end )
		menu:AddSpacer()
		menu:AddOption( "Reset", function()
			local queryPanel = Derma_Query(
				"Are you sure you would like to reset your changes?",
				"Pending",
				"Yes",
				function()
					if IsValid( self ) then
						self:SetBackgroundColor( Color( 0, 0, 0, 0 ) )
						self:SetImageUrl( '' )
						self:SetTextOverlays( {} )

						self:CloseChildFrames()
					end
				end,
				"No"
			)

			self:AddChildFrame( queryPanel ) -- don't forget to remove it if the parent is closed
		end )
		menu:AddSpacer()
		menu:AddOption( "Help", function()
			self.doTutorial = true
		end )
		menu:Open()
end

function PANEL:Paint( w, h )
	if self.bgColor.a < 255 then
		surface.SetDrawColor( 255, 255, 255, 255 )
		surface.DrawRect( 0, 0, w, h )

		surface.SetDrawColor( 200, 200, 200, 255 )
		
		for r = 1, math.ceil( h / CheckerSize ) do
			for c = (r % 2 == 0 and 1 or 2), math.ceil( w / CheckerSize ), 2 do
				surface.DrawRect( 
					(c - 1) * CheckerSize, 
					(r - 1) * CheckerSize, 
					CheckerSize, CheckerSize
				)
			end
		end
	end

	if self.doTutorial then
		surface.SetDrawColor( 0, 0, 0, 245 )
		surface.DrawRect( 0, 0, w, h )

		local lines = string.Explode( '\n', TutorialText )

		for i, line in ipairs( lines ) do
			if #line == 0 then continue end -- blank

			draw.SimpleText(
				line,
				Signs.GetFont( "Default", TutorialFontSize ),
				w / 2, (h / 2) - (((#lines / 2) - i) * TutorialFontSize),
				Color( 255, 255, 255, 255 ),
				TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER
			)
		end
	else
		if self.bgColor.a > 0 then
			surface.SetDrawColor( self.bgColor )
			surface.DrawRect( 0, 0, w, h )
		end
		
		if self.useImage and IsValid( self.htmlPanel ) then
			self.htmlPanel:UpdateHTMLTexture()

			local mat = self.htmlPanel:GetHTMLMaterial()

			if mat then
				surface.SetDrawColor( 255, 255, 255, 255 )
				surface.SetMaterial( mat )
				surface.DrawTexturedRectUV( 
					0, 0, w, h, 
					0, 0, 1, 1
				)
			end
		end
	end
end

function PANEL:OnRemove()
	self:CloseChildFrames()

	if self.ApplyChangesCallback then
		self:ApplyChangesCallback()
	end
end

derma.DefineControl( "DSignEditor", "", PANEL, "DPanel" )
