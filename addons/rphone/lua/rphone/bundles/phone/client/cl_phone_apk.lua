
local CallerIcon = "dan/rphone/icons/person01.png"
local DisconnectIcon = "dan/rphone/icons/phone02.png"
local ArrowIcon = "dan/rphone/icons/arrow_left.png"


surface.CreateFont( "rphone_phone_time", {
	font = "DermaDefault",
	size = 12
} )

surface.CreateFont( "rphone_phone_dialpad", {
	font = "Trebuchet18",
	size = 20
} )

surface.CreateFont( "rphone_phone_dialpadcall", {
	font = "Trebuchet18",
	size = 20,
	weight = 600
} )


local APP = rPhone.CreateAppPackage( "phone" )

APP.Launchable = true
APP.DisplayName = "Phone"
APP.Icon = "dan/rphone/icons/phone01.png"



function APP:Initialize( params )
	self.pk_os = rPhone.AssertPackage( "os" )

	APP.SetAppInstance( self )

	local canv = self:GetCanvas()	
	self.pgman = self.pk_os.Util.CreatePageManager( canv )

	if APP.IsInCall() then
		self:DisplayCallPage()
	elseif APP.IsCallPending() then
		self:DisplayAnswerPage()
	elseif params.Number then
		local num = rPhone.ToRawNumber( params.Number )

		if !rPhone.IsValidNumber( num ) then 
			self:Kill()
			return
		end

		APP.DialNumber( num )

		self:DisplayCallPage()
	else
		self:DisplayMenu( params.DisplayRecents == true )
	end

	self.pk_os.AddAppAction( self, "Settings", function()
		self.pk_os.LaunchApp( "settings", { PageName = APP.DisplayName } )
	end )
end

function APP:GoBack( nokill )
	self.pgman:GoBack()

	if !nokill and !self.pgman:GetCurrentPage() then
		self:Kill()
	end
end

function APP:DisplayCallPage()
	local page = self.pgman:NewPage( false, "call" )
	local num = APP.GetCallerNumber()
	local alias = APP.GetDisplayAlias( num )
	local whisper = APP.GetWhisperDefault()
	local ptt = APP.GetPushToTalkDefault()

	local pw, ph = page:GetSize()

	local icnsize = pw / 2.5

	local callericon = rPhone.CreatePanel( "RPDImageButton", page )
		callericon:SetDisabled( true )
		callericon:SetDisabledColor( callericon:GetColor() )
		callericon:SetImage( CallerIcon )
		callericon:SetSize( icnsize, icnsize )
		callericon:SetPos( (pw / 2) - (icnsize / 2), 20 )
		callericon:SetPadding( 6 )
		callericon.OldPaint = callericon.Paint
		function callericon:Paint( w, h )
			self:OldPaint( w, h )

			local balpha = 120

			if APP.IsCallAnswered() then
				local caller = APP.GetCaller()

				if IsValid( caller ) then
					balpha = caller:VoiceVolume() * 255
				end
			end

			surface.SetDrawColor( 255, 255, 255, balpha )
			surface.DrawOutlinedRect( 0, 0, w, h )
		end

	local lblname = rPhone.CreatePanel( "DLabel", page )
		lblname:SetFont( "Trebuchet24" )
		lblname:SetText( alias )
		lblname:SizeToContents()
		lblname:SetPos( 
			(pw - lblname:GetWide()) / 2,
			20 + 20 + icnsize
		)

	self.callstatus = rPhone.CreatePanel( "DLabel", page )
		function self.callstatus:PerformLayout()
			local _, nly = lblname:GetPos()

			self:SetPos( 
				(pw - self:GetWide()) / 2,
				nly + lblname:GetTall() + 5
			)
		end

	local btnpad = 5
	local bw = (pw - (btnpad * 4)) / 3
	local bh = 40
	local by = ph - bh - 5

	local btnmute = rPhone.CreatePanel( "RPDTextButton", page )
		btnmute:SetText( "Mute" )
		btnmute:SetSize( bw, bh )
		btnmute:SetPos( btnpad, by )
		btnmute:SetToggleable( true )
		btnmute:SetToggled( false )
		function btnmute:OnToggled( toggled )
			if APP.IsInCall() then
				APP.SetMuted( toggled )
			end
		end
		function btnmute:Think()
			if !APP.IsInCall() and !self:GetDisabled() then
				self:SetDisabled( true )
			end
		end

	local btnwhisp = rPhone.CreatePanel( "RPDTextButton", page )
		btnwhisp:SetText( "Whisper" )
		btnwhisp:SetSize( bw, bh )
		btnwhisp:SetPos( (btnpad * 2) + bw, by )
		btnwhisp:SetToggleable( true )
		btnwhisp:SetToggled( whisper )
		function btnwhisp:OnToggled( toggled )
			if APP.IsInCall() then
				APP.SetWhisper( toggled )
			end
		end
		function btnwhisp:Think()
			if !APP.IsInCall() and !self:GetDisabled() then
				self:SetDisabled( true )
			end
		end
		if always_whisper then
			btnwhisp:SetDisabled( true )
			btnwhisp:SetToggled( true )
		end

	local btnptt = rPhone.CreatePanel( "RPDTextButton", page )
		btnptt:SetText( "Push To Talk" )
		btnptt:SetSize( bw, bh )
		btnptt:SetPos( (btnpad * 3) + (bw * 2), by )
		btnptt:SetToggleable( true )
		btnptt:SetToggled( ptt )
		function btnptt:OnToggled( toggled )
			if APP.IsInCall() then
				APP.SetPushToTalk( toggled )
			end
		end
		function btnptt:Think()
			if !APP.IsInCall() and !self:GetDisabled() then
				self:SetDisabled( true )
			end
		end

	local btnend = rPhone.CreatePanel( "RPDContentButton", page )
		btnend:SetSize( bw, bh )
		btnend:SetPos( (btnpad * 2) + bw, by - 5 - bh )
		btnend.DoClick = function()
			if APP.IsInCall() then
				APP.Disconnect()

				self:GoBack()

				if self.pgman:GetCurrentPage() then
					self:LoadRecents()
				end
			end
		end
		function btnend:Think()
			if !APP.IsInCall() and !self:GetDisabled() then
				self:SetDisabled( true )
			end
		end

	local imgsize = math.min( btnend:GetSize() )

	local imgend = rPhone.CreatePanel( "RPDImageButton", btnend )
		imgend:SetImage( DisconnectIcon )
		imgend:SetColor( Color( 255, 0, 0, 255 ) )
		imgend:SetSize( imgsize, imgsize )
		imgend:SetPadding( 0 )
		imgend:SetPos( 
			(bw - imgsize) / 2, 
			(bh - imgsize) / 2
		)
end

function APP:SetCallStatus( status )
	if !IsValid( self.callstatus ) then return end

	if self.callstatus:GetText() == status then return end

	self.callstatus:SetText( status )
	self.callstatus:SizeToContents()
end

function APP:DisplayAnswerPage()
	local page = self.pgman:NewPage( false, "answer" )
	local num = APP.GetCallerNumber()
	local alias = APP.GetDisplayAlias( num )

	local pw, ph = page:GetSize()

	local icnsize = pw / 2.5

	local callericon = rPhone.CreatePanel( "RPDImageButton", page )
		callericon:SetDisabled( true )
		callericon:SetDisabledColor( callericon:GetColor() )
		callericon:SetImage( CallerIcon )
		callericon:SetSize( icnsize, icnsize )
		callericon:SetPos( (pw - icnsize) / 2, 20 )
		callericon:SetPadding( 6 )
		callericon.OldPaint = callericon.Paint
		function callericon:Paint( w, h )
			self:OldPaint( w, h )

			surface.SetDrawColor( 255, 255, 255, 120 )
			surface.DrawOutlinedRect( 0, 0, w, h )
		end

	local lblname = rPhone.CreatePanel( "DLabel", page )
		lblname:SetFont( "Trebuchet24" )
		lblname:SetText( alias )
		lblname:SizeToContents()
		lblname:SetPos( 
			(pw - lblname:GetWide()) / 2,
			20 + 20 + icnsize
		)

	local btnpad = 5
	local bw = (pw - (btnpad * 3)) / 2
	local bh = 40

	local btnans = rPhone.CreatePanel( "RPDTextButton", page )
		btnans:SetText( "Answer" )
		btnans:SetFont( "rphone_phone_dialpadcall" )
		btnans:SetTextColor( Color( 0, 255, 0, 255 ) )
		btnans:SetSize( bw, bh )
		btnans:SetPos( btnpad, ph - (bh * 2) - 5 )
		btnans.DoClick = function()
			APP.AcceptCall()

			self:GoBack( true )
			self:DisplayCallPage()
		end

	local btndec = rPhone.CreatePanel( "RPDTextButton", page )
		btndec:SetText( "Decline" )
		btndec:SetFont( "rphone_phone_dialpadcall" )
		btndec:SetTextColor( Color( 255, 0, 0, 255 ) )
		btndec:SetSize( bw, bh )
		btndec:SetPos( (btnpad * 2) + bw, ph - (bh * 2) - 5  )
		btndec.DoClick = function()
			APP.DeclineCall()

			self:GoBack()
		end
end

function APP:LoadRecents()
	if !IsValid( self.recentslist ) then return end

	self.recentslist:Clear( true )

	for _, recent in ipairs( APP.GetRecents() ) do
		local num = recent.Number
		local incoming = recent.Incoming
		local ftime = self.pk_os.Util.FormatDateTime( recent.Time )
		local alias = APP.GetDisplayAlias( num )

		local rcb = rPhone.CreatePanel( "RPDContentButton" )
			rcb:SetTall( 20 )
			rcb.DoClick = function()
				if !rPhone.IsValidNumber( num ) then return end

				APP.DialNumber( num )

				self:DisplayCallPage()
			end
			rcb.DoRightClick = function()
				local nicenum = rPhone.ToNiceNumber( num )
				local name = APP.GetContactName( num )

				local menu = rPhone.CreatePanel( "RPDMenu", self.recentslist )
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
					menu:Open()
			end

		local lblname = rPhone.CreatePanel( "DLabel", rcb )
			lblname:SetFont( "DermaDefaultBold" )
			lblname:SetText( alias )
			lblname:SizeToContents()
			lblname:SetPos( 22, 2 )

		local imgdir = rPhone.CreatePanel( "RPDImageButton", rcb )
			imgdir:SetSize( 20, 20 )
			imgdir:SetPos( 0, 0 )
			imgdir:SetPadding( 2 )
			imgdir:SetColor( Color( 255, 255, 255, 80 ) )
			imgdir:SetImage( ArrowIcon )
			imgdir:SetRotation( incoming and 45 or -135 )
			imgdir:SetColor( incoming and Color( 0, 180, 255, 255 ) or Color( 0, 255, 75, 255 ) )

		local lbltime = rPhone.CreatePanel( "DLabel", rcb )
			lbltime:SetFont( "rphone_phone_time" )
			lbltime:SetText( ftime )
			lbltime:SizeToContents()
			lbltime:SetTextColor( Color( 140, 140, 140, 255 ) )

		rcb.OldPerformLayout = rcb.PerformLayout
		function rcb:PerformLayout()
			self:OldPerformLayout()

			if IsValid( lbltime ) then
				lbltime:SetPos( self:GetWide() - lbltime:GetWide() - 2, 3 )
			end
		end

		self.recentslist:AddItem( rcb )
	end
end

function APP:DisplayMenu( displayrecents )
	local page = self.pgman:NewPage( false, "menu" )

	local propsheet = rPhone.CreatePanel( "DPropertySheet", page )
		propsheet:SetSize( page:GetSize() )
		propsheet:SetShowIcons( false )
		propsheet:SetPadding( 0 )
		propsheet.Paint = nil

	local dialpad = rPhone.CreatePanel( "DPanel" )
		dialpad.Paint = nil

	local recents = rPhone.CreatePanel( "DPanel" )
		recents.Paint = nil

	local tabdialpad = propsheet:AddSheet( "Dialpad", dialpad, nil, false, false ).Tab
		tabdialpad.Paint = nil

	local tabrecents = propsheet:AddSheet( "Recents", recents, nil, false, false ).Tab
		tabrecents.Paint = nil

	propsheet:InvalidateLayout( true )

	if displayrecents then
		propsheet:SetActiveTab( tabrecents )
	end


	local pw, ph = dialpad:GetSize()
	local curnum = ""

	local lblnumbg = rPhone.CreatePanel( "DPanel", dialpad )
		function lblnumbg:Paint( w, h )
			surface.SetDrawColor( 40, 40, 40, 255 )
			surface.DrawRect( 0, 0, w, h )
		end

	local lblnum = rPhone.CreatePanel( "DLabel", dialpad )
		lblnum:SetFont( "Trebuchet24" )
		lblnum:SetText( "" )
		lblnum:SizeToContents()
		lblnum:SetColor( Color( 0, 0, 0, 255 ) )

	local function updateNumber()
		if !IsValid( lblnum ) then return end

		lblnum:SetText( rPhone.ToNiceNumber( curnum ) )
		lblnum:SizeToContents()
		lblnum:SetPos( (pw - lblnum:GetWide()) / 2, 5 )

		if rPhone.IsValidNumber( curnum ) then
			lblnum:SetTextColor( Color( 0, 255, 0, 255 ) )
		else
			lblnum:SetTextColor( Color( 255, 0, 0, 255 ) )
		end

		lblnumbg:SetSize( pw, lblnum:GetTall() + 10 )
	end

	updateNumber()

	local bw, bh = 80, 40
	local starth = 10 + lblnum:GetTall()
	local xspc = (pw - (3 * bw)) / 4
	local yspc = ((ph - starth) - (5 * bh)) / 6

	for i=1, 12 do
		local column = math.floor( (i - 1) % 3 ) + 1
		local row = math.floor( (i - 1) / 3 ) + 1
		local txt = (i == 11) and '0' or tostring( i )
		local color = Color( 255, 255, 255, 255 )
		local clickFunc = function()
			curnum = curnum .. txt
		end

		local btn = rPhone.CreatePanel( "RPDTextButton", dialpad )
			btn:SetFont( "rphone_phone_dialpad" )
			btn:SetText( txt )
			btn:SetSize( bw, bh )
			btn:SetPos( 
				(column * xspc) + ((column - 1) * bw), 
				starth + (row * yspc) + ((row - 1) * bh) 
			)
			
		if i == 10 then
			txt = "Clear"
			color = Color( 255, 0, 0, 255 )
			
			clickFunc = function()
				curnum = ''
			end
		elseif i == 12 then
			txt = "<"
			color = Color( 255, 0, 0, 255 )

			clickFunc = function()
				curnum = curnum:Left( #curnum - 1 )
			end
		end

		btn:SetText( txt )
		btn:SetTextColor( color )
		btn.DoClick = function()
			clickFunc()
			updateNumber()
		end
	end

	local btncall = rPhone.CreatePanel( "RPDTextButton", dialpad )
		btncall:SetFont( "rphone_phone_dialpadcall" )
		btncall:SetText( "Call" )
		btncall:SetSize( bw * 2, bh )
		btncall:SetPos( 
			(pw / 2) - bw, 
			starth + (5 * yspc) + (4 * bh)
		)
		btncall:SetTextColor( Color( 0, 255, 0, 255 ) )
		btncall.DoClick = function()
			if !rPhone.IsValidNumber( curnum ) then return end			

			APP.DialNumber( curnum )

			curnum = ''
			updateNumber()

			self:DisplayCallPage()
		end


	self.recentslist = rPhone.CreatePanel( "RPDCategoryList", recents )
		self.recentslist:SetPos( 5, 0 )
		self.recentslist:SetSize( pw - 10, ph - 15 - 25 )

	local btnclear = rPhone.CreatePanel( "RPDTextButton", recents )
		btnclear:SetText( "Clear" )
		btnclear:SetSize( 100, 25 )
		btnclear:SetPos( 5, ph - btnclear:GetTall() - 5 )
		btnclear.DoClick = function()
			APP.ClearRecents()
			self:LoadRecents()
		end

	self:LoadRecents()
end

function APP:Think()
	if APP.IsInCall() then
		if !APP.IsCallAnswered() then
			local dots = math.floor( SysTime() % 4 )

			self:SetCallStatus( "Calling" .. ('.'):rep( dots ) )
		else
			local time = APP.GetElapsedTime()
			local min = math.floor( time / 60 )
			local sec = math.floor( time % 60 )
			sec = (sec <= 9 and '0' or '') .. sec

			local str = min .. ':' .. sec

			self:SetCallStatus( str )
		end
	end
end

function APP:OnGainedFocus()
	self:LoadRecents()

	APP.RemoveNotification()
end

function APP:OnCallPending()
	local pname = self.pgman:GetCurrentPageName()

	if pname != "menu" then
		self:GoBack( true )
	end

	self:DisplayAnswerPage()
end

function APP:OnCallEnded( msg )
	local pname = self.pgman:GetCurrentPageName()

	if pname == "call" then
		self:SetCallStatus( msg )

		timer.Simple( 4, function()
			self:GoBack()
		end )
	elseif pname != "menu" then
		self:GoBack()
	end

	if self.pgman:GetCurrentPage() then
		self:LoadRecents()
	end
end
