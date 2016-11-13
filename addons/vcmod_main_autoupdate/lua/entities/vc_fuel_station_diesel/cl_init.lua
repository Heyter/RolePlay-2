// Copyright © 2012-2016 VCMod (freemmaann). All Rights Reserved. if you have any complaints or ideas contact me: email - freemmaann@gmail.com or skype - comman6.

include('shared.lua')

ENT.RenderGroup = RENDERGROUP_BOTH

function ENT:Initialize() self.VC_PVsb = util.GetPixelVisibleHandle() end

function ENT:Draw() if VC and VC.CodeEnt.Fuel_station and VC.CodeEnt.Fuel_station.Draw then return VC.CodeEnt.Fuel_station.Draw(self) end end