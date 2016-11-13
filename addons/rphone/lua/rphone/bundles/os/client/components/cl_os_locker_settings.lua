
local OS = rPhone.AssertPackage( "os" )

local os_settings = {}

local function settingsPageLayout( pnl, settings )
	local key = OS.GetLockKey()
	local mode = OS.GetLockKeyMode()
	local holdlen = OS.GetLockKeyHoldTime()
	local locklen = OS.GetLockAnimationTime()
	local sleepalpha = OS.GetSleepAlpha()
	local sleeptime = OS.GetSleepTime()
	
	local kname = input.GetKeyName( key )

	local aclist = rPhone.CreatePanel( "RPDAlignedControlList", pnl )
		aclist:SetPos( 0, 0 )
		aclist:SetSize( pnl:GetSize() )

	local lbllck = rPhone.CreatePanel( "DLabel" )
		lbllck:SetText( "Lock Key:" )
		lbllck:SizeToContents()

	local btnlck = rPhone.CreatePanel( "RPDTextButton" )
		btnlck:SetText( (kname or ''):upper() )
		btnlck:SetWide( 100 )
		function btnlck:DoClick()
			self:SetText( "Press a key" )
			
			input.StartKeyTrapping()
			self.trapping = true
		end
		function btnlck:Think()
			if !self.trapping then return end

			if !input.IsKeyTrapping() then
				self.trapping = false
			else
				local k = input.CheckKeyTrapping()

				if !k then return end

				key = k
				kname = input.GetKeyName( key )

				self.trapping = false
				settings.lock_key = key
			end

			if !self.trapping then
				self:SetText( (kname or ''):upper() )
			end
		end

	local lbllen = rPhone.CreatePanel( "DLabel" )
		lbllen:SetText( "Hold Time:" )
		lbllen:SizeToContents()

	local txtlen = rPhone.CreatePanel( "DTextEntry" )
		txtlen:SetWide( 100 )
		txtlen:SetText( holdlen )
		txtlen.OldSetDisabled = txtlen.SetDisabled
		function txtlen:SetDisabled( disabled )
			self:OldSetDisabled( disabled )
			self:SetEditable( !disabled )
		end
		function txtlen:OnTextChanged()
			local len = tonumber( self:GetText() )

			if !len or len < 0 then return end

			len = math.Clamp( len, 0.1, 5 )

			settings.lock_key_hold_length = len
		end
		txtlen:SetDisabled( settings.lock_mode == "doubletap" )

	local lblmode = rPhone.CreatePanel( "DLabel" )
		lblmode:SetText( "Lock Mode:" )
		lblmode:SizeToContents()

	local cmbmode = rPhone.CreatePanel( "DComboBox" )
		cmbmode:SetWide( 100 )
		cmbmode:SetValue( mode == "hold" and "Hold" or "Double Tap" )
		function cmbmode:OnSelect( idx, val, data )
			settings.lock_key_mode = data

			txtlen:SetDisabled( settings.lock_mode == "doubletap" )
		end
		cmbmode:AddChoice( "Hold", "hold" )
		cmbmode:AddChoice( "Double Tap", "doubletap" )

	local lbllocklen = rPhone.CreatePanel( "DLabel" )
		lbllocklen:SetText( "Animation Length:" )
		lbllocklen:SizeToContents()

	local txtlocklen = rPhone.CreatePanel( "DTextEntry" )
		txtlocklen:SetWide( 100 )
		txtlocklen:SetText( locklen )
		function txtlocklen:OnTextChanged()
			local len = tonumber( self:GetText() )

			if !len or len < 0 then return end

			len = math.Clamp( len, 0.1, 5 )

			settings.lock_anim_length = len
		end

	local lblsleepalpha = rPhone.CreatePanel( "DLabel" )
		lblsleepalpha:SetText( "Sleep Alpha:" )
		lblsleepalpha:SizeToContents()

	local txtsleepalpha = rPhone.CreatePanel( "DTextEntry" )
		txtsleepalpha:SetWide( 100 )
		txtsleepalpha:SetText( sleepalpha )
		function txtsleepalpha:OnTextChanged()
			local alpha = tonumber( self:GetText() )

			if !alpha then return end

			alpha = math.floor( math.Clamp( alpha, 0, 255 ) )

			settings.sleep_alpha = alpha
		end

	local lblsleeptime = rPhone.CreatePanel( "DLabel" )
		lblsleeptime:SetText( "Sleep After:" )
		lblsleeptime:SizeToContents()

	local txtsleeptime = rPhone.CreatePanel( "DTextEntry" )
		txtsleeptime:SetWide( 100 )
		txtsleeptime:SetText( sleeptime )
		function txtsleeptime:OnTextChanged()
			local len = tonumber( self:GetText() )

			if !len or len < 0 then return end

			settings.sleep_time = len
		end

	aclist:AddRow( lbllck, btnlck )
	aclist:AddRow( lbllen, txtlen )
	aclist:AddRow( lblmode, cmbmode )
	aclist:AddRow( lbllocklen, txtlocklen )
	aclist:AddRow( lblsleepalpha, txtsleepalpha )
	aclist:AddRow( lblsleeptime, txtsleeptime )
end

rPhone.RegisterEventCallback( "SETTINGS_Initialize", function( apk_settings )
	os_settings = apk_settings.GetSettings( OS.PackageName )
end )

rPhone.RegisterEventCallback( "SETTINGS_PopulateMenu", function( apk_settings )
	apk_settings.AddSettingsPage( "Key Bindings", {
		Category = "System",
		PackageName = OS.PackageName,
		PerformLayout = settingsPageLayout
	} )
end )



function OS.GetLockKey()
	return os_settings.lock_key or rPhone.GetVariable( "OS_LOCK_KEY_DEFAULT", KEY_P )
end

function OS.GetLockKeyMode()
	return os_settings.lock_key_mode or rPhone.GetVariable( "OS_LOCK_KEY_MODE_DEFAULT", "hold" )
end

function OS.GetLockKeyHoldTime()
	return math.Clamp(
		os_settings.lock_key_hold_length or rPhone.GetVariable( "OS_LOCK_KEY_HOLD_LENGTH_DEFAULT", 0.75 ),
		0.1, 5
	)
end

function OS.GetLockAnimationTime()
	return math.Clamp(
		os_settings.lock_anim_length or rPhone.GetVariable( "OS_LOCK_ANIMATION_LENGTH_DEFAULT", 0.6 ),
		0.1, 5
	)
end

function OS.GetSleepAlpha()
	return math.Clamp(
		os_settings.sleep_alpha or rPhone.GetVariable( "OS_SLEEP_ALPHA_DEFAULT", 75 ),
		0, 255
	)
end

function OS.GetSleepTime()
	return os_settings.sleep_time or rPhone.GetVariable( "OS_SLEEP_INACTIVITY_TIME_DEFAULT", 4 )
end
