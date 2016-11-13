
util.AddNetworkString( "rphone_phone_dial" )
util.AddNetworkString( "rphone_phone_dc" )
util.AddNetworkString( "rphone_phone_response" )
util.AddNetworkString( "rphone_phone_request" )
util.AddNetworkString( "rphone_phone_end" )
util.AddNetworkString( "rphone_phone_whisper" )
util.AddNetworkString( "rphone_phone_mute" )
util.AddNetworkString( "rphone_phone_answer" )

local PhoneLib = rPhone.GetLibrary( "phone" )

local ring_timeout = rPhone.GetVariable( "PHONE_RING_TIMEOUT", 10 )
local force_whisper = rPhone.GetVariable( "PHONE_WHISPER_FORCE", false )
local conversations = {}

local function sendCallEnd( ply, msg )
	if !IsValid( ply ) then return end

	net.Start( "rphone_phone_end" )
		net.WriteString( msg )
	net.Send( ply )
end

local function sendCallRequest( ply, num )
	if !IsValid( ply ) then return end

	net.Start( "rphone_phone_request" )
		net.WriteString( num )
	net.Send( ply )
end

local function getConv( ply )
	if !IsValid( ply ) then return end

	for id, cnv in pairs( conversations ) do
		if cnv.caller == ply or cnv.callee == ply then
			return id, cnv
		end
	end
end

local function triggerCallEnd( convid )
	local conv = conversations[convid]

	if !conv then return end

	local users = {}

	if IsValid( conv.caller ) then table.insert( users, conv.caller ) end
	if IsValid( conv.callee ) then table.insert( users, conv.callee ) end

	rPhone.TriggerEvent( "PHONE_CALL_ENDED", convid, users ) 
end

net.Receive( "rphone_phone_whisper", function( len, ply )
	if force_whisper then return end

	local convid, conv = getConv( ply )

	if !conv then return end

	local whisp = net.ReadBit() == 1

	if ply == conv.caller then
		conv.callerwhisp = whisp
	else
		conv.calleewhisp = whisp
	end
end )

net.Receive( "rphone_phone_mute", function( len, ply )
	local convid, conv = getConv( ply )

	if !conv then return end

	local mute = net.ReadBit() == 1

	if ply == conv.caller then
		conv.callermute = mute
	else
		conv.calleemute = mute
	end
end )

net.Receive( "rphone_phone_dial", function( len, caller )
	if getConv( caller ) then
		sendCallEnd( caller, "Tried to initiate concurrent call." )
		return
	end

	local callernum = rPhone.GetNumber( caller )
	local calleenum = rPhone.ToRawNumber( net.ReadString() )

	if !rPhone.IsValidNumber( calleenum ) then return end

	local ans, ply_msg = rPhone.TriggerEventForResult( "PHONE_DIALED", calleenum, caller, callernum )
	local callee

	if ans then
		if !IsValid( ply_msg ) then
			sendCallEnd( caller, "Call failed." )
			return
		end

		callee = ply_msg
	elseif ans == false then
		sendCallEnd( caller, ply_msg )
		return
	else
		local calleesteam = rPhone.GetSteamIDFromNumber( calleenum )

		if !calleesteam then
			sendCallEnd( caller, "Number is unregistered." )
			return
		end

		for _, ply in pairs( player.GetAll() ) do
			if ply:SteamID() == calleesteam then
				callee = ply
				break
			end
		end		
	end

	if !IsValid( callee ) then
		sendCallEnd( caller, "User is offline." )
		return
	end

	if getConv( callee ) then
		sendCallEnd( caller, "User is busy." )
		return
	end

	if caller == callee then
		sendCallEnd( caller, "You cannot call yourself." )
		return
	end

	table.insert( conversations, {
		caller = caller,
		callermute = false,
		callerwhisp = false,

		callee = callee,
		calleemute = false,
		calleewhisp = false,

		accepted = false,
		start = CurTime()
	} )

	sendCallRequest( callee, callernum )
end )

net.Receive( "rphone_phone_response", function( len, ply )
	local accepted = net.ReadBit() == 1

	local convid, conv = getConv( ply )

	if !conv then
		sendCallEnd( ply, "You are not currently in a call." )
		return
	end

	if conv.callee != ply or conv.accepted then return end

	if accepted then
		conv.accepted = true

		net.Start( "rphone_phone_answer" )
			net.WriteEntity( conv.callee )
		net.Send( conv.caller )

		net.Start( "rphone_phone_answer" )
			net.WriteEntity( conv.caller )
		net.Send( conv.callee )
	else
		triggerCallEnd( convid )

		sendCallEnd( conv.caller, "User is busy." )

		conversations[convid] = nil
	end
end )

net.Receive( "rphone_phone_dc", function( len, ply )
	local convid, conv = getConv( ply )

	if !conv then return end

	triggerCallEnd( convid )

	local other = (conv.caller == ply) and conv.callee or conv.caller

	sendCallEnd( other, "User disconnected." )

	conversations[convid] = nil
end )

hook.Add( "PlayerCanHearPlayersVoice", "sv_phone_canhearvoice", function( listener, talker )
	local lisid, lisconv = getConv( listener )
	local tlkid, tlkconv = getConv( talker )

	if lisid == tlkid and lisconv and lisconv.accepted then
		local talkmute = (lisconv.caller == talker) and lisconv.callermute or lisconv.calleemute

		if !talkmute then return true end
	end

	if tlkid and lisid != tlkid and 
		(force_whisper or 
			((tlkconv.caller == talker) and tlkconv.callerwhisp or tlkconv.calleewhisp)) then
		return false
	end
end )

hook.Add( "Think", "sv_phone_think", function()
	for convid, conv in pairs( conversations ) do
		if !IsValid( conv.caller ) or !IsValid( conv.callee ) then
			triggerCallEnd( convid )

			sendCallEnd( conv.caller, "User disconnected." )
			sendCallEnd( conv.callee, "User disconnected." )

			conversations[convid] = nil
		elseif !conv.accepted and (CurTime() - conv.start) >= ring_timeout then
			triggerCallEnd( convid )

			sendCallEnd( conv.caller, "User is busy." )
			sendCallEnd( conv.callee, "User is busy." )

			conversations[convid] = nil
		end
	end
end )

hook.Add( "PlayerDeath", "sv_phone_playerdeath", function( ply )
	local convid, conv = getConv( ply )

	if !conv then return end

	triggerCallEnd( convid )

	sendCallEnd( conv.caller, "Call ended." )
	sendCallEnd( conv.callee, "Call ended." )

	conversations[convid] = nil
end )



function PhoneLib.IsInCall( ply )
	return getConv( ply ) != nil
end

function PhoneLib.GetConversationInfo( ply )
	local conv = getConv( ply )

	return {
		pending = !conv.accepted,
		start_time = conv.start,
		peers = { conv.caller == ply and conv.callee or conv.caller }
	}
end
