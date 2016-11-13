
rPhone.ClientInclude( "client/cl_games_apk.lua" )


local gamesdir = "rphone/bundles/games/games/"
local _, games = file.Find( rPhone.ToGarrySafePath( gamesdir, "/*" ), "LUA" )

for _, game in pairs( games ) do
	local ginit = rPhone.ToGarrySafePath( gamesdir, game, "sh_init.lua" )

	if file.Exists( ginit, "LUA" ) then
		rPhone.SharedInclude( ginit )
	end
end

