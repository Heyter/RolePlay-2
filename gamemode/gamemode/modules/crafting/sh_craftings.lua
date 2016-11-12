CRAFT_TABLE = {}

CRAFT_LANG = {
	drug_pot = "Blumentopf",
	beer = "Bier",
    lodine = "Lodine",
	beer_box = "Bier Kasten ( 15x Bier )",
	bullet_casing = "Patronen Huelle",
	cardboard_box = "Karton",
	chunk_of_plastic = "Stueck Plastik",
	fuel_can = "Benzinkanister",
	glue = "Kleber",
	kitty_litter = "Katzenstreu",
	metal_polish = "Metall Lackierung",
	metal_rod = "Metallstange",
	paint_bucket = "Farbeimer",
	piece_of_metal = "Stueck Metall",
	propane_tank = "Propan Tank",
	wooden_board = "Holzbrett",
	wooden_nail = "Nagel",
	normal_batterie = "Batterie",
	rope_roll = "Kabelrolle"
}

RP.CRAFTING = RP.CRAFTING or {}
function RP.CRAFTING.GetItemInfo( item )
    local source = itemstore.items.Registered
    
    for k, v in pairs( source ) do
        if item == k then return v end
    end
    return nil
end

function RP.CRAFTING.AddMixture( info_table )
    table.insert( CRAFT_TABLE, info_table )
end