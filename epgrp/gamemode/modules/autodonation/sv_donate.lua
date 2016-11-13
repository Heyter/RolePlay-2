RP.PREMIUM = RP.PREMIUM or {}
RP.PREMIUM.SETTINGS = RP.PREMIUM.SETTINGS or {}

RP.PREMIUM.SETTINGS.VipLevel = {}
RP.PREMIUM.SETTINGS.VipLevel["vip_1"] = 10
RP.PREMIUM.SETTINGS.VipLevel["vip_2"] = 15
RP.PREMIUM.SETTINGS.VipLevel["vip_3"] = 20

RP.PREMIUM.SETTINGS.FirstReward = {}
RP.PREMIUM.SETTINGS.FirstReward["vip_1"] = function( Player )
    Player:AddCash( 10000 )
    Player:ChatPrint( "Weil du das erste mal gespendet hast, bekommst du: +10.000,-EUR" )
end
RP.PREMIUM.SETTINGS.FirstReward["vip_2"] = function( Player )
    Player:AddCash( 20000 )
	Player:AddSkillPoint( 1, false )
    Player:ChatPrint( "Weil du das erste mal gespendet hast, bekommst du: +20.000,-EUR und 1 Skill Punkt" )
end
RP.PREMIUM.SETTINGS.FirstReward["vip_3"] = function( Player )
    Player:AddCash( 40000 )
    Player:AddSkillPoint( 2, false )
    Player:ChatPrint( "Weil du das erste mal gespendet hast, bekommst du: +40.000,-EUR und 2 Skill Punkte" )
end

RP.PREMIUM.SETTINGS.PremiumDays = 30


function RP.PREMIUM.LoadPremium( Player )
    Query( "SELECT * FROM premium WHERE sid='" .. tostring( Player:SteamID() ) .. "'", function( tbl )
        if !(tbl) then Msg( "There was an error loading the Premium Table!" ) return end
        Player.premium_counts = #tbl
        if #tbl < 1 then return end
        
        local level = nil
        local total = 0
        for k, v in pairs( tbl ) do
            if v.expires > os.time() then
                total = total + v.amount
            end
        end
        
        level = RP.PREMIUM.GetLevel( total )
        if level == nil then return end
        
        Player:SetUserGroup( level )
        timer.Create( "CheckForPremium" .. tostring(Player:SteamID()), 300, 0, RP.PREMIUM.CheckForPremium( Player ) )
    end)
end
hook.Add( "PlayerAuthed", "Premuim_LoadPlayer", RP.PREMIUM.LoadPremium )

function RP.PREMIUM.GetLevel( amount )
    local level = nil
    for k, v in pairs( RP.PREMIUM.SETTINGS.VipLevel ) do
        if amount >= v then level = k end
    end
    return level
end

function RP.PREMIUM.CheckForPremium( Player )
    if !(IsValid( Player ) ) then
        timer.Destroy( "CheckForPremium" .. tostring(Player:SteamID()) )
        return
    end
    
    Query( "SELECT * FROM premium WHERE sid='" .. tostring( Player:SteamID() ) .. "'", function( tbl )
        if !(tbl) then Msg( "There was an error loading the Premium Table!" ) return end
        if #tbl < 1 then return end
        
        local level = nil
        local total = 0
        for k, v in pairs( tbl ) do
            if v.expires > os.time() then
                total = total + v.amount
            end
        end
        
        level = RP.PREMIUM.GetLevel( total )
        if level == nil then 
            Player:SetUserGroup( "user" ) 
            Player:ChatPrint( "Dein Premium ist abgelaufen. Du profitierst nun nicht mehr von den VIP Features!" )
            timer.Destroy( "CheckForPremium" .. tostring(Player:SteamID()) )
        end
    end)
end

// Add Premium

function RP.PREMIUM.AddPremium( Player, amount )
    if !(IsValid( Player )) then return end
    if !(amount) then return end
    local level = RP.PREMIUM.GetLevel( amount )
    if level == nil then return end
    
    local expires = os.time() + ( 86400 * RP.PREMIUM.SETTINGS.PremiumDays )
    
    Query( "INSERT INTO premium( sid, amount, received, expires ) VALUES( '" .. tostring( Player:SteamID() ) .. "', " .. amount .. ", " .. os.time() .. ", " .. expires .. " )", function()
        Player:SetUserGroup( level )
        Player:ChatPrint( "Danke für deine Spende :)" )
        
        if Player.premium_counts == 0 then
            RP.PREMIUM.SETTINGS.FirstReward[level]( Player )
        end
        
        timer.Create( "PremiumPurchase" .. tostring( Player:SteamID() ), 1, 10, function()
            local vPoint = Player:GetPos()
            for i=1, 5 do
                vPoint = vPoint + Vector( math.Rand( -5, 5 ), math.Rand( -5, 5 ), 2 )
                local effectdata = EffectData()
                effectdata:SetOrigin( vPoint )
                util.Effect( "balloon_pop", effectdata )
            end
            Player:EmitSound( "vo/npc/Barney/ba_ohyeah.wav", 50, math.Rand( 60, 180 ) )
        end)
        Player.premium_counts = Player.premium_counts + 1
    end)
    return true
end

concommand.Add( "NOSRP_AddPremiumUser", function( ply, cmd, args )
    if !(ply:IsSuperAdmin()) then return end
    if !(args[1]) then return end
    local user = FindPlayerBySteamID( tostring(args[1] ) )
    if user == nil then return end
    if !(tonumber(args[2])) then return end
    
    RP.PREMIUM.AddPremium( user, tonumber( args[2] ) )
    ply:ChatPrint( "User wurde erfolgreich hinzugefügt!" )
end)