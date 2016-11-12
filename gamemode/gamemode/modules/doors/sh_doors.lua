function IsDoor( door )
    if (door:GetClass() == "prop_door_rotating" or door:GetClass() == "prop_door" or door:GetClass() == "func_door" or door:GetClass() == "func_door_rotating" or door:GetClass() == "prop_vehicle_jeep" or door:GetClass() == "prop_vehicle_jeep_old") then
        return true
    else
        return false
    end
end

function CompareVector( str )
	local vec = {}
	
	for k, v in pairs( string.Explode( " ", str ) ) do
		table.insert( vec, tonumber( v ) )
	end
	return Vector( vec[1], vec[2], vec[3] )
end

function FindDoor( pos )
	local doors = ents.FindInSphere( pos, 5 )
	for k, v in pairs( doors or {} ) do
		if IsDoor( v ) then
			return v
		end
	end
	
	if !(found) then
		return nil
	end
end

local door_meta = FindMetaTable( "Entity" )
function door_meta:GetDoorOwner()
    if !(IsValid( self )) then return nil end
    if !(IsDoor( self)) then return nil end
    
    local data = self:GetRPVar( "doordata" )
    if self.master then
        return self.master.owner
    end
    return data.owner
end

if CLIENT then
	local viewdistance = 250
	
	net.Receive( "SendDoorTable", function()
		local tbl = net.ReadTable() or nil
		if tbl == nil then return end
		RP.Doors = tbl
        
        for k, v in pairs( RP.Doors ) do
           v.owner = v.owner or nil
           v.door:SetRPVar( "doordata", {owner=v.owner, title=v.title, cost=v.cost, teams=v.teams, pos=v.pos, subdoors=v.subdoors, locked=v.locked, door=v.door} )
            
            for _, pos in pairs( v.subdoors ) do
                local doordata = v.door:GetRPVar( "doordata" )
                if doordata == nil then continue end
                owner = owner or nil
                local door = FindDoor( CompareVector( pos ) )
                if door != nil then
                    door:SetRPVar( "doordata", {owner=owner, title=doordata.title, cost=doordata.cost, teams=doordata.teams, pos=doordata.position, subdoors=doordata.subdoors, locked=doordata.locked, masterdoor=v.door, door=door} )
                end
            end

        end
	end)
    
    local lastdatarequest = CurTime() - 1
	
	hook.Add( "PostDrawOpaqueRenderables", "RP_DrawDoorText", function()
	
		local doors = ents.FindInSphere( LocalPlayer():GetPos(), viewdistance )
		for k, v in pairs( doors ) do
			if !(IsValid( v )) or !(IsDoor( v )) then continue end
			if !(RPIsInSight( v )) then continue end		// FPS Fix!
			
			local data = v:GetRPVar( "doordata" )
            if data == nil && lastdatarequest < CurTime() then
                net.Start( "RequestDoorTable" )
                net.SendToServer()
                lastdatarequest = CurTime() + 10
                return
            end
			local alpha = math.Clamp((viewdistance+50) - v:GetPos():Distance( LocalPlayer():GetPos() ), 0, 255)
			if alpha < 1 then continue end

			if !(data) then continue end
			if (LocalPlayer():InVehicle()) then return end
			if v:IsVehicle() then continue end
			
			
			local pos = v:GetPos() + v:OBBCenter()
			local offset = Vector( 0, 0, -4 )
			local doormul = 3.5
			local text = "Owned!"
			local font = "RPNormal_10"
			local len = surface.GetTextSize( text )
			local col = Color( 255, 255, 255, 255 )
			
			if v:GetClass() == "func_door_rotating" then
				doormul = 2
				offset = Vector( 0, 0, 4 )
			else
				doormul = 1.1
				offset = Vector( 0, 0, 4 )
			end
			
			local Ang = v:GetAngles()
			local Ang2 = v:GetAngles()
			
			Ang:RotateAroundAxis(Ang:Up(), 90)
			Ang:RotateAroundAxis(Ang:Forward(), 90)
			Ang:RotateAroundAxis(Ang:Right(), 180)
			
			Ang2:RotateAroundAxis(Ang2:Up(), 90)
			Ang2:RotateAroundAxis(Ang2:Forward(), 90)
			Ang2:RotateAroundAxis(Ang2:Right(), 0)
			
			pos = v:LocalToWorld( v:OBBCenter() ) + offset
			
			
			data.masterdoor = data.masterdoor or nil
			if data.masterdoor != nil && IsValid( data.masterdoor:GetRPVar( "doordata" ).owner ) then continue end
			
			if !(IsValid( data.owner )) then
				text = data.title
				font = "RPNormal_40"
				col = Color( 200, 0, 0, 255 )
				len = surface.GetTextSize( text )
			end

            local imbuddy = false
			if (IsValid( data.owner )) && !(#data.teams > 0) then
				text = data.title
				font = "RPNormal_40"
				if data.owner == LocalPlayer() then
					col = Color( 0, 200, 0, 255 )
                elseif data.owner:IsBuddy( LocalPlayer() ) then
                    col = Color( 51, 153, 255, 255 )
                    imbuddy = true
				else
					col = Color( 200, 0, 0, 255 )
				end
				len = surface.GetTextSize( text )
			end

			
			if !(IsValid( data.owner )) && data.cost < 1 then
				text = data.title
				font = "RPNormal_40"
				col = HUD_SKIN.LIST_BG_FIRST
				len = surface.GetTextSize( text )
			end
			
			
			cam.Start3D2D(pos + Ang:Up() * doormul, Ang, 0.15)
				draw.SimpleTextOutlined(text, font, 0, 0, col, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 2, Color( 0, 0, 0, alpha ))
                if imbuddy == true then draw.SimpleTextOutlined("- Freund -", "RPNormal_25", 0, 30, col, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 2, Color( 0, 0, 0, alpha )) end
			cam.End3D2D()
			
			cam.Start3D2D(pos + Ang2:Up() * doormul, Ang2, 0.15)
				draw.SimpleTextOutlined(text, font, 0, 0, col, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 2, Color( 0, 0, 0, alpha ))
               if imbuddy == true then draw.SimpleTextOutlined("- Freund -", "RPNormal_25", 0, 30, col, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 2, Color( 0, 0, 0, alpha )) end
			cam.End3D2D()
			
		end
	end)
end