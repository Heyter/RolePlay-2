
local APP = rPhone.CreateAppPackage( "settings" )

APP.Launchable = true
APP.DisplayName = "Settings"
APP.Icon = "dan/rphone/icons/settings.png"


local settings_pdbi
local settings_pages = {}
local settings_categories = {
	"General",
	"Apps",
	"System",
	"Other"
}

rPhone.RegisterEventCallback( "OS_Initialize", function( pk_os )
	settings_pdbi = pk_os.Util.CreatePDBI( APP.PackageName )
	settings_pdbi.settings = settings_pdbi.settings or {}

	rPhone.TriggerEvent( "SETTINGS_Initialize", APP )
	rPhone.TriggerEvent( "SETTINGS_PopulateMenu", APP )
end )



function APP.GetSettings( pname )
	if !settings_pdbi then return end

	settings_pdbi.settings[pname] = settings_pdbi.settings[pname] or {}

	return settings_pdbi.settings[pname]
end

function APP.CommitSettings()
	if settings_pdbi then
		settings_pdbi:Commit()
	end
end

function APP.AddSettingsPage( name, info )
	info = info or {}
	info.Category = info.Category or "Other"

	settings_pages[name] = {
		PackageName = info.PackageName,
		Category = info.Category,
		PerformLayout = info.PerformLayout,
		OnClose = info.OnClose
	}

	if !table.HasValue( settings_categories, info.Category )then
		table.insert( settings_categories, info.Category )
	end
end



function APP:Initialize( params )
	self.pk_os = rPhone.AssertPackage( "os" )

	local canv = self:GetCanvas()
	self.pgman = self.pk_os.Util.CreatePageManager( canv )

	if params.PageName then
		if !self:DisplaySettingsPage( params.PageName ) then
			self:Kill()
		end
	else
		self:DisplaySettingsOverview()
	end
end

function APP:DisplaySettingsPage( name )
	local pinfo = settings_pages[name]

	if !pinfo or !pinfo.PerformLayout then return false end

	local page = self.pgman:NewPage()
	local settings

	if pinfo.PackageName then
		settings = APP.GetSettings( pinfo.PackageName )
	end

	pinfo.PerformLayout( page, settings )

	self.pk_os.SetAppTitle( self, ([[%s (%s)]]):format( APP.DisplayName, name ) )

	self.page_closefunc = pinfo.OnClose

	return true
end

function APP:AddSettingsPageButton( pname, list )
	local pnl = rPhone.CreatePanel( "RPDContentButton" )
		pnl.DoClick = function()
			self:DisplaySettingsPage( pname )
		end

	local lblname = rPhone.CreatePanel( "DLabel", pnl )
		lblname:SetFont( "DermaDefaultBold" )
		lblname:SetText( pname )
		lblname:SizeToContents()
		lblname:SetPos( 4, 2 )

	pnl:SetTall( lblname:GetTall() + 6 )

	list:AddItem( pnl )
end

function APP:DisplaySettingsOverview()
	local page = self.pgman:NewPage()

	local list = rPhone.CreatePanel( "RPDCategoryList", page )
		list:SetPos( 5, 5 )
		list:SetSize( page:GetWide() - 10, page:GetTall() - 10 )

	for _, cat in ipairs( settings_categories ) do
		local sorted = {}

		for name, info in pairs( settings_pages ) do
			if info.Category == cat then
				table.insert( sorted, name )
			end
		end

		if #sorted == 0 then continue end

		list:AddCategory( cat )

		table.sort( sorted, function( n1, n2 ) return n1:lower() < n2:lower() end )

		for _, name in ipairs( sorted ) do
			self:AddSettingsPageButton( name, list )
		end
	end
end

function APP:OnSettingsPageClosed()
	if self.page_closefunc then
		self.page_closefunc()

		self.page_closefunc = nil
	end
end

function APP:OnBackPressed()
	self.pgman:GoBack()

	self:OnSettingsPageClosed()

	if !self.pgman:GetCurrentPage() then
		self:Kill()
	else
		self.pk_os.SetAppTitle( self, APP.DisplayName )
	end

	return true
end

function APP:Finalize()
	self:OnSettingsPageClosed()
	
	APP.CommitSettings()
end
