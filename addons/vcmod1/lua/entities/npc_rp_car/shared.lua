ENT.Base = "base_ai" 
ENT.Type = "ai"
ENT.PrintName		= "Car NPC"
ENT.Author			= "freemmaann"
ENT.Category		= "VCMod"
ENT.Contact			= "N/A"
ENT.Purpose			= "N/A"
ENT.Instructions	= "Press E"
ENT.Spawnable		= true
ENT.AdminSpawnable		= true
ENT.AutomaticFrameAdvance = true

function ENT:SetAutomaticFrameAdvance( bUsingAnim )
	self.AutomaticFrameAdvance = bUsingAnim
end