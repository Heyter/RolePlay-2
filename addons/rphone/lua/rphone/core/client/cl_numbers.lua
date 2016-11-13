
local number

net.Receive( "rphone_numbers_send", function( len )
	number = net.ReadString()
end )



function rPhone.GetNumber()
	return number
end
