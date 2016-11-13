
local LeftIcon = "dan/rphone/icons/left.png"
local RightIcon = "dan/rphone/icons/right.png"


local APP = rPhone.CreateAppPackage( "tutorial" )


local pages = {}

function APP.AddPage( layoutfunc )
	table.insert( pages, layoutfunc )
end

function APP.PlayTutorial()
	local pk_os = rPhone.AssertPackage( "os" )

	pk_os.NavigateHome()

	local pw, ph = rPhone.GetSize()
	local tut_canv = rPhone.CreateCanvas( 0, 0, pw, ph, rPhone.GetBaseCanvas() )
	local tut = rPhone.LaunchApp( APP.PackageName, tut_canv )

	tut:RegisterEventCallback( "Finalize", function()
		tut_canv:Dispose()
	end )
end

rPhone.RegisterEventCallback( "OS_PostInitialize", function()
	if !file.Exists( "rphone/tutorial_viewed.txt", "DATA" ) then
		APP.PlayTutorial()

		rPhone.RegisterEventCallback( "OS_ShouldSleep", "cl_tutorial_apk_shouldsleep", function()
			return false
		end )
	end
end )



function APP:Initialize()
	local pk_os = rPhone.AssertPackage( "os" )
	local pk_launcher = rPhone.GetPackage( "launcher" )

	local app_launch_time = 1

	if pk_launcher then
		app_launch_time = pk_launcher.GetFadeAnimationTime() + 0.2
	end

	local canv = self:GetCanvas()
	local cw, ch = canv:GetSize()
	local btnsize = 32

	self.sheet = canv:AddPanel()
		self.sheet:SetSize( cw, ch )
		self.sheet.Paint = nil

	local btnprev = canv:AddPanel( "RPDImageButton" )
		btnprev:SetImage( LeftIcon )
		btnprev:SetSize( btnsize, btnsize )
		btnprev:SetPos( 0, (ch - btnsize) / 2 )
		btnprev:SetColor( Color( 125, 125, 125, 255 ) )
		btnprev:SetHoveredColor( Color( 255, 255, 255 ) )
		btnprev.DoClick = function()
			if self.lastchange and (SysTime() - self.lastchange) < app_launch_time then return end

			if self.page > 1 then
				self.page = self.page - 1

				self:LoadPage()

				self.lastchange = SysTime()
			end
		end

	local btnnext = canv:AddPanel( "RPDImageButton" )
		btnnext:SetImage( RightIcon )
		btnnext:SetSize( btnsize, btnsize )
		btnnext:SetPos( cw - btnsize, (ch - btnsize) / 2 )
		btnnext:SetColor( Color( 125, 125, 125 ) )
		btnnext:SetHoveredColor( Color( 255, 255, 255 ) )
		btnnext.DoClick = function()
			if self.lastchange and (SysTime() - self.lastchange) < app_launch_time then return end

			if self.page < #pages then
				self.page = self.page + 1

				self:LoadPage()

				self.lastchange = SysTime()
			else
				if !file.Exists( "rphone/tutorial_viewed.txt", "DATA" ) then
					rPhone.UnregisterEventCallback( "OS_ShouldSleep", "cl_tutorial_apk_shouldsleep" )

					rPhone.FileWrite( "rphone/tutorial_viewed.txt", "" )
				end

				self:Kill()
			end
		end

	self.bounds = {
		bs = btnsize,
		trh = pk_os.GetTrayHeight(),
		nbh = pk_os.GetNavBarHeight(),
		w = cw, h = ch
	}
	self.bounds.sx = self.bounds.bs + 5
	self.bounds.sy = self.bounds.trh + 5
	self.bounds.sw = cw - (self.bounds.sx * 2)
	self.bounds.sh = ch - self.bounds.trh - self.bounds.nbh - 10

	self.page = 1
	self:LoadPage()
end

function APP:LoadPage()
	local layoutfunc = pages[self.page]

	if !layoutfunc then return end

	if IsValid( self.tutpnl ) then
		self.tutpnl:Remove()
	end

	self.tutpnl = rPhone.CreatePanel( "DPanel", self.sheet )
		self.tutpnl:SetSize( self.sheet:GetSize() )
		self.tutpnl.Paint = nil

	layoutfunc( self.tutpnl, self.bounds )
end

function APP:Draw( w, h )
end
