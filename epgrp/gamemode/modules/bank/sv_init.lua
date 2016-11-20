util.AddNetworkString( "NOSBank_WithdrawMoney" )
util.AddNetworkString( "NOSBank_DepositMoney" )
util.AddNetworkString( "NOSBank_TransferMoney" )

NOSBank = {}

net.Receive( "NOSBank_WithdrawMoney", function( len, ply )
	local amount = tonumber( net.ReadString() )
    local cash = ply:GetRPVar( "bank_cash" ) or 0
	if amount && cash >= amount then
		NOSBank.takeMoney( ply, amount )
		ply:AddCash( amount )
	end
end )

net.Receive( "NOSBank_DepositMoney", function( len, ply )
	local amount = tonumber( net.ReadString() )
    
	if amount && ply:CanAfford( amount ) then
		NOSBank.addMoney( ply, amount )
		ply:AddCash( -amount )
	end
end )

net.Receive( "NOSBank_TransferMoney", function( len, ply )
	local amount = tonumber( net.ReadString() )
	local target = net.ReadEntity()

	if IsValid( target ) and amount then
		NOSBank.takeMoney( ply, amount )
		NOSBank.addMoney( target, amount )

		ply:RPNotify( "Du hast " .. amount .. ",-EUR zu " .. target:GetRPVar( "rpname" ) .. " überwiesen.", 3 )
		target:RPNotify( "Du hast " .. amount .. ",-EUR von " .. ply:GetRPVar( "rpname" ) .. " überwiesen bekommen.", 3 )
	end
end )

function NOSBank.initializePlayer( ply )
	if IsValid( ply ) then
		RP.SQL:Query( "SELECT * FROM players WHERE sid = %1%", {ply:SteamID()}, function( q )
			if not q[1] then return end
			
			ply:SetRPVar( "bank_cash", q[1].bank_cash )			
		end )
	end
end
hook.Add( "PlayerAuthed", "Load Bank", NOSBank.initializePlayer )

function NOSBank.addMoney( ply, amount )
	if IsValid( ply ) then
		local newamount = ply:GetRPVar( "bank_cash" ) + amount

		RP.SQL:Query( "UPDATE players SET bank_cash = %1% WHERE sid = %2%", {math.Round((newamount or 0)), ply:SteamID()} )

		ply:SetRPVar( "bank_cash", math.Round(newamount or 0) )
	end
end

function NOSBank.takeMoney( ply, amount )
	if IsValid( ply ) then
		local bankcash = ply:GetRPVar( "bank_cash" ) or 0
		local newamount = bankcash - amount

		if newamount >= 0 then
			RP.SQL:Query( "UPDATE players SET bank_cash = %1% WHERE sid = %2%", {math.Round(newamount), ply:SteamID()} )

			ply:SetRPVar( "bank_cash", math.Round(newamount) )
		end
	end
end

hook.Add( "PlayerAuthed", "CreateZinsTimer", function( ply )
    timer.Create( "PlayerBankZinsen" .. tostring( ply:SteamID() ), ECONOMY.BANKZINSINTERVAL, 0, function()
        if !(IsValid( ply )) then timer.Destroy( "PlayerBankZinsen" .. tostring( ply:SteamID() ) ) return end
        
        local zins = ((ply:GetRPVar( "bank_cash" ) / 100) * ECONOMY.BANKZINSEN)
        NOSBank.addMoney( ply, zins )
    end)
end)

hook.Add( "PlayerDisconnected", "RemoveBankZinsTimer", function( ply )
    timer.Destroy( "PlayerBankZinsen" .. tostring( ply:SteamID() ) )
end)