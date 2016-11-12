concommand.Add("getfunc", function()
	local trace = LocalPlayer():GetEyeTrace()
	if !(trace.Entity:IsValid()) then return end
	local vector = trace.Entity:GetPos().x .. ", " .. trace.Entity:GetPos().y .. ", " .. trace.Entity:GetPos().z
	
	print("SpawnEnt( '" .. tostring(trace.Entity:GetClass()) .. "', Vector(" .. tostring(vector) .. "), Angle(" .. tostring(trace.Entity:GetAngles()) .. "), '" .. trace.Entity:GetModel() .. "' )" )
end)

/*
function GM:OnContextMenuOpen()

-- Let the gamemode decide whether we should open or not..
if ( !hook.Call( "SpawnMenuOpen", GAMEMODE ) ) then return end

if ( IsValid( g_ContextMenu ) && !g_ContextMenu:IsVisible() ) then 
g_ContextMenu:Open() 
menubar.ParentTo( g_ContextMenu )
end

end
*/
