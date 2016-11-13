
util.AddNetworkString( "rphone_sms_send" )
util.AddNetworkString( "rphone_sms_receive" )

local mailbox_size = rPhone.GetVariable( "SMS_MAILBOX_SIZE", 100 )
local sms_max_message_length = rPhone.GetVariable( "SMS_MAX_MESSAGE_LENGTH", 256 )

local sms_delays = {}
local sms_warning_delays = {}

local sqlstr = sql.SQLStr

local function smsSendBatch( to, fromnum, msgs )
	if !IsValid( to ) then return end

	net.Start( "rphone_sms_receive" )
		net.WriteString( fromnum )
		net.WriteUInt( #msgs, 16 )

		for _, msginfo in ipairs( msgs ) do
			net.WriteString( msginfo.msg )
			net.WriteBit( msginfo.servermsg == true )
			net.WriteUInt( msginfo.time, 32 )
		end
	net.Send( to )
end

local function smsSend( to, fromnum, msg, servermsg, time )
	smsSendBatch( to, fromnum, { { 
		msg = msg, 
		servermsg = servermsg, 
		time = time 
	} } )
end

local function toJSONSafeNumber( num )
	return '#' .. num
end

local function fromJSONSafeNumber( num )
	return num:sub( 2 )
end

local function queueMessage( tonum, fromnum, msg, time )
	local result = sql.QueryRow( 
		([[SELECT * FROM rphone_sms WHERE number=%s]]):format(
			sqlstr( tonum )
		)
	)
	local msgtbl = { msg, tostring( time ) }
	local safenum = toJSONSafeNumber( fromnum )
	local qstr

	if !result then
		local json = util.TableToJSON( { [safenum] = { msgtbl } } )

		qstr = ([[INSERT INTO rphone_sms VALUES (%s, %s)]]):format(
			sqlstr( tonum ),
			sqlstr( json )
		)
	else
		local queue = util.JSONToTable( result.queue ) or {}
		local fromqueue = queue[safenum]
		local msgcnt = 0

		for _, msgs in pairs( queue ) do
			msgcnt = msgcnt + #msgs
		end

		if msgcnt >= mailbox_size then
			return false
		end

		if fromqueue then
			table.insert( fromqueue, msgtbl )
		else
			queue = { [safenum] = { msgtbl } }
		end

		local queuestr = util.TableToJSON( queue )

		qstr = ([[UPDATE rphone_sms SET queue=%s WHERE number=%s]]):format(
			sqlstr( queuestr ),
			sqlstr( tonum )
		)
	end

	sql.Query( qstr )

	return true
end

local function getQueue( num, empty )
	local result = sql.QueryRow( 
		([[SELECT * FROM rphone_sms WHERE number=%s]]):format(
			sqlstr( num )
		)
	)

	if !result then return {} end

	local queuestr = result.queue
	local queue = util.JSONToTable( result.queue ) or {}
	local ret = {}

	for safenum, mq in pairs( queue ) do
		local num = fromJSONSafeNumber( safenum )

		ret[num] = {}

		for _, msginfo in ipairs( mq ) do
			local msg, time = msginfo[1], msginfo[2]

			if !msg or !time then continue end

			table.insert( ret[num], { msg = msg, time = time } )
		end
	end

	if empty then
		sql.Query(
			([[UPDATE rphone_sms SET queue='{}' WHERE number=%s]]):format(
				sqlstr( num )
			)
		)
	end

	return ret
end

net.Receive( "rphone_sms_send", function( len, sender )
	local sendernum = rPhone.GetNumber( sender )
	local receivernum = net.ReadString()
	local msg = net.ReadString()

	sms_delays[sender] = sms_delays[sender] or 0

	if CurTime() - sms_delays[sender] < 0.1 then
		sms_warning_delays[sender] = sms_warning_delays[sender] or 0
		
		if CurTime() - sms_warning_delays[sender] >= 1 then
			smsSend( sender, receivernum, "Please slow down.", true, os.time() )

			sms_warning_delays[sender] = CurTime()
		end

		return
	end

	sms_delays[sender] = CurTime()

	if #msg > sms_max_message_length then return end

	local receiversteam = rPhone.GetSteamIDFromNumber( receivernum )
	local receiver

	if !receiversteam then
		smsSend( sender, receivernum, "Number is unregistered.", true, os.time() )
		return
	end

	for _, ply in pairs( player.GetAll() ) do
		if ply:SteamID() == receiversteam then
			receiver = ply
			break
		end
	end

	if !IsValid( receiver ) then
		if !queueMessage( receivernum, sendernum, msg, os.time() ) then
			smsSend( sender, receivernum, "Mailbox full.", true, os.time() )
		end
	else
		smsSend( receiver, sendernum, msg, false, os.time() )
	end
end )

hook.Add( "Initialize", "sv_sms_checkdb", function()
	if !sql.TableExists( "rphone_sms" ) then
		sql.Query( [[
			CREATE TABLE rphone_sms (
				number TEXT PRIMARY KEY NOT NULL,
				queue TEXT
			)
		]] )
	end
end )

hook.Add( "PlayerInitialSpawn", "sv_sms_sendsmsqueue", function( ply )
	local num = rPhone.GetNumber( ply )
	local queue = getQueue( num, true )

	for fromnum, mq in pairs( queue ) do
		smsSendBatch( ply, fromnum, mq )
	end
end )
