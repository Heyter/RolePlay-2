itemstore.gamemodes = {}

PROVIDER = {}
include( "gamemodeproviders/" .. itemstore.config.GamemodeProvider .. ".lua" )
if SERVER then AddCSLuaFile( "gamemodeproviders/" .. itemstore.config.GamemodeProvider .. ".lua" ) end
itemstore.gamemodes.Provider = PROVIDER
PROVIDER = nil

assert( itemstore.gamemodes.Provider, "[ItemStore] Gamemode provider not found" )

function itemstore.gamemodes.Run( func_name, ... )
	local func = itemstore.gamemodes.Provider[ func_name ]
	if not func then return end

	return func( itemstore.gamemodes.Provider, ... )
end

function itemstore.gamemodes.GetMoney( pl )
	return itemstore.gamemodes.Run( "GetMoney", pl )
end

if SERVER then
	function itemstore.gamemodes.SetMoney( pl, money )
		return itemstore.gamemodes.Run( "SetMoney", pl, money )
	end

	function itemstore.gamemodes.GiveMoney( pl, money )
		return itemstore.gamemodes.SetMoney( pl, itemstore.gamemodes.GetMoney( pl ) + money )
	end

	function itemstore.gamemodes.AddCommand( command, info, func )
		return itemstore.gamemodes.Run( "AddCommand", command, info, func )
	end

	itemstore.gamemodes.AddCommand( "trade", "Initiates a trade with another player.", function( pl, args )
		if not itemstore.config.TradingEnabled then
			return ""
		end

		if pl.TradingCooldown and pl.TradingCooldown > CurTime() then
			pl:ChatPrint( itemstore.Translate( "trading_cooldown" ) )
			return ""
		end

		local target = pl:GetEyeTrace().Entity

		if args ~= "" then
			for _, pl in ipairs( player.GetAll() ) do
				if string.find( string.lower( pl:Name() ), string.lower( args ), 1, true ) then
					target = pl
				end
			end
		end

		if not IsValid( target ) or not target:IsPlayer() then
			pl:ChatPrint( itemstore.Translate( "player_not_found" ) )
			return ""
		end

		if itemstore.config.TradeDistance ~= 0 and pl:GetPos():Distance( target:GetPos() ) > itemstore.config.TradeDistance then
			pl:ChatPrint( itemstore.Translate( "too_far_away" ) )
			return ""
		end

		itemstore.Trade( pl, target )

		pl.TradingCooldown = CurTime() + itemstore.config.TradeCooldown

		return ""
	end )

	itemstore.gamemodes.AddCommand( "inv", "Opens your inventory.", function( pl )
		pl:OpenContainer( pl.Inventory:GetID(), itemstore.Translate( "inventory" ), true )
		return ""
	end )

	itemstore.gamemodes.AddCommand( "pickup", "Picks an item up.", function( pl )
		pl:PickupItem()
		return ""
	end )
end

hook.Add( "PostGamemodeLoaded", "ItemStoreGamemodeLoad", function()
	itemstore.gamemodes.Run( "Load" )
end )
