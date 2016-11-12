local meta = FindMetaTable( "Player" )
RP.Organisations = RP.Organisations or {}

/*---------------------------------
-- Enable -/ Disable this Plugin
---------------------------------*/

ORGANISATION_ENABLED = true


/*---------------------------------
		Plugin settings
---------------------------------*/

ORGANISATION_MAXLEADERS = 2
ORGANISATION_MAXLEVEL = 15

ORGANISATION_MAXUSERS = 50

ORGANISATION_DRAWDISTANCE = 500




/*---------------------------------
		Funktionen
---------------------------------*/
function IsValidSteamID( id )
	if string.Left( id, 6 ) == "STEAM_" then return true else return false end
end


/*---------------------------------------------------------
   Name: player:FindOrganisation()
   Desc: Findet die Organisation des Spielers.
   Returns: id ( der Organisation ) oder nil bei kein Ergebniss.
---------------------------------------------------------*/

function meta:FindOrganisationID()
	for id, organisation in pairs( RP.Organisations or {} ) do	// Durchstöbert alle Organisationen
		// Ist der Spieler in besitz einer Organisation?
		for leaderindex, leader in pairs( organisation["leader"] ) do
			if tostring(self:SteamID()) == tostring(leader.sid) then return id else continue end
		end
		
		// Der Spieler ist also keiner besitzer, dann durchsuchen wir mal die Mitglieder
		for gruppenindex, benutzergruppe in pairs( organisation["member"] ) do	// Geht alle Benutzergruppen durch, mit den jeweiligen benutzern untergeordnet
			for memberindex, playerData in pairs( benutzergruppe or {} ) do	// Jetzt gehen wir in die Benutzergruppe und vergleichen alle member mit dem angegebenen Spieler
				if tostring(playerData.sid) == tostring(self:SteamID()) then return id else continue end	// Spieler wurde gefunden! Jetzt geben wir die OrganisationsID preis.
			end
		end
	end
	return nil	// Nichts gefunden, Spieler ist in keiner Organisation
end

function meta:GetOrganisation()
	local orgid = self:FindOrganisationID() or nil
	if orgid == nil then return orgid end
	
	for k, v in pairs( RP.Organisations ) do
		if tonumber( orgid ) == tonumber( k ) then return v end
	end
	return nil
end