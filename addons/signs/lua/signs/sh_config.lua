
Signs.EnableDefaultFPPBehaviors = true -- whether entities will assume most common FPP behaviors
Signs.RemoveOnDisconnect = false -- remove all signs on disconnect

Signs.Fonts = {						-- sign fonts (["<display name>"] = "<font name>",)
	["Trebuchet"] = "Trebuchet24",
	["After Shok"] = "After Shok",
	["Dumb"] = "3Dumb",
	["1942"] = "1942 report",
	["Airstream"] = "Airstream",
	["Akashi"] = "Akashi",
	["Aller"] = "Aller",
	["Alpha Echo"] = "Alpha Echo",
	["Amadeus Regular"] = "Amadeus Regular",
	["Amatic"] = "Amatic SC",
	["AnuDaw"] = "AnuDaw",
	["Archery"] = "SF Archery Black",
	["Archistico"] = "Archistico"
}
Signs.FontWeightDefault = 500 -- default font weight
Signs.FontBoldWeight = 700 -- weight when bolded

Signs.FadeDistance = 6000 -- distance that signs are visible

Signs.TextLengthMax = 48 -- maximum length of any ticker/text overlay string

-- Normal Sign settings

Signs.BackgroundColorDefault = Color( 0, 0, 0, 50 ) -- default background color for signs

Signs.TextOverlayMax = 32 -- each sign can have this many text overlays
Signs.TextOverlayFontDefault = "Trebuchet24" -- the default font
Signs.TextOverlayFontSizeMin = 10 -- minimum font size
Signs.TextOverlayFontSizeMax = 150 -- maximum font size
Signs.TextOverlayFontSizeDefault = 30 -- default font size
Signs.TextOverlayColorDefault = Color( 255, 0, 0, 255 ) -- default text color

Signs.ImagesAllowed = true -- whether images are allowed
Signs.ImageFileSizeMax = 1000 * 2 -- kB (default is 1000 * 2 = 2000 kB = 2 MB)

-- Ticker Sign settings

Signs.TickerBackgroundColorDefault = Color( 255, 255, 255, 100 ) -- default ticker background
Signs.TickerFontDefault = "Trebuchet24" -- default ticker font
Signs.TickerTextColorDefault = Color( 0, 0, 0, 255 ) -- default ticker text color
Signs.TickerSpeedDefault = 2 -- default ticker speed
Signs.TickerCycleDelayDefault = 1 -- default ticker cycle delay (time between when it ends and starts over)
