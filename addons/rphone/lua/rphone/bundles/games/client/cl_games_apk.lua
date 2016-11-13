
local APP = rPhone.CreateAppPackage( "games" )

APP.Launchable = true
APP.DisplayName = "Games"
APP.Icon = "dan/rphone/icons/gamepad.png"


local games_pdbi

local games = {}

local GAME = {}

function GAME:GetSize()
	return self:GetWidth(), self:GetHeight()
end


function GAME:Initialize()
end

function GAME:Think()
end

function GAME:Draw()
end

function GAME:Finalize()
end

rPhone.RegisterEventCallback( "OS_Initialize", function( pk_os )
	games_pdbi = pk_os.Util.CreatePDBI( APP.PackageName )
	games_pdbi.games = games_pdbi.games or {}
end )



function APP.RegisterGame( name, gtbl )
	gtbl = gtbl or {}
	gtbl.DisplayName = name

	games[name] = gtbl

	return gtbl
end



function APP:Initialize( params )
	self.pk_os = rPhone.AssertPackage( "os" )

	local canv = self:GetCanvas()
	self.pgman = self.pk_os.Util.CreatePageManager( canv )

	self:DisplayGameList()
end

function APP:Think()
	if self.gameinst then
		self.gameinst:Think( SysTime() - self.lastupdate )

		self.lastupdate = SysTime()
	end
end

function APP:StartGame( name )
	self:EndGame()

	local gtbl = games[name]

	if !gtbl then return false end

	games_pdbi.games[name] = games_pdbi.games[name] or {}

	local page = self.pgman:NewPage()
	local pw, ph = page:GetSize()
	local gdb = games_pdbi.games[name]
	local ginst = setmetatable( 
		{
			GetDB = function()
				return gdb
			end,

			GetPanel = function()
				return page
			end,
			GetWidth = function()
				return pw
			end,
			GetHeight = function()
				return ph
			end,

			IsInForeground = function()
				return self.pk_os.GetForegroundApp() == self
			end
		}, 
		{ 
			__index = function( self, k ) 
				return gtbl[k] or GAME[k] 
			end 
		}
	)

	self.gameinst = ginst
	self.lastupdate = SysTime()

	page.Paint = function()
		surface.SetDrawColor( 0, 0, 0, 255 )
		surface.DrawRect( 0, 0, pw, ph )

		ginst:Draw( pw, ph )
	end

	ginst:Initialize( gdb )	

	self.pk_os.SetAppTitle( self, ([[%s (%s)]]):format( APP.DisplayName, name ) )

	return true
end

function APP:EndGame()
	if self.gameinst then
		self.gameinst:Finalize( self.gameinst:GetDB() )
		self.gameinst = nil

		games_pdbi:Commit()

		self.pgman:GoBack()
	end
end

function APP:AddGameButton( name, list )
	local pnl = rPhone.CreatePanel( "RPDContentButton" )
		pnl.DoClick = function()
			self:StartGame( name )
		end

	local lblname = rPhone.CreatePanel( "DLabel", pnl )
		lblname:SetFont( "DermaDefaultBold" )
		lblname:SetText( name )
		lblname:SizeToContents()
		lblname:SetPos( 4, 2 )

	pnl:SetTall( lblname:GetTall() + 6 )

	list:AddItem( pnl )
end

function APP:DisplayGameList()
	local page = self.pgman:NewPage( false, "gamelist" )

	local list = rPhone.CreatePanel( "RPDCategoryList", page )
		list:SetPos( 5, 5 )
		list:SetSize( page:GetWide() - 10, page:GetTall() - 10 )

	local iter = rPhone.SortedPairsFunc( games, function( n1, _, n2, _ )
		return n1:lower() < n2:lower()
	end )

	for name in iter do
		self:AddGameButton( name, list )
	end
end

function APP:OnBackPressed()
	if self.pgman:GetCurrentPageName() == "gamelist" then
		self:Kill()
	else
		self:EndGame()

		self.pk_os.SetAppTitle( self, APP.DisplayName )
	end

	return true
end

function APP:Finalize()
	self:EndGame()
end
