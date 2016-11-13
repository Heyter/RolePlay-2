
local SilentIcon = "dan/rphone/icons/muted.png"
local VibrateSound = "dan/rphone/bundles/os/vibrate.wav"
local VibrateTime = 1


local OS = rPhone.AssertPackage( "os" )

local os_pdbi

local silent = false
local silent_notification
local vibrate_end, vibrate_laststart

local silent_mat = Material( SilentIcon, "smooth" )
local silent_padding = 2

local SNBT = {}
function SNBT:Draw( w, h )
	surface.SetDrawColor( 255, 255, 255, 255 )
	surface.SetMaterial( silent_mat )
	surface.DrawTexturedRect( 
		silent_padding, silent_padding, 
		w - (silent_padding * 2), 
		h - (silent_padding * 2)
	)
end
function SNBT:DoClick()	
	OS.SetSilent( false )

	self:Remove()
end

rPhone.RegisterEventCallback( "OS_Initialize", function()
	os_pdbi = OS.Util.CreatePDBI( OS.PackageName )
	os_pdbi.silent = os_pdbi.silent or false

	OS.SetSilent( os_pdbi.silent )
end )



function OS.IsSilent()
	return silent
end

function OS.SetSilent( sil )
	if silent != sil then
		silent = sil

		os_pdbi.silent = silent
		os_pdbi:Commit()
	end

	if silent and !IsValid( silent_notification ) then
		silent_notification = OS.AddTrayNotification( SNBT, 4, "right" )
	elseif !silent and IsValid( silent_notification ) then
		silent_notification:Remove()
	end
end

function OS.PlayToneLoop( tone, reps )
	if !silent then
		return rPhone.PlayToneLoop( tone, reps )
	end
end

function OS.PlayTone( tone )
	if !silent then
		return OS.PlayToneLoop( tone, 1 )
	end
end

function OS.PlayToneDuration( tone, duration )
	if !silent then
		return rPhone.PlayToneDuration( tone, duration ) 
	end
end

function OS.StopTone( toneid )
	rPhone.StopTone( toneid )
end

function OS.Vibrate( duration )
	surface.PlaySound( VibrateSound )

	vibrate_end = SysTime() + (duration or VibrateTime)
	vibrate_laststart = SysTime()
end

function OS.StopVibrating()
	vibrate_end = nil
end

function OS.IsVibrating()
	return vibrate_end and (SysTime() < vibrate_end)
end

timer.Create( "cl_os_tones_vibrate", 0.1, 0, function()
	if OS.IsVibrating() and (SysTime() - vibrate_laststart) >= VibrateTime + 0.5  then
		vibrate_laststart = SysTime()

		surface.PlaySound( VibrateSound )
	end
end )
