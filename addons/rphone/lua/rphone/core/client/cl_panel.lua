
function rPhone.CreatePanel( ptype, parent, noevent )
	ptype = ptype or "DPanel"
	
	local pnl = vgui.Create( ptype )

	if !IsValid( pnl ) then return end	
	
	if parent then
		pnl:SetParent( parent )
	end

	if !noevent then
		rPhone.TriggerEvent( "PanelCreated", pnl, ptype )
	end

	return pnl
end
