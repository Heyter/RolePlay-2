
local OS = rPhone.AssertPackage( "os" )

local apk_contacts
local os_settings = {}

local function getContactName( num )
	if apk_contacts then
		return apk_contacts.GetContactName( num )
	end
end

local function getDisplayAlias( num )
	num = rPhone.ToRawNumber( num )
	local nicenum = rPhone.ToNiceNumber( num )
	local name = getContactName( num )

	return name and ([[%s (%s)]]):format( name, nicenum ) or nicenum
end

local function loadBlockedNumbers( list )
	local blocked = OS.GetBlockedNumbers()
	local aliases = {}

	local iter = rPhone.SortedPairsFunc(
		blocked,
		function( _, n1, _, n2 )
			aliases[n1] = aliases[n1] or getDisplayAlias( n1 )
			aliases[n2] = aliases[n2] or getDisplayAlias( n2 )

			return aliases[n1]:lower() < aliases[n2]:lower()
		end
	)

	list:Clear( true )

	for _, num in iter do
		local alias = aliases[num] or getDisplayAlias( num )

		local btn = rPhone.CreatePanel( "RPDContentButton" )
			btn.DoClick = function()
				local menu = rPhone.CreatePanel( "RPDMenu", list )
					menu:AddOption( "Unblock", function()
						OS.UnblockNumber( num )

						loadBlockedNumbers( list )
					end )
					menu:Open()
			end
			btn.DoRightClick = btn.DoClick

		local lblname = rPhone.CreatePanel( "DLabel", btn )
			lblname:SetFont( "DermaDefaultBold" )
			lblname:SetText( alias )
			lblname:SizeToContents()
			lblname:SetPos( 4, 2 )

		btn:SetTall( lblname:GetTall() + 6 )

		list:AddItem( btn )
	end
end

local function displayBlockDialogue( pnl, list )
	local updateValidity

	local bg = rPhone.CreatePanel( "DPanel", pnl )
		bg:SetSize( pnl:GetSize() )
		function bg:Paint( w, h )
			surface.SetDrawColor( 0, 0, 0, 245 )
			surface.DrawRect( 0, 0, w, h )
		end

	local popup = rPhone.CreatePanel( "DPanel", bg )
		function popup:Paint( w, h )
			surface.SetDrawColor( 0, 0, 0, 255 )
			surface.DrawRect( 0, 0, w, h )

			surface.SetDrawColor( 255, 255, 255, 255 )
			surface.DrawOutlinedRect( 0, 0, w, h )
		end
		function popup:PerformLayout()
			self:SetPos( 
				(pnl:GetWide() - self:GetWide()) / 2,
				(pnl:GetTall() - self:GetTall()) / 2
			)
		end
		popup:InvalidateLayout( true )
		popup:SetSize( 225, 53 )

	local lblnum = rPhone.CreatePanel( "DLabel", popup )
		lblnum:SetText( "Number:" )
		lblnum:SizeToContents()
		lblnum:SetPos( 5, 7 )

	local txtnum = rPhone.CreatePanel( "DTextEntry", popup )
		txtnum:SetPos( 10 + lblnum:GetWide(), 5 )
		txtnum:SetWide( pnl:GetWide() - lblnum:GetWide() - 15 )
		function txtnum:OnTextChanged()
			updateValidity()
		end
		txtnum:RequestFocus()

	local btnconf = rPhone.CreatePanel( "RPDTextButton", popup )
		btnconf:SetText( "Confirm" )
		btnconf:SetSize( (popup:GetWide() / 2) - 7, 20 )
		btnconf:SetPos( (popup:GetWide() / 2) + 2, popup:GetTall() - 25 )
		btnconf.DoClick = function()
			local num = rPhone.ToRawNumber( txtnum:GetText() )

			bg:Remove()

			if !rPhone.IsValidNumber( num ) then return end

			OS.BlockNumber( num )

			loadBlockedNumbers( list )
		end

	local btncanc = rPhone.CreatePanel( "RPDTextButton", popup )
		btncanc:SetText( "Cancel" )
		btncanc:SetSize( (popup:GetWide() / 2) - 7, 20 )
		btncanc:SetPos( 5, popup:GetTall() - 25 )
		btncanc.DoClick = function()
			bg:Remove()
		end

	function updateValidity()
		local num = rPhone.ToRawNumber( txtnum:GetText() )

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

local function settingsPageLayout( pnl, settings )
	local btnadd = rPhone.CreatePanel( "RPDTextButton", pnl )
		btnadd:SetText( "Add Block" )
		btnadd:SetPos( 5, pnl:GetTall() - btnadd:GetTall() - 5 )
		btnadd:SetSize( 100, 25 )

	local list = rPhone.CreatePanel( "RPDCategoryList", pnl )
		list:SetPos( 5, 5 )
		list:SetSize( pnl:GetWide() - 10, pnl:GetTall() - btnadd:GetTall() - 15 )

	btnadd.DoClick = function()
		displayBlockDialogue( pnl, list )
	end

	loadBlockedNumbers( list )
end

rPhone.RegisterEventCallback( "SETTINGS_Initialize", function( apk_settings )
	os_settings = apk_settings.GetSettings( OS.PackageName )
	os_settings.blocked_numbers = os_settings.blocked_numbers or {}
end )

rPhone.RegisterEventCallback( "SETTINGS_PopulateMenu", function( apk_settings )
	apk_settings.AddSettingsPage( "Blocked Numbers", {
		Category = "General",
		PackageName = OS.PackageName,
		PerformLayout = settingsPageLayout
	} )
end )

rPhone.RegisterEventCallback( "CONTACTS_Initialize", function( _apk_contacts )
	apk_contacts = _apk_contacts 
end )



function OS.IsNumberBlocked( num )
	num = rPhone.ToRawNumber( num )

	return os_settings.blocked_numbers[num] == true
end

function OS.GetBlockedNumbers()
	local ret = {}

	for num in pairs( os_settings.blocked_numbers ) do
		table.insert( ret, num )
	end

	return ret
end

function OS.BlockNumber( num )
	num = rPhone.ToRawNumber( num )

	os_settings.blocked_numbers[num] = true
end

function OS.UnblockNumber( num )
	num = rPhone.ToRawNumber( num )

	os_settings.blocked_numbers[num] = nil
end
