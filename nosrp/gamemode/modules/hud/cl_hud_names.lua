--[[---------------------------------------------------------
   File: hud_names.lua
   Desc: Shows names of other players
-----------------------------------------------------------]]

surface.CreateFont( "3D2DName", { 
    font = "coolvetica",
    size = 50,
    weight = 600,
    antialias = true,
    shadow = true
     } )

function draw.NameText(text, font, x, y, colour, xalign, yalign)
    draw.SimpleText(text, font, x, y + 4, Color(0,0,0,colour.a), xalign, yalign)
    draw.SimpleText(text, font, x + 1, y + 2, Color(0,0,0,colour.a), xalign, yalign)
    draw.SimpleText(text, font, x - 1, y + 2, Color(0,0,0,colour.a), xalign, yalign)
    draw.SimpleText(text, font, x, y, colour, xalign, yalign)
end

hook.Add( "HUDPaint", "NOSRP_DRAW_INFO", function()
    if tutorial.cache.MovePlay then return end
    local text = HUD_SKIN.TOP_TEXT
    local font = "RPNormal_30"
    surface.SetFont( font )
    local w, h = surface.GetTextSize( text )
    
    draw.SimpleText( text, font, (ScrW() - w)/2, 5, Color( 255, 255, 255, 200 ) )
    
    text = HUD_SKIN.TOP_TEXT_RED
    font = "RPNormal_20"
    surface.SetFont( font )
    w, h = surface.GetTextSize( text )
    draw.SimpleText( text, font, (ScrW() - w)/2, 33, Color( 255, 0, 0, 200 ) )
end)

local function DrawName(ply, opacityScale)

    if !(ply:IsVehicle()) then if !IsValid(ply) or !ply:Alive() then return end end

    local pos = ply:GetPos()
    local ang = LocalPlayer():EyeAngles()

    ang:RotateAroundAxis( ang:Forward(), 90 )
    ang:RotateAroundAxis( ang:Right(), 90 )

    if !(ply:IsVehicle()) then
        if ply:InVehicle() then
            pos = pos + Vector( 0, 0, 30 )
        else
            pos = pos + Vector( 0, 0, 60 )
        end
    end

    local dist = LocalPlayer():GetPos():Distance( ply:GetPos() )
    if ( dist >= 800 ) then return end // no need to draw anything if the player is far away

    local opacity = math.Clamp( 310.526 - ( 0.394737 * dist ), 0, 150 ) // woot mathematica

    opacityScale = opacityScale and opacityScale or 1
    opacity = opacity * opacityScale

    local name
    local t
    local col
    
    if ply:IsVehicle() then
        name = "  " .. string.upper( ply:GetRPVar( "owner" ):GetRPVar( "rpname" ))
        t = "   KM/H: " .. tostring( ply:GetSpeed() )
        col = GAMEMODE.TEAMS[ ply:GetRPVar("owner"):Team() ].Color
    else
        name = "  " .. string.upper( ply:GetRPVar("rpname") or ply:Nick() )
        t = "  " .. string.upper( GAMEMODE.TEAMS[ ply:Team() ].Name )
        col = GAMEMODE.TEAMS[ ply:Team() ].Color
    end
    
    if LocalPlayer():InVehicle() then
        pos = ply:GetPos()
        ang = ply:GetAngles( ply:GetAngles().p, ply:GetAngles().y, ply:GetAngles().r )
		
		draw.SimpleText( "Tank: " .. tostring(LocalPlayer():GetVehicle():GetNWInt("fuel")), "RPNormal_24", ScrW()/2, ScrH() - 50, Color( 255, 255, 255, 100), 1, 1 )
    end

    cam.Start3D2D( pos, Angle( 0, ang.y, 90 ), 0.15 )

        -- render.OverrideDepthEnable(false, true)
        if ply:IsPlayer() then
            draw.NameText( name, "RPNormal_40", 50, 0, Color( 255, 255, 255, opacity ) )
            draw.NameText( t, "RPNormal_25", 50, -20, Color( col.r, col.g, col.b, opacity ) )
            
            local count = ply:GetRPVar( "warrant" ) or 0
            for i= 0, 4 do
                local col = Color( 0, 0, 0, 100 )
                if count > i then col = Color( 255, 255, 255, 100 ) end
                local TexturedQuadStructure = {
                    texture = surface.GetTextureID( 'roleplay/hud/warrant_star' ), 
                    color = col, 
                    x 	= 65 + (16*i), 
                    y 	= 38, 
                    w 	= 16, 
                    h 	= 16
                }
                draw.TexturedQuad( TexturedQuadStructure )
            end
        else
            draw.NameText( name, "RPNormal_80", ply:OBBCenter().z*8, -ply:OBBCenter().z*10, Color( 255, 255, 255, opacity ) )
            draw.NameText( t, "RPNormal_60", ply:OBBCenter().z*8, -ply:OBBCenter().z*8.5, Color( 200, 0, 0, opacity ) )
        end

        -- render.OverrideDepthEnable(false, false)

    cam.End3D2D()

end

local HUDTargets = {}
local HUDTargetsNPCs = {}
local fadeTime = 1
hook.Add( "PostDrawTranslucentRenderables", "DrawPlayerNames", function()

    for ply, time in pairs(HUDTargets) do

        if time < RealTime() then
            HUDTargets[ply] = nil
            continue
        end

        -- Fade over time
        DrawName( ply, 0.8 * ((time - RealTime()) / fadeTime) )

    end

    local tr = util.GetPlayerTrace( LocalPlayer() )
    local trace = util.TraceLine( tr )
    if (!trace.Hit) then return end
    if (!trace.HitNonWorld) then return end
    
    if trace.Entity:IsVehicle() && trace.Entity:GetRPVar( "owner" ) == nil then
        net.Start( "SendPlayerVar" )
        net.SendToServer()
        return
    end

    -- Keep track of recently targetted players
    if trace.Entity:IsPlayer() then
        HUDTargets[trace.Entity] = RealTime() + fadeTime
    elseif trace.Entity:IsVehicle() and
        IsValid(trace.Entity:GetRPVar( "owner" )) and
        trace.Entity:GetRPVar( "owner" ):IsPlayer() then
        HUDTargets[trace.Entity] = RealTime() + fadeTime
    end

end )

function GM:HUDDrawTargetID()
    return false
end