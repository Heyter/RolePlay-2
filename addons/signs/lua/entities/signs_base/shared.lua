
ENT.Type = "anim"
ENT.Base = "base_anim"
ENT.PrintName = ""
ENT.Author = "Dan"
ENT.Spawnable = false
ENT.AdminSpawnable = false

Signs.AccessorFunc( ENT, "bgColor", "BackgroundColor", Signs.BackgroundColorDefault, true )
Signs.AccessorFunc( ENT, "imgUrl", "ImageUrl", '' )
Signs.AccessorFunc( ENT, "imgCropMode", "ImageCropMode", 0 )
Signs.AccessorFunc( ENT, "textOverlays", "TextOverlays", {}, true )
Signs.AccessorFunc( ENT, "interactionUrl", "InteractionUrl", "" )


function ENT:AddNetworkVar( type, name )
	self.nwvarscnt = self.nwvarscnt or {}

	self.nwvarscnt[type] = (self.nwvarscnt[type] or -1) + 1

	self:NetworkVar( type, self.nwvarscnt[type], name )
end

function ENT:SetupDataTables()
	self:AddNetworkVar( "Entity", "owning_ent" )
end
