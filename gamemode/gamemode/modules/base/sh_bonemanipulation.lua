local meta = FindMetaTable( "Player" )


if SERVER then
	function meta:ManipulateBones( bone_data )
		if bone_data == nil then return end
		self:SetRPVar( "BoneManipulation", bone_data )
		
		for k, v in pairs( player.GetAll() ) do v:SendLua( "EditBones( " .. tostring( self:EntIndex() ) .. " )" ) end
	end
	
	function meta:NormalizeBones()
		for k, v in pairs( player.GetAll() ) do v:SendLua( "NormalizeBones(" .. tostring( self:EntIndex() ) .. " )" ) end
	end
end

if CLIENT then
	local ent = FindMetaTable( "Entity" )
	
	function EditBones( id )
		local self = Entity( id )
		
		local bone_data = self:GetRPVar( "BoneManipulation" )
		if bone_data == nil then return end
		
		for i = 1, table.Count( bone_data ) do
			self:ManipulateBoneAngles( bone_data[i].bone_index, bone_data[i].ang )
			self:ManipulateBoneJiggle( bone_data[i].bone_index, bone_data[i].jiggle )
			self:ManipulateBonePosition( bone_data[i].bone_index, bone_data[i].pos )
			self:ManipulateBoneScale( bone_data[i].bone_index, bone_data[i].scale )
		end
	end
	
	function NormalizeBones( id )
		local self = Entity( id )
		
		for i = 0, self:GetBoneCount() do
			self:ManipulateBoneAngles( i, Angle( 0, 0, 0 ) )
			self:ManipulateBoneJiggle( i, 0 )
			self:ManipulateBonePosition( i, Vector( 0, 0, 0 ) )
			self:ManipulateBoneScale( i, Vector( 1, 1, 1 ) )
		end
	end
end