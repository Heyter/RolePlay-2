local CL_SETTINGS = {}

// Clientside Settings

CreateClientConVar( "play_radio_in_car", "1", true, true )



// Non-Stream to Server ( vars that dont get checked serverside with PLY:GetInfoNum() )
CreateClientConVar( "door_viewdistance", "250", true, false )
CreateClientConVar( "show_fire_smoke", "1", true, false ) 
CreateClientConVar( "disable_radios", "0", true, false )
CreateClientConVar( "weather_enable_drops", "0", true, false )
CreateClientConVar( "draw_holster_weapons", "1", true, false )
CreateClientConVar( "draw_tuning_neon", "1", true, false )
CreateClientConVar( "radio_volume", "100", true, false )





CL_SETTINGS.Info = {}
CL_SETTINGS.Info["play_radio_in_car"] = {desc="Schaltet das Walkie-Talkie im Auto (An-/Aus).", min=0, max=1}
CL_SETTINGS.Info["door_viewdistance"] = {desc="Wie weit die Türinfo gerendert werden sool", min=0, max=500}
CL_SETTINGS.Info["show_fire_smoke"] = {desc="Schaltet den Rauch über ein Feuer ( An-/Aus ).", min=0, max=1}
CL_SETTINGS.Info["disable_radios"] = {desc="Schaltet alle Radios stumm.", min=0, max=1}
CL_SETTINGS.Info["weather_enable_drops"] = {desc="Schaltet Regen / Schnee / Hagel an.", min=0, max=1}
CL_SETTINGS.Info["draw_holster_weapons"] = {desc="Schaltet ( An-/ Aus ) ob Waffen auf dem Rücken gezeigt werden.", min=0, max=1}
CL_SETTINGS.Info["draw_tuning_neon"] = {desc="Schaltet ( An-/ Aus ) ob der Underglow unter dem Auto angezeigt wird.", min=0, max=1}
CL_SETTINGS.Info["radio_volume"] = {desc="Lautstärke der Radios.", min=0, max=100}






