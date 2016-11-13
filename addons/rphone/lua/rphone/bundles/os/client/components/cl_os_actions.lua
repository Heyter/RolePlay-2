
local OS = rPhone.AssertPackage( "os" )


OS.AddAction( "Lock", function()
	OS.Lock()
end )

OS.AddAction( "Toggle Silent", function()
	OS.SetSilent( !OS.IsSilent() )
end )

OS.AddAction( "Copy Number", function()
	local num = rPhone.GetNumber()

	if num then
		SetClipboardText( rPhone.ToNiceNumber( num ) )
	end
end )

