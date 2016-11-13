
local libs = {}



function rPhone.GetLibrary( name )
	libs[name] = libs[name] or {}

	return libs[name]
end
