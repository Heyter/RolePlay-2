RP.PLUGINS.RadioChat = {}
RP.PLUGINS.RadioChat.Channel = {}

RP.PLUGINS.RadioChat.Channel[1] = {name="Normal", frq=1500}
RP.PLUGINS.RadioChat.Channel[2] = {name="Streife", frq=500}
RP.PLUGINS.RadioChat.Channel[3] = {name="Einsatz", frq=1500}
RP.PLUGINS.RadioChat.Channel[4] = {name="Support", frq=500}

if SERVER then

    util.AddNetworkString( "RP_Radio_TurnOn" )
    util.AddNetworkString( "RP_Radio_TurnOff" )
    util.AddNetworkString( "RP_Radio_GotoChannel" )

    hook.Add( "PlayerAuthed", "RP.Radio.SetVars", function( Player )
        Player:SetRPVar( "RadioChat", false )
        Player:SetRPVar( "RadioChannel", 1 )
    end)
    
    net.Receive( "RP_Radio_TurnOn", function( data, ply )
        if (ply:IsPolice() or ply:IsSWAT() or ply:IsMedic() or ply:Team() == TEAM_FIRE) then
            ply:SetRPVar( "RadioChat", true )
        end
    end)
    net.Receive( "RP_Radio_TurnOff", function( data, ply )
        if (ply:IsPolice() or ply:IsSWAT() or ply:IsMedic() or ply:Team() == TEAM_FIRE) then
            ply:SetRPVar( "RadioChat", false )
        end
    end)
    net.Receive( "RP_Radio_GotoChannel", function( data, ply )
        ply:SetRPVar( "RadioChannel", tonumber(net.ReadString()) )
    end)
end

if CLIENT then
    local next_radio_switch = 0
    
    hook.Add( "PlayerEndVoice", "RP.Radio.VoiceEnd", function( ply )
        if ply:GetRPVar( "RadioChat" ) == true then
            local chnl = ply:GetRPVar( "RadioChannel" ) or 1
            
            if chnl == LocalPlayer():GetRPVar( "RadioChannel" ) then
                surface.PlaySound( "nosrp/radio/voice_end.wav" )
            end
        end
    end)
    
    hook.Add( "Think", "Radio_Client_Think", function()
        if input.IsKeyDown( KEY_T ) && next_radio_switch < CurTime() && (LocalPlayer():IsPolice() or LocalPlayer():IsSWAT() or LocalPlayer():IsMedic() or LocalPlayer():Team() == TEAM_FIRE) then
            next_radio_switch = CurTime() + 1
            if LocalPlayer():GetRPVar( "RadioChat" ) == true then
                net.Start( "RP_Radio_TurnOff" )
                net.SendToServer()
                surface.PlaySound( "nosrp/radio/power_off.wav" )
            else
                net.Start( "RP_Radio_TurnOn" )
                net.SendToServer()
                surface.PlaySound( "nosrp/radio/power_on.wav" )
            end
        end
        
        if input.IsKeyDown( KEY_PAD_PLUS ) && next_radio_switch < CurTime() && (LocalPlayer():IsPolice() or LocalPlayer():IsSWAT() or LocalPlayer():IsMedic() or LocalPlayer():Team() == TEAM_FIRE) then
            next_radio_switch = CurTime() + .5
            local chnl = LocalPlayer():GetRPVar( "RadioChannel" ) or 1
            chnl = chnl + 1
            if chnl > #RP.PLUGINS.RadioChat.Channel then chnl = #RP.PLUGINS.RadioChat.Channel end
            
            net.Start( "RP_Radio_GotoChannel" )
                net.WriteString( tostring( chnl ) )
            net.SendToServer()
            --surface.PlaySound( "nosrp/radio/switch_channel.wav" )
        end
        
        if input.IsKeyDown( KEY_PAD_MINUS ) && next_radio_switch < CurTime() && (LocalPlayer():IsPolice() or LocalPlayer():IsSWAT() or LocalPlayer():IsMedic() or LocalPlayer():Team() == TEAM_FIRE) then
            next_radio_switch = CurTime() + .5
            local chnl = LocalPlayer():GetRPVar( "RadioChannel" ) or 1
            chnl = chnl - 1
            if chnl < 1 then chnl = 1 end
            
            net.Start( "RP_Radio_GotoChannel" )
                net.WriteString( tostring( chnl ) )
            net.SendToServer()
            --surface.PlaySound( "nosrp/radio/switch_channel.wav" )
        end
    end)
    
    hook.Add( "HUDPaint", "DrawRadio", function()
        if LocalPlayer():GetRPVar( "RadioChat" ) == true then
            local id = "roleplay/hud/walkie_talkie.png"
            surface.SetMaterial( Material( id ) )
            surface.SetDrawColor( Color( 255, 255, 255, 255 ) )
            surface.DrawTexturedRect( 15, ScrH()/3, 64, 64 )
            
            local chnl = LocalPlayer():GetRPVar( "RadioChannel" ) or 1
            local cnt = 0
            for k, v in pairs( player.GetAll() ) do if v == LocalPlayer() then continue end if v:GetRPVar( "RadioChannel" ) == chnl && v:GetRPVar( "RadioChat" ) then cnt = cnt + 1 end end
            draw.SimpleText( "Channel: " .. RP.PLUGINS.RadioChat.Channel[chnl].name .. " [" .. tostring(cnt) .. "]", "default", 15, (ScrH()/3) + 65, Color( 255, 255, 255, 150 ) )
            draw.SimpleText( "Freq: " .. RP.PLUGINS.RadioChat.Channel[chnl].frq, "default", 15, (ScrH()/3) + 75, Color( 255, 255, 255, 150 ) )
        end
    end)
end