function PLAYER_META:GetCash()
    return self:GetRPVar( "cash" )
end

function PLAYER_META:CanAfford( amount )
    return ( self:GetRPVar( "cash" ) >= amount )
end

function PLAYER_META:GetGivenSkillPoints()
    local p = 0
    for k, v in pairs( SETTINGS.GeneTypes ) do
        if !(v.can_skill) then continue end
        p = p + self:GetRPVar( "skills_" .. v.name )
    end
    p = p + self:GetSkillPoints()
    return p
end

function PLAYER_META:GetSkillPoints()
    return self:GetRPVar( "skill_points" )
end

function PLAYER_META:GetSkillPointCost()
    local cost = SETTINGS.GenePointCost * math.Clamp((self:GetGivenSkillPoints() - SETTINGS.StartGenePoints), 1, 9999999999 )
    local p = (SETTINGS.GenePointCost * (self:GetGivenSkillPoints() - SETTINGS.StartGenePoints)) / 100
    
    if self:GetVIPLevel() > 0 then
        p = p * (SETTINGS.GenePointVIPDiscount * self:GetVIPLevel())
        cost = cost - p
    end
    
    return math.Round(cost)
end

function PLAYER_META:GetSkillPointResetCost()
    local cost = SETTINGS.GenePointCost * self:GetGivenSkillPoints() / 20
    local p = SETTINGS.GenePointCost * (self:GetGivenSkillPoints() / 20) / 100
    
    if self:GetVIPLevel() > 0 then
        p = p * (SETTINGS.GenePointVIPDiscount * self:GetVIPLevel())
        cost = cost - p
    end
    
    return math.Round(cost)
end


--[[---------------------------------------------------------
   Name: GetSkill( name )
   Desc: Gets the skill points of the given name from the player
-----------------------------------------------------------]]
function PLAYER_META:GetSkill( name )
    return (self:GetRPVar( "skills_" .. name ) or 0)
end

--[[---------------------------------------------------------
   Name: GetVIPLevel()
   Desc: Returns players vip level
-----------------------------------------------------------]]
function PLAYER_META:GetVIPLevel()
    if self:IsUserGroup( "vip_1" ) then return 1 end
    if self:IsUserGroup( "vip_2" ) then return 2 end
    if self:IsUserGroup( "vip_3" ) then return 3 end
    return 0
end

function FindPlayerBySteamID( id )
     for k, v in pairs( player.GetAll() ) do
        if tostring(v:SteamID()) == tostring(id) then return v end
     end
     return nil
end