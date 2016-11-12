LANGUAGES = LANGUAGES or {}

function RP.translate( index )
	if !(LANGUAGES[SETTINGS.LANGUAGE]) then return "Error! No Translation file." end
	if !(LANGUAGES[SETTINGS.LANGUAGE][index]) then return "Error! No Translation index." end
	return LANGUAGES[SETTINGS.LANGUAGE][index]
end