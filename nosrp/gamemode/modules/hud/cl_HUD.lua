local HEALTH_VISUAL = HEALTH_VISUAL or {}
local cash = 0

local function DrawSkillProgress( x, y, w, h, max, cur, text, col1 )

    col1 = col1 or HUD_SKIN.THEME_COLOR
    cur = cur or 100
    
    local left = x
    local bar_w, bar_h = w, h
    bar_w = bar_w
        
    local inner_left = left + 2
    local inner_top = y + 2
    local inner_w = bar_w - 4
    local inner_h = bar_h - 4
            
    draw.RoundedBox( 2, x, y, bar_w, bar_h, Color( 100, 100, 100, 50 ) )
            
    local font = "RPNormal_25"
    local text = text
    surface.SetFont( font )
    local t_w, t_h = surface.GetTextSize( text )
            

    local p_w = (inner_w / (max or 0)) * cur
            
    draw.RoundedBox( 2, inner_left, inner_top, p_w, inner_h, Color( col1.r, col1.g, col1.b, 150 ) )
    draw.SimpleText( text, font, (left + bar_w) - (15 + t_w), inner_top - t_h/1.5, Color( 255, 255, 255, 150 ) )
end

function GM:HUDShouldDraw( name )
    if ( name == "CHudHealth" or name == "CHudBattery" or name == "CHudDeathNotice" or name == "CHudAmmo" ) then
        return false
    end
    return true
end

local function DrawHudBox( text, icon, x, y, w, h, col, tcol )
    tcol = tcol or Color( 0, 0, 0, 200 )
    if text == nil then return end
    local font = "RPNormal_" .. math.Round( (w + h) / 3 )
    surface.SetFont( font )
    local len, hi = surface.GetTextSize( text )
    draw.RoundedBox( 2, x, y, w + ( 10 + len ), h, col )
    draw.RoundedBox( 2, x, y, h, h, Color( 0, 0, 0, 50 ) )
    draw.RoundedBox( 2, x + 1, y + 1, h - 2, h - 2, Color( 255, 255, 255, 50 ))
    draw.RoundedBox( 2, x + 2, y + 2, h - 4, h - 4, HUD_SKIN.THEME_COLOR )
    draw.SimpleText( text, font, x + h + 10, y + 4, tcol )
    draw.SimpleText( icon, font, x + (h/3), y + 3, Color( 255, 255, 255, 200 ) )
end

local pl_health = 0
local pl_stamina = 0

hook.Add( "InitPostEntity", "LoadPLHealth", function()
	pl_health = (LocalPlayer():Health() or 0)
	pl_stamina = 0--(LocalPlayer():GetRPVar( "stamina" ) or 0)
end)

function cl_DrawLeftHUD()
	

    local w, h = 50, 50
    local x, y = 20 + w, ScrH() - (w + 15)
    local outline = 4
    local o = w - outline
    
    local health = LocalPlayer():Health()
    local hp_calc = (1 / 100) * math.Clamp( pl_health, 0, 100 )
    
    local stamina = LocalPlayer():GetRPVar( "stamina" )
    local stamina_calc = (.25 / 100) * math.Clamp( pl_stamina, 0, 100 )
    
    if !(health == pl_health) then
        pl_health = Lerp( 6*FrameTime(), pl_health, health )
    end
    
    if !(stamina == pl_stamina) then
        --pl_stamina = Lerp( 6*FrameTime(), pl_stamina, stamina )
    end
    
    
    draw.RoundedBox( 8, x, y - w + 6, 250, h*2 - 12, Color( 0, 0, 0, 150 ) )
    
    DrawCircleGradient( x - outline + 4, y + outline - 4, o + 8, .25, Color( 0, 0, 0, 150 ) )
    DrawCircle( x - outline + 4, y + outline - 4, o + 8, stamina_calc, Color( 0, 155, 255, 255 ) )
    
    DrawCircleGradient( x, y, w, 1, Color( 0, 0, 0, 150 ) )
    DrawCircle( x, y, w, hp_calc, Color( 150, 150, 150, 255 ) )
    
    DrawCircle( x, y, o, 1, Color( 255, 255, 255, 255 ) )
    DrawCircleGradient( x, y, o, 1, Color( 0, 0, 0, 150 ) )
    
	if LocalPlayer():GetRPVar( "cash" ) != nil then
		draw.SimpleText( LocalPlayer():GetRPVar( "rpname" ), "RPNormal_25", x + w + 5, y - (w/2), Color( 255, 255, 255, 200 ), 0, 1 )
		draw.SimpleText( LocalPlayer():GetRPVar( "cash" ) .. ",-EUR", "RPNormal_29", x + w + 15, y, Color( 0, 150, 0, 200 ), 0, 1 )
	end
    --local id = "roleplay/hud/hud_heart.png"
    --surface.SetMaterial( Material( id ) )
    --surface.SetDrawColor( Color( 255, 255, 255, 255 ) )
    --surface.DrawTexturedRect( x - (w/2), y - (w/2), 64, 64 )
end

function cl_DrawImportantBars()
    local alpha_parts = 50
    local alpha_normal = 25
    
    local w1, h1 = 250, 20
    local w2, h2 = 250, 20
    local ruf = LocalPlayer():GetRPVar( "skills_Ruf")
    DrawSkillProgress( ScrW() - (w1 + 15), ScrH() - (h1 + 15 ), 250, 20, 100, ruf, "Stadt Ruf" )
    
    local e_rech = (100 / ECONOMY.MAX) * (ECONOMY.CITY_CASH or 0)
    local col_rech = (255 / ECONOMY.MAX) * (ECONOMY.CITY_CASH or 0)
    DrawSkillProgress( ScrW() - (w2 + 15), ScrH() - (h2 + 50 ), 250, 20, 100, math.Clamp(e_rech, 0, 100), "Economy" )
end

local wave_left = 0
local wave_state = 1
local points = 1
local next_point = CurTime() + 1
function cl_DrawLoading()
	draw.RoundedBox( 0, 0, 0, ScrW(), ScrH(), Color( 0, 0, 0, 255 ) )
	
	local p = ""
	for i=1, points do
		p = p .. "."
	end
	if next_point < CurTime() then
		next_point = CurTime() + 1
		points = points + 1
		if points > 3 then points = 0 end
	end
	
	
	draw.SimpleText( "Lade Spielerdaten" .. p, "RPNormal_40", ScrW()/2, ScrH()/2, Color( 255 ,255, 255, 255 ), 1, 1 )
	draw.SimpleText( "Bitte habe ein kleinen moment Geduld.", "RPNormal_20", ScrW()/2, ScrH()/1.9, Color( 255 ,255, 255, 255 ), 1, 1 )
end

function cl_DrawModernHUD()
	if LocalPlayer():GetRPVar( "cash" ) == nil then
		cl_DrawLoading()
		return 
	end
	
	if cash != LocalPlayer():GetRPVar( "cash" ) then cash = Lerp( .1, cash, LocalPlayer():GetRPVar( "cash" )) end
	
	draw.SimpleText( LocalPlayer():GetRPVar( "rpname" ), "RPNormal_40", 25, ScrH()/1.18, Color( 255, 255, 255, 50 ) )
	draw.SimpleText( math.Round(cash) .. ",-EUR", "RPNormal_25", 25, ScrH()/1.125, Color( 0, 200, 0, 50 ) )
	
	
	//Health Bar
	local channel = Radio_Get_Loudest()
	local pos_x, pos_y, size_x, size_y, thickness = -150, ScrH()/1.1, 250, 100, 3
	local t = (thickness*2) - 10
	
	for k, v in pairs( HEALTH_VISUAL ) do
		v.move = v.move + 2
		local alpha = (size_x-v.move)
		local fade_pxl = 50
		local left_fade = (230/200)*(size_x - v.move)
		local right_fade = (230/50)*v.move
		if v.move > fade_pxl then
			local col = Color( 0, 150-math.sin( CurTime()*2)*50, 0, math.Clamp(left_fade, 0, 25) )
			
			if LocalPlayer():Health() < 51 && LocalPlayer():Health() > 26 then 
				col.r = 255 
				col.g = 204 
				col.b = 51 
				col.a = 25-math.sin( CurTime()*1.5)*20
			end
			if LocalPlayer():Health() < 26 then  col = Color( math.sin( CurTime()*3)*255, 50-math.sin( CurTime()*3)*100, 0, math.Clamp(left_fade, 0, 25) ) end
			
			draw.RoundedBox( 1, (pos_x + size_x/2) + (v.move + thickness), pos_y + v.left_h, thickness, 5, col )
		else
			
			--draw.RoundedBox( 0, (pos_x + size_x/2) + (v.move + thickness), pos_y + v.left_h, thickness, size_y - v.left_h, Color( 0, 200, 0, math.Clamp(right_fade, 0, 50) ) )
		end
		if (v.move - 5) > size_x then table.remove( HEALTH_VISUAL, k ) continue end
		if v.move < t then return end
		
		local wave_l = 15
		--if v.move > 2 && v.move < size_x/4 then v.left_h = Lerp( v.left_h, v.left_h, v.left_h - substract ) end
		--if v.move > size_x/4 && v.move < size_x/1.5 then v.left_h = Lerp( v.left_h, v.left_h, v.left_h + substract ) end
	end
	
	local left, right = 0.8, 0.8
	
	// Wave
	local c = math.sin( CurTime()*3)
	
	local left_vol = (size_y/100)*left*100
	local left_h = (size_y/100)*left_vol
	
	if c > 0 then
		table.insert( HEALTH_VISUAL, {move=0, left_h=left_h-(c*50)} )
	else
		table.insert( HEALTH_VISUAL, {move=0, left_h=left_h+(c*50)} )
	end
	
end

function DrawLocalHUD()
    if IsValid(LocalPlayer():GetVehicle()) && LocalPlayer():GetVehicle():GetNWInt( "fuel" ) then
       -- DrawHudBox( math.Round(LocalPlayer():GetVehicle():GetNWInt( "fuel" )) .. " Liter", "T", 120, ScrH() - 170, 50, 35, Color( 0, 0, 0, 200 ), Color( 255, 255, 255, 200 ) )
    end
    
	cl_DrawModernHUD()
    cl_DrawImportantBars()
end

function CRP_HUDPaint()
	tutorial.cache.MovePlay = tutorial.cache.MovePlay or false
    if !(tutorial.cache.MovePlay) then
        DrawLocalHUD()
    end
end
hook.Add( "HUDPaint", "CRP_DrawHUD", function() CRP_HUDPaint() end)

function PlayerDieingSounds( )
    // Local player heartbeat on death.
    if LocalPlayer():Health() <= 20 then
    if !GAMEMODE.HeartbeatNoise then
        GAMEMODE.HeartbeatNoise = CreateSound(LocalPlayer(), Sound('player/heartbeat1.wav'));
    end
    
    local rech = 8/LocalPlayer():Health()
    
    GAMEMODE.LastHeartBeatPlay = GAMEMODE.LastHeartBeatPlay or 0;
    
    if GAMEMODE.LastHeartBeatPlay + .717 <= CurTime() then
        GAMEMODE.LastHeartBeatPlay = CurTime();
        GAMEMODE.HeartbeatNoise:Stop();
        GAMEMODE.HeartbeatNoise:Play();
        GAMEMODE.HeartbeatNoise:ChangeVolume( math.Clamp(rech, 0, 1), 0 )
    end
    elseif GAMEMODE.HeartbeatNoise then
        GAMEMODE.HeartbeatNoise:Stop();
        GAMEMODE.HeartbeatNoise = nil;
    end
    
    // global player moaning on death
    for k, v in pairs(player.GetAll()) do
    if !v:Alive() then
        v:GetTable().NextGroan = v:GetTable().NextGroan or CurTime() + math.random(5, 15);
        
        if v:GetTable().NextGroan < CurTime() then
            v:GetTable().NextGroan = nil;
        
            local ToUse = "male";
            if string.match( LocalPlayer():GetModel(), "female", 0 ) then ToUse = "female" end
            local MoanFile = Sound('vo/npc/' .. ToUse .. '01/moan0' .. math.random(1, 5) .. '.wav');
           sound.Play(MoanFile, v:GetPos(), 100, 100);
        end
        elseif v:GetTable().NextGroan then
            v:GetTable().NextGroan = nil;
        end
    end
end
hook.Add('Think', 'PlayerDieingSounds', PlayerDieingSounds);
