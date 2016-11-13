
local NewMessageIcon = "dan/rphone/icons/new_message.png"


local APP = rPhone.AssertPackage( "sms" )

local pk_os
local sms_pdbi

local app_instances = rPhone.NewWeakTable( 'k' )
local preinit_msgqueue = {}

local newmsg_mat = Material( NewMessageIcon, "smooth" )
local newmsg_padding = 2
local newmsg_notification

local MNBT = {}
function MNBT:Draw( w, h )
	surface.SetDrawColor( 255, 255, 255, 255 )
	surface.SetMaterial( newmsg_mat )
	surface.DrawTexturedRect( 
		newmsg_padding, newmsg_padding, 
		w - (newmsg_padding * 2), 
		h - (newmsg_padding * 2)
	)
end
function MNBT:DoClick()
	local unread = APP.GetUnreadConversations()
	local unreadcnt = table.Count( unread )

	for num in pairs( unread ) do
		print(num)
	end

	if unreadcnt > 0 then
		local params

		if unreadcnt == 1 then
			params = { Number = next( unread ) }
		end

		pk_os.LaunchApp( APP.PackageName, params )
	end

	self:Remove()
end

local function addNotification()
	if !pk_os then return end

	if !IsValid( newmsg_notification ) then
		newmsg_notification = pk_os.AddTrayNotification( MNBT, 3 )
	end

	local tone = APP.GetTone()

	if !tone or tone == "Silent" then return end
	if tone == "Vibrate" or pk_os.IsSilent() then 
		pk_os.Vibrate()

		return
	end

	local tones = rPhone.GetVariable( "SMS_TONES", {} )
	local path = tones[tone]
	
	if !path or !rPhone.IsValidTone( path ) then return end

	pk_os.PlayTone( path )
end

local function removeNotification()
	if IsValid( newmsg_notification ) then
		newmsg_notification:Remove()
	end
end

local function messageReceived( num, msg, servermsg, time )
	if !pk_os then return end

	local fgapp = pk_os.GetForegroundApp()
	local addnote = true

	for app in pairs( app_instances ) do
		if !app:IsRunning() then continue end

		local shouldaddnote = app:OnMessageReceived( num, msg, servermsg, time )

		if !shouldaddnote and app == fgapp then addnote = false end
	end

	if pk_os.IsLocked() or addnote then
		addNotification()
	end
end

net.Receive( "rphone_sms_receive", function( len )
	local num = net.ReadString()

	if pk_os and pk_os.IsNumberBlocked( num ) then return end

	local msgcnt = net.ReadUInt( 16 )
	local convs = sms_pdbi and sms_pdbi.conversations or preinit_msgqueue

	convs[num] = convs[num] or { messages = {} }
	local conv = convs[num]

	conv.unread = true

	for i=1, msgcnt do
		local msg = net.ReadString()
		local servermsg = net.ReadBit() == 1
		local time = net.ReadUInt( 32 )

		table.insert( conv.messages, { msg, servermsg and 2 or 1, time } )

		messageReceived( num, msg, servermsg, time )
	end

	if sms_pdbi then
		sms_pdbi:Commit()
	end
end )

rPhone.RegisterEventCallback( "OS_Initialize", function( _pk_os )
	pk_os = _pk_os

	sms_pdbi = pk_os.Util.CreatePDBI( APP.PackageName )
	sms_pdbi.conversations = sms_pdbi.conversations or {}

	local convs = sms_pdbi.conversations
	local msgrecv = false

	for num, cinfo in pairs( preinit_msgqueue ) do
		if pk_os.IsNumberBlocked( num ) then continue end

		convs[num] = convs[num] or { messages = {} }
		local conv = convs[num]

		table.Add( conv.messages, cinfo.messages )

		conv.unread = true
		msgrecv = true
	end

	if msgrecv then
		addNotification()

		sms_pdbi:Commit()
		preinit_msgqueue = nil
	end
end )



function APP.RegisterAppInstance( inst )
	app_instances[inst] = true
end

function APP.SendMessage( num, msg )
	if !sms_pdbi then return end

	num = rPhone.ToRawNumber( num )

	local time = os.time()
	local msgs = APP.GetMessages( num )

	table.insert( msgs, { msg, 0, time } )
	
	net.Start( "rphone_sms_send" )
		net.WriteString( num )
		net.WriteString( msg )
	net.SendToServer()

	sms_pdbi:Commit()
end

function APP.GetConversations()
	if !sms_pdbi then return {} end

	return sms_pdbi.conversations
end

function APP.GetConversation( num )
	if !sms_pdbi then return {} end

	num = rPhone.ToRawNumber( num )

	local convs = sms_pdbi.conversations

	if !convs[num] then
		convs[num] = { messages = {} }
		sms_pdbi:Commit()
	end

	return convs[num]
end

function APP.DiscardConversation( num )
	if !sms_pdbi then return end

	num = rPhone.ToRawNumber( num )

	sms_pdbi.conversations[num] = nil
	sms_pdbi:Commit()
end

function APP.SetHasUnread( num, unread )
	if !sms_pdbi then return end

	num = rPhone.ToRawNumber( num )

	local conv = APP.GetConversation( num )

	conv.unread = unread

	sms_pdbi:Commit()
end

function APP.GetHasUnread( num )
	return APP.GetConversation( num ).unread == true
end

function APP.GetMessages( num )
	return APP.GetConversation( num ).messages or {}
end

function APP.GetLastMessage( num )
	local msgs = APP.GetMessages( num )

	return msgs and msgs[#msgs]
end

function APP.ClearMessages( num )
	if !sms_pdbi then return end

	local conv = APP.GetConversation( num )

	conv.messages = {}
	conv.unread = false

	sms_pdbi:Commit()
end

function APP.GetUnreadConversations()
	local ret = {}

	for num, conv in pairs( APP.GetConversations() ) do
		if APP.GetHasUnread( num ) then
			ret[num] = conv
		end
	end

	return ret
end

function APP.RemoveNotification()
	removeNotification()
end

function APP.RemoveNotificationIfRead()
	if table.Count( APP.GetUnreadConversations() ) == 0 then
		removeNotification()
	end
end
