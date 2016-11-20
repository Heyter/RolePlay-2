
local APP = rPhone.CreateAppPackage( "directory" )

APP.Launchable = true
APP.DisplayName = "Directory"
APP.Icon = "dan/rphone/icons/person02.png"


local list_all = rPhone.GetVariable( "DIRECTORY_LIST_ALL", false )
local include_default = rPhone.GetVariable( "DIRECTORY_INCLUDE_DEFAULT", true )

local directory_pdbi


local function sendIncludePreference( include )
	net.Start( "rphone_directory_include" )
		net.WriteBit( include )
	net.SendToServer()
end

net.Receive( "rphone_directory_update", function( len )
	local cnt = net.ReadUInt( 8 )
	local numbers = {}

	for i=1, cnt do
		local ply = net.ReadEntity()

		if IsValid( ply ) then
			numbers[ply:GetRPVar( "rpname")] = net.ReadString()
		end
	end

	for _, app in pairs( rPhone.GetRunningApps() ) do
		if app.PackageName == APP.PackageName then
			app:UpdateDirectory( numbers )
		end
	end
end )

rPhone.RegisterEventCallback( "OS_Initialize", function( pk_os )
	directory_pdbi = pk_os.Util.CreatePDBI( APP.PackageName )

	if !list_all then
		if directory_pdbi.include == nil then
			directory_pdbi.include = include_default
		end

		sendIncludePreference( directory_pdbi.include )
	end
end )



function APP:Initialize( params )
	self.pk_os = rPhone.AssertPackage( "os" )
	self.apk_contacts = rPhone.AssertPackage( "contacts" )

	self.canv = self:GetCanvas()
	
	self:DisplayDirectory()
end

function APP:AddDirectoryEntry( name, num )
	local nicenum = rPhone.ToNiceNumber( num )

	local pnl = rPhone.CreatePanel( "RPDContentButton" )
		pnl.DoClick = function()
			local menu = rPhone.CreatePanel( "RPDMenu", self.list )
				menu:AddOption( "Dial", function()
					local params = { Number = num }

					self.pk_os.LaunchApp( "phone", params )
				end )
				menu:AddOption( "SMS", function()
					local params = { Number = num }

					self.pk_os.LaunchApp( "sms", params )
				end )
				menu:AddSpacer()
				if !self.apk_contacts.GetContactInfo( num ) then
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
		pnl.DoRightClick = pnl.DoClick

	local lblnamenum = rPhone.CreatePanel( "DLabel", pnl )
		lblnamenum:SetFont( "DermaDefaultBold" )
		lblnamenum:SetText( name .. " - " .. nicenum )
		lblnamenum:SizeToContents()
		lblnamenum:SetPos( 4, 2 )

	pnl:SetTall( lblnamenum:GetTall() + 6 )

	self.list:AddItem( pnl )
end

function APP:UpdateDirectory( numbers )
	if IsValid( self.lblload ) then
		self.lblload:Remove()
	end

	self.list:Clear()

	local iter = rPhone.SortedPairsFunc(
		numbers,
		function( n1, _, n2, _ )
			return n1:lower() < n2:lower()
		end
	)
	local prevcat

	for name, num in iter do
		local fchar = name[1]:upper()

		if prevcat != fchar then
			self.list:AddCategory( fchar )

			prevcat = fchar
		end

		self:AddDirectoryEntry( name, num )
	end
end

function APP:DisplayDirectory()
	local w, h = self.canv:GetSize()

	self.list = self.canv:AddPanel( "RPDCategoryList" )
		self.list:SetPos( 5, 5 )
		self.list:SetWide( w - 10 )

	if !list_all then
		local cbinclude = self.canv:AddPanel( "DCheckBoxLabel" )
			cbinclude:SetText( "Include me in listing" )
			cbinclude:SizeToContents()
			cbinclude:SetPos( 5, h - cbinclude:GetTall() - 5 )
			cbinclude:SetChecked( directory_pdbi.include == true )
			function cbinclude:OnChange( checked )
				directory_pdbi.include = checked
				directory_pdbi:Commit()

				sendIncludePreference( checked )
			end

		self.list:SetTall( cbinclude.y - 10 )
	else
		self.list:SetTall( h - 10 )
	end

	self.lblload = self.canv:AddPanel( "DLabel" )
		self.lblload:SetText( "Loading..." )
		self.lblload:SizeToContents()
		self.lblload:SetPos( (w - self.lblload:GetWide()) / 2, (h - self.lblload:GetTall()) / 2 )

	net.Start( "rphone_directory_update" )
	net.SendToServer()
end
