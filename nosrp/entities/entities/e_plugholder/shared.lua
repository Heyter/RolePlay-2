ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.PrintName = "Drug Lab"
ENT.Author = "Rickster"
ENT.Spawnable = false

function ENT:SetupDataTables()
    self:NetworkVar("Int", 0, "plugged")
end