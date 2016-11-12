--[[
	Hey there! This is the configuration file for ItemStore. If you want to change any behavior in
	ItemStore, you should probably do it here. That said, there are a couple things you should
	know before you go and change this file around.

	Like any other Lua file, if you make an error here, it'll cause Gmod to report errors.
	In this case, ItemStore will report the error and load up a default configuration.
	If your changes aren't taking effect, you should have a look at your server console
	to see if there's any syntax errors that you may have caused.

	Users coming from ItemStore v2 may notice that some of the options once contained
	in this file are no longer here. This is because their functionality was highly specific
	or redundant. Following is a list of removed, changed or renamed settings.

	The following options have been removed:
		- DontUsePocket (please use darkrp's configuration to do this instead)
		- UsePickupSWEP (please use darkrp's configuration to do this instead)
		- InventorySize (use the default entry in InventorySizes to change this)
		- BankSize (use the default entry in BankSizes to change this)

	The following options have been renamed:
		- ContexstOpenInventory -> ContextInventory
		- InventoryAtLeft -> ContextInventoryPosition
		- RankSizes -> InventorySizes
		- DisableAntidupe -> AntiDupe
		- Gamemode -> GamemodeProvider

	The following options have had their functionality modified:
		- Both InventorySizes (previously RankSizes) and BankSizes now contain
 		  a "default" rank. This is the size of the inventory that a player will spawn
		  with if they don't match any of the other ranks configured.
		- In addition to the changes above, InventorySizes and BankSizes both allow
		  for a third dimension to be defined, in the form of pages.
		- ContextInventoryPosition (previously InventoryAtLeft) can now
		  be configured to go to any side of the screen using the TOP, LEFT, RIGHT
		  and BOTTOM arguments.
]]

-- The maximum allowable size for stacked items. Set to math.huge for infinite stacks.
-- SOME ITEMS DO NOT OBEY THIS CONFIG OPTION!! Ammo and money are exempt for obvious reasons.
itemstore.config.MaxStack = 16

-- Where to save player data. Values are text and mysql.
-- Please see mysqlsetup.txt for mysql instructions.
itemstore.config.DataProvider = "text"

-- The gamemode to enable support for. Valid values are darkrp and darkrp24.
itemstore.config.GamemodeProvider = "imrp"

-- The interval at which the inventory saves all players automatically, in seconds.
itemstore.config.SaveInterval = 180

-- The language of the inventory.
-- There is only a single language installed by default, english (en).
itemstore.config.Language = "en"

-- Enable quick inventory viewing by holding the context menu key, default C.
itemstore.config.ContextInventory = false

-- If context inventory is enabled, this defines where it appears on the player's screen.
-- Valid values are "top", "bottom", "left" and "right"
itemstore.config.ContextInventoryPosition = "bottom"

-- Force player to holster all of their ammo as well as their gun when they use /invholster, ala DarkRP.
itemstore.config.InvholsterTakesAmmo = false

-- Force player to retrieve their items from the bank before being able to use them.
itemstore.config.PickupsGotoBank = false

-- The distance that the player is able to "reach" when picking up items.
itemstore.config.PickupDistance = 100

-- The key to use in combination with +use (E) to pick up items.
-- A list of keys for this option is here: http://wiki.garrysmod.com/page/Enums/IN
-- Set this to -1 to disable the key combo.
itemstore.config.PickupKey = -1

-- Whether or not trading should be enabled. Set this to false to disable.
itemstore.config.TradingEnabled = true

-- How long in seconds the player needs to wait after a trade to trade again
itemstore.config.TradeCooldown = 60

-- How close in hammer units two players need to be to trade. 0 means infinite.
itemstore.config.TradeDistance = 0

-- Whether or not the player should drop their inventory on death.
itemstore.config.DeathLoot = false

-- How long in seconds the player's dropped inventory should exist for.
itemstore.config.DeathLootTimeout = 60 * 5

-- Makes boxes breakable if enough damage is inflicted
itemstore.config.BoxBreakable = false

-- Amount of health for boxes to have
itemstore.config.BoxHealth = 100

-- Should users be able to pick up other users' entities
itemstore.config.IgnoreOwner = true

-- Fixes a duplication bug by detouring ENTITY:Remove()..
-- WARNING: Turning this off will open an exploit that allows players to dupe items!
-- Only turn it off if it is somehow conflicting.
itemstore.config.AntiDupe = true

-- Inventory sizes according to rank.
-- The format for this table is:
-- <rank> = { <width>, <height>, <pages> }
-- If a player's rank is not contained within this table, it defaults to default.
-- DO NOT REMOVE DEFAULT! If you remove it, there will be errors!
itemstore.config.InventorySizes = {
	default = { 11, 5, 1 },
	--superadmin = { 10, 5, 1 },
	--admin = { 10, 3, 1 },
}

-- Same as above, for banks. Same format. DON'T REMOVE DEFAULT!
itemstore.config.BankSizes = {
	default = { 8, 4, 2 },
	--admin = { 12, 4, 1 }
}

-- The skin to use. Preinstalled skins are "flat" and "classic".
itemstore.config.Skin = "flat"

-- The various colours of the VGUI in R, G, B, A 0-255 format.
-- Currently not available when using the flat skin
itemstore.config.Colours = {
	Slot = Color( 0, 0, 0, 150 ),
	HoveredSlot = Color( 255, 255, 255, 150 ),
	Title = Color( 255, 255, 255 ),

	TitleBackground = Color( 0, 0, 0, 200 ),
	Upper = Color( 100, 100, 100, 100 ),
	Lower = Color( 30, 30, 30, 150 ),
	InnerBorder = Color( 0, 0, 0, 0 ),
	OuterBorder = Color( 0, 0, 0, 200 )
}

-- A table of disabled items. Set any value in this table to true to disallow picking up the item.
itemstore.config.DisabledItems = {
	drug = false,
	drug_lab = false,
	food = false,
	gunlab = false,
	microwave = false,
	money_printer = false,
	spawned_food = false,
	spawned_shipment = false,
	spawned_weapon = false,

	durgz_alcohol = false,
	durgz_aspirin = false,
	durgz_cigarette = false,
	durgz_cocaine = false,
	durgz_heroine = false,
	durgz_lsd = false,
	durgz_mushroom = false,
	durgz_pcp = false,
	durgz_weed = false
}

-- Custom items. Defining these will allow server owners to make certain
-- entities pickupable... but may not work 100%. If this is the case, you will probably
-- need to code the item definition yourself.
-- Format for each entry is:
-- <entity class> = { "<name>", "<description>", <stackable (optional)> }
itemstore.config.CustomItems = {
	sent_ball = { "Bouncy Ball", "A bouncy ball!", true },
}
