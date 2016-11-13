
Gas_Table = {
	gas_price = 2,
	pumped_liters = 0
}

local Prices = {"1.8", "2", "2.2", "2.4", "2.5", "2.7", "2.9", "3", "3.2", "3.4", "3.6"}
if SERVER then
	local function SetGasPrice( ply, cmd, args )
		if !ply:IsAdmin() then return end
		if !tonumber(args[1]) then return end
		
		--NotifyGasPrice( tonumber(args[1]) )
		
		ECONOMY.GASPREIS = args[1]
	end
	concommand.Add("rp_gasprice", SetGasPrice)
	
	function NotifyGasPrice( price )
		if tonumber(price) > tonumber(Gas_Table.gas_price) then
			for _, v in pairs(player.GetAll()) do
				GAMEMODE:Notify( v, 2, 8, "Der Benzinpreis ist auf $" .. price .. " gestiegen!" )
			end
		else
			for _, v in pairs(player.GetAll()) do
				GAMEMODE:Notify( v, 2, 8, "Der Benzinpreis ist auf $" .. price .. " gesunken!" )
			end
		end
		umsg.Start("RefreshGasPrice")
		umsg.String( tostring(price) )
		umsg.End()
	end
	
	//////////////////////
	// Random Gas Price //
	//////////////////////
	timer.Create("NewGasPrice", 600, 0, function()
		local count = math.Rand(1, #Prices)
		
		--NotifyGasPrice( Prices[math.Round(count)] )
		
		ECONOMY.GASPREIS = Prices[math.Round(count)]
		
	end)
	
end