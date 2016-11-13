
local RingingIcon = "dan/rphone/icons/phone_ring.png"
local ArrowIcon = "dan/rphone/icons/arrow_left.png"


local APP = rPhone.AssertPackage( "phone" )

local pk_os
local phone_pdbi

local app_instance
local in_call, call_pending, call_answered, call_answer_time
local caller, caller_number
local push_to_talk, voice_bind

local ring_notification, ringtone_id
local ring_mat = Material( RingingIcon, "smooth" )
local arrow_mat = Material( ArrowIcon, "smooth" )
local ring_icon_padding = 2

local keyFromName

local RNBT = {}
function RNBT:Draw( w, h )
	if APP.IsCallPending() then
		surface.SetDrawColor( 255, 255, 255, 255 )
		surface.SetMaterial( ring_mat )
		surface.DrawTexturedRect( 
			ring_icon_padding, ring_icon_padding, 
			w - (ring_icon_padding * 2), 
			h - (ring_icon_padding * 2)
		)
	else
		surface.SetDrawColor( 0, 180, 255, 255 )
		surface.SetMaterial( arrow_mat )
		surface.DrawTexturedRectRotated( 
			w / 2, h / 2, 
			w - (ring_icon_padding * 2), 
			h - (ring_icon_padding * 2),
			45
		)
	end
end
function RNBT:DoClick()
	if !pk_os then return end
	
	local params

	if !APP.IsCallPending() then
		params = { DisplayRecents = true }
	end

	pk_os.LaunchApp( APP.PackageName, params )

	self:Remove()
end

local CNBT = {}
function CNBT:Draw( w, h )
	if APP.IsInCall() then
		surface.SetDrawColor( 255, 255, 255, 255 )
		surface.SetMaterial( ring_mat )
		surface.DrawTexturedRect( 
			ring_icon_padding, ring_icon_padding, 
			w - (ring_icon_padding * 2), 
			h - (ring_icon_padding * 2)
		)
	else
		self:Remove()
	end
end
function CNBT:DoClick()
	if !pk_os then return end
	
	pk_os.LaunchApp( APP.PackageName )
end

do
	local keys = {}

	for k, v in pairs( _G ) do
		if type( k ) == "string" and (k:StartWith( "KEY_" ) or k:StartWith( "MOUSE_" )) then
			local kname = input.GetKeyName( v )

			if kname then
				keys[kname] = v
			end
		end
	end

	function keyFromName( name )
		return keys[name]
	end
end

local function addNotification()
	if pk_os and !IsValid( ring_notification ) then
		ring_notification = pk_os.AddTrayNotification( RNBT, 4 )
	end
end

local function removeNotification()
	if IsValid( ring_notification ) then
		ring_notification:Remove()
	end
end

local function stopRingTone()
	if !pk_os then return end

	if ringtone_id then
		rPhone.StopTone( ringtone_id )
		ringtone_id = nil
	elseif pk_os.IsVibrating() then
		pk_os.StopVibrating()
	end
end

local function playRingTone()
	if !pk_os then return end

	stopRingTone()

	local tone = APP.GetRingTone()

	if !tone or tone == "Silent" then return end
	if tone == "Vibrate" then 
		pk_os.Vibrate( APP.GetRingTimeout() )
		
		return
	end

	local tones = rPhone.GetVariable( "PHONE_RINGTONES", {} )
	local path = tones[tone]
	
	if !path or !rPhone.IsValidTone( path ) then return end

	ringtone_id = pk_os.PlayToneDuration( path, APP.GetRingTimeout() )
end

local function startCall()
	local whisper = APP.GetWhisperAlways() or APP.GetWhisperDefault()
	local ptt = APP.GetPushToTalkDefault()

	in_call = true
	call_pending = false
	call_answered = false

	APP.SetWhisper( whisper )
	APP.SetPushToTalk( ptt )

	stopRingTone()

	pk_os.AddTrayNotification( CNBT, 2 )
end

local function endCall()
	in_call = false
	call_pending = false
	caller_number = nil

	if !push_to_talk then
		RunConsoleCommand( "-voicerecord" )
	end

	stopRingTone()
end

rPhone.RegisterEventCallback( "OS_Initialize", function( _pk_os )
	pk_os = _pk_os
	
	phone_pdbi = pk_os.Util.CreatePDBI( APP.PackageName )
	phone_pdbi.recents = phone_pdbi.recents or {}
end )

rPhone.RegisterEventCallback( "OS_Unlock", function( pk_os )
	if !APP.IsCallPending() then return end

	local fgapp = pk_os.GetForegroundApp()

	if fgapp != APP.GetAppInstance() then
		pk_os.LaunchApp( "phone" )
	end
end )

net.Receive( "rphone_phone_request", function( len )
	local num = net.ReadString()

	if !pk_os or pk_os.IsNumberBlocked( num ) then
		APP.DeclineCall()
		return
	end

	local app = APP.GetAppInstance()
	local fgapp = pk_os.GetForegroundApp()
	local islocked = pk_os.IsLocked()

	in_call = false
	call_pending = true
	call_answered = false
	caller_number = num

	if app then
		app:OnCallPending( num )
	end

	if !app or fgapp != app or islocked then
		addNotification()
	end

	APP.AddRecent( num, os.time(), true )

	playRingTone()
end )

net.Receive( "rphone_phone_answer", function( len )
	caller = net.ReadEntity()

	call_answered = true
	call_answer_time = SysTime()
end )

net.Receive( "rphone_phone_end", function( len )
	local msg = net.ReadString()
	local app = APP.GetAppInstance()

	if app then
		app:OnCallEnded( msg )
		removeNotification()
	elseif !APP.IsCallPending() then
		removeNotification()
	end

	endCall()
end )

hook.Add( "PlayerEndVoice", "cl_phone_voice_sustain", function( ply )
	if APP.IsInCall() and !push_to_talk then
		RunConsoleCommand( "+voicerecord" )
	end
end )

hook.Add( "Think", "cl_phone_ptt_emulate", function()
	if !pk_os or !pk_os.HasKeyboardFocus() then return end 
	if !APP.IsInCall() or !push_to_talk or !voice_bind then return end

	if input.IsButtonDown( voice_bind ) then
		RunConsoleCommand( "+voicerecord" )
	else
		RunConsoleCommand( "-voicerecord" )
	end
end )



function APP.AddRecent( num, time, incoming, nocommit )
	if !phone_pdbi then return end

	num = rPhone.ToRawNumber( num )

	if !rPhone.IsValidNumber( num ) then return end

	local tbl = {
		num, 
		time, 
		incoming
	}

	table.insert( phone_pdbi.recents, tbl )

	if !nocommit then
		phone_pdbi:Commit()
	end
end

function APP.GetRecents()
	if !phone_pdbi then return {} end

	local recents = phone_pdbi.recents
	local ret = {}

	for i=#recents, 1, -1 do
		local tbl = recents[i]

		table.insert( ret, {
			Number = tbl[1],
			Time = tbl[2],
			Incoming = tbl[3]
		} )
	end

	return ret
end

function APP.ClearRecents( nocommit )
	if !phone_pdbi then return end

	phone_pdbi.recents = {}

	if !nocommit then
		phone_pdbi:Commit()
	end
end

function APP.SetAppInstance( app )
	if rPhone.IsAppRunning( app_instance ) then
		app_instance:Kill()
	end

	app_instance = app
end

function APP.GetAppInstance()
	if rPhone.IsAppRunning( app_instance ) then
		return app_instance
	end
end

function APP.IsInCall()
	return in_call
end

function APP.IsCallPending()
	return !in_call and call_pending
end

function APP.IsCallAnswered()
	return in_call and call_answered
end

function APP.GetCaller()
	if in_call and call_answered then
		return caller
	end
end

function APP.GetCallerNumber()
	if in_call or call_pending then
		return caller_number
	end
end

function APP.GetElapsedTime()
	if in_call and call_answered then
		return SysTime() - call_answer_time
	end

	return 0
end

function APP.DialNumber( num )
	if in_call or call_pending then return end

	num = rPhone.ToRawNumber( num )

	if !rPhone.IsValidNumber( num ) then return end

	net.Start( "rphone_phone_dial" )
		net.WriteString( num )
	net.SendToServer()

	caller_number = num

	APP.AddRecent( num, os.time(), false )

	startCall()
end

function APP.Disconnect()
	if !in_call then return end

	net.Start( "rphone_phone_dc" )
	net.SendToServer()

	endCall()
end

function APP.AcceptCall()
	if !APP.IsCallPending() then return end

	net.Start( "rphone_phone_response" )
		net.WriteBit( true )
	net.SendToServer()

	startCall()
end

function APP.DeclineCall()
	if !APP.IsCallPending() then return end

	net.Start( "rphone_phone_response" )
		net.WriteBit( false )
	net.SendToServer()

	endCall()
end

function APP.SetMuted( muted )
	if !APP.IsInCall() then return end

	net.Start( "rphone_phone_mute" )
		net.WriteBit( muted )
	net.SendToServer()
end

function APP.SetWhisper( whisper )
	if !APP.IsInCall() then return end

	net.Start( "rphone_phone_whisper" )
		net.WriteBit( whisper )
	net.SendToServer()
end

function APP.SetPushToTalk( ptt )
	if !APP.IsInCall() then return end

	push_to_talk = ptt

	if ptt then
		RunConsoleCommand( "-voicerecord" )

		local bindname = input.LookupBinding( "voicerecord" )

		voice_bind = keyFromName( bindname )

	else
		RunConsoleCommand( "+voicerecord" )
	end
end

function APP.RemoveNotification()
	removeNotification()
end
