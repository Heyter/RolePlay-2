
rPhone.SVSetVariable( "RPHONE_DOWNLOAD_CONTENT_WORKSHOP", true )  --download content from the workshop

rPhone.SetVariable( "RPHONE_NUMBER_LENGTH_MIN", 3 )  --minimum valid number length
rPhone.SetVariable( "RPHONE_NUMBER_LENGTH_MAX", 7 )	 --maximum valid number length
rPhone.SetVariable( "RPHONE_NUMBER_LENGTH_DEFAULT", 7 )  --default number length (for generated numbers)

rPhone.SetVariable( "RPHONE_TONES_ENABLED", true )  --tones enabled
rPhone.SetVariable( "RPHONE_TONES_CLIENTSIDEONLY", false )  --tones client side only (don't play for everyone)
rPhone.SetVariable( "RPHONE_TONES_VOLUME", 10 )  --tone volume (1 - 100)

rPhone.SVSetVariable( "RPHONE_TONES_SUPPRESS_INTERVAL", 5 )  --time until you can start another tone
rPhone.SVSetVariable( "RPHONE_TONES_MAX_LENGTH", 10 )  --maximum duration of a tone
