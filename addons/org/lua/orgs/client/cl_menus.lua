surface.CreateFont( "titlefont", {
	font = "bebasneue",
	size = 30,
	weight = 300,
	antialias = true
} )

surface.CreateFont( "InviteTextFont", {
	font = "Open Sans",
	size = 18,
	weight = 400,
	antialias = true
} )

-- Org menu fonts.
surface.CreateFont( "TextFont", {
	font = "Roboto Cn",
	size = 30,
	weight = 800,
	antialias = true
} )

surface.CreateFont( "MainTitleFont", {
	font = "Roboto Cn",
	size = 30,
	weight = 400,
	antialias = true
} )

surface.CreateFont( "MoTDTextFont", {
	font = "Open Sans",
	size = 22,
	weight = 400,
	antialias = true
} )

-- Player list fonts.
surface.CreateFont( "NameFont", {
	font = "Roboto Cn",
	size = 24,
	weight = 400,
	antialias = true
} )

surface.CreateFont( "RankFont", {
	font = "Roboto Cn",
	size = 22,
	weight = 400,
	antialias = true
} )

surface.CreateFont( "StateFont", {
	font = "Roboto Cn",
	size = 20,
	weight = 400,
	antialias = true
} )

net.Receive("orgmenu", function()
	local data = net.ReadTable()
	local mainFrame = vgui.Create( "DFrame" )
	mainFrame:SetSize( 700, 400 )
	mainFrame:SetTitle( "" )
	mainFrame:SetVisible( true )
	mainFrame:SetDraggable( true )
	mainFrame:ShowCloseButton( false )
	mainFrame:Center()
	mainFrame:MakePopup()
	mainFrame.Paint = function()
		draw.RoundedBox( 0, 0, 0, mainFrame:GetWide(), mainFrame:GetTall(), Color(226,226,226) )
	end
	
	local closeButton = vgui.Create("DButton", mainFrame)
	closeButton:SetSize( 70, 20 )
	closeButton:SetPos( 630 , 0 )
	closeButton:SetColor( Color( 255, 255, 255 ))
	closeButton:SetText("X")

	closeButton.Paint = function( )
		if closeButton.isHover then
			draw.RoundedBox( 0, 0, 0, closeButton:GetWide(), closeButton:GetTall(), Color( 192, 57, 43 ) )
		else
			draw.RoundedBox( 0, 0, 0, closeButton:GetWide(), closeButton:GetTall(), Color( 231, 76, 60 ) )
		end
	end

	closeButton.OnCursorEntered = function()
		closeButton.isHover = true
	end

	closeButton.OnCursorExited = function()
		closeButton.isHover = false
	end

	closeButton.DoClick = function()
		mainFrame:Close()
	end

	local orgNameLabel = vgui.Create("DLabel", mainFrame)
	orgNameLabel:SetText( data[1]["name"] )
	orgNameLabel:SetFont("MainTitleFont")
	orgNameLabel:SetColor( Color( 52, 73, 94 ) )
	orgNameLabel:SizeToContents()
	orgNameLabel:SetPos( 210, 3 )

	local sideMenu = vgui.Create("DSidemenu", mainFrame)
	sideMenu:SetPos( 0, 0 )
	sideMenu:SetSize( 200, 400 )

	local dashboardPanel = vgui.Create("DCustomPanel", mainFrame)
	dashboardPanel:Title( ORGS_Lang.dashboard )

	local panelsHolder = vgui.Create("DPanelList", dashboardPanel)
	panelsHolder:SetPos(10, 45)
	panelsHolder:SetSize( 480, 200 )
	panelsHolder:SetSpacing( 15 )
	panelsHolder:EnableHorizontal( true ) 

	local membersBlock = vgui.Create("DPanel")
	membersBlock:SetTall( 120 )
	membersBlock:SetWide( 150 )
	membersBlock.Paint = function()
		draw.RoundedBox( 0, 0, 0, membersBlock:GetWide(), membersBlock:GetTall(), Color( 59, 174, 218 ) )
		draw.RoundedBox( 0, 0,  membersBlock:GetTall() - 30, membersBlock:GetWide(), 30, Color( 255, 255, 255 ) )
	end
	local membersBlockLabel = vgui.Create("DLabel", membersBlock)
	membersBlockLabel:SetColor( Color( 148, 148, 150 ) )
	membersBlockLabel:SetFont("FlatButtonsFont")
	membersBlockLabel:SetText("Members")
	membersBlockLabel:SizeToContents()
	membersBlockLabel:SetPos( membersBlock:GetWide() / 2 - membersBlockLabel:GetWide() / 2, 93 )
	local membersBlockImage = vgui.Create("DImage", membersBlock)
	membersBlockImage:SetImage( "org/members.png" )
	membersBlockImage:SizeToContents()
	membersBlockImage:SetPos( membersBlock:GetWide() / 2 - membersBlockImage:GetWide() / 2, 12 )
	local membersBlockLabel = vgui.Create("DLabel", membersBlock)
	membersBlockLabel:SetColor( Color( 255, 255, 255 ) )
	membersBlockLabel:SetFont("TextFont")
	membersBlockLabel:SetText(table.Count( data[3] ))
	membersBlockLabel:SizeToContents()
	membersBlockLabel:SetPos( membersBlock:GetWide() / 2 - membersBlockLabel:GetWide() / 2, 50 )
	panelsHolder:AddItem( membersBlock )

	local onlineMembersBlock = vgui.Create("DPanel")
	onlineMembersBlock:SetTall( 120 )
	onlineMembersBlock:SetWide( 150 )
	onlineMembersBlock.Paint = function()
		draw.RoundedBox( 0, 0, 0, onlineMembersBlock:GetWide(), onlineMembersBlock:GetTall(), Color( 246, 187, 67 ) )
		draw.RoundedBox( 0, 0,  onlineMembersBlock:GetTall() - 30, onlineMembersBlock:GetWide(), 30, Color( 255, 255, 255 ) )
	end
	local onlineMembersBlockLabel = vgui.Create("DLabel", onlineMembersBlock)
	onlineMembersBlockLabel:SetColor( Color( 148, 148, 150 ) )
	onlineMembersBlockLabel:SetFont("FlatButtonsFont")
	onlineMembersBlockLabel:SetText("Online")
	onlineMembersBlockLabel:SizeToContents()
	onlineMembersBlockLabel:SetPos( onlineMembersBlock:GetWide() / 2 - onlineMembersBlockLabel:GetWide() / 2, 93 )
	local onlineMembersBlockImage = vgui.Create("DImage", onlineMembersBlock)
	onlineMembersBlockImage:SetImage( "org/online.png" )
	onlineMembersBlockImage:SizeToContents()
	onlineMembersBlockImage:SetPos( onlineMembersBlock:GetWide() / 2 - onlineMembersBlockImage:GetWide() / 2, 12 )
	local onlineMembersLabel = vgui.Create("DLabel", onlineMembersBlock)
	onlineMembersLabel:SetColor( Color( 255, 255, 255 ) )
	onlineMembersLabel:SetFont("TextFont")
	local online = {}
	for k,v in pairs( data[3] ) do
		if player.GetBySteamID(v.steamid) != false then table.insert(online, v.steamid) end
	end
	onlineMembersLabel:SetText(table.Count( online ))
	onlineMembersLabel:SizeToContents()
	onlineMembersLabel:SetPos( onlineMembersBlock:GetWide() / 2 - onlineMembersLabel:GetWide() / 2, 50 )
	panelsHolder:AddItem( onlineMembersBlock )

	local orgBalanceBlock = vgui.Create("DPanel")
	orgBalanceBlock:SetTall( 120 )
	orgBalanceBlock:SetWide( 150 )
	orgBalanceBlock.Paint = function()
		draw.RoundedBox( 0, 0, 0, orgBalanceBlock:GetWide(), orgBalanceBlock:GetTall(), Color( 54, 188, 155 ) )
		draw.RoundedBox( 0, 0,  orgBalanceBlock:GetTall() - 30, orgBalanceBlock:GetWide(), 30, Color( 255, 255, 255 ) )
	end
	local orgBalanceBlockLabel = vgui.Create("DLabel", orgBalanceBlock)
	orgBalanceBlockLabel:SetColor( Color( 148, 148, 150 ) )
	orgBalanceBlockLabel:SetFont("FlatButtonsFont")
	orgBalanceBlockLabel:SetText("Balance")
	orgBalanceBlockLabel:SizeToContents()
	orgBalanceBlockLabel:SetPos( orgBalanceBlock:GetWide() / 2 - orgBalanceBlockLabel:GetWide() / 2, 93 )
	local orgBalanceBlockImage = vgui.Create("DImage", orgBalanceBlock)
	orgBalanceBlockImage:SetImage( "org/dollar.png" )
	orgBalanceBlockImage:SizeToContents()
	orgBalanceBlockImage:SetPos( orgBalanceBlock:GetWide() / 2 - orgBalanceBlockImage:GetWide() / 2, 12 )
	local orgBalanceBlockLabel = vgui.Create("DLabel", orgBalanceBlock)
	orgBalanceBlockLabel:SetColor( Color( 255, 255, 255 ) )
	orgBalanceBlockLabel:SetFont("TextFont")
	orgBalanceBlockLabel:SetText( data[1]["bankbalance"] )
	orgBalanceBlockLabel:SizeToContents()
	orgBalanceBlockLabel:SetPos( orgBalanceBlock:GetWide() / 2 - orgBalanceBlockLabel:GetWide() / 2, 50 )
	panelsHolder:AddItem( orgBalanceBlock )

	local motdTitle = vgui.Create("DLabel", dashboardPanel)
	motdTitle:SetText( "MoTD" )
	motdTitle:SetFont( "TitlesFont" )
	motdTitle:SetPos( 10, 185 )
	motdTitle:SizeToContents()
	motdTitle:SetColor(Color(52, 73, 94))

	local motd = vgui.Create("DLabel", dashboardPanel)
	motd:SetPos( 10, 225 )
	motd:SetAutoStretchVertical( true )
	motd:SetWide( 470 )
	motd:SetWrap( true )
	motd:SetFont("MoTDTextFont")
	motd:SetColor( Color( 0, 0, 0 ) )
	motd:SetText( data[1]["motd"] )

	net.Receive("refreshclientmotd", function()
		if motd:IsValid() then
			motd:SetText( net.ReadString() )
		end
	end)
	sideMenu:AddMenuButton(ORGS_Lang.dashboard, "org/online.png", dashboardPanel)

	local membersPanel = vgui.Create("DCustomPanel", mainFrame)
	membersPanel:Title( ORGS_Lang.members )

	local playerListHolder = vgui.Create("DPanelList", membersPanel)
	playerListHolder:SetPos( 10, 45 )
	playerListHolder:SetSize( 475, 310 )
	playerListHolder:SetSpacing( 7 )
	playerListHolder:EnableVerticalScrollbar( true )

	function addMember( name, rank, online, steamid, lastseen )
		local playerPanel = vgui.Create("DPanel")
		playerPanel:SetTall( 65 )
		playerPanel.Paint = function()
			draw.RoundedBox( 2, 0, 0, playerPanel:GetWide(), playerPanel:GetTall(), Color( 247, 246, 241 ) )
			surface.SetDrawColor( 231, 230, 225 )
			surface.DrawLine( 60, 35, playerPanel:GetWide() - 20, 35 )
		end

		local playerName = vgui.Create("DLabel", playerPanel)
		playerName:SetText(name)
		playerName:SetColor(Color(126, 127, 131))
		playerName:SetPos( 62, 10 )
		playerName:SetFont("NameFont")
		playerName:SizeToContents()

		local playerNank = vgui.Create("DLabel", playerPanel)
		playerNank:SetText(rank)
		playerNank:SetColor(Color(180, 180, 180))
		playerNank:SetPos( 63, 38 )
		playerNank:SetFont("RankFont")
		playerNank:SizeToContents()

		local playerState = vgui.Create("DLabel", playerPanel)
		playerState:SetText(online)
		playerState:SetColor(Color(180, 180, 180))
		playerState:SetPos( 410, 11 )
		playerState:SetFont("StateFont")
		playerState:SizeToContents()

		if table.HasValue(data[2], "e") or table.HasValue(data[2], "f") then
			local playerOptions = vgui.Create("DButton", playerPanel )
			playerOptions:SetPos( 405, 40 )
			playerOptions:SetSize( 24, 24 )
			playerOptions:SetImage("org/option.png")
			playerOptions:SetText("")
			playerOptions.DoClick = function()
				local memberOptions = DermaMenu()
				if table.HasValue(data[2], "e") then
					memberOptions:AddOption("Kick Member", function() 
						Derma_Query("Are you sure that you want to kick ".. name .." from the "..ORGS_Config.addonName.."?", "Warning!",
							ORGS_Lang.yes, function() RunConsoleCommand("org_kickmember", steamid) end,
							ORGS_Lang.no)
					end)
				end
				if table.HasValue(data[2], "f") then
					if data[4] != nil then
						local promoteMenu = memberOptions:AddSubMenu(ORGS_Lang.updaterank)
						for k,v in pairs(data[4]) do
							promoteMenu:AddOption(v["name"], function() RunConsoleCommand("org_setrank", steamid, v["id"]) end)
						end
					end
				end
				memberOptions:Open()
			end
			playerOptions.Paint = function() end
		end
		
		if player.GetBySteamID(steamid) then
			local playerSteamurl = vgui.Create("DButton", playerPanel)
			playerSteamurl:SetPos( 428, 40 )
			playerSteamurl:SetSize( 24, 24 )
			playerSteamurl:SetImage("org/steam.png")
			playerSteamurl:SetText("")
			playerSteamurl.DoClick = function()
				gui.OpenURL("http://steamcommunity.com/profiles/".. player.GetBySteamID(steamid):SteamID64())
			end
			playerSteamurl.Paint = function() end

			local playerAvatar = vgui.Create("CircleAvater", playerPanel)
			playerAvatar:SetPos( 7, 8 )
			playerAvatar:SetSize( 50, 50 )
			playerAvatar:SetPlayer( player.GetBySteamID(steamid), 64 )
		else
			local playerAvatar = vgui.Create("DImage", playerPanel)
			playerAvatar:SetPos( 9, 10 )
			playerAvatar:SetSize( 45, 45 )
			playerAvatar:SetImage("org/offline.png")
			local playerLastseen = vgui.Create("DLabel", playerPanel)
			playerLastseen:SetText("Last seen on: " ..lastseen)
			playerLastseen:SetColor(Color(180, 180, 180))
			playerLastseen:SetPos( 230, 40 )
			playerLastseen:SetFont("StateFont")
			playerLastseen:SizeToContents()
		end
		playerListHolder:AddItem( playerPanel )		
	end

	for k,v in pairs( data[3] ) do
		local online
		local rankname
		if player.GetBySteamID(v.steamid) != false then online = "Online" else online = "Offline" end
		if (data[4] != nil and table.Count(data[4]) > 0) then
			for k,val in pairs(data[4]) do
				if tonumber(v.rank) == tonumber(val.id) then
					rankname = val.name
				elseif v.rank == "o" then
					rankname = ORGS_Lang.rankowner	
				elseif v.rank == "n" then
					rankname = ORGS_Lang.ranknewmember
				end
			end
		else
			if v.rank == "o" then
				rankname = ORGS_Lang.rankowner	
			elseif v.rank == "n" then
				rankname = ORGS_Lang.ranknewmember
			end
		end
		addMember( v.name, rankname, online, v.steamid, v.lastseen )
	end

	sideMenu:AddMenuButton(ORGS_Lang.members, "org/members.png", membersPanel)

	net.Receive("refreshclientplayerlist", function()
		if playerListHolder:IsValid() then
			playerListHolder:Clear()
			for k,v in pairs( net.ReadTable() ) do
				local online
				local rankname
				if player.GetBySteamID(v.steamid) != false then online = "Online" else online = "Offline" end
				if data[4] != nil then
					for k,val in pairs(data[4]) do
						if tonumber(v.rank) == tonumber(val.id) then
							rankname = val.name
						elseif v.rank == "o" then
							rankname = ORGS_Lang.rankowner	
						elseif v.rank == "n" then
							rankname = ORGS_Lang.ranknewmember
						end
					end
				else
					if v.rank == "o" then
						rankname = ORGS_Lang.rankowner	
					elseif v.rank == "n" then
						rankname = ORGS_Lang.ranknewmember
					end
				end
				addMember( v.name, rankname, online, v.steamid, v.lastseen )
			end
		end
	end)

	if ORGS_Config.enableOrgBank then
		if table.HasValue(data[2], "a") or table.HasValue(data[2], "b") then
			local orgBankPanel = vgui.Create("DCustomPanel", mainFrame)
			orgBankPanel:Title( ORGS_Lang.bank )
			local welcomeScreen = vgui.Create("DPanel", orgBankPanel)
			welcomeScreen:SetPos( 10, 45 )
			welcomeScreen:SetSize( 478, 310 )
			welcomeScreen.Paint = function() end

			local bankPanels = vgui.Create("DPanelList", welcomeScreen)
			bankPanels:SetPos( 0, 5 )
			bankPanels:SetSize( 478, 400 )
			bankPanels:SetSpacing( 10 )

			local balanceBlock = vgui.Create("DPanel")
			balanceBlock:SetTall( 75 )
			balanceBlock:SetWide( 478 )
			balanceBlock.Paint = function()
				draw.RoundedBox( 6, 0, 0, balanceBlock:GetWide(), balanceBlock:GetTall(), Color( 236, 240, 241 ) )
			end

			local balanceLabel = vgui.Create("DLabel", balanceBlock)
			balanceLabel:SetText( data[1]["bankbalance"] .."$" )
			balanceLabel:SetFont("TextFont")
			balanceLabel:SetColor( Color(52, 152, 219) )
			balanceLabel:SizeToContents()
			balanceLabel:SetPos(  balanceBlock:GetWide() / 2 - balanceLabel:GetWide() / 2, 8 )
		
			local subbalanceLabel = vgui.Create("DLabel", balanceBlock)
			subbalanceLabel:SetText( "Organisation Bank Balance" )
			subbalanceLabel:SetFont("FlatButtonsFont")
			subbalanceLabel:SetColor( Color(126, 127, 131) )
			subbalanceLabel:SizeToContents()
			subbalanceLabel:SetPos(  balanceBlock:GetWide() / 2 - subbalanceLabel:GetWide() / 2, 38 )

			bankPanels:AddItem( balanceBlock )

			local depositBlock = vgui.Create("DButton")
			depositBlock:SetText("")
			depositBlock:SetTall( 65 )
			depositBlock:SetWide( 478 )
			depositBlock.Paint = function()
				draw.RoundedBox( 6, 0, 0, depositBlock:GetWide(), depositBlock:GetTall(), Color( 236, 240, 241 ) )
			end

			local depositLabel = vgui.Create("DLabel", depositBlock)
			depositLabel:SetText( "Deposit" )
			depositLabel:SetFont("TextFont")
			depositLabel:SetColor( Color(126, 127, 131) )
			depositLabel:SizeToContents()
			depositLabel:SetPos( 8, 8 )
		
			local subdepositLabel = vgui.Create("DLabel", depositBlock)
			subdepositLabel:SetText( "Deposit money to the organisation bank." )
			subdepositLabel:SetFont("FlatButtonsFont")
			subdepositLabel:SetColor( Color(126, 127, 131) )
			subdepositLabel:SizeToContents()
			subdepositLabel:SetPos( 8, 35 )

			depositBlock.DoClick = function()
				Derma_StringRequest( ORGS_Lang.bank, ORGS_Lang.bankhowmuchdeposit, "Enter amount..", function(t) RunConsoleCommand("org_deposit", t) end)
			end
			bankPanels:AddItem( depositBlock )

			local withdrawBlock = vgui.Create("DButton")
			withdrawBlock:SetText("")
			withdrawBlock:SetTall( 65 )
			withdrawBlock:SetWide( 478 )
			withdrawBlock.Paint = function()
				draw.RoundedBox( 6, 0, 0, withdrawBlock:GetWide(), withdrawBlock:GetTall(), Color( 236, 240, 241 ) )
			end

			local withdrawLabel = vgui.Create("DLabel", withdrawBlock)
			withdrawLabel:SetText( "Withdraw" )
			withdrawLabel:SetFont("TextFont")
			withdrawLabel:SetColor( Color(126, 127, 131) )
			withdrawLabel:SizeToContents()
			withdrawLabel:SetPos( 8, 8 )
	
			local subwithdrawLabel = vgui.Create("DLabel", withdrawBlock)
			subwithdrawLabel:SetText( "Withdraw money from the organisation bank." )
			subwithdrawLabel:SetFont("FlatButtonsFont")
			subwithdrawLabel:SetColor( Color(126, 127, 131) )
			subwithdrawLabel:SizeToContents()
			subwithdrawLabel:SetPos( 8, 35 )

			withdrawBlock.DoClick = function()
				Derma_StringRequest( ORGS_Lang.bank, ORGS_Lang.bankhowmuchwithdraw, "Enter amount..", function(t) RunConsoleCommand("org_withdraw", t) end)
			end
			bankPanels:AddItem( withdrawBlock )

			sideMenu:AddMenuButton(ORGS_Lang.bank, "org/bank.png", orgBankPanel)

			net.Receive("refreshclientbank", function()
				if balanceLabel:IsValid() then
					balanceLabel:SetText(net.ReadString() .."$" )
					balanceLabel:SizeToContents()
					balanceLabel:SetPos(  balanceBlock:GetWide() / 2 - balanceLabel:GetWide() / 2, 8 )
				end
			end)
		end
	end

	if table.HasValue(data[2], "c") or table.HasValue(data[2], "d") or table.HasValue(data[2], "e") or table.HasValue(data[2], "f") or table.HasValue(data[2], "g") or table.HasValue(data[2], "h")  then
		local managePanel = vgui.Create("DCustomPanel", mainFrame)
		managePanel:Title( ORGS_Lang.manage )
		sideMenu:AddMenuButton(ORGS_Lang.manage, "org/manage.png", managePanel)

		local manageTabs = vgui.Create( "DPropertySheet", managePanel )
		manageTabs:SetSize(470, 310)
		manageTabs:SetPos( 10, 45 )
		manageTabs:SetPadding(5)

		manageTabs.Paint = function( panel )
			surface.SetDrawColor(Color(52, 73, 94, 250))
			surface.DrawRect(0, 0, panel:GetWide(), panel:GetTall())
		end
		manageTabs:SetSkin("managertab")

		if table.HasValue(data[2], "g") then
			local ranks = vgui.Create("DCustomPanel")
			local newRankName = vgui.Create("DTextEntry", ranks)
			newRankName:SetSize( 442, 35 )
			newRankName:SetPos( 5, 15 )
			newRankName:SetText( ORGS_Lang.rankname )
			newRankName:SetFont("FlatButtonsFont")
			newRankName.Paint = function( me )
				draw.RoundedBox( 0, 0, 0, newRankName:GetWide(), newRankName:GetTall(), Color( 255, 255, 255 ) )
				surface.SetDrawColor(189, 195, 199, 255)
				surface.DrawOutlinedRect(0, 0, newRankName:GetWide(), newRankName:GetTall())
				me:DrawTextEntryText(Color(52, 73, 94, 255), Color(52, 73, 94, 255), Color(52, 73, 94, 255))
			end

			local flagList = vgui.Create("DPanelList", ranks)
			flagList:SetSize(230, 470)
			flagList:SetPos(8, 65)
			flagList:SetSpacing( 15 )
			flagList:EnableHorizontal( true ) 

			local flags = {}

			flags[1] = vgui.Create( "DCheckBoxLabel" )
			flags[1]:SetText( ORGS_Lang.flagsdeposit )
			flags[1]:SetTextColor(Color(0,0,0))
			flags[1]:SizeToContents()
			flags[1]:SetWide( 100 )
			flags[1].flag = "a"
			flagList:AddItem( flags[1] )

			flags[2] = vgui.Create( "DCheckBoxLabel" )
			flags[2]:SetText( ORGS_Lang.flagswithdraw )
			flags[2]:SetTextColor(Color(0,0,0))
			flags[2]:SizeToContents()
			flags[2]:SetWide( 110 )
			flags[2].flag = "b"
			flagList:AddItem( flags[2] )

			flags[3] = vgui.Create( "DCheckBoxLabel" )
			flags[3]:SetText( ORGS_Lang.flagsinvite )
			flags[3]:SetTextColor(Color(0,0,0))
			flags[3]:SizeToContents()
			flags[3]:SetWide( 100 )
			flags[3].flag = "c"
			flagList:AddItem( flags[3] )

			flags[4] = vgui.Create( "DCheckBoxLabel" )
			flags[4]:SetText( ORGS_Lang.flagsmotd )
			flags[4]:SetTextColor(Color(0,0,0))
			flags[4]:SizeToContents()
			flags[4]:SetWide( 100 )
			flags[4].flag = "d"
			flagList:AddItem( flags[4] )

			flags[5] = vgui.Create( "DCheckBoxLabel" )
			flags[5]:SetText( ORGS_Lang.flagskick )
			flags[5]:SetTextColor(Color(0,0,0))
			flags[5]:SizeToContents()
			flags[5]:SetWide( 100 )
			flags[5].flag = "e"
			flagList:AddItem( flags[5] )

			flags[6] = vgui.Create( "DCheckBoxLabel" )
			flags[6]:SetText( ORGS_Lang.flagsranks )
			flags[6]:SetTextColor(Color(0,0,0))
			flags[6]:SizeToContents()
			flags[6]:SetWide( 100 )
			flags[6].flag = "f"
			flagList:AddItem( flags[6] )

			flags[7] = vgui.Create( "DCheckBoxLabel" )
			flags[7]:SetText( ORGS_Lang.flagsranks1 )
			flags[7]:SetTextColor(Color(0,0,0))
			flags[7]:SizeToContents()
			flags[7]:SetWide( 100 )
			flags[7].flag = "g"
			flagList:AddItem( flags[7] )

			flags[8] = vgui.Create( "DCheckBoxLabel" )
			flags[8]:SetText( "Create Meeting" )
			flags[8]:SetTextColor(Color(0,0,0))
			flags[8]:SizeToContents()
			flags[8]:SetWide( 100 )
			flags[8].flag = "h"
			flagList:AddItem( flags[8] )

			local createRankButton = vgui.Create("DFlatButton", ranks )
			createRankButton:SetState( true )
			createRankButton:SetSize(150, 40)
			createRankButton:SetPos(300, 230)
			createRankButton:SetText(ORGS_Lang.createrank)
			createRankButton.DoClick = function()
				local flagsString = ""
				for k,v in pairs(flags) do
					if flags[k]:GetChecked() then
						flagsString = flagsString .. flags[k].flag .. ","
					end
				end
				if newRankName:GetValue() != "" or newRankFlags:GetValue() != "" then
					if string.match(newRankName:GetValue(),"%d") or string.match(newRankName:GetValue(),"%p") or string.len(newRankName:GetValue()) > 25 then
						sendNotify( LocalPlayer(), ORGS_Lang.notallowed, NOTIFY_ERROR )
					end
					RunConsoleCommand("org_newrank", newRankName:GetValue(), flagsString)
				else

				end
			end
			manageTabs:AddSheet( ORGS_Lang.createranks, ranks, nil, false, false, ORGS_Lang.createranks )

			local editRanks = vgui.Create("DCustomPanel")
			local rankList = vgui.Create( "DComboBox", editRanks )
			rankList:SetFont("FlatButtonsFont")
			rankList:SetPos( 5, 15 )
			rankList:SetSize( 442, 35 )
			rankList:SetValue( ORGS_Lang.chooserank )
			local selectedID = nil
			if data[4] != nil then
				for k,v in pairs(data[4]) do
					rankList:AddChoice( v["name"], { v["id"], v["flags"] } )
				end
			end
			rankList.Paint = function()
				draw.RoundedBox( 0, 0, 0, rankList:GetWide(), rankList:GetTall(), Color( 255, 255, 255 ) )
				surface.SetDrawColor(189, 195, 199, 255)
				surface.DrawOutlinedRect(0, 0, rankList:GetWide(), rankList:GetTall())
			end

			local editRankName = vgui.Create("DTextEntry", editRanks)
			editRankName:SetSize( 442, 35 )
			editRankName:SetPos( 5, 55 )
			editRankName:SetText( ORGS_Lang.rankname )
			editRankName:SetFont("FlatButtonsFont")
			editRankName.Paint = function( )
				draw.RoundedBox( 0, 0, 0, editRankName:GetWide(), editRankName:GetTall(), Color( 255, 255, 255 ) )
				surface.SetDrawColor(189, 195, 199, 255)
				surface.DrawOutlinedRect(0, 0, editRankName:GetWide(), editRankName:GetTall())
				editRankName:DrawTextEntryText(Color(52, 73, 94, 255), Color(52, 73, 94, 255), Color(52, 73, 94, 255))
			end

			local flagList = vgui.Create("DPanelList", editRanks)
			flagList:SetSize(230, 130)
			flagList:SetPos(8, 105)
			flagList:SetSpacing( 15 )
			flagList:EnableHorizontal( true ) 

			local flags = {}

			flags[1] = vgui.Create( "DCheckBoxLabel" )
			flags[1]:SetText( ORGS_Lang.flagsdeposit )
			flags[1]:SetTextColor(Color(0,0,0))
			flags[1]:SizeToContents()
			flags[1]:SetWide( 100 )
			flags[1].flag = "a"
			flagList:AddItem( flags[1] )

			flags[2] = vgui.Create( "DCheckBoxLabel" )
			flags[2]:SetText( ORGS_Lang.flagswithdraw )
			flags[2]:SetTextColor(Color(0,0,0))
			flags[2]:SizeToContents()
			flags[2]:SetWide( 110 )
			flags[2].flag = "b"
			flagList:AddItem( flags[2] )

			flags[3] = vgui.Create( "DCheckBoxLabel" )
			flags[3]:SetText( ORGS_Lang.flagsinvite )
			flags[3]:SetTextColor(Color(0,0,0))
			flags[3]:SizeToContents()
			flags[3]:SetWide( 100 )
			flags[3].flag = "c"
			flagList:AddItem( flags[3] )

			flags[4] = vgui.Create( "DCheckBoxLabel" )
			flags[4]:SetText( ORGS_Lang.flagsmotd )
			flags[4]:SetTextColor(Color(0,0,0))
			flags[4]:SizeToContents()
			flags[4]:SetWide( 100 )
			flags[4].flag = "d"
			flagList:AddItem( flags[4] )

			flags[5] = vgui.Create( "DCheckBoxLabel" )
			flags[5]:SetText( ORGS_Lang.flagskick )
			flags[5]:SetTextColor(Color(0,0,0))
			flags[5]:SizeToContents()
			flags[5]:SetWide( 100 )
			flags[5].flag = "e"
			flagList:AddItem( flags[5] )

			flags[6] = vgui.Create( "DCheckBoxLabel" )
			flags[6]:SetText( ORGS_Lang.flagsranks )
			flags[6]:SetTextColor(Color(0,0,0))
			flags[6]:SizeToContents()
			flags[6]:SetWide( 100 )
			flags[6].flag = "f"
			flagList:AddItem( flags[6] )

			flags[7] = vgui.Create( "DCheckBoxLabel" )
			flags[7]:SetText( ORGS_Lang.flagsranks1 )
			flags[7]:SetTextColor(Color(0,0,0))
			flags[7]:SizeToContents()
			flags[7]:SetWide( 100 )
			flags[7].flag = "g"
			flagList:AddItem( flags[7] )

			flags[8] = vgui.Create( "DCheckBoxLabel" )
			flags[8]:SetText( "Create Meeting" )
			flags[8]:SetTextColor(Color(0,0,0))
			flags[8]:SizeToContents()
			flags[8]:SetWide( 100 )
			flags[8].flag = "h"
			flagList:AddItem( flags[8] )

			rankList.OnSelect = function( panel, index, value, data )
				editRankName:SetText( value )
				for k,v in pairs(flags) do
					flags[k]:SetChecked( false )
					if string.find( data[2], flags[k].flag ) then
						flags[k]:SetChecked( true )
					end
				end
				selectedID = data[1]
			end

			local editButton = vgui.Create("DFlatButton", editRanks )
			editButton:SetSize(150, 40)
			editButton:SetPos(300, 230)
			editButton:SetText(ORGS_Lang.editrank)
			editButton.DoClick = function()
				if selectedID != nil then
					if editRankName != "" or editRankFlags != "" then
						if string.match(editRankName:GetValue(),"%d") or string.match(editRankName:GetValue(),"%p") or string.len(editRankName:GetValue()) > 25 then
						sendNotify( LocalPlayer(), ORGS_Lang.notallowed, NOTIFY_ERROR )
						end
						local flagsString = ""
						for k,v in pairs(flags) do
							if flags[k]:GetChecked() then
								flagsString = flagsString .. flags[k].flag .. ","
							end
						end
						RunConsoleCommand("org_editrank", selectedID, editRankName:GetValue(), flagsString)
					else
					end
				else
					sendNotify( LocalPlayer(), ORGS_Lang.selectrank, NOTIFY_ERROR )
				end
			end

			local deleteButton = vgui.Create("DFlatButton", editRanks )
			deleteButton:SetState( false )
			deleteButton:SetSize(150, 40)
			deleteButton:SetPos(145, 230)
			deleteButton:SetText(ORGS_Lang.deleterank)

			deleteButton.DoClick = function()
				if selectedID != nil then
					RunConsoleCommand("org_delrank", selectedID)
				else
					sendNotify( LocalPlayer(), ORGS_Lang.selectrank, NOTIFY_ERROR )
				end
			end
			manageTabs:AddSheet( ORGS_Lang.editranks, editRanks, nil, false, false, ORGS_Lang.editranks )	
		end

		if table.HasValue(data[2], "d") then
			local motd = vgui.Create("DCustomPanel")
			local motdTextEntry = vgui.Create("DTextEntry", motd )
			motdTextEntry:SetSize( 445, 205 )
			motdTextEntry:SetPos( 5, 15 )
			motdTextEntry:SetFont("FlatButtonsFont")
			motdTextEntry:SetText( data[1]["motd"] )
			motdTextEntry:SetMultiline( true )
			motdTextEntry.Paint = function( )
				draw.RoundedBox( 0, 0, 0, motdTextEntry:GetWide(), motdTextEntry:GetTall(), Color( 255, 255, 255 ) )
				surface.SetDrawColor(189, 195, 199, 255)
				surface.DrawOutlinedRect(0, 0, motdTextEntry:GetWide(), motdTextEntry:GetTall())
				motdTextEntry:DrawTextEntryText(Color(52, 73, 94, 255), Color(52, 73, 94, 255), Color(52, 73, 94, 255))
			end

			local motdButton = vgui.Create("DFlatButton", motd )
			motdButton:SetSize(150, 40)
			motdButton:SetPos(300, 230)
			motdButton:SetText(ORGS_Lang.changemotd)
			motdButton.DoClick = function()
				if string.len(string.Replace(motdTextEntry:GetValue(), '"', "")) > 350 then
					sendNotify( LocalPlayer(), ORGS_Lang.limit, NOTIFY_HINT )
				else
					RunConsoleCommand("org_setmotd", string.Replace(motdTextEntry:GetValue(), '"', ""))
				end
			end
			manageTabs:AddSheet( "MoTD", motd, nil, false, false, ORGS_Lang.motd )
		end

		if table.HasValue(data[2], "c") then
			local invite = vgui.Create("DCustomPanel")

			local playerList = vgui.Create("DComboBox", invite )
			playerList:SetValue( ORGS_Lang.chooseplayer )
			playerList:SetFont("FlatButtonsFont")
			playerList:SetSize( 445, 35 )
			playerList:SetPos( 5, 15 )
			for k,v in pairs(player.GetAll()) do
				playerList:AddChoice( v:Nick() )
			end
			playerList.Paint = function( )
				draw.RoundedBox( 0, 0, 0, playerList:GetWide(), playerList:GetTall(), Color( 255, 255, 255 ) )
				surface.SetDrawColor(189, 195, 199, 255)
				surface.DrawOutlinedRect(0, 0, playerList:GetWide(), playerList:GetTall())
			end
			
			local messageEntry = vgui.Create("DTextEntry", invite )
			messageEntry:SetMultiline(true)
			messageEntry:SetPos(5, 55)
			messageEntry:SetSize(445, 165)
			messageEntry:SetFont("FlatButtonsFont")
			messageEntry:SetText("Hey, you invited to ".. data[1]["name"] .." by " .. LocalPlayer():Nick() .. ".\nWould you like to join us?")
			messageEntry.Paint = function( )
				draw.RoundedBox( 0, 0, 0, messageEntry:GetWide(), messageEntry:GetTall(), Color( 255, 255, 255 ) )
				surface.SetDrawColor(189, 195, 199, 255)
				surface.DrawOutlinedRect(0, 0, messageEntry:GetWide(), messageEntry:GetTall())
				messageEntry:DrawTextEntryText(Color(52, 73, 94, 255), Color(52, 73, 94, 255), Color(52, 73, 94, 255))
			end

			local invitePlayerButton = vgui.Create("DFlatButton", invite )
			invitePlayerButton:SetSize(150, 40)
			invitePlayerButton:SetPos(300, 230)
			invitePlayerButton:SetText(ORGS_Lang.inviteplayer)
			invitePlayerButton.DoClick = function()
				if playerList:GetValue() != ORGS_Lang.needchooseplayer then
					if string.len(string.Replace(messageEntry:GetValue(), '"', "")) > 150 then
						sendNotify( LocalPlayer(), ORGS_Lang.limit, NOTIFY_HINT )
					else
						RunConsoleCommand("org_inviteplayer", playerList:GetValue(), messageEntry:GetValue())
					end
				else
					sendNotify( LocalPlayer(), ORGS_Lang.needchooseplayer, NOTIFY_HINT )
				end
			end
			manageTabs:AddSheet( ORGS_Lang.invite, invite, nil, false, false, ORGS_Lang.invite )
		end
		if ORGS_Config.enableOrgMeetups then
			if table.HasValue(data[2], "h") then
				local meetuppanel = vgui.Create("DCustomPanel")

				local meetuptext = vgui.Create("DLabel", meetuppanel)
				meetuptext:SetPos( 5, 15 )
				meetuptext:SetAutoStretchVertical( true )
				meetuptext:SetWide( 440 )
				meetuptext:SetWrap( true )
				meetuptext:SetFont("MoTDTextFont")
				meetuptext:SetColor( Color( 0, 0, 0 ) )
				meetuptext:SetText( ORGS_Lang.meetexplain )
				local meetupdesc = vgui.Create( "DTextEntry", meetuppanel )
				meetupdesc:SetFont("FlatButtonsFont")
				meetupdesc:SetPos( 5, 110 )
				meetupdesc:SetSize( 442, 35 )
				meetupdesc:SetValue( ORGS_Lang.meetexplain1 )
				meetupdesc.Paint = function()
					draw.RoundedBox( 0, 0, 0, meetupdesc:GetWide(), meetupdesc:GetTall(), Color( 255, 255, 255 ) )
					surface.SetDrawColor(189, 195, 199, 255)
					surface.DrawOutlinedRect(0, 0, meetupdesc:GetWide(), meetupdesc:GetTall())
					meetupdesc:DrawTextEntryText(Color(52, 73, 94, 255), Color(52, 73, 94, 255), Color(52, 73, 94, 255))
				end

				local meetupposition = vgui.Create("DTextEntry", meetuppanel)
				meetupposition:SetSize( 442, 35 )
				meetupposition:SetPos( 5, 150 )
				meetupposition:SetText( ORGS_Lang.meetexplain2 )
				meetupposition:SetFont("FlatButtonsFont")
				meetupposition.Paint = function( )
					draw.RoundedBox( 0, 0, 0, meetupposition:GetWide(), meetupposition:GetTall(), Color( 255, 255, 255 ) )
					surface.SetDrawColor(189, 195, 199, 255)
					surface.DrawOutlinedRect(0, 0, meetupposition:GetWide(), meetupposition:GetTall())
					meetupposition:DrawTextEntryText(Color(52, 73, 94, 255), Color(52, 73, 94, 255), Color(52, 73, 94, 255))
				end

				local createmeetup = vgui.Create("DFlatButton", meetuppanel )
				createmeetup:SetSize(150, 40)
				createmeetup:SetPos(300, 230)
				createmeetup:SetText( ORGS_Lang.meetcreate )
				createmeetup.DoClick = function()
					RunConsoleCommand("org_meetup", meetupdesc:GetValue(), meetupposition:GetValue())
				end
				manageTabs:AddSheet( "Meetup", meetuppanel, nil, false, false, "Meetup" )
			end
		end
	end

	if ORGS_Config.enableHaloEffect then
		sideMenu:AddSwitchButton(ORGS_Lang.optionholo, "org/holo.png", function()
			local onlineOrgPlayers = {}
			for k,v in pairs( data[3] ) do
				if player.GetBySteamID(v["steamid"]) then
					table.insert(onlineOrgPlayers, player.GetBySteamID(v["steamid"]))
				end
			end
			turnHoloMode( onlineOrgPlayers )
		end)
	end

	sideMenu:AddSwitchButton(ORGS_Lang.optionchat, "org/chat.png", function()
		turnOrgChat()
	end)

	sideMenu:AddSwitchButton(ORGS_Lang.optionleave, "org/leave.png", function()
		Derma_Query(ORGS_Lang.leave, ORGS_Lang.warning,
			ORGS_Lang.yes, function() RunConsoleCommand("org_leave") mainFrame:Close() end,
			ORGS_Lang.no)
	end)
end)


net.Receive("orginvitebox", function()
	local inviteFrame = vgui.Create("DFrame")
	inviteFrame:SetSize( 360, 180 )
	inviteFrame:Center()
	inviteFrame:SetTitle(ORGS_Lang.invited)
	inviteFrame:SetVisible( true )
	inviteFrame:SetDraggable( true )
	inviteFrame:ShowCloseButton( false )
	inviteFrame:MakePopup()
	inviteFrame.Paint = function()
		draw.RoundedBox( 0, 0, 0, inviteFrame:GetWide(), 25, Color(52, 73, 94) )
		draw.RoundedBox( 0, 0, 25, inviteFrame:GetWide(), inviteFrame:GetTall() - 25, Color(226,226,226) )
	end

	local panel = vgui.Create("DPanel", inviteFrame)
	panel:SetSize(350, 90)
	panel:SetPos(5, 35)
	local textLabel = vgui.Create("DLabel", panel)	
	textLabel:SetPos(10, 10)
	textLabel:SetColor(Color(50, 50, 50))
	textLabel:SetText(net.ReadString() .."!\nDo you want to join in?")
	textLabel:SetFont("InviteTextFont")
	textLabel:SetAutoStretchVertical( true )
	textLabel:SetWide( 345 )
	textLabel:SetWrap( true )
	
	local acceptButton = vgui.Create("DFlatButton", inviteFrame)
	acceptButton:SetState( true )
	acceptButton:SetPos(0, 140)
	acceptButton:SetText(ORGS_Lang.acceptinvite)
	acceptButton.DoClick = function()
		LocalPlayer():ConCommand("org_accept")
		inviteFrame:Close()
	end

	local denyButton = vgui.Create("DFlatButton", inviteFrame)
	denyButton:SetState( false )
	denyButton:SetPos(181, 140)
	denyButton:SetText(ORGS_Lang.denyinvite)
	denyButton.DoClick = function()
		LocalPlayer():ConCommand("org_deny")
		inviteFrame:Close()
	end
end)

net.Receive("orgsadminselect", function()

	local mainFrame = vgui.Create( "DFrame" )
	mainFrame:SetSize( 500, 500 )
	mainFrame:SetTitle( "" )
	mainFrame:SetVisible( true )
	mainFrame:SetDraggable( false )
	mainFrame:ShowCloseButton( false )
	mainFrame:Center()
	mainFrame:MakePopup()
	mainFrame.Init = function()
		mainFrame.startTime = SysTime()
	end
	mainFrame.Paint = function()
		Derma_DrawBackgroundBlur(mainFrame, mainFrame.startTime)
		draw.RoundedBox( 0, 0, 0, mainFrame:GetWide(), mainFrame:GetTall(), Color(226,226,226) )
		draw.RoundedBox( 0, 0, 0, mainFrame:GetWide(), 30, Color( 52, 73, 94 ) )
	end
	
	local closeButton = vgui.Create("DButton", mainFrame)
	closeButton:SetSize( 70, 30 )
	closeButton:SetPos( 430 , 0 )
	closeButton:SetColor( Color( 255, 255, 255 ))
	closeButton:SetText("X")
	closeButton:SetVisible( true )

	closeButton.Paint = function( )
		if closeButton.isHover then
			draw.RoundedBox( 0, 0, 0, closeButton:GetWide(), closeButton:GetTall(), Color( 192, 57, 43 ) )
		else
			draw.RoundedBox( 0, 0, 0, closeButton:GetWide(), closeButton:GetTall(), Color( 231, 76, 60 ) )
		end
	end

	closeButton.OnCursorEntered = function()
		closeButton.isHover = true
	end

	closeButton.OnCursorExited = function()
		closeButton.isHover = false
	end

	closeButton.DoClick = function()
		mainFrame:Close()
	end

	local title = vgui.Create("DLabel", mainFrame)
	title:SetText( "Organisations" )
	title:SetFont("titlefont")
	title:SetColor( Color( 255, 255, 255 ) )
	title:SizeToContents()
	title:SetPos( 6, 2 )

	local orgslist = vgui.Create( "DListView", mainFrame )
	orgslist:SetSize( 480, 430 )
	orgslist:SetPos( 10, 40 )
	orgslist:SetMultiSelect( false )
	orgslist:AddColumn( "Org ID" )
	orgslist:AddColumn( "Name" )
	orgslist:AddColumn( "Bank" )
	
	for k,v in pairs(net.ReadTable()) do
		orgslist:AddLine( v.id, v.name, v.bankbalance.."$" )
	end

	orgslist.OnRowRightClick = function ( btn, line )
	    local orgsOptions = DermaMenu()
		orgsOptions:AddOption("Delete Organisation", function() 
			Derma_Query("Are you sure that you want to delete this organisation?", "Warning!",
				"Yes", function() RunConsoleCommand("org_delete", orgslist:GetLine(line):GetValue(1)) orgslist:RemoveLine(line) end,
				"No")
		end )
		orgsOptions:AddOption("Edit Organisation", function() 
			net.Start("requestorg")
				net.WriteString( orgslist:GetLine( line ):GetValue(1) )
			net.SendToServer()
		end )
	    orgsOptions:Open()
	end

	orgslist.DoDoubleClick = function( id, line )
		net.Start("requestorg")
			net.WriteString( orgslist:GetLine( line ):GetValue(1) )
		net.SendToServer()
	end

end )



net.Receive("requestorganswer", function()
	local org = net.ReadTable()	
	local mainFrame = vgui.Create( "DFrame" )
	mainFrame:SetSize( 500, 750 )
	mainFrame:SetTitle( "" )
	mainFrame:SetVisible( true )
	mainFrame:SetDraggable( false )
	mainFrame:ShowCloseButton( false )
	mainFrame:Center()
	mainFrame:MakePopup()
	mainFrame.Init = function()
		mainFrame.startTime = SysTime()
	end
	mainFrame.Paint = function()
		Derma_DrawBackgroundBlur(mainFrame, mainFrame.startTime)
		draw.RoundedBox( 0, 0, 0, mainFrame:GetWide(), mainFrame:GetTall(), Color(226,226,226) )
		draw.RoundedBox( 0, 0, 0, mainFrame:GetWide(), 30, Color( 52, 73, 94 ) )
	end
	
	local closeButton = vgui.Create("DButton", mainFrame)
	closeButton:SetSize( 70, 30 )
	closeButton:SetPos( 430 , 0 )
	closeButton:SetColor( Color( 255, 255, 255 ))
	closeButton:SetText("X")
	closeButton:SetVisible( true )

	closeButton.Paint = function( )
		if closeButton.isHover then
			draw.RoundedBox( 0, 0, 0, closeButton:GetWide(), closeButton:GetTall(), Color( 192, 57, 43 ) )
		else
			draw.RoundedBox( 0, 0, 0, closeButton:GetWide(), closeButton:GetTall(), Color( 231, 76, 60 ) )
		end
	end

	closeButton.OnCursorEntered = function()
		closeButton.isHover = true
	end

	closeButton.OnCursorExited = function()
		closeButton.isHover = false
	end

	closeButton.DoClick = function()
		mainFrame:Close()
	end
	local title = vgui.Create("DLabel", mainFrame)
	title:SetText( org[1].name )
	title:SetFont("titlefont")
	title:SetColor( Color( 255, 255, 255 ) )
	title:SizeToContents()
	title:SetPos( 6, 2 )

	local firststage = vgui.Create("DPanel", mainFrame)
	firststage:SetSize( 480, 700 )
	firststage:SetPos( 10, 40 )

	local orgnamelabel = vgui.Create("DLabel", firststage)
	orgnamelabel:SetPos( 10, 10 )
	orgnamelabel:SetText("Name")
	orgnamelabel:SetFont("smalltextfont")
	orgnamelabel:SetColor(Color(52, 73, 94))
	orgnamelabel:SizeToContents()

	local orgnameentry = vgui.Create("DTextEntry", firststage)
	orgnameentry:SetPos( 10, 35 )
	orgnameentry:SetSize( 450, 30 )
	orgnameentry:SetText( org[1].name )

	local bankbalancelabel = vgui.Create("DLabel", firststage)
	bankbalancelabel:SetPos( 10, 75 )
	bankbalancelabel:SetText("Bank Balance")
	bankbalancelabel:SetFont("smalltextfont")
	bankbalancelabel:SetColor(Color(52, 73, 94))
	bankbalancelabel:SizeToContents()

	local bankbalanceentry = vgui.Create("DTextEntry", firststage)
	bankbalanceentry:SetPos( 10, 100 )
	bankbalanceentry:SetSize( 450, 30 )
	bankbalanceentry:SetText( org[1].bankbalance )

	local motdlabel = vgui.Create("DLabel", firststage)
	motdlabel:SetPos( 10, 140 )
	motdlabel:SetText("MOTD")
	motdlabel:SetFont("smalltextfont")
	motdlabel:SetColor(Color(52, 73, 94))
	motdlabel:SizeToContents()

	local motdentry = vgui.Create("DTextEntry", firststage)
	motdentry:SetPos( 10, 165 )
	motdentry:SetSize( 450, 180 )
	motdentry:SetMultiline( true )
	motdentry:SetText( org[1].motd )

	local membersList = vgui.Create("DListView", firststage)
	membersList:SetSize(450, 270)
	membersList:SetPos(10, 360)
	membersList:AddColumn("STEAMID")
	membersList:AddColumn(ORGS_Lang.membername)
	membersList:AddColumn(ORGS_Lang.isonline)
	membersList:AddColumn(ORGS_Lang.lastseen)
	
	for k,v in pairs( org[2] ) do
		local online
		if player.GetBySteamID(v.steamid) != false then online = ORGS_Lang.yes else online = ORGS_Lang.no end
		membersList:AddLine(v.steamid, v.name, online, v.lastseen)
	end

	membersList.OnRowRightClick = function ( btn, line )
	    local memberOptions = DermaMenu()
		memberOptions:AddOption("Kick Member", function() 
			Derma_Query("Are you sure that you want to kick ".. membersList:GetLine(line):GetValue(2) .." from the "..ORGS_Config.addonName.."?", "Warning!",
				ORGS_Lang.yes, function() RunConsoleCommand("org_kickmember", membersList:GetLine(line):GetValue(1)) end,
				ORGS_Lang.no)
		end )
	    memberOptions:Open()
	end


	local editorg = vgui.Create("DButton", firststage)
	editorg:SetSize( 180, 40 )
	editorg:SetPos( 10, 640 )
	editorg:SetColor( Color( 255, 255, 255) )
	editorg:SetFont("ButtonsFont")
	editorg:SetText("Edit Organisation")
	editorg.DoClick = function()
		net.Start("editorg")
			net.WriteTable( {  org[1].id, orgnameentry:GetValue(), bankbalanceentry:GetValue(), motdentry:GetValue() } )
		net.SendToServer()
		mainFrame:Close()
		surface.PlaySound( 'buttons/button15.wav' )
	end
	editorg.Paint = function()
		draw.RoundedBox( 0, 0, 0, editorg:GetWide(), editorg:GetTall(), Color( 46, 204, 113 ) )
	end

	local deleteorg = vgui.Create("DButton", firststage)
	deleteorg:SetSize( 180, 40 )
	deleteorg:SetPos( 280, 640 )
	deleteorg:SetColor( Color( 255, 255, 255) )
	deleteorg:SetFont("ButtonsFont")
	deleteorg:SetText("Delete Organisation")
	deleteorg.DoClick = function()
		RunConsoleCommand("org_delete", org[1].id, text )
		mainFrame:Close()
		surface.PlaySound( 'buttons/button15.wav' )
	end
	deleteorg.Paint = function()
		draw.RoundedBox( 0, 0, 0, deleteorg:GetWide(), deleteorg:GetTall(), Color( 231, 76, 60 ) )
	end
end)

net.Receive("leaveorg", function()
	--[[
	if mainFrame:IsValid() then
		mainFrame:Close()
	end
	]]
	hook.Remove( "PreDrawHalos", "ShowMembersHalos")
	orgChat = true
	holoMod = false
	meetup = nil
end)