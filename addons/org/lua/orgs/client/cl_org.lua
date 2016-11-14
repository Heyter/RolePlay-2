surface.CreateFont( "meetupfont", {
	font="Roboto Cn",
	size = 16,
	weight = 400,
	antialias = true
})


if orgChat == nil and holoMod == nil then
	orgChat = true
	holoMod = false
end

function turnHoloMode( players )
	if holoMod == false then
		hook.Add( "PreDrawHalos", "ShowMembersHalos",  function() halo.Add( players, Color( 0, 255, 0, 255 ), 2, 10, 10,true,true) end)
		sendNotify( LocalPlayer(), ORGS_Lang.holoon, NOTIFY_HINT )
		holoMod = true
	else
		hook.Remove( "PreDrawHalos", "ShowMembersHalos")
		sendNotify( LocalPlayer(), ORGS_Lang.holooff, NOTIFY_HINT )
		holoMod = false
	end
end

function turnOrgChat()
	if orgChat == false then
		sendNotify( LocalPlayer(), ORGS_Lang.chaton, NOTIFY_HINT )
		orgChat = true
	else
		sendNotify( LocalPlayer(), ORGS_Lang.chatoff, NOTIFY_HINT )
		orgChat = false
	end
end

net.Receive("orgchatmsg", function()
	if orgChat == true then
		local msgdata = net.ReadTable()
		chat.AddText(Color(0,255,0), "[".. ORGS_Config.addonName .." Chat] " .. msgdata[1] .." [ " .. msgdata[2]  .. " ]: ", Color(255,255,255), msgdata[3])
	end
end)

hook.Add("HUDPaint", "playersorgs", function()
	if ORGS_Config.showNames then
		local eyepos = LocalPlayer():GetShootPos()
		local aimvec = LocalPlayer():GetAimVector()
		for k, v in pairs(players or player.GetAll()) do
			local hisPos = v:GetShootPos()
			if hisPos:DistToSqr(eyepos) < 160000 then
				local pos = hisPos - eyepos
				local unitPos = pos:GetNormalized()
				if unitPos:Dot(aimvec) > 0.95 then
					local pos = LocalPlayer():EyePos()
					if pos:isInSight({LocalPlayer(), v}) then
						local pos = v:EyePos()
					    if not pos:isInSight({LocalPlayer(), v}) then return end
					    pos.z = pos.z + 10
					    pos = pos:ToScreen()
					    draw.DrawNonParsedText(v:GetNWString("orgName"), "DarkRPHUD2", pos.x + 1, pos.y + 10, Color(0,0,0), 1)
					    draw.DrawNonParsedText(v:GetNWString("orgName"), "DarkRPHUD2", pos.x + 1, pos.y + 9, Color(255,0,0), 1)
					end
				end
			end
		end
	end
end)


meetup = nil
net.Receive("meetuppoint", function()
	local meetupdata = net.ReadTable()
	sendNotify( LocalPlayer(), meetupdata[3].. " "..ORGS_Lang.meetset.." "..meetupdata[4]..". Description: " ..meetupdata[1], NOTIFY_HINT )
	meetup = meetupdata
	timer.Simple(600, function()
		meetup = nil
	end)
end)

function drawMeetupPoint()
	if meetup then
		local ang = LocalPlayer():EyeAngles()
		ang:RotateAroundAxis( ang:Forward(), 90 )
		ang:RotateAroundAxis( ang:Right(), 90 )
		cam.Start3D2D( meetup[2] + Vector( 0,80, 80 + 10 * math.abs(math.sin(CurTime() * 0.8)) ) , Angle(0, ang.y, 90), 1 )
            draw.DrawText( ORGS_Config.addonName.. " Meeting Point!\nCreated by: "..meetup[3].."\n"..meetup[1], "meetupfont", 0, 0, Color(255, 255, 255), TEXT_ALIGN_CENTER )
        cam.End3D2D()
	end
end
hook.Add("PostDrawOpaqueRenderables", "drawthepoint", drawMeetupPoint)

local used = false
function bindUsed()
	if not used then
		if input.IsKeyDown(ORGS_Config.keyToActivate) then
			used = true
			LocalPlayer():ConCommand("org_menu")
			timer.Simple(4, function()
				used = false
			end)
		end
	end
end
hook.Add("Think", "bindUsed", bindUsed)

hook.Add("OnPlayerChat", "chat", function(ply, text)
	if (string.sub(text, 1, 4) == "!org") then
    	return true
	end
end)

