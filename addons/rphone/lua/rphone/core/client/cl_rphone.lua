
local PhoneWidth = 320
local PhoneHeight = math.floor( PhoneWidth * (3/2) )

local rp_init = false
local rp_running
local rp_basecanv

local function rPhone_Initialize()
	if rp_basecanv then
		rp_basecanv:Dispose()
	end

	rp_init = true
	rp_running = {}
	rp_basecanv = rPhone.CreateCanvas( 0, 0, PhoneWidth, PhoneHeight )

	rPhone.TriggerEvent( "Initialize" )
end

local function rPhone_Think()
	if !rp_init then return end
		
	for app in pairs( rp_running ) do
		app:TriggerEvent( "Think" )
	end

	rPhone.TriggerEvent( "Think" )
end

local function rPhone_Finalize()
	if !rp_init then return end
	
	rPhone.TriggerEvent( "Finalize" )

	for app in pairs( rp_running ) do
		app:Kill()
	end

	if rp_basecanv then rp_basecanv:Dispose() end

	rp_init = false
end

hook.Add( "HUDPaint", "cl_rphone_initialize", function()
	hook.Remove( "HUDPaint", "cl_rphone_initialize" )

	rPhone_Initialize()
end )
hook.Add( "Think", "cl_rphone_think", rPhone_Think )
hook.Add( "ShutDown", "cl_rphone_finalize", rPhone_Finalize )



function rPhone.IsInitialized()
	return rp_init
end

function rPhone.CanKeyListen()
	if !LocalPlayer():Alive() then return false end
	if gui.IsConsoleVisible() or gui.IsGameUIVisible() then return false end

	local fpnl = vgui.GetKeyboardFocus()

	if IsValid( fpnl ) and fpnl:GetClassName():find( "TextEntry", nil, true ) then return false end

	return true
end

function rPhone.GetBaseCanvas()
	return rp_basecanv
end

function rPhone.SetPosition( x, y )
	if rp_basecanv then
		rp_basecanv:SetPos( x, y )
	end
end

function rPhone.GetPosition()
	if rp_basecanv then
		return rp_basecanv:GetPos()
	end
end

function rPhone.GetSize()
	return PhoneWidth, PhoneHeight
end

function rPhone.IsAppRunning( app )
	if !rp_init then return false end

	return rp_running[app] != nil
end

function rPhone.KillApp( app )
	if !rp_init or !rPhone.IsAppRunning( app ) then return end

	app:TriggerEvent( "Finalize" )

	rp_running[app] = nil
end

function rPhone.GetRunningApps()
	local ret = {}

	if rp_init then
		for app in pairs( rp_running ) do
			table.insert( ret, app )
		end
	end

	return ret
end

function rPhone.LaunchAppInstance( app, canv, params )
	if !rp_init then return false end
	if !app or !canv or app:IsStarted() then return false end
	
	params = (params == nil) and {} or params

	rp_running[app] = true
	
	local started = app:Start( canv, params )

	rp_running[app] = started

	return started
end

function rPhone.LaunchApp( pname, canv, params )
	local app = rPhone.CreateAppInstance( pname )
	
	if app and rPhone.LaunchAppInstance( app, canv, params ) then
		return app
	end
end
