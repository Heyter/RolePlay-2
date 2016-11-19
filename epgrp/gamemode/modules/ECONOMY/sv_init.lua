util.AddNetworkString( "ECONOMY_SEND_MAYOR_DECISIONS" )
util.AddNetworkString( "ECONOMY_SEND_SETTINGS" )
util.AddNetworkString( "ECONOMY_SEND_CITY_LOG" )
util.AddNetworkString( "ECONOMY_PURCHASE_ITEM" )

ECONOMY.CITY_CASH = ECONOMY.MAX / 2
ECONOMY.LAST_MONTH_CASH = 0
ECONOMY.CITY_LOG = {}


hook.Add( "ShowTeam", "ECONOMY_SHOW_MENU", function( ply )
   local canopen = false
   for k, v in pairs( ECONOMY.ADMINISTRATORS ) do if ply:Team() == v then canopen = true end end
   if canopen then ply:SendLua("OpenEconomyMenu()") end
end)

hook.Add( "PlayerAuthed", "ECONOMY_SYNC_SETTINGS", function( ply )
    local tbl = table.Copy(ECONOMY)
    
    for k, v in pairs( tbl ) do
        if isfunction( v ) then tbl[k] = nil end
    end
    
    net.Start( "ECONOMY_SEND_SETTINGS" )
        net.WriteTable( GAMEMODE.TEAMS )
        net.WriteTable( tbl )
    net.Send( ply )
end)

net.Receive( "ECONOMY_SEND_MAYOR_DECISIONS", function( um, ply )
    if !(IsValid( ply ) or ply:IsPlayer() or ply:Team() == TEAM_MAYOR or ply:IsAdmin()) then return end
    local tbl = net.ReadTable()
    local zins_tbl = net.ReadTable()
    
    for _, setting in pairs( tbl ) do
        for k, v in pairs( ECONOMY.JOBPANELS["TEAM_" .. tostring( setting.job )] ) do
            if k == "Job" then continue end
            if !(v.key == setting.key) then continue end
            if v.min and v.max then // Checkbox oder Nummer unterscheidung
                if setting.value < v.min then continue end  // Exploit check
                if setting.value > v.max then continue end  // Exploit check
            end
            
            GAMEMODE.TEAMS[setting.job][setting.key] = setting.value    // Lets overwrite Job informations
        end
    end
    
    for k, v in pairs( zins_tbl ) do
        ECONOMY[v.key] = v.val
    end
    
    ply:SendLua("PLUGINS.NOTIFY.AddNotify(\"Job settings has been successfully changed\", NOTIFY_UNDO, 5)")
    
    local tbl = table.Copy(ECONOMY)
    
    for k, v in pairs( tbl ) do
        if isfunction( v ) then tbl[k] = nil end
    end
    
    net.Start( "ECONOMY_SEND_SETTINGS" )    // Now we need to Sync the TEAMS again, because client has old informations
        net.WriteTable( GAMEMODE.TEAMS )
        net.WriteTable( tbl )
    net.Send( player.GetAll() )             // Sync with all Players on the Server
    
    for k, v in pairs( player.GetAll() ) do
        ply.lasteconotify = ply.lasteconotify or CurTime() - 10     // anti Spam
        if ply.lasteconotify > CurTime() - 10 then continue end
        ply.lasteconotify = CurTime()
        v:SendLua("PLUGINS.NOTIFY.AddNotify(\"Job Payments and Restrictions has been changed! Check the Blackboard for more Informations.\", NOTIFY_UNDO, 10)")
    end
end)

function ECONOMY.HasAccess( ply )
    for k, v in pairs( ECONOMY.ADMINISTRATORS ) do
        if ply:Team() == v then return true end
    end
    if ply:IsSuperAdmin() then return true end
    return false
end

/******************************************************
            ECONOMY SYSTEM FOR MAYOR
*///////////////////////////////////////////////////////
    timer.Create( "ECONOMY_MONTH_TIMER", ECONOMY.MONTH_LAST, 0, function()
        ECONOMY.CITY_LOG = {}
		ECONOMY.CITY_LOG.CASH = {}
		ECONOMY.CITY_LOG.WARRANT = {}
		ECONOMY.CITY_LOG.DAMAGE = {}
        ECONOMY.LAST_MONTH_CASH = ECONOMY.CITY_CASH
        ECONOMY.SyncCityData()
        
        if GetMayor() then GetMayor():RPNotify( "Ein neuer Monat hat begonnen!", 10 ) end
        if GetMayor() then GetMayor():RPNotify( "Mehr Details im City Log.", 10 ) end
    end)
    
    hook.Add( "PlayerAuthed", "EOCNOMY_SEND_CITY_DATA", function( ply )
        timer.Simple( 2, function()
            net.Start( "ECONOMY_SEND_CITY_LOG" )
                net.WriteString( ECONOMY.CITY_CASH )
                net.WriteString( ECONOMY.LAST_MONTH_CASH )
                net.WriteTable( ECONOMY.CITY_LOG )
            net.Send( ply )
        end)
    end)
    
    function ECONOMY.HAS_ITEM_LIMIT( item )
        if !(item) then return end
        
        local count = 0
        for k, v in pairs( ents.FindByClass( ECONOMY.SHOPITEMS[item].ent ) ) do
            count = count + 1
        end
        if count > ECONOMY.SHOPITEMS[item].max then return true end
        return false
    end
    
    net.Receive( "ECONOMY_PURCHASE_ITEM", function( data, ply )
        if !(IsValid( ply )) then return end
        if !(ECONOMY.HasAccess( ply )) then return end
        if !(ply:Alive()) then return end
        
        local spawnpos = ply:GetEyeTrace().HitPos
        if spawnpos:Distance( ply:GetPos() ) > ECONOMY.SPAWN_DISTANCE then
            ply:RPNotify( "Bitte spawne das Item näher an dir dran!", 5 )
            return false
        end
        local item = net.ReadString()
        local name = item
        if ECONOMY.HAS_ITEM_LIMIT( item ) then return end
        item = ECONOMY.SHOPITEMS[item]
        
        if ECONOMY.GetCityCash() < item.cost then return end
        
        if item.cost > 0 then
            ECONOMY.AddCityCash( -item.cost )
            ECONOMY.AddToLog( "-" .. item.cost .. ",-EUR für " .. name .. "." )
        end
        
        local spawnpos = ply:GetEyeTrace().HitPos
        
        local ent = ents.Create( item.ent )
        ent:SetPos( spawnpos )
        ent:Spawn()
        ent.city_spawn = true
        
        local a = (ply:EyeAngles() - ent:GetAngles())
        ent:SetAngles( Angle( 0, a.y - 90, a.r) )
    end)
////////

function ECONOMY.SyncCityData()
    net.Start( "ECONOMY_SEND_CITY_LOG" )
        net.WriteString( ECONOMY.CITY_CASH )
        net.WriteString( ECONOMY.LAST_MONTH_CASH )
        net.WriteTable( ECONOMY.CITY_LOG )
    net.Send( player.GetAll() )
end

function ECONOMY.AddCityCash( amount )
    ECONOMY.CITY_CASH = math.Round(ECONOMY.CITY_CASH + amount)
    ECONOMY.SyncCityData()
end

function ECONOMY.GetCityCash()
    return (ECONOMY.CITY_CASH or 0)
end

function ECONOMY.AddToLog( args, class )
	class = class or "cash"
    if !(args) then return end
    
	if class == "cash" then	
		if string.len( args ) < 2 then return end
        if not ECONOMY.CITY_LOG.CASH then end
		table.insert( ECONOMY.CITY_LOG.CASH, {text} )
	elseif class == "warrant" then
        if not ECONOMY.CITY_LOG.WARRANT then end
		table.insert( ECONOMY.CITY_LOG.WARRANT, { args[1], args[2], args[3] } )
	elseif class == "damage" then
        if not ECONOMY.CITY_LOG.DAMAGE then end
		table.insert( ECONOMY.CITY_LOG.DAMAGE, { args[1], args[2], args[3] } )
	end
	
    ECONOMY.SyncCityData()
end
