--[[---------------------------------------------------------
   File: sv_player.lua
   Desc: Provides serverside functions related to players
-----------------------------------------------------------]]

local ply = FindMetaTable("Player")

--[[---------------------------------------------------------
   Name: SetCash(amount)
   Desc: Sets the cash of a player to a specific amount
-----------------------------------------------------------]]
function ply:SetCash(amount)
    self:SetRPVar( "cash", amount )
    Query( "UPDATE players SET cash = " .. amount .. " WHERE sid = '" .. tostring(self:SteamID()) .. "'", function() end, function() print("nö") end )
end

--[[---------------------------------------------------------
   Name: AddCash(amount)
   Desc: Adds the amount to the player's cash
-----------------------------------------------------------]]
function ply:AddCash(amount)
    if amount == nil then return end
    self:SetCash(self:GetCash() + math.Round(amount))
end

--[[---------------------------------------------------------
   Name: SaveSkills()
   Desc: Save the skills
-----------------------------------------------------------]]
function ply:SaveSkills()
    local tbl = {}
    for k, v in pairs( SETTINGS.GeneTypes ) do
        tbl[v.name] = tonumber((self:GetRPVar( "skills_" .. v.name ) or 0))
    end
    tbl = util.TableToJSON( tbl )
    Query( "UPDATE players SET skills = '" .. tbl .. "' WHERE sid = '" .. tostring(self:SteamID()) .. "'", function() end )
    Query( "UPDATE players SET skill_points = " .. self:GetRPVar( "skill_points" ) .. " WHERE sid = '" .. tostring(self:SteamID()) .. "'", function() end )
end

--[[---------------------------------------------------------
   Name: ResetSkillPoints()
   Desc: Resets the player skills
-----------------------------------------------------------]]
function PLAYER_META:ResetSkillPoints( purchase )
    purchase = purchase or false
    
    if purchase && !(self:CanAfford( self:GetSkillPointResetCost() )) then return false end
    if purchase then self:AddCash( -self:GetSkillPointResetCost() ) end
    
    self:SetRPVar( "skill_points", self:GetGivenSkillPoints() )
    for k, v in pairs( SETTINGS.GeneTypes ) do
        if !(v.can_skill) then continue end
        self:SetRPVar( "skills_" .. v.name, 0 )
    end
    Query( "UPDATE players SET skill_points = " .. self:GetRPVar( "skill_points" ) .. " WHERE sid = '" .. tostring(self:SteamID()) .. "'", function() end )
    self:RPNotify( "Deine Skills wurden Erfolgreich zurückgesetzt!", 5 )
    self:SaveSkills()
end

function PLAYER_META:AddSkillPoint( amount, purchase )
    purchase = purchase or false
    
    if purchase && !(self:CanAfford( SETTINGS.GenePointCost * (self:GetGivenSkillPoints() - SETTINGS.StartGenePoints) )) then return false end
    if purchase then self:AddCash( -SETTINGS.GenePointCost * (self:GetGivenSkillPoints() - SETTINGS.StartGenePoints) ) end
    self:SetRPVar( "skill_points", self:GetRPVar( "skill_points" ) + amount )
    self:SaveSkills()
end

--[[---------------------------------------------------------
   Name: SetSkill( name )
   Desc: Gets the skill points of the given name from the player
-----------------------------------------------------------]]
function ply:SetSkill( name, amount, add )
    name = name or nil
    amount = amount or nil
    add = add or false
    local skillable = false
    
    if amount == nil then return end
    if amount <= 0 then return end
    if name == nil then return end
    
    for k, v in pairs( SETTINGS.GeneTypes ) do
        if v.name == name && v.can_skill then skillable = true continue end
    end
    
    if skillable then
        if self:GetSkillPoints() < 1 then return end
        self:SetRPVar( "skill_points", self:GetSkillPoints() - 1 )
    end
    
    if self:GetRPVar( "skills_" .. name ) == nil then return end
    
    local max = 0
    for k, v in pairs( SETTINGS.GeneTypes ) do
        if v.name == name then max = v.max break end
    end
    
    if amount > max then amount = max end
    
    if add then
        self:SetRPVar( "skills_" .. name, self:GetRPVar( "skills_" .. name ) + amount )
    else
        self:SetRPVar( "skills_" .. name, amount )
    end
    self:SaveSkills()
end

--[[---------------------------------------------------------
   Name: RegisterPlayer(Player)
   Desc: Registers a Player, called by LoadPlayer
-----------------------------------------------------------]]
util.AddNetworkString( "ShowCharMenu" )
util.AddNetworkString( "SendCharInfo_Creation" )
util.AddNetworkString( "HideCharMenu" )
util.AddNetworkString( "RP_Buy_Gen" )
util.AddNetworkString( "RP_Reset_Gen" )
util.AddNetworkString( "RP_Purchase_Skill_Point" )
local function RegisterPlayer(Player)
    -- Send the Client that he should show rules...
    net.Start("ShowCharMenu")
    net.Send(Player)

    Player:SetHealth( 999999999999999 )
end

local function CreatePlayeraccount( len, ply )
    local tbl = net.ReadTable()
    local skills = tbl.craft_skills
    
    for k, v in pairs( SETTINGS.GeneTypes ) do
        local found = false
        for name, _ in pairs( skills ) do
            if name == v.name then found = true end
        end
        if !(found) then
            skills[v.name] = v.standart_wert
        end
    end
    
    tbl.bodysize = tbl.bodysize or 1
    local text = "'" .. tostring(ply:SteamID()) .. "','" .. tbl.fname  .. " " .. tbl.sname .. "'," .. SETTINGS.StartingCash .. "," .. SETTINGS.StartingBank .. ",0,'" .. tbl.playermodel .. "',0,'" .. util.TableToJSON( skills ) .. "'," .. tbl.bodysize
    
    Query( "INSERT INTO players(sid,rpname,cash,bank_cash,playtime,playermodel,clan,skills,bodysize) VALUES (" .. text .. ")", function( data )
        ply:Spawn()
        ply:SetHealth( 100 )
        ply:SetArmor( 0 )
        ply:SetModel( tbl.playermodel )
        
        ply:SetRPVar( "cash", SETTINGS.StartingCash )
        ply:SetRPVar( "bank_cash", SETTINGS.StartingBank )
        ply:SetRPVar( "rpname", tbl.fname .. " " .. tbl.sname )
        ply:SetRPVar( "playtime", tbl.playtime )
        ply:SetRPVar( "clan", tbl.clan )
        ply:SetRPVar( "model", tbl.playermodel )
        ply:SetRPVar( "modysize", tbl.bodysize )
        ply:SetRPVar( "skill_points", 0 )
        
        ply:LoadPlaytime()
        
        for k, v in pairs( tbl.craft_skills ) do
            ply:SetRPVar( "skills_" .. k, v )
        end
        
        net.Start( "HideCharMenu" )
        net.Send( ply )
    end)
end
net.Receive( "SendCharInfo_Creation", CreatePlayeraccount )

--[[---------------------------------------------------------
   Name: LoadPlayer
   Desc: Checks if Player is registered, if yes load him else let him register. Called by Net Message
-----------------------------------------------------------]]
function LoadPlayer(Player)
    Player.isLoaded = Player.isLoaded or false
    if (Player.isLoaded) then -- Don't load him again
    --    return
    end

    -- Check if User exists
    Query("SELECT COUNT(sid) AS count FROM players WHERE sid = '"..tostring(Player:SteamID()).."'", function (sqldata)

        -- User already exists
        if (tonumber(sqldata[1].count) > 0) then
            Query("SELECT * FROM players WHERE sid = '" .. tostring(Player:SteamID()) .. "'", function( data )
                Player:SetRPVar( "cash", data[1].cash )
                Player:SetRPVar( "bank_cash", data[1].bank_cash )
                Player:SetRPVar( "rpname", data[1].rpname )
                Player:SetRPVar( "playtime", data[1].playtime )
                Player:SetRPVar( "clan", data[1].clan )
                Player:SetRPVar( "model", data[1].playermodel )
                Player:SetRPVar( "bodysize", data[1].bodysize )
                Player:SetRPVar( "skill_points", data[1].skill_points )
                
                Player:SetHealth( 100 )
                Player:SetArmor( 0 )
                Player:SetModel( data[1].playermodel )
                
                Player:Spawn()
                
                local sk = util.JSONToTable(data[1].skills)
                --SETTINGS.GeneTypes
                /*
                local new_skill_tbl = {}
                for k, v in pairs( sk ) do
                    local found = false
                    for i=1, #SETTINGS.GeneTypes do
                        if SETTINGS.GeneTypes[i].name == k then found = true end
                    end

                    if !(found) then    // Skill doent exist!
                        Player:AddSkillPoint( v, false )
                        continue
                    end
                    new_skill_tbl[k] = v
                end*/
                for k, v in pairs( sk ) do
                    Player:SetRPVar( "skills_" .. k, v )
                end
            end)
        else
            -- User does not exist
            RegisterPlayer(Player)
        end
        
        Player.isLoaded = true
        hook.Call( "NOSRP_PlayerReady", {}, Player )
     end)
end

net.Receive( "RP_Buy_Gen", function( data, ply )
    ply:AddSkillPoint( 1, true )
end)

net.Receive( "RP_Reset_Gen", function( data, ply )
    ply:ResetSkillPoints( true )
end)

net.Receive( "RP_Purchase_Skill_Point", function( data, ply )
    local skill = net.ReadString()
    ply:SetSkill( skill, ply:GetRPVar( "skills_" .. skill ) + 1 )
end)

net.Receive( "NPC_CanTakeJob", function( data, ply )
    local TEAM = tonumber(net.ReadString())
    local cando = 0
    if !(ply:CanEnterJob( TEAM )) then 
        net.Start( "NPC_CanTakeJob" )
            net.WriteString( TEAM )
            net.WriteString( cando )
        net.Send( ply )
        return
    end
    
    if !(TEAM == TEAM_MAYOR) then
        ply:SwapTeam( TEAM, true )
    else
        ply.EnteredMayorVote = ply.EnteredMayorVote or false
        if ply.EnteredMayorVote then
            ply:DeleteFromMayorSelection()
            cando = 2
        else
            ply:AddToMayorSelection()
        end
    end
    
    net.Start( "NPC_CanTakeJob" )
        net.WriteString( TEAM )
        net.WriteString( cando )
    net.Send( ply )
end)

net.Receive( "NPC_LeaveJob", function( data, ply )
    local calc = math.Round(CurTime() - (ply.nextpayday - SETTINGS.PayDayTime))
    if calc >= 60 then 
        ply:SwapTeam( TEAM_CITIZEN, true )
        ply.car = ply.car or nil
        ply.car:Remove()
        return true 
    end
    ply:RPNotify( "Du musst noch " .. tostring( 60 - calc ) .. " Sekunden warten!", 5 )
end)

net.Receive( "NPC_ClaimJobCar", function( data, ply )
    if !(IsValid( ply )) then return end
    if GAMEMODE.TEAMS[ply:Team()].MaxCars < 1 then return end
    
    GAMEMODE.TEAMS[ply:Team()].SpawnedCars = GAMEMODE.TEAMS[ply:Team()].SpawnedCars or 0
    GAMEMODE.TEAMS[ply:Team()].CarSpawns = GAMEMODE.TEAMS[ply:Team()].CarSpawns or {}
    ply.car = ply.car or nil
    
    if ply.car != nil then
        ECONOMY.AddCityCash( -ECONOMY.CAR_COST )
        ECONOMY.AddToLog( "-" .. tostring( ECONOMY.CAR_COST ) .. "€ Job Car Cost."  )
    end
    
    if (IsValid( ply.car )) then
        if IsValid( ply.car:GetDriver() ) then return end
        ply.car:Remove()
    end
    
    GAMEMODE.TEAMS[ply:Team()].SpawnedCars = 0
    for k, v in pairs( ents.GetAll() ) do
        if !(IsValid( v )) then continue end
        if !(v:IsVehicle()) then continue end
        if v.VehicleName == GAMEMODE.TEAMS[ply:Team()].CarType then
            GAMEMODE.TEAMS[ply:Team()].SpawnedCars = GAMEMODE.TEAMS[ply:Team()].SpawnedCars + 1
        end
    end
    
    if GAMEMODE.TEAMS[ply:Team()].SpawnedCars >= GAMEMODE.TEAMS[ply:Team()].MaxCars then return end
    
    local found, p, a = false, nil, nil
    for k, v in pairs( GAMEMODE.TEAMS[ply:Team()].CarSpawns ) do
        local finder = ents.FindInSphere( v.pos, 5 )
        
        local car = nil
        for _, c in pairs( finder ) do
            if !(IsValid( c )) then continue end
            if c:IsVehicle() then car = c end
        end
        if IsValid(car) then continue end
        
        found = true
        p = v.pos
        a = v.ang
    end
    
    if found then
        ply.car = CARSHOP.CreateJOBCar( ply, GAMEMODE.TEAMS[ply:Team()].CarType, p, a )
        ply.car.armor = (GAMEMODE.TEAMS[ply:Team()].CarArmor or 0)
        if GAMEMODE.TEAMS[ply:Team()].CarSkin != nil then ply.car:SetSkin( GAMEMODE.TEAMS[ply:Team()].CarSkin ) end
        if GAMEMODE.TEAMS[ply:Team()].CarColor != nil then ply.car:SetColor( GAMEMODE.TEAMS[ply:Team()].CarColor ) end
        
        if IsValid( car ) then ply:DeleteOnRemove( car ) end
    end
end)

// Chat Commands

RP.PLUGINS.CHATCOMMAND.AddChatCommand( "/holster", function( ply, args, public )
    if !(ply:Team() == TEAM_CITIZEN) then return end
    local wep = ply:GetActiveWeapon()
    if !(IsValid( wep )) then return end
    local found_wep = false
    for k, v in pairs( CRAFT_TABLE ) do
        if tostring( v.UniqueName ) == tostring( wep:GetClass() ) then found_wep = true end
    end
    if !(found_wep) then return end
    
    local item = itemstore.Item( "spawned_weapon" )
    item:SetData( "Class", wep:GetClass() )
    item:SetData( "Model", wep:GetModel() )
    item:SetData( "Name", (wep:GetTable().PrintName or "Unbekannt") )
    item:SetData( "CraftOwner", ply:GetRPVar( "rpname" ) )
    ply.Inventory:AddItem( item )
    wep:Remove()
    return ""
end)

RP.PLUGINS.CHATCOMMAND.AddChatCommand( "/drop", function( ply, args, public )
    if !(tonumber(args[1])) then ply:ChatPrint( "Please enter the amount: /drop <amount>" ) return "" end
    if tonumber(args[1]) < 1 then ply:ChatPrint( "The amount must be more than 0$" ) return "" end
    if !(ply:GetCash() >= tonumber(args[1])) then ply:ChatPrint( "You dont have enough money!" ) return "" end
    
    local moneybag = ents.Create( "spawned_money" )
    moneybag.amount = tonumber(args[1])
    moneybag:SetPos( ply:GetShootPos() + ply:EyeAngles():Forward() * 50 )
    moneybag:Spawn()
    
    ply:AddCash( -tonumber(args[1]) )
    return ""
end)

util.AddNetworkString( "ItemStoreTradeCommand" )
RP.PLUGINS.CHATCOMMAND.AddChatCommand( "/trade", function( ply, args, public )
    local target = ply:GetEyeTrace().Entity
    
    if ( IsValid( target ) and target:IsPlayer() ) then
        net.Start( "ItemStoreTradeCommand" )
            net.WriteInt( tonumber( target:EntIndex() ), 32 )
        net.Send( ply )
    else
        ply:PrintMessage( HUD_PRINTTALK, "Couldn't initialize trade: no player with that name." )
    end
    
    return ""
end )
