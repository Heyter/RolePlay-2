RP.PLUGINS = RP.PLUGINS or {}
RP.PLUGINS.CHATCOMMAND = RP.PLUGINS.CHATCOMMAND or {}
RP.PLUGINS.CHATCOMMAND.COMMANDS = RP.PLUGINS.CHATCOMMAND.COMMANDS or {}


--[[---------------------------------------------------------
   Name: RP.PLUGINS:AddChatCommand( command, function )
   Desc: Adds a Chatcommand that executes the given function
         when it gets said.
-----------------------------------------------------------]]
function RP.PLUGINS.CHATCOMMAND.AddChatCommand( command, func )
    for k, v in pairs( RP.PLUGINS.CHATCOMMAND.COMMANDS or {} ) do
        if command == v.command then table.remove( RP.PLUGINS.CHATCOMMAND.COMMANDS, k ) end
    end
    
    table.insert( RP.PLUGINS.CHATCOMMAND.COMMANDS, {command=command, func=func} )
    print( "Command: " .. command .. " has been successfully added!" )
end

--[[---------------------------------------------------------
   Name: RP.PLUGINS:RemoveChatCommand( command )
   Desc: Removes a created chatcommand.
-----------------------------------------------------------]]
function RP.PLUGINS.CHATCOMMAND.RemoveChatCommand( command )
    for k, v in pairs( RP.PLUGINS.CHATCOMMAND.COMMANDS or {} ) do
        if command == v.command then table.remove( RP.PLUGINS.CHATCOMMAND.COMMANDS, k ) end
    end
end

--[[---------------------------------------------------------
   Name: RP.PLUGINS:CheckForCommand( ply, text, public )
   Desc: This function checks everytime a user say something,
         if its a chatcommand.
-----------------------------------------------------------]]
function RP.PLUGINS.CHATCOMMAND.CheckForCommand( ply, text, public )
    if text == nil then return "" end
    for k, v in pairs( RP.PLUGINS.CHATCOMMAND.COMMANDS ) do
        local len = string.len( v.command )
        if string.lower(v.command) == string.lower(string.sub(text, 1, len )) then
            v.func( ply, RP.PLUGINS.CHATCOMMAND.ConvertText( text ), text, public )
            return ""
        end
    end
    
    if public then
		RP.PLUGINS.CHATCOMMAND.Send_Chat( ply, text, 0)
	else
		RP.PLUGINS.CHATCOMMAND.Send_Chat( ply, text, 1)
	end
	return ""
end
hook.Add( "PlayerSay", "RP.PLUGINS_CheckForCommand", RP.PLUGINS.CHATCOMMAND.CheckForCommand )

util.AddNetworkString( "Send_Text" )
function RP.PLUGINS.CHATCOMMAND.Send_Chat( ply, text, pub )
	if pub == 0 then
		local t = ply:Team()
		local plys = team.GetPlayers( t )
		for k, v in pairs(plys or {}) do
			net.Start("Send_Text")
				net.WriteString( text )
				net.WriteEntity( ply )
				net.WriteFloat(0)
			net.Send( v )
		end
	elseif pub == 1 then
		local players = ents.FindInSphere( ply:GetPos(), SETTINGS.VoiceRadius )
		for k, v in pairs(players) do
			if !(v:IsPlayer()) then continue end
			if !(IsValid( v )) then continue end
			
			net.Start("Send_Text")
				net.WriteString( text )
				net.WriteEntity( ply )
				net.WriteFloat(1)
			net.Send( v )
		end
	elseif pub == 2 then
		net.Start("Send_Text")
			net.WriteString( text )
			net.WriteEntity( ply )
			net.WriteFloat(2)
		net.Broadcast()
    elseif pub == 3 then
        local players = ents.FindInSphere( ply:GetPos(), SETTINGS.VoiceRadius )
		for k, v in pairs(players) do
			if !(v:IsPlayer()) then continue end
			if !(IsValid( v )) then continue end
			
			net.Start("Send_Text")
				net.WriteString( text )
				net.WriteEntity( ply )
				net.WriteFloat(3)
			net.Send( v )
		end
    elseif pub == 4 then
        net.Start("Send_Text")
			net.WriteString( text )
			net.WriteEntity( ply )
			net.WriteFloat(4)
		net.Broadcast()
    elseif pub == 5 then
        net.Start("Send_Text")
			net.WriteString( text )
			net.WriteEntity( ply )
			net.WriteFloat(5)
		net.Broadcast()
	elseif pub == 911 then
		for k, v in pairs( player.GetAll() ) do
			if (v:Team() == TEAM_POLICE or v:Team() == TEAM_MAYOR) then
				net.Start("Send_Text")
					net.WriteString( text )
					net.WriteEntity( ply )
					net.WriteFloat(911)
				net.Send( v )
			end
		end
	end
end


local function WriteOOC( ply, args, text )
	text = string.gsub( text, "//", "" )
	if text == "" then return end
	RP.PLUGINS.CHATCOMMAND.Send_Chat( ply, text, 2)
end
RP.PLUGINS.CHATCOMMAND.AddChatCommand( "//", WriteOOC )

local function WriteMe( ply, args, text )
	text = string.gsub( text, "/me", "" )
	if text == "" then return end
	RP.PLUGINS.CHATCOMMAND.Send_Chat( ply, text, 3)
end
RP.PLUGINS.CHATCOMMAND.AddChatCommand( "/me", WriteMe )

local function WriteAdvert( ply, args, text )
    if !(ply:CanAfford( SETTINGS.AdvertCost )) then ply:RPNotify( "Du kannst dir keine Werbung leisten! Kosten: " .. SETTINGS.AdvertCost .. ",-EUR", 5 ) return end
    ply:AddCash( -SETTINGS.AdvertCost )
	text = string.gsub( text, "/werbung", "" )
	if text == "" then return end
	RP.PLUGINS.CHATCOMMAND.Send_Chat( ply, text, 4)
end
RP.PLUGINS.CHATCOMMAND.AddChatCommand( "/werbung", WriteAdvert )

local function WriteBroadcast( ply, args, text )
    if GetMayor() != ply then return end
	text = string.gsub( text, "/broadcast", "" )
	if text == "" then return end
	RP.PLUGINS.CHATCOMMAND.Send_Chat( ply, text, 5)
end
RP.PLUGINS.CHATCOMMAND.AddChatCommand( "/broadcast", WriteBroadcast )

local function WriteEmergency( ply, args, text )
	if text == "" then return end
	text = string.gsub( text, "/911", "" )
	RP.PLUGINS.CHATCOMMAND.Send_Chat( ply, text, 911)
end
RP.PLUGINS.CHATCOMMAND.AddChatCommand( "/911", WriteEmergency )

--[[---------------------------------------------------------
   Name: RP.PLUGINS:ConvertText( text )
   Desc: Converts the text behind the command to args [ table ]
-----------------------------------------------------------]]
function RP.PLUGINS.CHATCOMMAND.ConvertText( text )
    local explode = string.Explode( " ", text )
    local args = {}
    for i=2, #explode do
        table.insert( args, explode[i] )
    end
    return args
end

function RP.PLUGINS.CHATCOMMAND.FindUserByName( name )
    for k, v in pairs( player.GetAll() ) do
        if string.find( string.lower((v:GetRPVar( "rpname" ) or v:Nick())), string.lower(name) ) then
            return v
        end
    end
    return nil
end