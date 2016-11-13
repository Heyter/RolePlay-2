
local APP = rPhone.AssertPackage( "tutorial" )

local function wrapTag( tag, val, txt )
	return ([[<%s=%s>%s</%s>]]):format( tag, val, txt, tag )
end

local function wrapFont( txt, font )
	font = font or "DermaDefaultBold"

	return wrapTag( "font", font, txt )
end

local function addOverlay( pnl, info )
	info = info or {}

	local pw, ph = pnl:GetSize()

	local x, y = info.x or 0, info.y or 0
	local w, h = info.w or pw, info.h or ph
	local col = info.color or Color( 0, 0, 0, 200 )

	local overlay = rPhone.CreatePanel( "DPanel", pnl )
		overlay:SetPos( x, y )
		overlay:SetSize( w, h )
		function overlay:Paint( w, h )
			surface.SetDrawColor( col )
			surface.DrawRect( 0, 0, w, h )
		end

	return overlay
end

local function addMessage( pnl, msg, x, y, w )
	local pw = pnl:GetWide()

	x, y = x or 0, y or 0
	w = w or (pw - x)

	local lblmsg = rPhone.CreatePanel( "RPDMarkupLabel", pnl )
		lblmsg:SetWide( w )
		lblmsg:SetPadding( 2 )
		lblmsg:SizeToContents()
		lblmsg:SetPos( x, y )
		lblmsg:SetText( msg )

	return lblmsg
end

local function launchApp( pname, params )
	local pk_os = rPhone.AssertPackage( "os" )
	
	pk_os.LaunchApp( pname, params )
end

local function killForegroundApp()
	local pk_os = rPhone.AssertPackage( "os" )
	local fgapp = pk_os.GetForegroundApp()

	if fgapp then fgapp:Kill() end
end

local function layoutWelcomePage( pnl, bounds )
	local pk_os = rPhone.AssertPackage( "os" )

	local lkey = pk_os.GetLockKey()
	local lkeyname = (input.GetKeyName( lkey ) or ''):upper()
	local lmode = pk_os.GetLockKeyMode()

	local msg_unlock = wrapFont( ([[%s %s to unlock]]):format( 
		(lmode == "hold") and "Press and hold" or "Double tap", 
		lkeyname
	) )
	local msg_welcome = wrapFont( [[Welcome to <color=60,255,80>rPhone</color>!

This short tutorial will explain basic usage and features of rPhone.

To advance, click the next arrow. To go back, click the previous arrow.]] )

	addOverlay( pnl, { color = Color( 0, 0, 0, 255 ) } )

	addMessage( pnl, msg_unlock, 5, 5 )
	addMessage( pnl, msg_welcome, bounds.sx, bounds.sy, bounds.sw )
end

local function layoutHomePage( pnl, bounds )
	killForegroundApp()

	local msg_home = wrapFont( [[This is the Launcher, which displays all available apps.

To launch an app, simply click its icon.]] )

	addOverlay( pnl, { 
		h = bounds.trh, 
		color = Color( 0, 0, 0, 255 ) 
	} )
	addOverlay( pnl, { 
		y = bounds.h - bounds.nbh, 
		h = bounds.nbh, 
		color = Color( 0, 0, 0, 255 ) 
	} )

	addMessage( pnl, msg_home, bounds.sx, bounds.sy, bounds.sw )
end

local function layoutTrayPage( pnl, bounds )
	local msg_tray = wrapFont( [[On top we have the System Tray.

This displays general information as well as notifications for things like incoming calls or texts.]] )

	addOverlay( pnl, {
		y = bounds.trh,
		h = bounds.h - bounds.trh,
		color = Color( 0, 0, 0, 255 )
	} )

	addMessage( pnl, msg_tray, bounds.sx, bounds.sy, bounds.sw )
end

local function layoutNavBarPage( pnl, bounds )
	local msg_nav = wrapFont( [[Below is the Navigation Bar. From left to right we have the Back, Home and Actions buttons.

Back returns you to the previous page/app, Home returns you to the Launcher, and Actions displays several quick actions.]] )

	addOverlay( pnl, {
		h = bounds.h - bounds.nbh,
		color = Color( 0, 0, 0, 255 )
	} )

	local msg = addMessage( pnl, msg_nav, 0, 0, bounds.sw )
	msg:SetPos( bounds.sx, bounds.sy + bounds.sh - msg:GetTall() )
end

local function layoutSettingsPage( pnl, bounds )
	killForegroundApp()
	launchApp( "settings" )

	local msg_settings = wrapFont( [[Here we have the Settings app.

To adjust System or Application settings, simply click the corresponding entry. From there a new page will be displayed with the settings options.]] )

	addOverlay( pnl, { 
		y = bounds.trh,
		h = bounds.h - bounds.trh - bounds.nbh
	} )

	local msg = addMessage( pnl, msg_settings, 0, 0, bounds.sw )
	msg:SetPos( bounds.sx, bounds.sy + bounds.sh - msg:GetTall() - 30 )
end

local function layoutContactsPage( pnl, bounds )
	killForegroundApp()
	launchApp( "contacts" )

	local msg_contacts = wrapFont( [[This is the Contacts app.

From here you can view the contacts you have added. To add a new contact, click the 'New Contact' button and fill in their name and number. You can initiate a call or send a text by clicking a contact and selecting one of the options.

Note: You may enter a number with or without dashes (i.e. [1234567] and [123-4567] are both valid).]] )

	addOverlay( pnl, { 
		y = bounds.trh,
		h = bounds.h - bounds.trh - bounds.nbh
	} )

	local msg = addMessage( pnl, msg_contacts, 0, 0, bounds.sw )
	msg:SetPos( bounds.sx, bounds.sy + bounds.sh - msg:GetTall() - 30 )
end

local function layoutSMSPage( pnl, bounds )
	killForegroundApp()
	launchApp( "sms" )

	local msg_sms = wrapFont( [[This is the SMS app.

You can begin a conversation using either the 'New Conversation' button or the Contacts app. This page will display currently active conversations, the last message received and the time the last message was received.

You may also send texts to offline users and change your text notification sound in Settings.]] )

	addOverlay( pnl, { 
		y = bounds.trh,
		h = bounds.h - bounds.trh - bounds.nbh
	} )

	local msg = addMessage( pnl, msg_sms, 0, 0, bounds.sw )
	msg:SetPos( bounds.sx, bounds.sy + bounds.sh - msg:GetTall() - 30 )
end

local function layoutPhonePage( pnl, bounds )
	killForegroundApp()
	launchApp( "phone" )

	local msg_phone = wrapFont( [[This is the Phone app.

Like the SMS app, you can initiate a conversation using either the dialpad or the Contacts app. Recents will display previous incoming or outgoing calls. In a call, the Mute button will mute your voice, the Whisper button will make it so only the callee can hear your voice, and Push-To-Talk allows you to toggle the mic always being on.

The default values for these as well as your ring tone can be configured in Settings.]] )

	addOverlay( pnl, { 
		y = bounds.trh,
		h = bounds.h - bounds.trh - bounds.nbh
	} )

	local msg = addMessage( pnl, msg_phone, 0, 0, bounds.sw )
	msg:SetPos( bounds.sx, bounds.sy + bounds.sh - msg:GetTall() - 30 )
end

local function layoutCameraPage( pnl, bounds )
	killForegroundApp()
	launchApp( "camera" )

	local msg_camera = wrapFont( [[This is the Camera.

Click and drag to pan, scroll wheel controls zoom. Select the view toggle button in the bottom left to switch between First Person and Third Person view modes. Strike a pose and hit the save button in the bottom right to upload your photo to the Steam Cloud.

Whether the image saves in fullscreen or in the aspect ratio of the phone is configurable in Settings.]] )

	addOverlay( pnl, { 
		y = bounds.trh,
		h = bounds.h - bounds.trh - bounds.nbh
	} )

	local msg = addMessage( pnl, msg_camera, bounds.sx, bounds.sy, bounds.sw )
end

local function layoutAdditionalInfoPage( pnl, bounds )
	killForegroundApp()

	local msg_info = wrapFont( [[<color=255,0,0,255>You can find your phone number</color> by either selecting 'Copy Number' in the Actions menu, or vising the About page in Settings.

To change your Wallpaper, you can either enter a solid color or a URL in the Wallpaper Settings page.

You may also block or unblock numbers in Settings, which prevents those users from texting or calling you.

To change which key opens the phone, the hold time, or to open by double tapping a key, go to the Key Bindings
Settings page.]] )

	addOverlay( pnl, { 
		y = bounds.trh,
		h = bounds.h - bounds.trh - bounds.nbh
	} )

	local msg = addMessage( pnl, msg_info, bounds.sx, bounds.sy, bounds.sw )
	msg:SetPos( bounds.sx, bounds.sy + ((bounds.sh - msg:GetTall()) / 2)  )
end

local function layoutFinalPage( pnl, bounds )
	killForegroundApp()

	local msg_final = wrapFont( [[This concludes the rPhone tutorial. You can view it again through the Settings app at any time.

There are several features that were not covered in this tutorial, so take a look around!]] )

	addOverlay( pnl, { 
		y = bounds.trh,
		h = bounds.h - bounds.trh - bounds.nbh
	} )

	local msg = addMessage( pnl, msg_final, bounds.sx, bounds.sy, bounds.sw )
	msg:SetPos( bounds.sx, bounds.sy + ((bounds.sh - msg:GetTall()) / 2)  )
end



APP.AddPage( layoutWelcomePage )
APP.AddPage( layoutHomePage )
APP.AddPage( layoutTrayPage )
APP.AddPage( layoutNavBarPage )
APP.AddPage( layoutSettingsPage )
APP.AddPage( layoutContactsPage )
APP.AddPage( layoutSMSPage )
APP.AddPage( layoutPhonePage )
APP.AddPage( layoutCameraPage )
APP.AddPage( layoutAdditionalInfoPage )
APP.AddPage( layoutFinalPage )
