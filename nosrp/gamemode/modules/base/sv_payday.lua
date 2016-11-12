--[[---------------------------------------------------------
   Name: PayDay
   Desc: Do the PayDay!
-----------------------------------------------------------]]
function PLAYER_META:PayDay()
    local cash = GAMEMODE.TEAMS[self:Team()].Lohn
    local steuer = cash*(ECONOMY.PAYDAY_STEUER or 0)
    
    if ECONOMY.GetCityCash() < cash then
        self:RPNotify( "Kein - Zahltag! Die Stadt ist pleite!", 10 )
        self.nextpayday = CurTime() + SETTINGS.PayDayTime
        return
    end
    
    if self:GetVIPLevel() > 0 then
        local r = ( cash + ( SETTINGS.VIPPayDayPercent * self:GetVIPLevel() ) ) - steuer
        self:AddCash( r )
        
        ECONOMY.AddCityCash( (cash - steuer) )
        ECONOMY.AddToLog( "-" .. tostring( cash ) .. "€ " .. (self:GetRPVar( "rpname" ) or self:Nick()) .. " PayDay."  )
        
        self.nextpayday = CurTime() + SETTINGS.PayDayTime
        self:RPNotify( "Zahltag! Du bekommst: €" .. tostring(math.Round(r)) .. " ( -€" .. steuer .. " steuern ) + ( %" .. tostring( ( SETTINGS.VIPPayDayPercent * self:GetVIPLevel() ) ) .. " VIP Bonus! )" , 10 )
    else
        self:AddCash( cash - steuer )
        
        ECONOMY.AddCityCash( (cash - steuer) )
        ECONOMY.AddToLog( "-" .. tostring( cash ) .. "€ " .. (self:GetRPVar( "rpname" ) or self:Nick()) .. " PayDay."  )
        
        self.nextpayday = CurTime() + SETTINGS.PayDayTime
        self:RPNotify( "Zahltag! Du bekommst: €" .. tostring(math.Round(cash - steuer)) .. " ( -€" .. steuer .. " steuern )", 10 )
    end
    
    if self:IsPolice() or self:IsSWAT() or self:IsMedic() then
        self:SetSkill( "Ruf", 0.05, true )
    end
end

--[[---------------------------------------------------------
   Name: PayDayThink
   Desc: Calls the PayDay when its time for paycheck.
-----------------------------------------------------------]]
local function PayDayThink()
    for k, v in pairs( player.GetAll() ) do
        v.nextpayday = v.nextpayday or (CurTime() + SETTINGS.PayDayTime)
        if !(v.isLoaded) then continue end
        if !(IsValid( v )) then continue end
        if !(v:Alive()) then continue end
        if v:Team() < 1 then continue end
        if CurTime() < v.nextpayday then continue end

        v:PayDay()
        continue
    end
end
hook.Add( "Think", "PayDayThinkHook", PayDayThink )