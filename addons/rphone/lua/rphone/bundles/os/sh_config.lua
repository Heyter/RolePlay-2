
rPhone.CLSetVariable( "OS_LOCK_KEY_DEFAULT", KEY_P )  --default unlock key, see gmod wiki for KEY_* and MOUSE_* enumerations
rPhone.CLSetVariable( "OS_LOCK_KEY_MODE_DEFAULT", "hold" )  --default unlock type, 'hold' and 'doubletap' are valid values
rPhone.CLSetVariable( "OS_LOCK_KEY_HOLD_LENGTH_DEFAULT", 0.75 )  --default unlock hold duration

rPhone.CLSetVariable( "OS_LOCK_ANIMATION_LENGTH_DEFAULT", 0.6 )  --default lock/unlock animation duration

rPhone.CLSetVariable( "OS_LOCK_IN_JAIL", true )  --lock the phone when a user is jailed (DarkRP)

rPhone.CLSetVariable( "OS_AMMOFIX_ENABLED", true )  --whether to enable the fix for ammo being covered by phone
rPhone.CLSetVariable( "OS_AMMOFIX_COLOR", Color( 255, 255, 255, 255 ) )  --color of the ammofix indicator

rPhone.CLSetVariable( "OS_SCREEN_ALIGN", "right" )  --side of the screen to align the phone (left, right or center)
rPhone.CLSetVariable( "OS_SCREEN_ADDITIONAL_PADDING", 0 )  --padding from side of screen (only for left or right alignment)

rPhone.CLSetVariable( "OS_SLEEP_ALPHA_DEFAULT", 75 )  --transparency of phone when asleep (between 0 and 255)
rPhone.CLSetVariable( "OS_SLEEP_INACTIVITY_TIME_DEFAULT", 4 )  --how long until the phone falls asleep after no input
