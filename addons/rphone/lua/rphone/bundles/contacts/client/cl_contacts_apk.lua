
surface.CreateFont( "rphone_contacts_name", {
	font = "DermaDefaultBold",
	size = 16,
	weight = 600
} )


local APP = rPhone.CreateAppPackage( "contacts" )

APP.Launchable = true
APP.DisplayName = "Contacts"
APP.Icon = "dan/rphone/icons/person03.png"


local contacts_pdbi
local contact_actions = {}

rPhone.RegisterEventCallback( "OS_Initialize", function( pk_os )
	contacts_pdbi = pk_os.Util.CreatePDBI( APP.PackageName )
	contacts_pdbi.contacts = contacts_pdbi.contacts or {}

	rPhone.TriggerEvent( "CONTACTS_Initialize", APP )
	rPhone.TriggerEvent( "CONTACTS_AddContactActions", APP )
end )



function APP.GetContacts()
	if !contacts_pdbi then return {} end

	return table.Copy( contacts_pdbi.contacts )
end

function APP.GetContactInfo( num )
	if !contacts_pdbi then return end

	num = rPhone.ToRawNumber( num )

	local cinfo = contacts_pdbi.contacts[num]

	if cinfo then
		return table.Copy( cinfo )
	end
end

function APP.GetContactName( num )
	return (APP.GetContactInfo( num ) or {}).Name
end

function APP.AddContact( num, name, noupdate )
	if !contacts_pdbi then return end

	num = rPhone.ToRawNumber( num )

	if !rPhone.IsValidNumber( num ) then return end

	contacts_pdbi.contacts[num] = {
		Name = name
	}

	if !noupdate then
		contacts_pdbi:Commit()
	end
end

function APP.RemoveContact( num, noupdate )
	if !contacts_pdbi then return end

	num = rPhone.ToRawNumber( num )

	if contacts_pdbi.contacts[num] then
		contacts_pdbi.contacts[num] = nil

		if !noupdate then
			contacts_pdbi:Commit()
		end
	end
end

function APP.AddContactAction( name, func )
	contact_actions[name] = func
end



function APP:Initialize( params )
	self.pk_os = rPhone.AssertPackage( "os" )

	local canv = self:GetCanvas()
	self.pgman = self.pk_os.Util.CreatePageManager( canv )

	self:DisplayContacts()

	if params.AddNumber then
		local num = rPhone.ToRawNumber( params.AddNumber )

		self:ModifyContact( num )
	end
end

function APP:ModifyContact( num )
	local name, nicenum
	local updateValidity

	if num then
		num = rPhone.ToRawNumber( num )
		
		name = APP.GetContactName( num )
		nicenum = rPhone.ToNiceNumber( num )
	end

	local pnl = self.pgman:SimplePopup( true )
		pnl:SetSize( 225, 80 )

	local lblname = rPhone.CreatePanel( "DLabel", pnl )
		lblname:SetText( "Name:" )
		lblname:SizeToContents()
		lblname:SetPos( 5, 7 )

	local txtname = rPhone.CreatePanel( "DTextEntry", pnl )
		if name then
			txtname:SetText( name )
			txtname:SetCaretPos( #name )
		end
		txtname:RequestFocus()
		function txtname:OnTextChanged()
			updateValidity()
		end

	local lblnum = rPhone.CreatePanel( "DLabel", pnl )
		lblnum:SetText( "Number:" )
		lblnum:SizeToContents()
		lblnum:SetPos( 5, txtname:GetTall() + 12 )

	local txtnum = rPhone.CreatePanel( "DTextEntry", pnl )
		if nicenum then
			txtnum:SetText( nicenum )
			txtnum:SetCaretPos( #nicenum )
		end
		txtnum:SetWide( pnl:GetWide() - lblnum:GetWide() - 15 )
		txtnum:SetPos( lblnum:GetWide() + 10, txtname:GetTall() + 10 )
		function txtnum:OnTextChanged()
			updateValidity()
		end

	txtname:SetPos( lblnum:GetWide() + 10, 5 )
	txtname:SetWide( txtnum:GetWide() )

	local btnconf = rPhone.CreatePanel( "RPDTextButton", pnl )
		btnconf:SetText( "Submit" )
		btnconf:SetSize( (pnl:GetWide() / 2) - 7, 20 )
		btnconf:SetPos( (pnl:GetWide() / 2) + 2, pnl:GetTall() - 25 )
		btnconf.DoClick = function()
			local namestr, numstr = txtname:GetText(), txtnum:GetText()

			self.pgman:GoBack()

			numstr = rPhone.ToRawNumber( numstr )

			if #namestr < 1 or !rPhone.IsValidNumber( numstr ) then return end

			if num then
				APP.RemoveContact( num, true )
			end

			APP.AddContact( numstr, namestr )

			self:LoadContacts()
		end
		
	local btncanc = rPhone.CreatePanel( "RPDTextButton", pnl )
		btncanc:SetText( "Cancel" )
		btncanc:SetSize( (pnl:GetWide() / 2) - 7, 20 )
		btncanc:SetPos( 5, pnl:GetTall() - 25 )
		btncanc.DoClick = function()
			self.pgman:GoBack()
		end

	function updateValidity()
		local namestr, numstr = txtname:GetText(), txtnum:GetText()
		local num = rPhone.ToRawNumber( numstr )

		if #namestr < 1 or !rPhone.IsValidNumber( num ) then
			btnconf:SetDisabled( true )
			btnconf:SetTextColor( Color( 180, 180, 180, 255 ) )
		else
			btnconf:SetDisabled( false )
			btnconf:SetTextColor( Color( 255, 255, 255, 255 ) )
		end
	end

	updateValidity()
end

function APP:AddContactButton( name, num )
	if !IsValid( self.contacts_list ) then return end

	num = rPhone.ToRawNumber( num )
	local nicenum = rPhone.ToNiceNumber( num )

	local pnl = rPhone.CreatePanel( "RPDContentButton" )
		pnl.DoClick = function()
			local iter = rPhone.SortedPairsFunc(
				contact_actions,
				function( n1, _, n2, _ )
					return n1:lower() < n2:lower()
				end
			)

			local menu = rPhone.CreatePanel( "RPDMenu", self.contacts_list )
				for name, func in iter do
					menu:AddOption( name, function()
						if !self:IsRunning() then return end

						func( num, self )
					end )
				end
				if #iter > 0 then
					menu:AddSpacer()
				end
				if self.pk_os.IsNumberBlocked( num ) then
					menu:AddOption( "Unblock", function()
						self.pk_os.UnblockNumber( num )
					end )
				else
					menu:AddOption( "Block", function()
						self.pk_os.BlockNumber( num )
					end )
				end
				menu:AddOption( "Edit", function()
					if !self:IsRunning() then return end

					self:ModifyContact( num )
				end )
				menu:AddOption( "Remove", function()
					if !self:IsRunning() then return end

					APP.RemoveContact( num )
					self:LoadContacts()
				end )
				menu:Open()
		end
		pnl.DoRightClick = pnl.DoClick

	local lblname = rPhone.CreatePanel( "DLabel", pnl )
		lblname:SetPos( 4, 2 )
		lblname:SetFont( "rphone_contacts_name" )
		lblname:SetText( name )
		lblname:SizeToContents()	

	local lblnum = rPhone.CreatePanel( "DLabel", pnl )
		lblnum:SetText( ([[(%s)]]):format( nicenum ) )
		lblnum:SizeToContents()
		lblnum:SetPos( lblname:GetWide() + 10, 2 + (lblname:GetTall() - lblnum:GetTall()) / 2 )

	pnl:SetTall( lblname:GetTall() + 4 )

	self.contacts_list:AddItem( pnl )
end

function APP:LoadContacts()
	if !IsValid( self.contacts_list ) then return end

	self.contacts_list:Clear( true )

	local contacts = APP.GetContacts()
	local iter = rPhone.SortedPairsFunc(
		contacts,
		function( _, ci1, _, ci2 )
			return (ci1.Name or ''):lower() < (ci2.Name or ''):lower()
		end
	)

	local prevcat

	for num, cinfo in iter do
		local name = cinfo.Name

		if !name then continue end

		local fchar = name[1]:upper()

		if prevcat != fchar then
			self.contacts_list:AddCategory( fchar )

			prevcat = fchar
		end

		self:AddContactButton( name, num )
	end
end

function APP:DisplayContacts()
	local page = self.pgman:NewPage()

	self.contacts_list = rPhone.CreatePanel( "RPDCategoryList", page )
		self.contacts_list:SetPos( 5, 5 )

	local btnadd = rPhone.CreatePanel( "RPDTextButton", page )
		btnadd:SetText( "Add Contact" )
		btnadd:SetPos( 5, page:GetTall() - btnadd:GetTall() - 5 )
		btnadd:SetSize( 100, 25 )
		btnadd.DoClick = function()
			self:ModifyContact()
		end

	self.contacts_list:SetSize( page:GetWide() - 10, page:GetTall() - btnadd:GetTall() - 15 )

	self:LoadContacts()
end

function APP:OnBackPressed()
	self.pgman:GoBack()

	if !self.pgman:GetCurrentPage() then
		self:Kill()
	end

	return true
end
