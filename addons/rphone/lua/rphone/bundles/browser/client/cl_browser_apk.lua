
local APP = rPhone.CreateAppPackage( "browser" )

APP.Launchable = true
APP.DisplayName = "Browser"
APP.Icon = "dan/rphone/icons/cloud.png"



function APP:Initialize()
	gui.OpenURL( APP.GetHomepage() )

	self:Kill()
end
