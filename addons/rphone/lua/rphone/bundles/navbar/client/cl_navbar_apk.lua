
local BackIcon = "dan/rphone/icons/left.png"
local HomeIcon = "dan/rphone/icons/grid.png"
local ActionsIcon = "dan/rphone/icons/up.png"


local APP = rPhone.CreateAppPackage( "navbar" )



function APP:Initialize()
	local canv = self:GetCanvas()
	local cw, ch = canv:GetSize()
	local ch2 = ch / 2

	local btnback = canv:AddPanel( "RPDImageButton" )
		btnback:SetImage( BackIcon )
		btnback:SetSize( ch, ch )
		btnback:SetPos( 
			(cw / 4) - ch2,
			(ch / 2) - ch2
		)
		btnback.DoClick = function()
			self:OnBackPressed()
		end

	local btnhome = canv:AddPanel( "RPDImageButton" )
		btnhome:SetImage( HomeIcon )
		btnhome:SetSize( ch, ch )
		btnhome:SetPos( 
			(cw / 2) - ch2,
			(ch / 2) - ch2
		)
		btnhome.DoClick = function()
			self:OnHomePressed()
		end

	local btnact = canv:AddPanel( "RPDImageButton" )
		btnact:SetImage( ActionsIcon )
		btnact:SetSize( ch, ch )
		btnact:SetPos( 
			(cw * (3/4)) - ch2,
			(ch / 2) - ch2
		)
		btnact.DoClick = function()
			self:OnActionsPressed()
		end
end

function APP:OnBackPressed()
end

function APP:OnHomePressed()
end

function APP:OnActionsPressed()
end
