// Copyright © 2012-2016 VCMod (freemmaann). All Rights Reserved. if you have any complaints or ideas contact me: steam - http://steamcommunity.com/id/freemmaann, email - freemmaann@gmail.com or skype - comman6.

AddCSLuaFile("shared.lua")

SWEP.Category 		= "VCMod"
SWEP.PrintName		= "Jerry can"
SWEP.Author			= "freemmaann"
SWEP.Instructions	= "Aim at the fuel lid."

SWEP.ViewModel = Model("models/weapons/v_bugbait.mdl")
SWEP.WorldModel = Model("models/props_junk/gascan001a.mdl")

SWEP.ViewModelFOV	= 75

SWEP.Spawnable		= true
SWEP.Slot 			= 5

SWEP.DrawAmmo		= true
SWEP.Primary.ClipSize		= 20
SWEP.Primary.DefaultClip	= 20
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "none"

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"

SWEP.VC_Fuel = {}

if !VC.CodeEnt then VC.CodeEnt = {} end

function SWEP:Initialize() if VC and VC.CodeEnt.Jerrycan_Wep and VC.CodeEnt.Jerrycan_Wep.Initialize then return VC.CodeEnt.Jerrycan_Wep.Initialize(self) end end
function SWEP:Deploy() if VC and VC.CodeEnt.Jerrycan_Wep and VC.CodeEnt.Jerrycan_Wep.Deploy then return VC.CodeEnt.Jerrycan_Wep.Deploy(self) end end
function SWEP:Holster() if VC and VC.CodeEnt.Jerrycan_Wep and VC.CodeEnt.Jerrycan_Wep.Holster then return VC.CodeEnt.Jerrycan_Wep.Holster(self) end end
function SWEP:PrimaryAttack() if VC and VC.CodeEnt.Jerrycan_Wep and VC.CodeEnt.Jerrycan_Wep.PrimaryAttack then return VC.CodeEnt.Jerrycan_Wep.PrimaryAttack(self) end end 
function SWEP:SecondaryAttack() if VC and VC.CodeEnt.Jerrycan_Wep and VC.CodeEnt.Jerrycan_Wep.SecondaryAttack then return VC.CodeEnt.Jerrycan_Wep.SecondaryAttack(self) end end
function SWEP:Think() if VC and VC.CodeEnt.Jerrycan_Wep and VC.CodeEnt.Jerrycan_Wep.Think then return VC.CodeEnt.Jerrycan_Wep.Think(self) end end

if CLIENT then
function SWEP:GetViewModelPosition(pos, ang) if VC and VC.CodeEnt.Jerrycan_Wep and VC.CodeEnt.Jerrycan_Wep.GetViewModelPosition then return VC.CodeEnt.Jerrycan_Wep.GetViewModelPosition(self, pos, ang) end end
function SWEP:DrawHUD() if VC and VC.CodeEnt.Jerrycan_Wep and VC.CodeEnt.Jerrycan_Wep.DrawHUD then return VC.CodeEnt.Jerrycan_Wep.DrawHUD(self) end end
function SWEP:DrawWorldModel() if VC and VC.CodeEnt.Jerrycan_Wep and VC.CodeEnt.Jerrycan_Wep.DrawWorldModel then return VC.CodeEnt.Jerrycan_Wep.DrawWorldModel(self) end end
function SWEP:ViewModelDrawn() if VC and VC.CodeEnt.Jerrycan_Wep and VC.CodeEnt.Jerrycan_Wep.ViewModelDrawn then return VC.CodeEnt.Jerrycan_Wep.ViewModelDrawn(self) end end
else
function SWEP:VC_AddFuel(ftype, num) if VC and VC.CodeEnt.Jerrycan_Wep and VC.CodeEnt.Jerrycan_Wep.VC_AddFuel then return VC.CodeEnt.Jerrycan_Wep.VC_AddFuel(self, ftype, num) end end
end