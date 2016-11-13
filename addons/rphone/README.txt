- Installation

Extract to garrysmod/addons.

- Configuration

All configuration options exist in the files called 'sh_config.lua', and are accompanied by brief descriptions of their usage.
I do not recommend modifying the actual code outside of these files.

 - Tones
   
   All tone configuration options can be found in lua/rphone/core/sh_config.lua. From here you can disable tones, make them 
   clientside only, adjust their volume, maximum length, ect.

 - Phone Numbers

   Number configuration options can also be found in lua/rphone/core/sh_config.lua. However, I do not recommend changing these values,
   other than maybe the default number length. This is because it has the potential to conflict with future addons (such as maybe
   911 support, so leave the minimum length at 3 or less).

 - Browser
  
   The page that the Browser app opens up to by default (unless a user changes it in settings) is configurable in 
   lua/rphone/bundles/browser/sh_init.lua.

 - Launcher

   Default Wallpaper and Icon colors are configurable in lua/rphone/bundles/launcher/sh_init.lua.

 - OS

   Default lock key binding, key unlock mode, and whether to lock the phone in jail are configurable in 
   lua/rphone/bundles/os/sh_init.lua. You can also enable/disable and change the color of the ammo fix I made in case you have
   a custom HUD or something in this file as well.

   To set the transparency or the inactivity time for when the phone goes to sleep, adjust the OS_SLEEP_ALPHA_DEFAULT and
   OS_SLEEP_INACTIVITY_TIME_DEFAULT options respectively. The former accepts values ranging between 0 and 255.

 - Phone

   Phone configuration options can be found in lua/rphone/bundles/phone/sh_init.lua. From here, you can add ring tones according
   to the examples I provided. To set the default ring tone, use the PHONE_RINGTONE_DEFAULT attribute as detailed in the file.
   You can also set the maximum ringing time, and whether to have whisper always on in this file.

 - SMS

   SMS configuration options can be found in lua/rphone/bundles/sms/sh_init.lua. Like the Phone, you can add/remove available tones
   using the template I provided. You can also adjust the maximum mailbox (offline message queue) size and maximum message length.

 - Directory

   Directory configuration options can be found in lua/rphone/bundles/directory/sh_init.lua. In order to force all online users to be
   listed regardless of their preference, set the DIRECTORY_LIST_ALL option to true. If it is not being forced, you can also set the
   player's default inclusion preference with DIRECTORY_INCLUDE_DEFAULT.

- Trouble Shooting

 - Problems downloading content

   I added the rPhone content to the Steam Workshop. If for some reason you have trouble downloading or content is missing, try
   disabling the "RPHONE_DOWNLOAD_CONTENT_WORKSHOP" option in rphone/core/sh_init.lua. If you have FastDL enabled, you will most
   likely need to bzip the content and upload it to your host.

- Contact

If you have any issues that weren't addressed here, or just need additional help, feel free to send me a PM or open a support ticket
on ScriptFodder.