--[[---------------------------------------------------------
   File: cl_player.lua
   Desc: Provides clientside player functions
-----------------------------------------------------------]]

--[[---------------------------------------------------------
   Name: SetCash(amount)
   Desc: Only gets called by the Server, sets the local cash for the player
-----------------------------------------------------------]]
function SetCash(lenght)
    LocalPlayer().cash = net.ReadInt(32)
end
net.Receive("SetCash", SetCash)

--[[---------------------------------------------------------
   Name: SetBank(lenght)
   Desc: Only gets called by the Server, sets the local bank for the player
-----------------------------------------------------------]]
function SetBank(lenght)
    LocalPlayer().bank = net.ReadInt(32)
end
net.Receive("SetBank", SetBank)

GM.AddHint = function() end   // Lets fix that crap error

function GM:DrawDeathNotice(x, y)
	return
end