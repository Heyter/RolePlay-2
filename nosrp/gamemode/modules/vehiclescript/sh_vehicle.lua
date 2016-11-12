function ENTITY_META:GetSpeed()
local velocity = self:GetVelocity():Length()

return math.Round( velocity / (39370.0787 / 3600) ) or 0
end