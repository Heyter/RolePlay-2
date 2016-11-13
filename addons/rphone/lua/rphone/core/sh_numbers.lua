
local numlen_max = math.max( rPhone.GetVariable( "RPHONE_NUMBER_LENGTH_MAX", 7 ), 1 )
local numlen_min = math.Clamp( rPhone.GetVariable( "RPHONE_NUMBER_LENGTH_MIN", 3 ), 1, numlen_max )
local numlen_default = math.Clamp( rPhone.GetVariable( "RPHONE_NUMBER_LENGTH_DEFAULT", 7 ), numlen_min, numlen_max )

function rPhone.GetMinNumberLength()
	return numlen_min
end

function rPhone.GetMaxNumberLength()
	return numlen_max
end

function rPhone.GetDefaultNumberLength()
	return numlen_default
end

function rPhone.IsValidNumber( num )
	if num:find( [=[[^%d]]=] ) then return false end

	local len = #num

	return num[1] != '0' and len >= numlen_min and len <= numlen_max
end

function rPhone.ToRawNumber( num )
	return num:gsub( [[%-]], '' )
end

function rPhone.ToNiceNumber( num )
	num = rPhone.ToRawNumber( num )

	local ret = num:sub( 1, 3 )
	local i = 4
	
	while (i - 1) < #num do
		ret = ret .. '-' .. num:sub( i, i + 3 )

		i = i + 4
	end

	return ret
end
