
local IconColumns = 3
local IconRows = 4
local IconWidth = 56
local IconPadding = 4


surface.CreateFont( "rphone_launcher_apptitle", {
	font = "DermaDefault",
	size = 16,
	weight = 600
} )


local APP = rPhone.CreateAppPackage( "launcher" )



function APP:Initialize()
	local canv = self:GetCanvas()
	self.canv = rPhone.CreateCanvas( 0, 0, canv:GetWide(), canv:GetTall(), canv )

	self.app_stack = {}
	self.titles = rPhone.NewWeakTable( 'k' )

	self:LayoutAppIcons()
end

function APP:FadeTo( balpha, falpha, time )
	local start = SysTime()
	local da = (falpha - balpha) / time

	local overlay = self.canv:AddPanel()
		overlay:SetSize( self.canv:GetSize() )
		function overlay:Paint( w, h )
			local alpha = balpha + (da * (SysTime() - start))
			alpha = math.Clamp( alpha, 0, 255 )

			surface.SetDrawColor( 0, 0, 0, alpha )
			surface.DrawRect( 0, 0, w, h )
		end

	timer.Simple( time, function() 
		if IsValid( overlay ) then
			overlay:Remove()
		end
	end )
end

function APP:FadeIn( time )
	self:FadeTo( 255, 0, time )
end

function APP:FadeOut( time )
	self:FadeTo( 0, 255, time )
end

function APP:LayoutAppIcons()
	local canv = self.canv
	local cw, ch = canv:GetSize()

	local btnh = IconWidth + 12
	local pnlsize = IconWidth - (IconPadding * 2)
	local xspc = (cw - (IconColumns * IconWidth)) / (IconColumns + 1)
	local yspc = (ch - (IconRows * btnh)) / (IconRows + 1)

	local iter = rPhone.SortedPairsFunc(
		rPhone.GetAppPackages(),
		function( pn1, _, pn2, _ )
			return pn1:lower() < pn2:lower()
		end
	)

	local i = 0

	for pname, pack in iter do
		if !pack.Launchable then continue end

		local dispname = pack.DisplayName or pname

		local column = math.floor( i % IconColumns ) + 1
		local row = math.floor( i / IconColumns ) + 1

		if row > IconRows then break end

		local drawicon = pack.DrawIcon

		if !drawicon and pack.Icon then
			local mat = Material( pack.Icon, "smooth" )

			drawicon = function( pnl, w, h, hov, col )
				if !mat or mat:IsError() then return end

				surface.SetDrawColor( col.r, col.g, col.b, hov and 255 or col.a )
				surface.SetMaterial( mat )
				surface.DrawTexturedRect( 0, 0, w, h )
			end
		end

		local btnicon = self.canv:AddPanel( "RPDContentButton" )
			btnicon:SetSize( IconWidth, btnh )
			btnicon:SetPos( 
				(column * xspc) + ((column - 1) * IconWidth),
				(row * yspc) + ((row - 1) * btnh)
			)
			function btnicon:Paint( w, h )
				local txtcol = APP.GetIconTextColor()

				draw.SimpleText( 
					dispname,
					"Default",
					w / 2, h,
					Color( txtcol.r, txtcol.g, txtcol.b, self:IsHovered() and 255 or txtcol.a ),
					TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM
				)
			end
			btnicon.DoClick = function()
				self:LaunchApp( pname )
			end

		local pnlicon = rPhone.CreatePanel( "DPanel", btnicon )
			pnlicon:SetSize( pnlsize, pnlsize )
			pnlicon:SetPos( IconPadding, IconPadding )
			function pnlicon:Paint( w, h )
				if drawicon then
					drawicon( self, w, h, btnicon:IsHovered(), APP.GetIconColor() )
				end
			end

		i = i + 1
	end
end

function APP:OpenApp( pname, params )
	if !rPhone.IsAppPackage( pname ) then return end

	local fgapp = self:GetForegroundApp()

	if fgapp then
		fgapp:Hide()
		fgapp:TriggerEvent( "OnLostFocus" )
	end

	self.canv:SetVisible( false )

	local cw, ch = self.canv:GetSize()

	local app = rPhone.CreateAppInstance( pname )
	local realcanv = rPhone.CreateCanvas( 0, 0, cw, ch, self:GetCanvas() )
	local appcanv = realcanv

	if !app.HideTitle then
		local dispname = app.DisplayName or app.PackageName

		local title = appcanv:AddPanel( "DLabel" )
			title:SetText( dispname )
			title:SetFont( "rphone_launcher_apptitle" )
			title:SizeToContents()
			title:SetPos( 4, 2 )

		self.titles[app] = title

		local tspace = title:GetTall() + 4

		function appcanv:Draw( w, h )
			surface.SetDrawColor( 20, 20, 20, 255 )
			surface.DrawRect( 0, 0, w, tspace )
		end

		appcanv = rPhone.CreateCanvas( 0, tspace, cw, ch - tspace, appcanv )
	end

	app:RegisterEventCallback( "Finalize", function()
		realcanv:Dispose()

		local fgapp = self:GetForegroundApp()

		table.RemoveByValue( self.app_stack, app )

		if app == fgapp then
			self:OnForegroundAppClose()
		end
	end )

	table.insert( self.app_stack, app )

	if rPhone.LaunchAppInstance( app, appcanv, params ) then
		app:TriggerEvent( "OnGainedFocus" )
	else
		table.remove( self.app_stack )
		
		realcanv:Dispose()
	end
end

function APP:LaunchApp( pname, params )
	if !rPhone.IsAppPackage( pname ) then return end

	local fadelen = APP.GetFadeAnimationTime()

	if self:GetForegroundApp() or fadelen <= 0 then
		self:OpenApp( pname, params )
	else
		self:FadeOut( fadelen )

		timer.Simple( fadelen, function()
			if !self or !self:IsRunning() then return end
			
			self:OpenApp( pname, params )
		end )
	end
end

function APP:OnForegroundAppClose()
	local fgapp = self:GetForegroundApp()

	if fgapp then
		fgapp:Show()
		fgapp:TriggerEvent( "OnGainedFocus" )
	else
		local fadelen = APP.GetFadeAnimationTime()

		if fadelen > 0 then
			self:FadeIn( fadelen )
		end

		self.canv:SetVisible( true )
	end
end

function APP:SetAppTitle( app, txt )
	if !app or !app:IsRunning() then return end

	local title = self.titles[app]

	if IsValid( title ) then
		title:SetText( txt )
		title:SizeToContents()
	end
end

function APP:GetAppTitle( app )
	if !app or !app:IsRunning() then return end

	local title = self.titles[app]

	if IsValid( title ) then
		return title:GetText()
	end
end

function APP:GetForegroundApp()
	local app = self.app_stack[#self.app_stack]

	if app and app:IsRunning() then
		return app
	end
end

function APP:KillForegroundApp()
	local app = self:GetForegroundApp()

	if app then app:Kill() end
end

function APP:KillAll()
	while self:GetForegroundApp() do
		self:KillForegroundApp()
	end
end

function APP:Draw( w, h )
	APP.DrawWallpaper( 0, 0, w, h )
end

function APP:Finalize()
	self:KillAll()
end
