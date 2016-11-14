
local function addEntities()
	-- modify these how you like, or remove them if you want to add them yourself

	if !AddEntity then return end

	AddEntity( "Small Sign", {
		ent = "signs_small",
		model = "models/hunter/plates/plate1x1.mdl",
		price = 500,
		max = 2,
		cmd = "buysmallsign"
	} )

	AddEntity( "Large Sign", {
		ent = "signs_large",
		model = "models/hunter/plates/plate2x2.mdl",
		price = 1000,
		max = 2,
		cmd = "buylargesign"
	} )

	AddEntity( "Small Sign (Wide)", {
		ent = "signs_small_wide",
		model = "models/hunter/plates/plate1x2.mdl",
		price = 750,
		max = 2,
		cmd = "buysmallsignwide"
	} )

	AddEntity( "Large Sign (Wide)", {
		ent = "signs_large_wide",
		model = "models/hunter/plates/plate2x4.mdl",
		price = 1250,
		max = 2,
		cmd = "buylargesignwide"
	} )


	AddEntity( "Small Ticker Sign", {
		ent = "signs_ticker_small",
		model = "models/hunter/plates/plate025x2.mdl",
		price = 250,
		max = 2,
		cmd = "buysmallticker"
	} )

	AddEntity( "Large Ticker Sign", {
		ent = "signs_ticker_large",
		model = "models/hunter/plates/plate025x4.mdl",
		price = 500,
		max = 2,
		cmd = "buylargeticker"
	} )
end


hook.Add( "Initialize", "sh_rprotect_ensure_addents", addEntities )
hook.Add( "OnGamemodeLoaded", "sh_rprotect_addents", function()
	hook.Remove(  "Initialize", "sh_rprotect_ensure_addents" )
	
	addEntities()
end )
