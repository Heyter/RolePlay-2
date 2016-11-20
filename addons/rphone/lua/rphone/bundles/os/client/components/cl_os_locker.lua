
local LockIcon = "dan/rphone/icons/lock_closed.png"
local LockOpenIcon = "dan/rphone/icons/lock_opened.png"


local OS = rPhone.AssertPackage( "os" )

local lock_in_jail = rPhone.GetVariable( "OS_LOCK_IN_JAIL", true )
local screen_align = rPhone.GetVariable( "OS_SCREEN_ALIGN", "right" )
local screen_additional_padding = rPhone.GetVariable( "OS_SCREEN_ADDITIONAL_PADDING", 0 )

local locked
local isdown, lastdown = false, nil
local transitioning, transition_start
local screen_padding = 0

local awake, last_wake = true, 0

local lock_mat = Material( LockIcon, "smooth" )
local lock_open_mat = Material( LockOpenIcon, "smooth" )
local lock_icon_padding = 2
local lock_notification

local LNBT = {}
function LNBT:Draw( w, h )
	local lalpha = 0
	local mode = OS.GetLockKeyMode()

	if locked then
		lalpha = 255

		if !transitioning and isdown and mode == "hold" then
			local holdlen = OS.GetLockKeyHoldTime()

			lalpha = 255 * (1 - ((SysTime() - lastdown) / holdlen))
		end
	elseif !transitioning and isdown and mode == "hold" then
		local holdlen = OS.GetLockKeyHoldTime()

		lalpha = 255 * ((SysTime() - lastdown) / holdlen)
	end

	local mat = (lalpha == 255) and lock_mat or lock_open_mat

	surface.SetDrawColor( 255, 255, 255, lalpha )
	surface.SetMaterial( mat )
	surface.DrawTexturedRect( 
		lock_icon_padding, lock_icon_padding, 
		w - (lock_icon_padding * 2), 
		h - (lock_icon_padding * 2)
	)
end

local function wakeForDuration( duration )
	last_wake = SysTime() + (duration or 0)
end

local function resetWake()
	wakeForDuration( 0 )
end

local function lockerThink()
	if !rPhone.IsInitialized() then return end

	local canunlock = OS.CanUnlock()
	local resetwakestate = false

	if !canunlock and !OS.IsLocked() then 
		OS.Lock()
	end

	if awake and OS.IsLocked() and (SysTime() - last_wake) >= OS.GetSleepTime() then
		local sleep, wdur = rPhone.TriggerEventForResult( "OS_ShouldSleep", OS )

		if sleep != false then
			awake = false
			resetwakestate = true
		else
			wakeForDuration( wdur )
		end
	elseif !awake and (!OS.IsLocked() or (SysTime() - last_wake) < OS.GetSleepTime()) then
		awake = true
		resetwakestate = true
	end

	if resetwakestate then
		local bcanv = rPhone.GetBaseCanvas()
		
		if bcanv then
			local bpnl = bcanv:GetBasePanel()
	
			if IsValid( bpnl ) then
				bpnl:AlphaTo( awake and 255 or OS.GetSleepAlpha(), 0.4, 0 )
			end
		end
	end

	if transitioning then
		local pw, ph = rPhone.GetSize()
		local animtime = OS.GetLockAnimationTime()
		local px = ScrW() - pw - screen_padding - screen_additional_padding

		if screen_align == "left" then
			px = screen_padding + screen_additional_padding
		elseif screen_align == "center" then
			px = (ScrW() - pw) / 2
		end

		if (SysTime() - transition_start) <= animtime then
			local sy = (
				(math.sin( (math.pi / 2) * ((SysTime() - transition_start) / animtime) )^5) *
				(locked and 1 or -1) *
				(ph - OS.GetTrayHeight())
			) - (locked and ph or OS.GetTrayHeight())

			rPhone.SetPosition( 
				px, 
				ScrH() + sy
			)
		else
			local yoff = locked and OS.GetTrayHeight() or ph

			rPhone.SetPosition( px, ScrH() - yoff )

			transitioning = false

			rPhone.TriggerEvent( locked and "OS_LockAnimationComplete" or "OS_UnlockAnimationComplete", OS )
		end
	elseif canunlock then
		local key = OS.GetLockKey()
		local mode = OS.GetLockKeyMode()

		if rPhone.CanKeyListen() and input.IsButtonDown( key ) then
			if lastdown then
				local dt = SysTime() - lastdown

				if mode == "hold" and isdown then
					local holdlen = OS.GetLockKeyHoldTime()

					if dt >= holdlen then
						OS.ToggleLocked()
						isdown = false
					end
				elseif mode == "doubletap" and !isdown then
					if dt <= 0.3 then
						OS.ToggleLocked()
						isdown = false
					end
				end
			end

			if !isdown and !transitioning then
				isdown = true
				lastdown = SysTime()
			end

			if !IsValid( lock_notification ) then
				lock_notification = OS.AddTrayNotification( LNBT, 3, "right" )
			end

			resetWake()
		else
			isdown = false

			if !locked and IsValid( lock_notification ) then
				lock_notification:Remove()
			end
		end
	end	
end

hook.Add( "Think", "cl_os_locker_think", lockerThink )

rPhone.RegisterEventCallback( "OS_Initialize", function()
	OS.Lock( true )

	wakeForDuration( 10 )
end )

rPhone.RegisterEventCallback( "OS_TrayNotificationAdded", resetWake )
rPhone.RegisterEventCallback( "OS_LockAnimationComplete", resetWake )

concommand.Add( "rphone_unlock", function()
	if OS.IsLocked() then
		OS.Unlock()
	end
end )



function OS.SetScreenEdgePadding( pad ) 
	screen_padding = pad
end

function OS.CanUnlock()
	local lp = LocalPlayer()

	if lock_in_jail then
		local isArrested = lp:GetNWBool( "arrested" ) or false

		if isArrested then
			return false
		end
	end

	return lp:Alive() and !lp:InVehicle()
end

function OS.Lock( noanim )
	if locked then return end

	if locked != nil then					  --causes input problems on initial lock otherwise
		local bcanv = rPhone.GetBaseCanvas()
		
		if bcanv then
			local bpnl = bcanv:GetBasePanel()
	
			if IsValid( bpnl ) then
				bpnl:SetKeyboardInputEnabled( false )
				bpnl:SetMouseInputEnabled( false )
			end
		end

		gui.EnableScreenClicker( false )
	end

	locked = true
	transitioning = true
	transition_start = noanim and 0 or SysTime()

	if !IsValid( lock_notification ) then
		lock_notification = OS.AddTrayNotification( LNBT, 3, "right" )
	end

	rPhone.TriggerEvent( "OS_Lock", OS )

	local fgapp = OS.GetForegroundApp()

	if fgapp then
		fgapp:TriggerEvent( "OnLostFocus" )
	end
end

function OS.Unlock( noanim )
	if !locked or !OS.CanUnlock() then return end

	locked = false
	transitioning = true
	transition_start = noanim and 0 or SysTime()

	local bcanv = rPhone.GetBaseCanvas()
		
	if bcanv then
		local bpnl = bcanv:GetBasePanel()

		if IsValid( bpnl ) then
			bpnl:MakePopup()
		end
	end

	if IsValid( lock_notification ) then
		lock_notification:Remove()
	end

	OS.Wake()

	rPhone.TriggerEvent( "OS_Unlock", OS )

	local fgapp = OS.GetForegroundApp()

	if fgapp then
		fgapp:TriggerEvent( "OnGainedFocus" )
	end
end

function OS.ToggleLocked( noanim )
	if locked then
		OS.Unlock( noanim )
	else
		OS.Lock( noanim )
	end
end

function OS.IsLocked()
	return locked
end

function OS.Wake( duration )
	wakeForDuration( duration )
end

function OS.IsAwake()
	return awake
end
