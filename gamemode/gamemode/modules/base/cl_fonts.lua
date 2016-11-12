for i=10, 80 do
    surface.CreateFont( "RPNormal_" .. i, {
        font = "BigNoodleTitling",
        size = i,
        weight = 500 + (i*2),
        blursize = 0,
        scanlines = 0,
        antialias = true,
        underline = false,
        italic = false,
        strikeout = false,
        symbol = false,
        rotary = false,
        shadow = false,
        additive = false,
        outline = false,
    } )
end

for i=15, 60 do
    surface.CreateFont( "Trebuchet"..i, {
	font = "Trebuchet18", 
	size = i, 
	weight = 1500, 
	blursize = 0, 
	scanlines = 0, 
	antialias = true, 
	underline = false, 
	italic = false, 
	strikeout = false, 
	symbol = false, 
	rotary = false, 
	shadow = false, 
	additive = false, 
	outline = false, 
} )
end