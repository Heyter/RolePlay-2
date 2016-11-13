GM.TEAMS = {}

--[[---------------------------------------------------------
   Name: GM:RegisterTeam( JobTable )
   Desc: Registers a new Job to the GM
-----------------------------------------------------------]]
function RegisterTeam( JobTable )
    JobTable.RequireMayor = JobTable.RequireMayor or false

    table.insert( GM.TEAMS, JobTable )
    
    team.SetUp(#GM.TEAMS, JobTable.Name, JobTable.Color)
    
    if type(JobTable.Model) == "table" then
		for k,v in pairs(JobTable.Model) do util.PrecacheModel(v) end
	else
		util.PrecacheModel(JobTable.Model)
	end
    
    print( "Sucessfully registered Team: " .. JobTable.Name .. " | Index: " .. tostring( #GM.TEAMS ) )
    return #GM.TEAMS
end

function PLAYER_META:IsPolice()
    if self:Team() == TEAM_POLICE or self:Team() == TEAM_MAYOR then return true end
    return false
end

function PLAYER_META:IsMedic()
    if self:Team() == TEAM_MEDIC then return true end
    return false
end

function PLAYER_META:IsSWAT()
    if self:Team() == TEAM_SWAT or self:Team() == TEAM_SECRETSERVICE then return true end
    return false
end

function GetTeamByEnum( Enum )
    for k, v in ipairs( GAMEMODE.TEAMS ) do
        if v.ENUM == Enum then return k end
    end
    return 0
end

if SERVER then
    --[[---------------------------------------------------------
       Name: meta:SwapTeam( TEAM, FORCE )
       Desc: Changes the Players Team
    -----------------------------------------------------------]]
    function PLAYER_META:SwapTeam( TEAM, FORCE )
        FORCE = FORCE or false
        
        if !(IsValid( self )) then return false end
        if self:Team() == TEAM then return false end
        
        if !(FORCE) then
            --local pt = (GAMEMODE.TEAMS[job].RequiredGameMinutes - (GAMEMODE.TEAMS[job].RequiredGameMinutes / 100)*(SETTINGS.VIPPlaytimePercent*self:GetVIPLevel()))
            --if TEAM ~= TEAM_CITIZEN && team.NumPlayers( TEAM ) >= GAMEMODE.TEAMS[TEAM].Max then return false end
            --if self:GetRPVar( "playtime" ) < pt then return false end
            if !(self:CanEnterJob( TEAM )) then return false end
        end
        
        self:SetRPVar( "RadioChat", false )
        self:StripWeapons()
        self:SetTeam( TEAM )
        if TEAM == TEAM_CITIZEN then
            self:SetModel( self:GetRPVar( "model" ) )
        else
            local mdl = table.Random(GAMEMODE.TEAMS[TEAM].Model)
            self:SetRPVar( "job_model", mdl )
            self:SetModel( mdl )
        end
        
        CARSHOP.PlayerDisconnected( self )
        
        for k, v in pairs( GAMEMODE.TEAMS[TEAM].Weapons ) do self:Give( v ) end
        
        if self:GetVIPLevel() > 0 or self:IsAdmin() then self:Give( "weapon_physgun" ) end
        if self:IsAdmin() then self:Give( "god_stick" ) end
        
        GAMEMODE.TEAMS[TEAM].Armor = GAMEMODE.TEAMS[TEAM].Armor or 0
        self:SetArmor( GAMEMODE.TEAMS[TEAM].Armor )
        
        self.nextpayday = CurTime() + SETTINGS.PayDayTime
        
        local vPoint = self:GetPos()
        local effectdata = EffectData()
        effectdata:SetStart( vPoint )
        effectdata:SetOrigin( vPoint )
        effectdata:SetScale( 1 )
        util.Effect( "HelicopterMegaBomb", effectdata )
    end
    
    function PLAYER_META:CanEnterJob( job, notify )
        notify = notify or false
        if !(IsValid( self )) then return false end
        if self:Team() == job then return false end
        if self:IsAdmin() then return true end
        if job ~= TEAM_CITIZEN && self:Team() ~= TEAM_CITIZEN then self:RPNotify("Du musst erst bei deinem derzeitigen Job Kündigen!", 5) return false end
        if job ~= TEAM_CITIZEN && (GetMayor() == nil && GAMEMODE.TEAMS[job].RequireMayor) then self:RPNotify("Es gibt kein Mayor. Wieso solltest du dann diesen Job ausüben?", 5) return false end
        if job ~= TEAM_CITIZEN && (GAMEMODE.TEAMS[job].Max == 0 or team.NumPlayers( job ) >= GAMEMODE.TEAMS[job].Max) then self:RPNotify("Der Mayor findet, dass es genug Leute in diesen Job gibt!", 5) return false end
		local pt = GAMEMODE.TEAMS[job].RequiredGameMinutes - ((GAMEMODE.TEAMS[job].RequiredGameMinutes / 100)*(SETTINGS.VIPPlaytimePercent*self:GetVIPLevel()))
        if (self:GetRPVar( "playtime" ) or 0) < pt then self:RPNotify("Du brauchst " .. pt .. " Minuten Spielzeit, um diesen Job ausführen zu können!", 5) return false end

        return true
    end
    
    function DemoteOnDeath( ply )
        if !(IsValid( ply )) then return end
        if !(GAMEMODE.TEAMS[ply:Team()].DemoteOnDeath) then return end
        
        ply:SwapTeam( TEAM_CITIZEN, true )
        
        if GAMEMODE.TEAMS[ply:Team()].DemoteMessage != nil then
            if ply:Team() == TEAM_MAYOR then
                for k, v in pairs( player.GetAll() ) do
                    ply:RPNotify( GAMEMODE.TEAMS[ply:Team()].DemoteMessage, 5 )
                end
                return
            end
            ply:RPNotify( GAMEMODE.TEAMS[ply:Team()].DemoteMessage, 5 )
        end
    end
    hook.Add( "NOSRP_PlayerDeath", "Demote_Player_On_Death", DemoteOnDeath )
end

local function PoliceNoDMG( ent, dmginfo )
    if !(IsValid( dmginfo:GetAttacker() ) ) then return dmginfo end
    if !(IsValid( ent )) then return dmginfo end
    if !(dmginfo:GetAttacker():IsPlayer() && ent:IsPlayer()) then return dmginfo end
    if dmginfo:GetAttacker():IsPolice() && ent:IsPolice() then dmginfo:ScaleDamage( 0.0 ) return dmginfo end
    if dmginfo:GetAttacker():IsSWAT() && ent:IsSWAT() then dmginfo:ScaleDamage( 0.0 ) return dmginfo end
    if dmginfo:GetAttacker():IsSWAT() && ent:IsPolice() then dmginfo:ScaleDamage( 0.0 ) return dmginfo end
    if dmginfo:GetAttacker():IsPolice() && ent:IsSWAT() then dmginfo:ScaleDamage( 0.0 ) return dmginfo end
end
hook.Add( "EntityTakeDamage", "police_no_dmg", PoliceNoDMG )