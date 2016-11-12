DIALOG = DIALOG or {}

local canGetCallback
local function accessbankaccount( )
	--net.Start( "OpenBankMenu" )
	--net.SendToServer( )
end

DIALOG["NPC_HouseRentHello"] = function( frame ) 
	local tbl = {
		{
			npcsay = "Hallo, wie kann ich Ihnen weiterhelfen?",
			options = {
				["Schon gut."] = function( frame )
					frame:Close( )
				end,
				["Ich bin an eins ihrer Häuser interessiert."] = function( frame ) 
					frame:GoToStage( 2 )
				end
			}
		},
        {
			npcsay = "Alles klar! Hier ist der Katalog. Lassen sie sich Zeit.",
			options = {
				["Dankeschön"] = function( frame )
                    PurchaseHousePanel()
					frame:Close( )
				end,
                ["Geben sie schon her!"] = function( frame )
                    frame:Close( )
					PurchaseHousePanel()
				end,
                ["*Flüstern* Gib her du olle zippe!"] = function( frame )
					frame:GoToStage( 3 )
				end
			}
		},
        {
			npcsay = "Haben Sie was gesagt?",
			options = {
				["Nein. Hab ich nicht."] = function( frame )
                    frame:Close( )
					PurchaseHousePanel()
				end,
                ["Ja. Ich hab gesagt sie sind hässlich!"] = function( frame )
					frame:GoToStage( 4 )
				end
			}
		},
        {
			npcsay = "RAUS!!!!!!!",
			options = {
				["... o.O"] = function( frame )
					frame:Close()
				end
			}
		}
	}
	return tbl 
end

function PurchaseHousePanel()
	local frame = vgui.Create( "DFrame" )
	frame:SetTall( 350 )
	frame:SetWide( 550 )
	frame:SetTitle( "" )
	frame:Center()
	frame:MakePopup()
    frame.Paint = function()
        draw.RoundedBox( 2, 0, 0, frame:GetWide(), frame:GetTall(), Color( 230, 230, 230, 255 ) )
        draw.RoundedBox( 2, 0, 0, frame:GetWide(), 25, Color( 0, 153, 204, 200 ) )
        draw.SimpleText( "Hausverkaufsstelle", "RPNormal_25", 2, 0, Color( 255, 255, 255, 200 ) )
    end

	DermaList = vgui.Create( "DPanelList", frame )
	DermaList:SetPos( 5,30 )
	DermaList:SetSize( frame:GetWide() -10, frame:GetTall() - 35 )
	DermaList:SetSpacing( 2 )
	DermaList:EnableHorizontal( false )
	DermaList:EnableVerticalScrollbar( true )
    DermaList.VBar.Paint = function() 
        local h = DermaList.VBar.btnUp:GetTall() + DermaList.VBar.btnDown:GetTall()
        draw.RoundedBox( 2, 0, h/2, DermaList.VBar:GetWide(), DermaList.VBar:GetTall() - h, Color( 0, 0, 0, 100 ) )
    end
    DermaList.VBar.btnUp.Paint = function() end
    DermaList.VBar.btnDown.Paint = function() end
    DermaList.VBar.btnGrip.Paint = function() 
        draw.RoundedBox( 2, 0, 0, DermaList.VBar:GetWide(), DermaList.VBar:GetTall(), Color( 0, 153, 204, 200 ) )
    end

    local item = 0
	for k, v in pairs( RP.Doors ) do
        local data = v
		if data.cost == 0 then continue end
		
		item = item + 1
        if item > 2 then item = 1 end
        
		local p = vgui.Create( "DPanel", frame )
		p:SetSize( DermaList:GetWide(), 104 )
        p.item = item
		p.Paint = function()
            if p.item == 1 then
                draw.RoundedBox( 2, 0, 0, p:GetWide(), p:GetTall(), Color( 230, 230, 230, 255 ) )
            elseif p.item == 2 then
                draw.RoundedBox( 2, 0, 0, p:GetWide(), p:GetTall(), HUD_SKIN.LIST_BG_FIRST )
            end
			draw.SimpleText( data.title, "RPNormal_30", 80, 10, Color( 150, 150, 150, 200 ) )
			if IsValid( data.owner ) && data.owner != LocalPlayer() then
				draw.SimpleText( "Verkauft!", "RPNormal_30", 80, 40, Color( 200, 0, 0, 200 ) )
			elseif IsValid( data.owner ) && data.owner == LocalPlayer() then
				draw.SimpleText( "Erworben!", "RPNormal_30", 80, 40, Color( 0, 200, 0, 200 ) )
			else
                local col = Color( 0, 200, 0, 200 )
                if not LocalPlayer():CanAfford( data.cost ) then col = Color( 200, 0, 0, 200 ) end
                
                draw.SimpleText( "$" .. tostring(data.cost), "RPNormal_30", 80, 40, col )
			end
			
			if LocalPlayer():IsPolice() or LocalPlayer():IsSWAT() then
				if !(data.owner == nil) then
					draw.SimpleText( "Eigentümer: ", "RPNormal_25", 80, 65, Color( 100, 100, 100, 200 ) )
					draw.SimpleText( (data.owner:GetRPVar("rpname") or data.owner:Nick()), "RPNormal_25", 185, 65, team.GetColor( data.owner:Team() ) )
				end
			end
		end
		
		local av = vgui.Create("AvatarImage", p)
		av:SetPos(5,5)
		av:SetSize(64, 64)
		av:SetPlayer( LocalPlayer(), 64 )
		
		local buy = vgui.Create( "DButton", p )
		buy:SetText( " " )
		local buytext = ""
		local createdbuybutton = false
		if IsValid( data.owner ) && data.owner == LocalPlayer() then
			buytext = "Verkaufen"
			buy:SetSize( 150, 50 )
			buy:SetPos( p:GetWide() - (buy:GetWide() + 25), p:GetTall()/2 - buy:GetTall()/2 )
			buy.DoClick = function()
				--if !(LocalPlayer():CanAfford( RP.Doors[k].cost )) then return end
				net.Start( "SellHouse" )
					net.WriteString( tostring(k) )
				net.SendToServer()
				
				LocalPlayer():EmitSound( "/buttons/button18.wav", 100, 100 )
				
				frame:Close()
				timer.Simple( 0.1, function() PurchaseHousePanel() end )
			end
			createdbuybutton = true
		else
			buytext = "Erwerben"
			buy:SetSize( 150, 50 )
			buy:SetPos( p:GetWide() - (buy:GetWide() + 25), p:GetTall()/2 - buy:GetTall()/2 )
			buy.DoClick = function()
				--if !(LocalPlayer():CanAfford( RP.Doors[k].cost )) then return end
				net.Start( "PurchaseHouse" )
					net.WriteString( tostring(k) )
				net.SendToServer()
				
				LocalPlayer():EmitSound( "/buttons/button9.wav", 100, 100 )
				
				frame:Close()
				timer.Simple( 0.1, function() PurchaseHousePanel() end )
			end
			createdbuybutton = true
		end
		buy.Paint = function()
            local font = "RPNormal_30"
            surface.SetFont( font )
            local w, h = surface.GetTextSize( buytext )
            draw.RoundedBox( 4, 0, 0, buy:GetWide(), buy:GetTall(), Color( 0, 153, 204, 200 ) )
            draw.SimpleText( buytext, font, (buy:GetWide() - w) / 2, (buy:GetTall() - h) / 2, Color( 255, 255, 255, 200 ) )
        end
		
		if !(createdbuybutton) then
			buy:Remove()
		end
		
		DermaList:AddItem( p )
		
	end
end

net.Receive( "FireNpcOpenDialog", function( )
	npc = net.ReadEntity( )
	local dialog = net.ReadString( )
    PrintTable(  DIALOG["askbank"] )
	openDialog( DIALOG[dialog], npc )
end )