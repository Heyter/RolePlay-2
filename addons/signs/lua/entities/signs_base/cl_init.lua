
include( "shared.lua" )

ENT.RenderGroup = RENDERGROUP_BOTH

local htmlPanelPool = {}


function ENT:OpenEditor()
	local frame = vgui.Create( "DFrame" )
		frame:SetSize( self.ScreenWidth + 10, self.ScreenHeight + 5 + 27 )
		frame:SetTitle( "Sign Editor" )
		frame:Center()
		frame:MakePopup()

	local editor = vgui.Create( "DSignEditor", frame )
		editor:SetSize( self.ScreenWidth, self.ScreenHeight )
		editor:SetPos( 5, 27 )
		
		editor:SetBackgroundColor( self:GetBackgroundColor() )
		editor:SetImageCropMode( self:GetImageCropMode() ) -- this first so it's set before loading the URL
		editor:SetImageUrl( self:GetImageUrl() )
		editor:SetTextOverlays( self:GetTextOverlays() )
		editor.ApplyChangesCallback = function()
			if !IsValid( self ) then return end
			
			local bgColor = editor:GetBackgroundColor()
			local imgUrl = editor:GetImageUrl()
			local imgCropMode = editor:GetImageCropMode()
			local overlays = editor:GetTextOverlays()

			net.Start( "signs_send_data" )
				net.WriteEntity( self )

				net.WriteUInt( bgColor.r, 8 )
				net.WriteUInt( bgColor.g, 8 )
				net.WriteUInt( bgColor.b, 8 )
				net.WriteUInt( bgColor.a, 8 )

				net.WriteString( imgUrl )
				net.WriteUInt( imgCropMode, 8 )

				net.WriteUInt( #overlays, 8 )

				for _, overlay in ipairs( overlays ) do
					net.WriteString( overlay.text )
					net.WriteString( overlay.font )
					net.WriteUInt( overlay.size, 8 )

					net.WriteInt( overlay.x, 16 )
					net.WriteInt( overlay.y, 16 )

					net.WriteUInt( overlay.color.r, 8 )
					net.WriteUInt( overlay.color.g, 8 )
					net.WriteUInt( overlay.color.b, 8 )
					net.WriteUInt( overlay.color.a, 8 )

					net.WriteBool( overlay.bold )
					net.WriteBool( overlay.italic )
					net.WriteBool( overlay.outline )
				end
			net.SendToServer()
		end
end

function ENT:ReleaseHtmlPanel()
	table.insert( htmlPanelPool, self.htmlPanel )

	self.htmlPanel = nil
end

function ENT:RemoveHTML()
	if self.htmlPanel then
		self.htmlPanel:Remove()
	else
		print('test')
	end
end

function ENT:SetImageUrl( url )
	self.imgUrl = url

	self:ReleaseHtmlPanel() -- force refresh
end

function ENT:Think()
	if IsValid( self.htmlPanel ) and (CurTime() - self.htmlPanelLastUsed) > 10 then
		self:ReleaseHtmlPanel()
	end
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
		local imgUrl = self:GetImageUrl()

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

			render.SetStencilCompareFunction( STENCIL_EQUAL )

			cam.Start3D2D( pos, ang, self.ScreenScale )
				if bgColor.a > 0 then
					surface.SetDrawColor( bgColor )
					surface.DrawRect( 0, 0, self.ScreenWidth, self.ScreenHeight )
				end

				if Signs.ImagesAllowed and #imgUrl > 0 then
					if !IsValid( self.htmlPanel ) then
						self.htmlPanel = table.remove( htmlPanelPool )

						if !IsValid( self.htmlPanel ) then
							self.htmlPanel = vgui.Create( "DHTML" )
								self.htmlPanel:SetSize( self.ScreenWidth, self.ScreenHeight )
								self.htmlPanel:SetPaintedManually( true )
								self.htmlPanel:Hide()
						end

						self.htmlPanel:SetHTML( Signs.GetImageHtml( 
							imgUrl,
							self:GetImageCropMode()
						) )
						
						if not signs_htmlpanels then
							signs_htmlpanels = {}
						end
						
						table.insert(signs_htmlpanels, self.htmlPanel)
						
						self.htmlPanelBeginLoad = CurTime()
					else
						if (CurTime() - self.htmlPanelBeginLoad) >= 1.5 then
							self.htmlPanel:UpdateHTMLTexture()

							local mat = self.htmlPanel:GetHTMLMaterial()

							if mat then
								surface.SetDrawColor( 255, 255, 255, 255 )
								surface.SetMaterial( mat )
								surface.DrawTexturedRectUV( 
									0, 0, self.ScreenWidth, self.ScreenHeight, 
									0, 0, 1, 1
								)
							end
						end
					end

					self.htmlPanelLastUsed = CurTime()
				end

				for _, overlay in ipairs( self:GetTextOverlays() ) do
					draw.SimpleText(
						overlay.text,
						Signs.GetFont( 
							overlay.font, overlay.size,
							overlay.bold, overlay.italic, overlay.outline
						),
						overlay.x, overlay.y,
						overlay.color,
						TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER -- center
					)
				end
			cam.End3D2D()

			render.ClearStencilBufferRectangle( 0, 0, ScrW(), ScrH(), 1 ) -- circumvents halos
		render.SetStencilEnable( false )
	end
end

net.Receive( "signs_edit", function( len )
	local ent = net.ReadEntity()

	if !IsValid( ent ) or ent.Base != "signs_base" then return end

	ent:OpenEditor()
end )

net.Receive( "signs_send_data", function( len )
	local ent = net.ReadEntity()

	if !IsValid( ent ) or ent.Base != "signs_base" then return end

	ent:SetBackgroundColor( Color(
		net.ReadUInt( 8 ),
		net.ReadUInt( 8 ),
		net.ReadUInt( 8 ),
		net.ReadUInt( 8 )
	) )
	ent:SetImageUrl( net.ReadString() )
	ent:SetImageCropMode( net.ReadUInt( 8 ) ) -- order doesn't matter since it just releases the HTML panel the same frame (won't try to load twice)
	
	local overlays = {}

	for i=1, net.ReadUInt( 8 ) do
		overlays[i] = {
			text = net.ReadString(),
			font = net.ReadString(),
			size = net.ReadUInt( 8 ),

			x = net.ReadInt( 16 ), y = net.ReadInt( 16 ),

			color = Color(
				net.ReadUInt( 8 ),
				net.ReadUInt( 8 ),
				net.ReadUInt( 8 ),
				net.ReadUInt( 8 )			
			),

			bold = net.ReadBool(),
			italic = net.ReadBool(),
			outline = net.ReadBool()
		}
	end

	ent:SetTextOverlays( overlays )
end )
