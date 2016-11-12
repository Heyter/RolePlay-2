--[[---------------------------------------------------------
   File: cl_hooks.lua
   Desc: Generic client functions overriden by us :)
-----------------------------------------------------------]]

--[[---------------------------------------------------------
   Name: gamemode:InitPostEntity()
   Desc: Called when all Entities are loaded (clientside here)
-----------------------------------------------------------]]
function GM:InitPostEntity()
    -- Send to the Server: "We are ready to get loaded :)"
    net.Start("CSLoaded")
    net.SendToServer()
end
