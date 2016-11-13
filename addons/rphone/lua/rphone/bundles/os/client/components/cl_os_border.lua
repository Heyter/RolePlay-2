
local BorderMat = "dan/rphone/borders/phone_border.png"
local BorderWidth, BorderHeight = 948, 780
local PhoneOffset = 14


surface.CreateFont( "rphone_border_ammotext", {
	font = "Marlett",
	size = 40
} )


local OS = rPhone.AssertPackage( "os" )

local ammofix_enabled = rPhone.GetVariable( "OS_AMMOFIX_ENABLED", true )
local ammofix_color = rPhone.GetVariable( "OS_AMMOFIX_COLOR", Color( 255, 255, 255, 255 ) )
local screen_align = rPhone.GetVariable( "OS_SCREEN_ALIGN", "right" )

local border_mat = Material( BorderMat, "smooth mips" )

local function drawBorder()
	if !rPhone.IsInitialized() or !border_mat or border_mat:IsError() then return end

	local px, py = rPhone.GetPosition()
	local pw, ph = rPhone.GetSize()
	local vib = OS.IsVibrating()

	local col = vib and 230 or 255
	local alpha = 255

	local bcanv = rPhone.GetBaseCanvas()
		
	if bcanv then
		local bpnl = bcanv:GetBasePanel()

		if IsValid( bpnl ) then
			alpha = bpnl:GetAlpha()
		end
	end

	surface.SetDrawColor( col, col, col, alpha )
	surface.SetMaterial( border_mat )
	surface.DrawTexturedRectRotated( px + (pw/2), py + (ph/2), BorderWidth, BorderHeight, 0 )
end

local function drawAmmo()
	if !rPhone.IsInitialized() then return end

	local wep = LocalPlayer():GetActiveWeapon()

	if IsValid( wep ) then
		local clip = wep:Clip1() or 0
		local px, py = rPhone.GetPosition()

		if clip < 0 or !py then return end

		local ammo = LocalPlayer():GetAmmoCount( wep:GetPrimaryAmmoType() ) or 0

		draw.SimpleText(
			clip .. " / " .. ammo,
			"rphone_border_ammotext",
			ScrW() - 5, py - 50,
			ammofix_color,
			TEXT_ALIGN_RIGHT, TEXT_ALIGN_BOTTOM
		)
	end
end

rPhone.RegisterEventCallback( "OS_Initialize", function()
	OS.SetScreenEdgePadding( PhoneOffset )

	hook.Add( "HUDPaint", "cl_os_border_drawborder", drawBorder )

	if ammofix_enabled and screen_align != "left" and screen_align != "center" then
		hook.Add( "HUDShouldDraw", "cl_os_border_disableoldammo", function( name )
			if name == "CHudAmmo" then
				return false
			end
		end )

		hook.Add( "HUDPaint", "cl_os_border_drawammo", drawAmmo )
	end
end )
