ENT.Type = "anim"
ENT.Base = "itemstore_box"

ENT.PrintName = "Huge Box"
ENT.Category = "ItemStore"

ENT.Spawnable = true
ENT.AdminOnly = true

if SERVER then
	AddCSLuaFile()

	ENT.DefaultHealth = itemstore.config.BoxHealth
	ENT.Model = "models/props_junk/garbage_bag001a.mdl"

	ENT.ContainerWidth = 8
	ENT.ContainerHeight = 4
	ENT.ContainerPages = 2
end
