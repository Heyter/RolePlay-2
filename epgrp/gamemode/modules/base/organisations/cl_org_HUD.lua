/*---------------------------------------------------------
   Name: DrawOrgElements()
   Desc: Alle HUDfunktionen sollten hier untereinander aufgelistet werden.
---------------------------------------------------------*/

function DrawOrgElements()
	DrawHeadOverlay()
end
hook.Add( "HUDPaint", "DrawORGElements", DrawOrgElements )

function DrawHeadOverlay()
	for k, v in pairs( ents.FindInSphere( LocalPlayer():GetPos(), ORGANISATION_DRAWDISTANCE ) ) do
		if !(RPIsInSight( v )) then continue end
		if !(IsValid( v )) then continue end
		if !(v:IsPlayer()) then continue end
		if !(v:Alive()) then continue end
		local org = v:GetOrganisation()
		if org == nil then continue end
		
		local posPlayerPos = (v:GetPos() + Vector(0, 0, 80)):ToScreen()
		local strGuildDisplayText = org.name
		surface.SetFont("RPNormal_25")
		local wide1, high1 = surface.GetTextSize(strGuildDisplayText)
	   
		draw.SimpleTextOutlined(strGuildDisplayText, "RPNormal_25", posPlayerPos.x, posPlayerPos.y, Color(51,153,204,255), 1, 1, 1.5, Color( 0,102,255,255 ))
	   
		--surface.SetDrawColor(255, 255, 255, 255)
		--surface.SetMaterial(Material(LocalPlayer():GetNWInt("GuildIcon")))
		--surface.DrawTexturedRect(posPlayerPos.x + (wide1 / 2) + 5, posPlayerPos.y - 26, 15, 15)
	end
end