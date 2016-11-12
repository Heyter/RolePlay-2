ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.PrintName = "Drug Lab"
ENT.Author = "Rickster"
ENT.Spawnable = false
ENT.AdminSpawnable = false

function GetSupplyAmmoPrice()
    local mayor = GetMayor()
    if mayor == nil or !(IsValid( mayor )) then return ECONOMY.AMMOROUND_COST end
    
    local skill = mayor:GetSkill( "Management" ) or 0
    local rech = ((ECONOMY.AMMOROUND_COST/100)*skill) or 0
    
    return (ECONOMY.AMMOROUND_COST-rech)
end