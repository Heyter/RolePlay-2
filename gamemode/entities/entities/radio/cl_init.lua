include("shared.lua")

BASS_CHANNELS = BASS_CHANNELS or {}
BASS_VISUAL = BASS_VISUAL or {}
local Range = 400
local text = ""
local font = "Trebuchet24"

local maxstreams = CreateClientConVar("radio_maxstreams", "10", true, false)

function ENT:Draw()
	self:DrawModel()
	
	--local VoiceChatTexture = surface.GetTextureID("voice/icntlk_pl")
	
	--render.SetViewPort( 0, 100, 50, 50 )
	
	--local offset = Vector( 0, 0, 15 )
	--local ang = self:GetAngles()
	--local pos = self:GetPos() + offset + ang:Up()
 
	--ang:RotateAroundAxis( ang:Forward(), 90 )
	--ang:RotateAroundAxis( ang:Right(), 90 )
 
	--cam.Start3D2D( pos, Angle( 0, ang.y, 90 ), 0.25 )
		--draw.DrawText( "Radio", "Default", 2, 2, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER )
	--cam.End3D2D()
end

function ENT:Think()
	local listeners = 0
	for k, v in pairs( BASS_CHANNELS ) do
		if !(IsValid( v.entity)) then // Radio got Remove
			StopBASSound( v.entity, true )
		end
		
		listeners = listeners + 1
		
		if listeners > maxstreams:GetInt() then 
			if (BASS_CHANNELS[k-1].playing) then 
				StopBASSound( BASS_CHANNELS[k-1].entity, true ) 
            end 
			return 
		end
        
        
		
		local dist = v.entity:GetPos():Distance(LocalPlayer():GetPos())
		v.sound:SetPos( v.entity:GetPos() )
		local rech = math.Clamp( (Range-dist)/500, 0, 1 )
		v.sound:SetVolume( rech )
		
		if rech >= 0.01 then
			text = "Radio: " .. v.sendername
			if !(v.playing) && BASS_Exists( v.entity ) != nil then v.playing = true StartBASSound( v.entity, v.sendername, v.URL ) end
		else
            if v.playing then
                text = ""
                v.playing=false
            end
			--if (v.playing) then StopBASSound( v.entity, false ) v.playing = false end
		end
	end
end

function Radio_Get_Loudest()
    local vol = 0
    local ch = nil
    for k, v in pairs( BASS_CHANNELS ) do
        if v.sound && v.sound:GetVolume() > vol then ch = k vol = v.sound:GetVolume() end
        continue
    end
    return BASS_CHANNELS[ch]
end

hook.Add( "HUDPaint", "RADIO_HUD", function()
	if text != "" then
        local channel = Radio_Get_Loudest()
        local pos_x, pos_y, size_x, size_y, thickness = ScrW()/2, ScrH()-100, 350, 100, 3
        local t = (thickness*2)+5
        
        --draw.RoundedBox( 0, pos_x - size_x/2, pos_y, size_x, size_y, Color( 0, 0, 0, 150 ) )
        draw.SimpleText( text, "RPNormal_21", pos_x - size_x/2, pos_y - 40, Color( 255, 255, 255, 200 ) )
        draw.SimpleText( channel.sound:GetFileName(), "RPNormal_19", pos_x - size_x/2, pos_y - 20, Color( 255, 255, 255, 200 ) )
        for k, v in pairs( BASS_VISUAL ) do
            v.move = v.move + 1
            local alpha = (size_x-v.move)
            local fade_pxl = 50
            local left_fade = (230/50)*(size_x - v.move)
            local right_fade = (230/50)*v.move
            if v.move > fade_pxl then
                draw.RoundedBox( 0, (pos_x + size_x/2) - v.move, pos_y + v.left_h, thickness, size_y - v.left_h, Color( 20, 20, 20, math.Clamp(left_fade, 0, 230) ) )
                draw.RoundedBox( 0, (pos_x + size_x/2) - (v.move + thickness), pos_y + v.left_h, thickness, size_y - v.left_h, Color( 50, 50, 50, math.Clamp(left_fade, 0, 230) ) )
            else
                draw.RoundedBox( 0, (pos_x + size_x/2) - v.move, pos_y + v.left_h, thickness, size_y - v.left_h, Color( 20, 20, 20, math.Clamp(right_fade, 0, 230) ) )
                draw.RoundedBox( 0, (pos_x + size_x/2) - (v.move + thickness), pos_y + v.left_h, thickness, size_y - v.left_h, Color( 50, 50, 50, math.Clamp(right_fade, 0, 230) ) )
            end
            if (v.move - 5) > size_x then table.remove( BASS_VISUAL, k ) continue end
            if v.move < t then return end
        end
        
        
        if !(channel) then return end
        
        local left, right = channel.sound:GetLevel( ) 
        
        local left_vol = (size_y/100)*left*100
        local right_vol = (size_y/100)*right*100
        local left_h, right_h = (size_y/100)*left_vol, (size_y/100)*right_vol
        
        table.insert( BASS_VISUAL, {move=0, left_h=left_h, right_h=right_h} )
	end
end)

net.Receive( "RADIO_PlayURL", function( data )
	local radio = net.ReadEntity()
	local tbl = net.ReadTable()
	StopBASSound( radio, true )
	StartBASSound( radio, tbl.name, tbl.URL )
end)

net.Receive( "RADIO_StopURL", function( data )
	local radio = net.ReadEntity()
	StopBASSound( radio, true )
	text = ""
end)

net.Receive( "RADIO_OpenURLMenu", function()
	OpenRadioMenu( net.ReadEntity() or {} )
end)

function BASS_Exists( ent )
	for k, v in pairs( BASS_CHANNELS ) do
		if v.entity == ent then return k end
	end
	return nil
end

function StopBASSound( ent, remove )
	remove = remove or false
	local radio = BASS_Exists( ent )
	if radio != nil && IsValid( BASS_CHANNELS[radio].sound ) then
		BASS_CHANNELS[radio].sound:Stop()
		text = ""
		if remove then table.remove( BASS_CHANNELS, radio ) end
		return
	end
end

function StartBASSound( ent, name, URL )
	name = name or "Standart"
	URL = URL or "http://listen.technobase.fm/dsl.pls"
	
	if !(IsValid(ent)) then return end
	
	local bass = BASS_Exists( ent )
	
	if bass == nil then
		sound.PlayURL( URL, "true;false;false;false", function(sound)
			if sound == nil then chat.AddText( Color( 0, 255, 0 ), "[RADIO] Media link isnt valid or not supported!" ) chat.PlaySound() return end
			if !(sound:IsValid()) then chat.AddText( Color( 0, 255, 0 ), "[RADIO] Media link isnt valid or not supported!" ) chat.PlaySound() return end
			
			if !(IsValid(ent)) then return end
			
			sound:SetPos( ent:GetPos() )
			sound:Play()
			text = "Radio: " .. name
			
			--if bass == nil then
				table.insert( BASS_CHANNELS, {entity = ent, sound = sound, sendername=name, URL=URL, playing = true} )
			--	print("call")
			--else
			--	table.insert( BASS_CHANNELS, {entity = ent, sound = sound, sendername=BASS_CHANNELS[bass].sendername, URL=BASS_CHANNELS[bass].URL, playing = true} )
			--	table.remove( BASS_CHANNELS, bass )
			--end
		end ) 
	else
		BASS_CHANNELS[bass].sound:Play()
	end
end

function OpenRadioMenu( radio )
    local w, t, h = 0, 0, 0
    local m_w, m_t = 450, 150
    
    local beginTime = CurTime( )
    local duration = 1.2
    local valueChange1 = m_w

    local valueChange2 = m_t
    
    local menu = vgui.Create( "DFrame" )
    menu:SetTall( t+ 30 )
    menu:SetWide( 30 )
    menu:SetTitle( " " )
    menu:MakePopup()
    menu.Think = function()
        local el = CurTime() - beginTime
        local result = easing.outElastic(el, 0, valueChange1, duration)
        menu:SetWide( math.Round(result) )
        
        local result = easing.outElastic(el, 0, valueChange2, duration)
        menu:SetTall( math.Round(result) )
        
        local result = easing.outElastic(el, 0, ScrH()/2 - 75, duration)
        h = math.Round(result)
        
        menu:SetPos( ScrW()/2 - menu:GetWide()/2, h )
    end
	 menu.Paint = function()
        draw.RoundedBox( 8, 0, 0, menu:GetWide(), menu:GetTall(), Color( 0, 0, 0, 200 ) )
        draw.RoundedBox( 8, 0, 0, menu:GetWide(), 30, Color( 28, 134, 238, 230 ) )
    end
    
    timer.Simple( duration, function()
        local label = vgui.Create( "DLabel", menu )
        label:SetPos( 22, menu:GetTall()/2.5 )
        label:SetColor( Color( 255, 255, 255, 255 ) )
        label:SetText( "Music URL ( Must be a valid Stream! ):" )
        label:SizeToContents()
        
        local textentry = vgui.Create( "DTextEntry", menu )
        textentry:SetWide( menu:GetWide() - 40 )
        textentry:SetPos( menu:GetWide()/2 - (menu:GetWide() - 40)/2, menu:GetTall()/1.9 )
        
        local button = vgui.Create( "DButton", menu )
        button:SetWide( menu:GetWide()/1.2 )
        button:SetPos( menu:GetWide() - button:GetWide() - 40, menu:GetTall()/1.3 )
        button:SetText( "Play this Link!" )
        button.DoClick = function()
			if string.len(textentry:GetValue()) > 5 then
				net.Start( "RADIO_RequestURL" )
					net.WriteTable( {ply=LocalPlayer(), URL=textentry:GetValue(), radio=radio} )
				net.SendToServer()
			else
				chat.AddText( Color( 0, 255, 0 ), "[RADIO] Media link isnt valid!" )
				chat.PlaySound()
			end
            menu:Close()
        end
		button.Paint = function()
            draw.RoundedBox( 2, 0, 4, button:GetWide(), button:GetTall() - 4, Color( 0, 0, 0, 200 ) )
            draw.RoundedBox( 2, 0, 0, button:GetWide(), 4, Color( 28, 134, 238, 230 ) )
        end
    end)
end

// Easing
--EASINGLIB by CaMoTraX
local pow = math.pow
local sin = math.sin
local cos = math.cos
local pi = math.pi
local sqrt = math.sqrt
local abs = math.abs
local asin = math.asin

local function linear(t, b, c, d)
  return c * t / d + b
end

local function inQuad(t, b, c, d)
  t = t / d
  return c * pow(t, 2) + b
end

local function outQuad(t, b, c, d)
  t = t / d
  return -c * t * (t - 2) + b
end

local function inOutQuad(t, b, c, d)
  t = t / d * 2
  if t < 1 then
    return c / 2 * pow(t, 2) + b
  else
    return -c / 2 * ((t - 1) * (t - 3) - 1) + b
  end
end

local function outInQuad(t, b, c, d)
  if t < d / 2 then
    return outQuad (t * 2, b, c / 2, d)
  else
    return inQuad((t * 2) - d, b + c / 2, c / 2, d)
  end
end

local function inCubic (t, b, c, d)
  t = t / d
  return c * pow(t, 3) + b
end

local function outCubic(t, b, c, d)
  t = t / d - 1
  return c * (pow(t, 3) + 1) + b
end

local function inOutCubic(t, b, c, d)
  t = t / d * 2
  if t < 1 then
    return c / 2 * t * t * t + b
  else
    t = t - 2
    return c / 2 * (t * t * t + 2) + b
  end
end

local function outInCubic(t, b, c, d)
  if t < d / 2 then
    return outCubic(t * 2, b, c / 2, d)
  else
    return inCubic((t * 2) - d, b + c / 2, c / 2, d)
  end
end

local function inQuart(t, b, c, d)
  t = t / d
  return c * pow(t, 4) + b
end

local function outQuart(t, b, c, d)
  t = t / d - 1
  return -c * (pow(t, 4) - 1) + b
end

local function inOutQuart(t, b, c, d)
  t = t / d * 2
  if t < 1 then
    return c / 2 * pow(t, 4) + b
  else
    t = t - 2
    return -c / 2 * (pow(t, 4) - 2) + b
  end
end

local function outInQuart(t, b, c, d)
  if t < d / 2 then
    return outQuart(t * 2, b, c / 2, d)
  else
    return inQuart((t * 2) - d, b + c / 2, c / 2, d)
  end
end

local function inQuint(t, b, c, d)
  t = t / d
  return c * pow(t, 5) + b
end

local function outQuint(t, b, c, d)
  t = t / d - 1
  return c * (pow(t, 5) + 1) + b
end

local function inOutQuint(t, b, c, d)
  t = t / d * 2
  if t < 1 then
    return c / 2 * pow(t, 5) + b
  else
    t = t - 2
    return c / 2 * (pow(t, 5) + 2) + b
  end
end

local function outInQuint(t, b, c, d)
  if t < d / 2 then
    return outQuint(t * 2, b, c / 2, d)
  else
    return inQuint((t * 2) - d, b + c / 2, c / 2, d)
  end
end

local function inSine(t, b, c, d)
  return -c * cos(t / d * (pi / 2)) + c + b
end

local function outSine(t, b, c, d)
  return c * sin(t / d * (pi / 2)) + b
end

local function inOutSine(t, b, c, d)
  return -c / 2 * (cos(pi * t / d) - 1) + b
end

local function outInSine(t, b, c, d)
  if t < d / 2 then
    return outSine(t * 2, b, c / 2, d)
  else
    return inSine((t * 2) -d, b + c / 2, c / 2, d)
  end
end

local function inExpo(t, b, c, d)
  if t == 0 then
    return b
  else
    return c * pow(2, 10 * (t / d - 1)) + b - c * 0.001
  end
end

local function outExpo(t, b, c, d)
  if t == d then
    return b + c
  else
    return c * 1.001 * (-pow(2, -10 * t / d) + 1) + b
  end
end

local function inOutExpo(t, b, c, d)
  if t == 0 then return b end
  if t == d then return b + c end
  t = t / d * 2
  if t < 1 then
    return c / 2 * pow(2, 10 * (t - 1)) + b - c * 0.0005
  else
    t = t - 1
    return c / 2 * 1.0005 * (-pow(2, -10 * t) + 2) + b
  end
end

local function outInExpo(t, b, c, d)
  if t < d / 2 then
    return outExpo(t * 2, b, c / 2, d)
  else
    return inExpo((t * 2) - d, b + c / 2, c / 2, d)
  end
end

local function inCirc(t, b, c, d)
  t = t / d
  return(-c * (sqrt(1 - pow(t, 2)) - 1) + b)
end

local function outCirc(t, b, c, d)
  t = t / d - 1
  return(c * sqrt(1 - pow(t, 2)) + b)
end

local function inOutCirc(t, b, c, d)
  t = t / d * 2
  if t < 1 then
    return -c / 2 * (sqrt(1 - t * t) - 1) + b
  else
    t = t - 2
    return c / 2 * (sqrt(1 - t * t) + 1) + b
  end
end

local function outInCirc(t, b, c, d)
  if t < d / 2 then
    return outCirc(t * 2, b, c / 2, d)
  else
    return inCirc((t * 2) - d, b + c / 2, c / 2, d)
  end
end

local function inElastic(t, b, c, d, a, p)
  if t == 0 then return b end

  t = t / d

  if t == 1 then return b + c end

  if not p then p = d * 0.3 end

  local s

  if not a or a < abs(c) then
    a = c
    s = p / 4
  else
    s = p / (2 * pi) * asin(c/a)
  end

  t = t - 1

  return -(a * pow(2, 10 * t) * sin((t * d - s) * (2 * pi) / p)) + b
end

-- a: amplitud
-- p: period
local function outElastic(t, b, c, d, a, p)
  if t == 0 then return b end

  t = t / d

  if t == 1 then return b + c end

  if not p then p = d * 0.3 end

  local s

  if not a or a < abs(c) then
    a = c
    s = p / 4
  else
    s = p / (2 * pi) * asin(c/a)
  end

  return a * pow(2, -10 * t) * sin((t * d - s) * (2 * pi) / p) + c + b
end

-- p = period
-- a = amplitud
local function inOutElastic(t, b, c, d, a, p)
  if t == 0 then return b end

  t = t / d * 2

  if t == 2 then return b + c end

  if not p then p = d * (0.3 * 1.5) end
  if not a then a = 0 end

  if not a or a < abs(c) then
    a = c
    s = p / 4
  else
    s = p / (2 * pi) * asin(c / a)
  end

  if t < 1 then
    t = t - 1
    return -0.5 * (a * pow(2, 10 * t) * sin((t * d - s) * (2 * pi) / p)) + b
  else
    t = t - 1
    return a * pow(2, -10 * t) * sin((t * d - s) * (2 * pi) / p ) * 0.5 + c + b
  end
end

-- a: amplitud
-- p: period
local function outInElastic(t, b, c, d, a, p)
  if t < d / 2 then
    return outElastic(t * 2, b, c / 2, d, a, p)
  else
    return inElastic((t * 2) - d, b + c / 2, c / 2, d, a, p)
  end
end

local function inBack(t, b, c, d, s)
  if not s then s = 1.70158 end
  t = t / d
  return c * t * t * ((s + 1) * t - s) + b
end

local function outBack(t, b, c, d, s)
  if not s then s = 1.70158 end
  t = t / d - 1
  return c * (t * t * ((s + 1) * t + s) + 1) + b
end

local function inOutBack(t, b, c, d, s)
  if not s then s = 1.70158 end
  s = s * 1.525
  t = t / d * 2
  if t < 1 then
    return c / 2 * (t * t * ((s + 1) * t - s)) + b
  else
    t = t - 2
    return c / 2 * (t * t * ((s + 1) * t + s) + 2) + b
  end
end

local function outInBack(t, b, c, d, s)
  if t < d / 2 then
    return outBack(t * 2, b, c / 2, d, s)
  else
    return inBack((t * 2) - d, b + c / 2, c / 2, d, s)
  end
end

local function outBounce(t, b, c, d)
  t = t / d
  if t < 1 / 2.75 then
    return c * (7.5625 * t * t) + b
  elseif t < 2 / 2.75 then
    t = t - (1.5 / 2.75)
    return c * (7.5625 * t * t + 0.75) + b
  elseif t < 2.5 / 2.75 then
    t = t - (2.25 / 2.75)
    return c * (7.5625 * t * t + 0.9375) + b
  else
    t = t - (2.625 / 2.75)
    return c * (7.5625 * t * t + 0.984375) + b
  end
end

local function inBounce(t, b, c, d)
  return c - outBounce(d - t, 0, c, d) + b
end

local function inOutBounce(t, b, c, d)
  if t < d / 2 then
    return inBounce(t * 2, 0, c, d) * 0.5 + b
  else
    return outBounce(t * 2 - d, 0, c, d) * 0.5 + c * .5 + b
  end
end

local function outInBounce(t, b, c, d)
  if t < d / 2 then
    return outBounce(t * 2, b, c / 2, d)
  else
    return inBounce((t * 2) - d, b + c / 2, c / 2, d)
  end
end

easing = {
  linear = linear,
  inQuad = inQuad,
  outQuad = outQuad,
  inOutQuad = inOutQuad,
  outInQuad = outInQuad,
  inCubic = inCubic ,
  outCubic = outCubic,
  inOutCubic = inOutCubic,
  outInCubic = outInCubic,
  inQuart = inQuart,
  outQuart = outQuart,
  inOutQuart = inOutQuart,
  outInQuart = outInQuart,
  inQuint = inQuint,
  outQuint = outQuint,
  inOutQuint = inOutQuint,
  outInQuint = outInQuint,
  inSine = inSine,
  outSine = outSine,
  inOutSine = inOutSine,
  outInSine = outInSine,
  inExpo = inExpo,
  outExpo = outExpo,
  inOutExpo = inOutExpo,
  outInExpo = outInExpo,
  inCirc = inCirc,
  outCirc = outCirc,
  inOutCirc = inOutCirc,
  outInCirc = outInCirc,
  inElastic = inElastic,
  outElastic = outElastic,
  inOutElastic = inOutElastic,
  outInElastic = outInElastic,
  inBack = inBack,
  outBack = outBack,
  inOutBack = inOutBack,
  outInBack = outInBack,
  inBounce = inBounce,
  outBounce = outBounce,
  inOutBounce = inOutBounce,
  outInBounce = outInBounce,
}
