RP.BaseEnts = RP.BaseEnts or {}

local ENT = FindMetaTable( "Entity" )

function AddBaseEntity( data )
	for k, v in pairs( data ) do
		RP.BaseEnts[data.UName] = data
	end
end

function ENT:BaseEntity_Load( uname )
	for k, v in pairs( RP.BaseEnts[uname] ) do
		self.k = v
	end
end
