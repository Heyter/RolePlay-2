// Copyright © 2012-2015 VCMod (freemmaann). All Rights Reserved. if you have any complaints or ideas contact me: email - freemmaann@gmail.com or skype - comman6.

function VC_CanEditAdminSettings(ply) return VC_Only_Allow_Admin_Settings_For_SuperAdmins and ply:IsSuperAdmin() or ply:IsAdmin() end