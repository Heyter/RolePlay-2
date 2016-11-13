
local TrayHeight = 26
local NavBarHeight = 32
local ActionsAnimTime = 0.5


local OS = rPhone.CreatePackage( "os" )


local app_tray, app_launcher, app_navbar
local canv_tray, canv_launcher, canv_navbar
local actions_menu

local os_dependencies = {}
local os_actions = {}
local app_actions = rPhone.NewWeakTable( 'k' )

local rphone_init, os_init = false, false

local function initOSOnPrepared()
	if !rphone_init or os_init then return end

	for _, dep in pairs( os_dependencies ) do
		if !dep then return end
	end

	os_init = true

	OS.Initialize()	
end

rPhone.RegisterEventCallback( "Initialize", function()
	rphone_init, os_init = true, false

	initOSOnPrepared()
end )

rPhone.RegisterEventCallback( "Finalize", function()
	OS.Finalize()
end )

rPhone.RegisterEventCallback( "OS_LockAnimationComplete", function()
	if canv_navbar then canv_navbar:SetVisible( false ) end
	if canv_launcher then canv_launcher:SetVisible( false ) end
end )

rPhone.RegisterEventCallback( "OS_Unlock", function()
	if canv_navbar then canv_navbar:SetVisible( true ) end
	if canv_launcher then canv_launcher:SetVisible( true ) end
end )



function OS.Initialize()
	local bcanv = rPhone.GetBaseCanvas()
	local pw, ph = rPhone.GetSize()
	
	canv_tray = rPhone.CreateCanvas( 0, 0, pw, TrayHeight, bcanv )
	app_tray = rPhone.LaunchApp( "tray", canv_tray )
	
	canv_navbar = rPhone.CreateCanvas( 0, ph - NavBarHeight, pw, NavBarHeight, bcanv )
	app_navbar = rPhone.LaunchApp( "navbar", canv_navbar )
		function app_navbar:OnBackPressed()
			OS.NavigateBack()
		end
		function app_navbar:OnHomePressed()
			OS.NavigateHome()
		end
		function app_navbar:OnActionsPressed()
			OS.DisplayActions()
		end

	canv_launcher = rPhone.CreateCanvas( 
		0, TrayHeight, 
		pw, ph - TrayHeight - NavBarHeight, 
		bcanv
	)
	app_launcher = rPhone.LaunchApp( "launcher", canv_launcher )

	rPhone.TriggerEvent( "OS_PreInitialize", OS )
	rPhone.TriggerEvent( "OS_Initialize", OS )
	rPhone.TriggerEvent( "OS_PostInitialize", OS )
end

function OS.GetTrayHeight()
	return TrayHeight
end

function OS.GetNavBarHeight()
	return NavBarHeight
end

function OS.AddTrayNotification( nbt, priority, side )
	if !rPhone.IsAppRunning( app_tray ) then return end

	local note = app_tray:AddNotification( nbt, priority, side )

	rPhone.TriggerEvent( "OS_TrayNotificationAdded", note )

	return note
end

function OS.AddAction( name, func )
	os_actions[name] = func
end

function OS.AddAppAction( app, name, func )
	app_actions[app] = app_actions[app] or {}
	app_actions[app][name] = func
end

function OS.NavigateBack()
	if !rPhone.IsAppRunning( app_launcher ) then return end

	local fgapp = app_launcher:GetForegroundApp()

	if fgapp and !fgapp:TriggerEventForResult( "OnBackPressed" ) then
		fgapp:Kill()
	end
end

function OS.NavigateHome()
	if !rPhone.IsAppRunning( app_launcher ) then return end

	app_launcher:KillAll()
end

function OS.DisplayActions()
	if !rPhone.IsAppRunning( app_launcher ) then return end
	if IsValid( actions_menu ) then
		actions_menu:Remove()

		return
	end

	local rpbcanv = rPhone.GetBaseCanvas()
	local fgapp = app_launcher and app_launcher:GetForegroundApp()

	local sortfunc = function( n1, _, n2, _ )
		return n1:lower() < n2:lower()
	end
	local ositer = rPhone.SortedPairsFunc( os_actions, sortfunc ) 
	local appiter = rPhone.SortedPairsFunc( app_actions[fgapp] or {}, sortfunc )

	actions_menu = rpbcanv:AddPanel( "RPDMenu" )
		for name, func in ositer do
			actions_menu:AddOption( name, func )
		end
		if #ositer > 0 and #appiter > 0 then 
			actions_menu:AddSpacer()
		end
		for name, func in appiter do
			actions_menu:AddOption( name, func )
		end
		actions_menu:Open()

	local start = SysTime()
	local x = canv_launcher:GetWide() - actions_menu:GetWide()
	local h = actions_menu:GetTall()

	actions_menu.OldThink = actions_menu.Think
	function actions_menu:Think()
		self:OldThink()

		local y = rpbcanv:GetTall() - NavBarHeight - 
			((math.sin( (math.pi / 2) * (SysTime() - start) / ActionsAnimTime )^2) * h)

		self:SetPos( x, y )

		if SysTime() - start >= ActionsAnimTime then
			self:SetPos( x, rpbcanv:GetTall() - h - NavBarHeight )
			self.Think = self.OldThink
		end
	end

	canv_navbar:GetBasePanel():MoveToFront()
end

function OS.LaunchApp( pname, params )
	if !rPhone.IsAppRunning( app_launcher ) then return end

	app_launcher:LaunchApp( pname, params )
end

function OS.SetAppTitle( app, title )
	if !rPhone.IsAppRunning( app_launcher ) then return end

	app_launcher:SetAppTitle( app, title )
end

function OS.GetAppTitle( app )
	if !rPhone.IsAppRunning( app_launcher ) then return end

	return app_launcher:GetAppTitle()
end

function OS.GetForegroundApp()
	if !rPhone.IsAppRunning( app_launcher ) then return end

	return app_launcher:GetForegroundApp()
end

function OS.Finalize()
	rPhone.TriggerEvent( "OS_Finalize" )

	if app_launcher then app_launcher:Kill() end
	if app_tray then app_tray:Kill() end
	if app_navbar then app_navbar:Kill() end

	if canv_launcher then canv_launcher:Dispose() end
	if canv_tray then canv_tray:Dispose() end
	if canv_navbar then canv_navbar:Dispose() end
end

function OS.AddDependancy( dname )
	os_dependencies[dname] = os_dependencies[dname] or false
end

function OS.SetDependancyPrepared( dname )
	os_dependencies[dname] = true

	initOSOnPrepared()
end

function OS.HasKeyboardFocus()
	return rPhone.CanKeyListen() and !OS.IsLocked()
end
