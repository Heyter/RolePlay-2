
Signs = {}

function Signs.AccessorFunc( metatbl, property, funcname, default, copy )
	metatbl["Get" .. funcname] = function( self )
		local value = self[property]

		if value == nil then 
			value = default -- don't return in case default is a table and copy is enabled
		end

		if copy and type( value ) == "table" then 
			return table.Copy( value )
		end

		return value
	end

	metatbl["Set" .. funcname] = function( self, value )
		self[property] = (copy and type( value ) == "table") and table.Copy( value ) or value
	end
end