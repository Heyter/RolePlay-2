// Copyright © 2012-2016 VCMod (freemmaann). All Rights Reserved. if you have any complaints or ideas contact me: email - freemmaann@gmail.com or skype - comman6.

include('shared.lua')

ENT.RenderGroup = RENDERGROUP_BOTH

function ENT:Initialize() self.VC_Color = Color(0,255,255,255) self.VC_Length = 142 self.VC_Text = "Vehicle Fuel 25%" self.VC_PVsb = util.GetPixelVisibleHandle() end