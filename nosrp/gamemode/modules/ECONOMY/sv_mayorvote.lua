util.AddNetworkString( "MayorSelectionStart" )
util.AddNetworkString( "SendMayorDecision" )

local Vote_Active = false
local Mayor_Selection_Player = {}
local max_player = 6
local vote_start_time = 120

// Dont Touch!
local vote_time = 0
local countdown = vote_start_time
local countdown_started = false
//

function PLAYER_META:AddToMayorSelection()
    if !(IsValid( self )) then return end
    local found = false
    for k, v in pairs( Mayor_Selection_Player ) do
        if v == self then found = true end
    end
    if found then return end
    
    if !(self:CanEnterJob( TEAM_MAYOR )) then
        return 
    end
    table.insert( Mayor_Selection_Player, self )
    self.EnteredMayorVote = true
    self:RPNotify( "Du hast dich Erfolgreich zum Mayor-Voting hinzugefügt!", 5 )
end

function PLAYER_META:DeleteFromMayorSelection()
    if !(IsValid( self )) then return end
    for k, v in pairs( Mayor_Selection_Player ) do
        if v == self then table.remove( Mayor_Selection_Player, k ) end
    end
    self.EnteredMayorVote = false
    self:RPNotify( "Du hast dich Erfolgreich vom Mayor-Voting abgemeldet!", 5 )
end

function StartMayorVote()
    Vote_Active = true
    countdown_started = false
    
    net.Start( "MayorSelectionStart" )
        net.WriteTable( Mayor_Selection_Player )
    net.Send( player.GetAll() )
    
    vote_time = CurTime() + 20
end

net.Receive( "SendMayorDecision", function( data, ply )
    if !(Vote_Active) then return end
    local ply = net.ReadEntity()

    ply.m_votes = ply.m_votes or 0
    ply.m_votes = ply.m_votes + 1
end)

local function GiveMayorToWinner()
    Vote_Active = false
    
    local votes, winner = 0, nil
    for k, v in pairs( Mayor_Selection_Player ) do
        if !(IsValid( v )) then continue end
        if (v.m_votes or 0) > votes then
            votes = v.m_votes
            winner = v
            v.m_votes = 0
        end
    end
    
    for k, v in pairs( player.GetAll() ) do
        v:RPNotify( (winner:GetRPVar( "rpname" ) or winner:Nick()) .. " hat die Mayor Wahl mit " .. tostring( votes ) .. " Stimmen gewonnen!", 10 )
    end
    
    Mayor_Selection_Player = {}
    winner:SwapTeam( TEAM_MAYOR, true )
end

local function MayorVoteThink()
    // Checks if the player still on Server & is valid
    for k, v in pairs( Mayor_Selection_Player ) do
        if !(IsValid( v )) then table.remove( Mayor_Selection_Player, k ) continue end
    end

    // Bevor der Vote startet, mÃ¼ssen wir erstmal auf genÃ¼gend Spieler warten. Wir warten Maximal 120 Sekunden bei 2 Spielern. Dann wird der Vote starten.
    if !(Vote_Active) && !(countdown_started) && #Mayor_Selection_Player > 1 then 
        countdown = CurTime() + vote_start_time
        countdown_started = true
        for k, v in pairs( player.GetAll() ) do
            v:RPNotify( "Der Mayor-Vote wird in 2 Minuten Starten!", 5 )
        end
    elseif !(Vote_Active) && #Mayor_Selection_Player < 2 && countdown_started then
        countdown = CurTime() - 1
        countdown_started = false
    end
    if !(Vote_Active) && (countdown - CurTime()) < 0 && #Mayor_Selection_Player > 1 then
        StartMayorVote()
    end
    
    // Der Vote ist nun gestartet
    if Vote_Active && vote_time - CurTime() < 0 then
        GiveMayorToWinner()
    end
end
hook.Add( "Think", "MayorVoteThink", MayorVoteThink )