/*
local DIALOG = {}

local canGetCallback
local text = ""
local npc

local function tryswitchjob( callback )
	net.Start( "RequestJobEnter" )
		net.WriteEntity( npc )
	net.SendToServer( )
	canGetCallback = callback
end

net.Receive( "CanEnterJob" .. TEAM_POLICE, function( )
	local canGet = net.ReadBit( )
	text = net.ReadString()
	canGetCallback( canGet )
end )

DIALOG["wrongjob"] = function( frame ) 
	local dialog = {
		{
			npcsay = "Hey",
			options = {
				["Bye"] = function( frame )
					frame:Close( )
				end
			}
		}
	}
	return dialog
end

DIALOG["showdialog"] = function( frame ) 
	local tbl = {
		{
			npcsay = "Hey, was kann ich fuer dich tun?",
			options = {
				["Ich weiss auch nicht."] = function( frame )
					frame:Close( )
				end,
				["Ich will mich gerne anders kleiden."] = function( frame ) 
					frame:GoToStage( 2 )
				end
			}
		},
		{
			npcsay = "Ok, jedes Kleidungsstueck kostet $1500. Bist du dir sicher, dass \ndu dich neu kleiden willst?",
			options = {
				["Nein, das ist mir zu teuer."] = function( frame )
					frame:GoToStage( 3 )
				end,
				["Ja"] = function( frame )
					frame:Close( )
					PM_OpenModelSelection()
				end
			}
		},
		{
			npcsay = "Alles klar, dann komm doch einfach wieder\nwenn du Geld hast.",
			options = {
				["NIEMALS!"] = function( frame )
					frame:Close( )
				end,
				["Ok, bye"] = function( frame )
					frame:Close( )
				end
			}
		}
	}
	return tbl 
end

net.Receive( "NewPlayerModelNpcOpenDialog", function( )
	npc = net.ReadEntity( )
	local dialog = net.ReadString( )
	openDialog( DIALOG[dialog], npc )
end )

function PM_OpenModelSelection()
	local curmodel = 1
	local sex = "male"
	local min = 0
	local max = 1
	local plymdltbl = {}
	
	if string.match( LocalPlayer():GetModel(), "female", 0 ) then sex = "female" end
	
	for k, v in pairs( GMNRP.Teams[1].model ) do
		if string.match( v, sex, 0 ) then
			table.insert( plymdltbl, k )
		end
	end
	min = plymdltbl[1]
	max = #plymdltbl

	local DFrame1 = vgui.Create( "DFrame" )
	DFrame1:SetTall( 350 )
	DFrame1:SetWide( 450 )
	DFrame1:SetTitle( "Shop" )
	DFrame1:Center()
	DFrame1:MakePopup()
	--DFrame1:SetSkin( "GMNRP" )

	DFrame1.bgmusic = CreateSound(LocalPlayer(), Sound('gmnrp/shop/background.mp3'))
	DFrame1.bgmusic:Play()

	local OK_Button = vgui.Create( "DButton", DFrame1 )
	OK_Button:SetTall(25)
	OK_Button:SetWide( DFrame1:GetWide()-40 )
	OK_Button:SetPos( 20, DFrame1:GetTall() - 35)
	OK_Button:SetText( "OK" )
	OK_Button.DoClick = function()
		DFrame1.bgmusic:ChangeVolume( 0.1, 3 )
		timer.Simple( 3, function() DFrame1.bgmusic:Stop() DFrame1:Close() end )
		DFrame1:Hide()
		net.Start( "Buy_Perma_Playermodel" )
			net.WriteString( tostring(curmodel) )
		net.SendToServer()
	end

	local icon = vgui.Create( "DModelPanel", DFrame1 )
	icon:SetModel( GMNRP.Teams[1].model[curmodel] )
	icon:SetSize( DFrame1:GetWide()/3, DFrame1:GetTall() )
	icon:SetAnimated(false)
	icon:SetCamPos( Vector( 0, 35, 40 ) )
	icon:SetLookAt( Vector( 0, 0, 40 ) )
	icon:SetPos( DFrame1:GetWide()/2 - icon:GetWide()/2, -30 )

	local l_Button = vgui.Create( "DButton", DFrame1 )
	l_Button:SetTall(25)
	l_Button:SetWide( 40 )
	l_Button:SetPos( 20, DFrame1:GetTall() - 80)
	l_Button:SetText( "<" )
	l_Button.DoClick = function()
	curmodel = curmodel - 1
	if curmodel < 1 then curmodel = max end
	icon:SetModel( GMNRP.Teams[1].model[curmodel] )
	end


	local r_Button = vgui.Create( "DButton", DFrame1 )
	r_Button:SetTall(25)
	r_Button:SetWide( 40 )
	r_Button:SetPos( DFrame1:GetWide() - 60, DFrame1:GetTall() - 80)
	r_Button:SetText( ">" )
	r_Button.DoClick = function()
	curmodel = curmodel + 1
	if curmodel > max then curmodel = min end
	icon:SetModel( GMNRP.Teams[1].model[curmodel] )
	end
end
*/