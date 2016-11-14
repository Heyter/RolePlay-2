SKIN = {}

function SKIN:PaintTab( panel )
	surface.SetDrawColor( Color(44, 62, 80) );
	surface.DrawRect(0, 0, panel:GetWide(), panel:GetTall())
end
derma.DefineSkin("managertab", "managetab", SKIN)