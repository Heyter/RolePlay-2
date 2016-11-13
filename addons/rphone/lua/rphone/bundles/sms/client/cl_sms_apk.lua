
local ReadIcon = "dan/rphone/icons/read.png"
local UnreadIcon = "dan/rphone/icons/unread.png"


surface.CreateFont( "rphone_sms_date", {
	font = "DermaDefault",
	size = 12
} )


local APP = rPhone.CreateAppPackage( "sms" )

APP.Launchable = true
APP.DisplayName = "SMS"
APP.Icon = "dan/rphone/icons/letter.png"


local sms_max_message_length = rPhone.GetVariable( "SMS_MAX_MESSAGE_LENGTH", 256 )
local app_state = {}

local function findURL( msg )
	local st, ed = msg:find( [=[http://[^%s]+]=] )

	if !st then
		st, ed = msg:find( [=[[^%s]*www%.[^%s]+]=] )
	end

	if st then
		local url = msg:sub( st, ed )

		return st, ed, url
	end
end




function APP:Initialize( params )
	self.pk_os = rPhone.AssertPackage( "os" )

	local canv = self:GetCanvas()
	self.pgman = self.pk_os.Util.CreatePageManager( canv )
	
	self.hp_message_queue = {}
	self.lp_message_queue = {}

	if params.Number then
		local num = rPhone.ToRawNumber( params.Number )

		if !rPhone.IsValidNumber( num ) then
			self:Kill()
			return
		end

		self:DisplayConversation( num )
	else
		local cnvnum = app_state.last_conv

		self:DisplayConversationOverview( true )

		if cnvnum then
			self:DisplayConversation( cnvnum )
		end
	end

	APP.RegisterAppInstance( self )

	self.pk_os.AddAppAction( self, "Settings", function()
		self.pk_os.LaunchApp( "settings", { PageName = APP.DisplayName } )
	end )
end

function APP:AddMessage( msgfmt, msg, align, lowpriority )
	local st, ed, url = findURL( msg )
	local clickFunc

	if url then
		msg = ([[%s<color=70,70,255,255>%s</color>%s]]):format(
			msg:sub( 1, st - 1 ),
			url,
			msg:sub( ed + 1, #msg )
		)

		clickFunc = function()
			if !url:StartWith( "http://" ) then
				url = "http://" .. url
			end

			gui.OpenURL( url )
		end
	end

	local str = msgfmt:format( msg )

	table.insert( 
		lowpriority and self.lp_message_queue or self.hp_message_queue, 
		{ str, align, clickFunc }
	)
end

function APP:AddIncomingMessage( name, msg, time, lowpriority )
	local timestamp = self.pk_os.Util.FormatDateTime( time )
	local msgfmt = ([[<color=255,255,255,255>%s</color>: <color=180,180,180,255>%%s</color>
<color=140,140,140,255><font=rphone_sms_date>%s</font></color>]]):format(
		name, timestamp
	)

	self:AddMessage( msgfmt, msg, "left", lowpriority )
end

function APP:AddOutgoingMessage( msg, time, lowpriority )
	local timestamp = self.pk_os.Util.FormatDateTime( time )
	local msgfmt = ([[<color=180,180,180,255>%%s</color>
<color=140,140,140,255><font=rphone_sms_date>%s</font></color>]]):format(
		timestamp
	)

	self:AddMessage( msgfmt, msg, "right", lowpriority )
end

function APP:AddServerMessage( msg, time, lowpriority )
	local timestamp = self.pk_os.Util.FormatDateTime( time )
	local msgfmt = ([[<color=255,0,0,255>Server:</color> <color=180,180,180,255>%%s</color>
<color=140,140,140,255><font=rphone_sms_date>%s</font></color>]]):format(
		timestamp
	)

	self:AddMessage( msgfmt, msg, "center", lowpriority )
end

function APP:DisplayConversation( num )
	num = rPhone.ToRawNumber( num )
	app_state.last_conv = num

	local messages = APP.GetMessages( num )
	local name = APP.GetDisplayAlias( num )

	local page = self.pgman:NewPage()

	self.msgpnl = rPhone.CreatePanel( "RPDAlignedMessageList", page )
		self.msgpnl:SetPos( 5, 0 )
		self.msgpnl:SetMessageSpacer( page:GetWide() / 4 )

	local txtinput = rPhone.CreatePanel( "DTextEntry", page )
		txtinput:SetWide( page:GetWide() - 10 )
		txtinput:SetPos( 5, page:GetTall() - txtinput:GetTall() )
		function txtinput:OnTextChanged()
			local txt = self:GetText()

			if #txt > sms_max_message_length then
				txt = txt:Left( sms_max_message_length )

				self:SetText( txt )
				self:SetCaretPos( #txt )
			end
		end
		txtinput.OnEnter = function()
			local msg = txtinput:GetText()
			local time = os.time()

			txtinput:SetText( "" )
			txtinput:RequestFocus()

			if #msg < 1 or #msg > sms_max_message_length or
				msg:match( [[^[%s]+$]] ) then return end

			self:AddOutgoingMessage( msg, time )

			APP.SendMessage( num, msg )
		end
		txtinput:RequestFocus()

	self.msgpnl:SetSize( page:GetWide() - 10, page:GetTall() - txtinput:GetTall() )

	self.hp_message_queue = {}
	self.lp_message_queue = {}

	for _, msginfo in ipairs( messages ) do
		local msg, sender, time = unpack( msginfo )

		if sender == 0 then
			self:AddOutgoingMessage( msg, time, true )
		elseif sender == 1 then
			self:AddIncomingMessage( name, msg, time, true )
		else
			self:AddServerMessage( msg, time, true )
		end
	end

	APP.SetHasUnread( num, false )
	APP.RemoveNotificationIfRead()
end

function APP:DisplayStartConversationDialog()
	local updateValidity

	local pnl = self.pgman:SimplePopup( true )
		pnl:SetSize( 225, 53 )

	local lblto = rPhone.CreatePanel( "DLabel", pnl )
		lblto:SetText( "Number:" )
		lblto:SizeToContents()
		lblto:SetPos( 5, 7 )

	local txtto = rPhone.CreatePanel( "DTextEntry", pnl )
		txtto:SetPos( 10 + lblto:GetWide(), 5 )
		txtto:SetWide( pnl:GetWide() - lblto:GetWide() - 15 )
		function txtto:OnTextChanged()
			updateValidity()
		end
		txtto:RequestFocus()

	local btnconf = rPhone.CreatePanel( "RPDTextButton", pnl )
		btnconf:SetText( "Confirm" )
		btnconf:SetSize( (pnl:GetWide() / 2) - 7, 20 )
		btnconf:SetPos( (pnl:GetWide() / 2) + 2, pnl:GetTall() - 25 )
		btnconf.DoClick = function()
			local to = rPhone.ToRawNumber( txtto:GetText() )

			self.pgman:GoBack()

			if !rPhone.IsValidNumber( to ) then return end

			self:DisplayConversation( to )
		end

	local btncanc = rPhone.CreatePanel( "RPDTextButton", pnl )
		btncanc:SetText( "Cancel" )
		btncanc:SetSize( (pnl:GetWide() / 2) - 7, 20 )
		btncanc:SetPos( 5, pnl:GetTall() - 25 )
		btncanc.DoClick = function()
			self.pgman:GoBack()
		end

	function updateValidity()
		local num = rPhone.ToRawNumber( txtto:GetText() )

		if !rPhone.IsValidNumber( num ) then
			btnconf:SetDisabled( true )
			btnconf:SetTextColor( Color( 180, 180, 180, 255 ) )
		else
			btnconf:SetDisabled( false )
			btnconf:SetTextColor( Color( 255, 255, 255, 255 ) )
		end
	end

	updateValidity()
end

function APP:AddConversationButton( num )
	if !IsValid( self.convlist ) then return end

	local alias = APP.GetDisplayAlias( num )
	local unread = APP.GetHasUnread( num )
	local lmsgtbl = APP.GetLastMessage( num )
	local msgcnt = #APP.GetMessages( num )

	local pnl = rPhone.CreatePanel( "RPDContentButton" )
		pnl:SetTall( 30 )
		pnl.DoClick = function()
			self:DisplayConversation( num )
		end
		pnl.DoRightClick = function()
			local nicenum = rPhone.ToNiceNumber( num )
			local name = APP.GetContactName( num )

			local menu = rPhone.CreatePanel( "RPDMenu", self.convlist )
				if !name then
					menu:AddOption( "Add to Contacts", function()
						self.pk_os.LaunchApp( "contacts", { AddNumber = num } )
					end )
				end
				menu:AddOption( "Copy Number", function()
					SetClipboardText( nicenum )
				end )
				menu:AddSpacer()
				if self.pk_os.IsNumberBlocked( num ) then
					menu:AddOption( "Unblock", function()
						self.pk_os.UnblockNumber( num )
					end )
				else
					menu:AddOption( "Block", function()
						self.pk_os.BlockNumber( num )
					end )
				end
				menu:AddOption( "Clear", function()
					if !self:IsRunning() then return end

					APP.ClearMessages( num )

					self:LoadConversations()
				end )
				menu:AddOption( "Close", function()
					if !self:IsRunning() then return end

					APP.DiscardConversation( num )

					self:LoadConversations()
				end )
				menu:Open()
		end

	local lblname = rPhone.CreatePanel( "DLabel", pnl )
		lblname:SetFont( "DermaDefaultBold" )
		lblname:SetText( alias )
		lblname:SizeToContents()
		lblname:SetPos( 22, 2 )

	local imgread = rPhone.CreatePanel( "RPDImageButton", pnl )
		imgread:SetSize( 20, 20 )
		imgread:SetPos( 0, 0 )
		imgread:SetPadding( 2 )
		imgread:SetColor( Color( 255, 255, 255, 80 ) )
		imgread:SetImage( unread and UnreadIcon or ReadIcon )
	
	local lblmsgcnt = rPhone.CreatePanel( "DLabel", pnl )
		lblmsgcnt:SetText( ([[(%i Messages)]]):format( msgcnt ) )
		lblmsgcnt:SizeToContents()
		lblmsgcnt:SetTextColor( Color( 180, 180, 180, 255 ) )

	local lbltime, lblmsg

	if lmsgtbl then
		local msg, _, time = unpack( lmsgtbl )
		local ftime = self.pk_os.Util.FormatDateTime( time )

		lbltime = rPhone.CreatePanel( "DLabel", pnl )
			lbltime:SetFont( "rphone_sms_date" )
			lbltime:SetText( ftime )
			lbltime:SizeToContents()
			lbltime:SetTextColor( Color( 140, 140, 140, 255 ) )

		lblmsg = rPhone.CreatePanel( "DLabel", pnl )
			lblmsg:SetFont( "rphone_sms_date" )
			lblmsg:SetText( msg )
			lblmsg:SizeToContents()
			lblmsg:SetTextColor( Color( 180, 180, 180, 255 ) )
	end

	pnl.OldPerformLayout = pnl.PerformLayout
	function pnl:PerformLayout()
		self:OldPerformLayout()

		if IsValid( lbltime ) then
			lbltime:SetPos( 
				self:GetWide() - lbltime:GetWide() - 2, 
				self:GetTall() - lbltime:GetTall() - 2
			)
		end

		if IsValid( lblmsg ) then
			lblmsg:SetPos( 22, self:GetTall() - lblmsg:GetTall() - 2 )
			lblmsg:SetWide( self:GetWide() - lbltime:GetWide() - 4 )
		end

		if IsValid( imgread ) then
			imgread:SetPos( 0, (self:GetTall() - imgread:GetTall()) / 2 )
		end

		if IsValid( lblmsgcnt ) then
			lblmsgcnt:SetPos( self:GetWide() - lblmsgcnt:GetWide() - 2, 2 )
		end
	end

	self.convlist:AddItem( pnl )
end

function APP:LoadConversations()
	if !IsValid( self.convlist ) then return end

	self.convlist:Clear( true )

	local conversations = APP.GetConversations()
	local iter = rPhone.SortedPairsFunc(
		conversations,
		function( _, c1, _, c2 )
			local c1l = c1.messages[#c1.messages]
			local c2l = c2.messages[#c2.messages]

			return (c1l and c1l[3] or 0) > (c2l and c2l[3] or 0)
		end
	)

	for num in iter do
		self:AddConversationButton( num )
	end
end

function APP:DisplayConversationOverview( keepnote )
	local page = self.pgman:NewPage()
	local pw, ph = page:GetSize()

	self.convlist = rPhone.CreatePanel( "DPanelList", page )
		self.convlist:SetPos( 5, 5 )
		self.convlist:SetSpacing( 5 )
		self.convlist:EnableVerticalScrollbar( true )

	local btnadd = rPhone.CreatePanel( "RPDTextButton", page )
		btnadd:SetText( "New Conversation" )
		btnadd:SetSize( 100, 25 )
		btnadd:SetPos( 5, page:GetTall() - btnadd:GetTall() - 5 )
		btnadd.DoClick = function()
			self:DisplayStartConversationDialog()
		end

	self.convlist:SetSize( pw - 10, ph - 15 - btnadd:GetTall() )

	self:LoadConversations()

	if !keepnote then
		APP.RemoveNotification()
	end
end

function APP:Think()
	if !IsValid( self.msgpnl ) then return end

	local hpmq = self.hp_message_queue
	local lpmq = self.lp_message_queue

	local mkstr, align, top, clickFunc

	if #hpmq > 0 then
		mkstr, align, clickFunc = unpack( hpmq[#hpmq] )

		top = false

		table.remove( hpmq )
	elseif #lpmq > 0 then
		mkstr, align, clickFunc = unpack( lpmq[#lpmq] )

		top = true

		table.remove( lpmq )
	else
		return
	end

	local line = self.msgpnl:AddLine( mkstr, align, top )

	if clickFunc then
		local btn = rPhone.CreatePanel( "RPDSimpleButton", line )
			btn:SetSize( line:GetSize() )
			btn.Paint = nil
			btn.DoClick = clickFunc
	end
end

function APP:OnMessageReceived( num, msg, servermsg, time )
	local cnvnum = app_state.last_conv

	if !cnvnum then
		self:LoadConversations()

		return false
	end

	if num != cnvnum then return true end

	if self.pk_os.GetForegroundApp() == self then
		APP.SetHasUnread( num, false )
	end

	if servermsg then
		self:AddServerMessage( msg, time )
	else
		local name = APP.GetDisplayAlias( num )
		
		self:AddIncomingMessage( name, msg, time )
	end

	return false
end

function APP:OnGainedFocus()
	local cnvnum = app_state.last_conv

	if !cnvnum then
		APP.RemoveNotification()
	else
		APP.SetHasUnread( cnvnum, false )
		APP.RemoveNotificationIfRead()
	end

	self:LoadConversations()
end

function APP:OnBackPressed()
	self.pgman:GoBack()
	app_state.last_conv = nil

	if !self.pgman:GetCurrentPage() then
		self:Kill()
	else
		self:LoadConversations()
	end

	APP.RemoveNotification()

	return true
end
