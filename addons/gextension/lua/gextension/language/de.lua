//////////////////////////////////////
//     	  GExtension (c) 2016       //
//                                  //
//  Created by Jakob 'ibot3' Müller //
//                                  //
//  You are not permitted to share, //
//   	 trade, give away, sell     //
//      or otherwise distribute     //
//////////////////////////////////////

function GExtension:InitLanguageVars()
	self.Language['player_group_updated'] = "Deine Gruppe wurde aktualisiert. Du bist nun <green>%1%</green>."
	self.Language['player_warned'] = "<red>%1%</red> wurde von <red>%2%</red> verwarnt. Grund: <green>%3%</green>"
	self.Language['you_warned'] = "<red>Du wurdest von %1% verwarnt!</red> Grund: <green>%2%</green>."
	self.Language['player_welcome'] = "Willkommen auf dem Server, <green>%1%</green>."
	self.Language['player_warnings_active'] = "Du hast <red>%1%</red> aktive Verwarnungen. Gib <green>!warnings</green> für Details ein."
	self.Language['package_expires_days'] = "Dein Paket <green>%1%</green> läuft in <red>%2%</red> Tagen ab."
	self.Language['player_unbanned'] = "<red>%1%</red> wurde von <green>%2%</green> entbannt."
	self.Language['player_banned_perma'] = "<red>%1%</red> wurde von <red>%2%</red> <green>permanent</green>  vom Server gebannt. Grund: <green>%3%</green>"
	self.Language['player_banned'] = "<red>%1%</red> wurde von <red>%3%</red> <green>%2% Minuten</green> vom Server gebannt. Grund: <green>%4%</green>"
	self.Language['ticket_responded_admin'] = "Ein Admin auf dein Ticket (<green>'%1%'</green>) geantwortet. (!tickets)"
	self.Language['player_kickban_immune'] = "<red>Du bist gebannt und solltest gekickt werden, doch deine Gruppe ist immun gegen Bannkick.</red>"
	self.Language['rslots_kick_connect_noslot'] = "Der Server ist voll und du hast keinen Zugriff auf einen reservierten Slot"
	self.Language['rslots_kick_connect'] = "Der Server ist voll"
	self.Language['rslots_kick'] = "Ein Spieler mit einem reservierten Slot ist auf den Server gekommen und du wurdest gekickt um Platz zu machen"
	self.Language['donations_donated'] = "<green>%1%</green> hat <red>%2%</red> für <green>%3%</green> gespendet."
	self.Language['reason'] = "Grund"
	self.Language['date'] = "Datum"
	self.Language['information'] = "Information"
	self.Language['status'] = "Status"
	self.Language['admin'] = "Admin"
	self.Language['warning'] = "Verwarnung"
	self.Language['warn'] = "Verwarnen"
	self.Language['your_warnings'] = "Deine Verwarnungen"
	self.Language['set_inactive'] = "Inaktiv setzen"
	self.Language['delete'] = "Löschen"
	self.Language['ban_on_threshold'] = "Bannen bei Schwelle"
	self.Language['ban_threshold'] = "Bann Schwelle"
	self.Language['kick_on_threshold'] = "Kicken bei Schwelle"
	self.Language['kick_threshold'] = "Kick Schwelle"
	self.Language['time_decay'] = "Ablauf Zeit"
	self.Language['length_ban'] = "Bann Länge"
	self.Language['kick_enable'] = "Aktiviere Kick"
	self.Language['ban_enable'] = "Aktiviere Bann"
	self.Language['threshold_limit_reached'] = "Maximale Anzahl an Verwarnungen erreicht."
	self.Language['minutes'] = "Minuten"
	self.Language['save'] = "Speichern"
	self.Language['ban_date'] = "Bann Datum"
	self.Language['unban_date'] = "Entbannungs Datum"
	self.Language['unban_url'] = "Entbannungsantrag"
	self.Language['welcome'] = "Willkommen"
	self.Language['never'] = "Niemals"
	self.Language['permission_denied'] = "Du hast <red>nicht</red> die Berechtigung um diese Funktion zu verwenden."
end