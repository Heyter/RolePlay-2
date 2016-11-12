tutorial = {}
tutorial.config = {}
tutorial.cache = {}
tutorial.Movings = {}

tutorial.config.fading_end = 2
tutorial.config.fading_start = 3

function tutorial.AddMove( name, from_pos, to_pos, look_to, time, drawing_function )
    name = name or "Unknown"
    from_pos = from_pos or nil
    to_pos = to_pos or nil
    look_to = look_to or nil
    time = time or 4
    drawing_function = drawing_function or (function() end)
    if from_pos == nil then return nil end
    if to_pos == nil then return nil end
    if look_to == nil then return nil end
    
    table.insert( tutorial.Movings, {
        name = name,
        from = from_pos,
        to = to_pos,
        look = look_to,
        time = time,
        drawing = drawing_function
    })
    
    return #tutorial.Movings
end

tutorial.AddMove( "TEST#1", Vector(-5950, -7761, 175), Vector(-5968, -6171, 175), Angle(0, 0, 0), 15, function( time )
    draw.SimpleText( "Willkommen zu NOS Role-Play", "Trebuchet50", ScrW()/3.3 + (-150-time*20), ScrH()/1.5, Color( 50, 150, 255, 150 ) )
    draw.SimpleText( "Gamemode von: ThaRealCamotrax", "Trebuchet50", ScrW()/3 + (-380+time*10), ScrH()/1.4, Color( 255, 255, 255, 50 ) )
    draw.SimpleText( "Just4FunKiller", "Trebuchet25", ScrW()/1.79 + (-350+time*10), ScrH()/1.32, Color( 255, 255, 255, 50 ) )
end)
tutorial.AddMove( "TEST#2", Vector(-5777, 13698, 274), Vector(-6287, 13693, 678), Angle(10, 180, 0), 7.5, function( time )
    draw.SimpleText( "Die RolePlay Revolution!", "Trebuchet50", ScrW()/3.3 + (-140-time*20), ScrH()/1.5, Color( 50, 150, 255, 150 ) )
    draw.SimpleText( "Ein Spielerlebniss wie nie zuvor", "Trebuchet50", ScrW()/3 + (-380+time*10), ScrH()/1.4, Color( 255, 255, 255, 50 ) )
    draw.SimpleText( "Autos, Apartments, Waffen, Crafting und mehr!", "Trebuchet25", ScrW()/2.5 + (-350+time*10), ScrH()/1.32, Color( 255, 255, 255, 50 ) )
    draw.SimpleText( "Einzigartig Sicher!", "Trebuchet50", ScrW()/1.9 - (-10-time*20), 75, Color( 255, 153, 0, 150 ) )
    draw.SimpleText( "NOS-AntiCheat erfasst Aimbot, Wallhack & Co", "Trebuchet25", ScrW()/1.7 + (100-time*20), 120, Color( 255, 255, 255, 50 ) )
end)
tutorial.AddMove( "TEST#3", Vector(-8549, 8940, 281), Vector(-8609, 9368, 434), Angle(15, 175, 0), 10, function( time )
    --draw.SimpleText( "Die RolePlay Revolution!", "Trebuchet50", ScrW()/3.3 + (-140-time*20), ScrH()/1.5, Color( 50, 150, 255, 150 ) )
    --draw.SimpleText( "Ein Spielerlebniss wie nie zuvor", "Trebuchet50", ScrW()/3 + (-380+time*10), ScrH()/1.4, Color( 255, 255, 255, 50 ) )
    --draw.SimpleText( "Autos, Apartments, Waffen, Crafting und mehr!", "Trebuchet25", ScrW()/2.5 + (-350+time*10), ScrH()/1.32, Color( 255, 255, 255, 50 ) )
    --draw.SimpleText( "Einzigartig Sicher!", "Trebuchet50", ScrW()/1.9 - (-10-time*20), 75, Color( 255, 153, 0, 150 ) )
    --draw.SimpleText( "NOS-AntiCheat erfasst Aimbot, Wallhack & Co", "Trebuchet25", ScrW()/1.7 + (100-time*20), 120, Color( 255, 255, 255, 50 ) )
end)
tutorial.AddMove( "TEST#4", Vector(3631, -6392, 127), Vector(6728, -6391, 485), Angle(0, 90, 0), 19, function( time )
    --draw.SimpleText( "Die RolePlay Revolution!", "Trebuchet50", ScrW()/3.3 + (-140-time*20), ScrH()/1.5, Color( 50, 150, 255, 150 ) )
    --draw.SimpleText( "Ein Spielerlebniss wie nie zuvor", "Trebuchet50", ScrW()/3 + (-380+time*10), ScrH()/1.4, Color( 255, 255, 255, 50 ) )
    --draw.SimpleText( "Autos, Apartments, Waffen, Crafting und mehr!", "Trebuchet25", ScrW()/2.5 + (-350+time*10), ScrH()/1.32, Color( 255, 255, 255, 50 ) )
    --draw.SimpleText( "Einzigartig Sicher!", "Trebuchet50", ScrW()/1.9 - (-10-time*20), 75, Color( 255, 153, 0, 150 ) )
    --draw.SimpleText( "NOS-AntiCheat erfasst Aimbot, Wallhack & Co", "Trebuchet25", ScrW()/1.7 + (100-time*20), 120, Color( 255, 255, 255, 50 ) )
end)
tutorial.AddMove( "TEST#5", Vector(4363, 12812, 142), Vector(3999, 13076, 563), Angle(4, -140, 0), 15, function( time )
    --draw.SimpleText( "Die RolePlay Revolution!", "Trebuchet50", ScrW()/3.3 + (-140-time*20), ScrH()/1.5, Color( 50, 150, 255, 150 ) )
    --draw.SimpleText( "Ein Spielerlebniss wie nie zuvor", "Trebuchet50", ScrW()/3 + (-380+time*10), ScrH()/1.4, Color( 255, 255, 255, 50 ) )
    --draw.SimpleText( "Autos, Apartments, Waffen, Crafting und mehr!", "Trebuchet25", ScrW()/2.5 + (-350+time*10), ScrH()/1.32, Color( 255, 255, 255, 50 ) )
    --draw.SimpleText( "Einzigartig Sicher!", "Trebuchet50", ScrW()/1.9 - (-10-time*20), 75, Color( 255, 153, 0, 150 ) )
    --draw.SimpleText( "NOS-AntiCheat erfasst Aimbot, Wallhack & Co", "Trebuchet25", ScrW()/1.7 + (100-time*20), 120, Color( 255, 255, 255, 50 ) )
end)
tutorial.AddMove( "TEST#6", Vector(-6003, -3385, 132), Vector(-6379, -4223, 787), Angle(4, -95, 0), 8.9, function( time )
    --draw.SimpleText( "Die RolePlay Revolution!", "Trebuchet50", ScrW()/3.3 + (-140-time*20), ScrH()/1.5, Color( 50, 150, 255, 150 ) )
    --draw.SimpleText( "Ein Spielerlebniss wie nie zuvor", "Trebuchet50", ScrW()/3 + (-380+time*10), ScrH()/1.4, Color( 255, 255, 255, 50 ) )
    --draw.SimpleText( "Autos, Apartments, Waffen, Crafting und mehr!", "Trebuchet25", ScrW()/2.5 + (-350+time*10), ScrH()/1.32, Color( 255, 255, 255, 50 ) )
    --draw.SimpleText( "Einzigartig Sicher!", "Trebuchet50", ScrW()/1.9 - (-10-time*20), 75, Color( 255, 153, 0, 150 ) )
    --draw.SimpleText( "NOS-AntiCheat erfasst Aimbot, Wallhack & Co", "Trebuchet25", ScrW()/1.7 + (100-time*20), 120, Color( 255, 255, 255, 50 ) )
end)
tutorial.AddMove( "TEST#7", Vector(-4979, -480, 112), Vector(-4979, 8872, 141), Angle(0, 90, 0), 6.2, function( time )
    --draw.SimpleText( "Die RolePlay Revolution!", "Trebuchet50", ScrW()/3.3 + (-140-time*20), ScrH()/1.5, Color( 50, 150, 255, 150 ) )
    --draw.SimpleText( "Ein Spielerlebniss wie nie zuvor", "Trebuchet50", ScrW()/3 + (-380+time*10), ScrH()/1.4, Color( 255, 255, 255, 50 ) )
    --draw.SimpleText( "Autos, Apartments, Waffen, Crafting und mehr!", "Trebuchet25", ScrW()/2.5 + (-350+time*10), ScrH()/1.32, Color( 255, 255, 255, 50 ) )
    --draw.SimpleText( "Einzigartig Sicher!", "Trebuchet50", ScrW()/1.9 - (-10-time*20), 75, Color( 255, 153, 0, 150 ) )
    --draw.SimpleText( "NOS-AntiCheat erfasst Aimbot, Wallhack & Co", "Trebuchet25", ScrW()/1.7 + (100-time*20), 120, Color( 255, 255, 255, 50 ) )
end)

tutorial.AddMove( "TEST#8", Vector(7246, 5206, 408), Vector(7248, 5206, 408), Angle(10, -38, 0), 0.4, function( time )
    tutorial.config.fading_end = 0.1
    tutorial.config.fading_start = 0.1
end)
tutorial.AddMove( "TEST#9", Vector(7258, 5197, 405), Vector(7258, 5197, 405), Angle(10, -38, 0), 0.4, function( time )
    tutorial.config.fading_end = 0.1
    tutorial.config.fading_start = 0.1
end)
tutorial.AddMove( "TEST#10", Vector(7304, 5160, 395), Vector(7304, 5160, 395), Angle(10, -38, 0), 0.4, function( time )
    tutorial.config.fading_end = 0.1
    tutorial.config.fading_start = 2
end)
tutorial.AddMove( "TEST#11", Vector(7344, 5128, 385), Vector(7316, 4597, 795), Angle(10, -38, 0), 2.7, function( time )
    --draw.SimpleText( "Die RolePlay Revolution!", "Trebuchet50", ScrW()/3.3 + (-140-time*20), ScrH()/1.5, Color( 50, 150, 255, 150 ) )
    --draw.SimpleText( "Ein Spielerlebniss wie nie zuvor", "Trebuchet50", ScrW()/3 + (-380+time*10), ScrH()/1.4, Color( 255, 255, 255, 50 ) )
    --draw.SimpleText( "Autos, Apartments, Waffen, Crafting und mehr!", "Trebuchet25", ScrW()/2.5 + (-350+time*10), ScrH()/1.32, Color( 255, 255, 255, 50 ) )
    --draw.SimpleText( "Einzigartig Sicher!", "Trebuchet50", ScrW()/1.9 - (-10-time*20), 75, Color( 255, 153, 0, 150 ) )
    --draw.SimpleText( "NOS-AntiCheat erfasst Aimbot, Wallhack & Co", "Trebuchet25", ScrW()/1.7 + (100-time*20), 120, Color( 255, 255, 255, 50 ) )
end)

tutorial.AddMove( "TEST#12", Vector(-388, 2819, 522), Vector(-389, 2819, 522), Angle(7, 61, 0), 0.4, function( time )
    tutorial.config.fading_end = 0.1
    tutorial.config.fading_start = 0.1
end)
tutorial.AddMove( "TEST#13", Vector(-331, 2924, 507), Vector(-332, 2924, 507), Angle(7, 61, 0), 0.4, function( time )
    tutorial.config.fading_end = 0.1
    tutorial.config.fading_start = 0.1
end)
tutorial.AddMove( "TEST#14", Vector(-267, 3042, 489), Vector(-268, 3042, 489), Angle(7, 61, 0), 0.4, function( time )
    tutorial.config.fading_end = 2
    tutorial.config.fading_start = 3
end)
tutorial.AddMove( "TEST#15", Vector(-527, 4553, 398), Vector(-308, 4840, 612), Angle(11, 7, 0), 3, function( time )
    --draw.SimpleText( "Die RolePlay Revolution!", "Trebuchet50", ScrW()/3.3 + (-140-time*20), ScrH()/1.5, Color( 50, 150, 255, 150 ) )
    --draw.SimpleText( "Ein Spielerlebniss wie nie zuvor", "Trebuchet50", ScrW()/3 + (-380+time*10), ScrH()/1.4, Color( 255, 255, 255, 50 ) )
    --draw.SimpleText( "Autos, Apartments, Waffen, Crafting und mehr!", "Trebuchet25", ScrW()/2.5 + (-350+time*10), ScrH()/1.32, Color( 255, 255, 255, 50 ) )
    --draw.SimpleText( "Einzigartig Sicher!", "Trebuchet50", ScrW()/1.9 - (-10-time*20), 75, Color( 255, 153, 0, 150 ) )
    --draw.SimpleText( "NOS-AntiCheat erfasst Aimbot, Wallhack & Co", "Trebuchet25", ScrW()/1.7 + (100-time*20), 120, Color( 255, 255, 255, 50 ) )
    tutorial.config.fading_end = 2
    tutorial.config.fading_start = 3
end)
tutorial.AddMove( "TEST#15", Vector(-5751, -10686, 197), Vector(-5748, -9847, 197), Angle(0, 180, 0), 14.6, function( time )
    draw.SimpleText( "Und jetzt viel Spaß auf unseren RP!", "Trebuchet50", ScrW()/3.3 + (-140-time*20), ScrH()/1.5, Color( 50, 150, 255, 150 ) )
    draw.SimpleText( "Web: WwW.NOS-Gaming.de", "Trebuchet50", ScrW()/3 + (-380+time*10), ScrH()/1.4, Color( 255, 255, 255, 50 ) )
    tutorial.config.fading_end = 3
    tutorial.config.fading_start = 3
end)
tutorial.AddMove( "TEST#16", Vector(-8477, -9359, 255), Vector(-8477, -9359, 983), Angle(9, -144, 0), 20, function( time )
    draw.SimpleText( "NOS", "RPNormal_45", ScrW()/2, ScrH()/2.2, Color( 255, 153, 0, 100 ), 1, 1 )
    draw.SimpleText( " - RolePlay - ", "RPNormal_60", ScrW()/2, ScrH()/2, Color( 50, 150, 255, 150 ), 1, 1 )
    draw.SimpleText( "Credits: Sligwolf - Models", "Trebuchet15", ScrW()/2, ScrH()/1.87, Color( 255, 255, 255, 100 ), 1, 1 )
    tutorial.config.fading_end = 2
    tutorial.config.fading_start = 3
end)

function tutorial.PlayMove()
    surface.PlaySound( "nosrp/intro/intro.mp3" )
    timer.Simple( 112.4, function() RunConsoleCommand( "stopsound" ) end )
    tutorial.cache = tutorial.cache or {}
    tutorial.cache.move_index = 1
    tutorial.cache.move_start = CurTime()
    tutorial.cache.move_end = CurTime() + tutorial.Movings[1].time
    tutorial.cache.MovePlay = true
end

function tutorial.FinishMove()
    tutorial.cache.MovePlay = false
end


/****************
    Drawing
*****************/
hook.Add( "HUDPaint", "Tutorial_Drawing", function()
    tutorial.cache.MovePlay = tutorial.cache.MovePlay or false
    if tutorial.cache.MovePlay then   // Movings Started
        local tbl = tutorial.Movings[tutorial.cache.move_index]
        
        tbl.drawing( tutorial.cache.move_end - CurTime() )
        
        local alpha = 255
        if (tutorial.cache.move_end - CurTime()) <= tutorial.config.fading_end + 0.3 then
            local combined = ((tutorial.cache.move_end) - CurTime())
            alpha = (255 / tutorial.config.fading_end) * (combined -0.3)
        else
            local combined = (tutorial.cache.move_end - tutorial.cache.move_start) - (tutorial.cache.move_end - CurTime())
            alpha = (255 / tutorial.config.fading_start) * (combined -.5)
            
        end
        draw.RoundedBox( 0, 0, 0, ScrW(), ScrH(), Color( 0, 0, 0, 255 - alpha ) ) // Black fading
        
    end
end)

hook.Add( "CalcView", "Tutorial_CalcView", function( ply, pos, angles, fov )
    tutorial.cache.MovePlay = tutorial.cache.MovePlay or false
    if tutorial.cache.MovePlay then
    
        local view = {}
        local tbl = tutorial.Movings[tutorial.cache.move_index]
        local from, to = tbl.from, tbl.to

 	               view.origin = MoveToPos( from, to, tutorial.cache.move_start, tbl.time )
 	               view.angles = tbl.look --angles
 	               view.fov = fov --fov
              view.drawviewer = true
 	            
 	               return view
    
    end
end)

hook.Add( "Think", "Tutorial_Think", function()
    tutorial.cache.MovePlay = tutorial.cache.MovePlay or false
    if tutorial.cache.MovePlay then
    
        if CurTime() > tutorial.cache.move_end then
            tutorial.cache.move_index = tutorial.cache.move_index + 1
            if tutorial.cache.move_index > #tutorial.Movings then
                tutorial.FinishMove()
                return
            end
            tutorial.cache.move_start = CurTime()
            tutorial.cache.move_end = CurTime() + tutorial.Movings[tutorial.cache.move_index].time
        end
    
    end
end)

/****************
    MoveToPos
*****************/

function MoveToPos( from, to, start, time, delay, callback )
    from = from or nil
    to = to or nil
    time = time or 1
    delay = delay or 0
    callback = callback or (function() end)
    if from == nil then return nil end
    if to == nil then return nil end
    
    local time_rech = (time / 100)
    local percent = (CurTime() - start) / time_rech
    local mid = LerpVector( percent/100, from, to )
    
    if percent >= 100 then
        mid = LerpVector( 1, from, to )
        callback() 
        return mid
    end
    
    return mid
end