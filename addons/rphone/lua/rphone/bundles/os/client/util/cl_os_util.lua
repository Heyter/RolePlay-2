
local OS = rPhone.AssertPackage( "os" )
OS.Util = {}

local UTIL = OS.Util

function UTIL.FormatDateTime( time )
	local dinfo = os.date( "*t", time )
	local dt = os.time() - time
	local daylen = 60 * 60 * 24
	local date = ""

	if dt <= daylen then
		date = "Today"
	elseif dt <= (daylen * 2) then
		date = "Yesterday"
	else
		date = ([[%i/%i/%i]]):format( dinfo.month, dinfo.day, dinfo.year - 2000	)
	end

	local hr, min = dinfo.hour, dinfo.min
	local ispm = hr >= 12
	hr = tostring( hr > 12 and hr - 12 or (hr == 0 and 12 or hr) )
	min = tostring( (min < 10) and ('0' .. min) or min )

	return ([[%s, %s:%s %s]]):format( date, hr, min, ispm and "PM" or "AM" )
end
