net.Receive( "Send_Text", function( data )
	local text = net.ReadString()
	local ply = net.ReadEntity() or {}
	local mode = net.ReadFloat()
	
	if !( text ) then return end
	if !( IsValid( ply ) ) then return end	
	
	if mode == 0 then
	
	elseif mode == 1 then
		chat.AddText(Color(200,200,200), "[", Color(0,200,0), "LOCAL" , Color(200,200,200), "] ", team.GetColor( ply:Team() ), (ply:GetRPVar( "rpname" ) or ply:Nick()) .. " >> ", Color(200,200,200), text)
		chat.PlaySound()
		return
	elseif mode == 2 then
		chat.AddText(Color(200,200,200), "[", Color(200,0,0), "OOC" , Color(200,200,200), "] ", team.GetColor( ply:Team() ), ply:Nick() .. " >> ", Color(200,200,200), text)
		chat.PlaySound()
		return
    elseif mode == 3 then
        chat.AddText(Color(200,0,0), (ply:GetRPVar( "rpname" ) or ply:Nick()) .. " " .. text)
		chat.PlaySound()
    elseif mode == 4 then
        chat.AddText(Color(200,200,200), "[", Color(255, 204, 51), "Werbung" , Color(200,200,200), "] ", Color(200,200,200), text)
		chat.PlaySound()
    elseif mode == 5 then
        chat.AddText(Color(200,200,200), "[", Color(200, 0, 0), "Broadcast" , Color(200,200,200), "] ", Color(200, 0, 0), text)
		chat.PlaySound()
	elseif mode == 911 then
        chat.AddText(Color(200, 0, 0), (ply:GetRPVar( "rpname" ) or ply:Nick()) .. " >> ", Color(200,200,200), "[", Color(200, 0, 0), "911" , Color(200,200,200), "] ", Color(200, 0, 0), text)
		chat.PlaySound()
	end
end)

net.Receive( "Send_PM", function( data )
	local ply = net.ReadEntity() or {}
	local text = net.ReadString()

	
	if !( text ) then return end
	if !( IsValid( ply ) ) then return end	
	
	chat.AddText(Color(255,255,255), "[", Color( 0, 200, 0 ), "PM" , Color(255,255,255), "] " .. (ply:GetRPVar( "rpname" ) or ply:Nick()) .. " >> " .. text)
	chat.PlaySound()
end)