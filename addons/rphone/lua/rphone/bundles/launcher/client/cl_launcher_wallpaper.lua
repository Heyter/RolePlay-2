
--Thanks Danking & Sitting Bear for the CSS help!

local APP = rPhone.AssertPackage( "launcher" )

local wall_mode, wall_url, wall_color
local wall_html, wall_html_prepared
local wall_html_fmt = [[
<html>
	<head>
		<style>
			.container {
				height: 512px;
				width: 512px;
				overflow: hidden;
			}
			.container > img {
				position: relative;
			}
			body {
				margin: 0;
			}
		</style>

		<script type="text/javascript">
			function onLoad()
			{
				var img = document.getElementById("img");

				var iw = img.width;
				var ih = img.height;

				var scale = Math.max(512 / iw, 512 / ih);

				var sw = scale * iw;
				var sh = scale * ih;

				img.style.width = sw + "px";
				img.style.height = sh + "px";
				img.style.left = ((512 - sw) / 2) + "px";
				img.style.top = ((512 - sh) / 2)  + "px";
			}
		</script>
	</head>

	<body>
		<div class="container">
			<img id="img" src="%s" onLoad="onLoad();"/>
		</div>
	</body>
</html>]]



function APP.UpdateWallpaper()
	local mode = APP.GetWallpaperMode()
	local col = APP.GetWallpaperColor()
	local url = APP.GetWallpaperURL()

	if mode == "url" and (wall_mode != "url" or wall_url != url) then
		if !IsValid( wall_html ) then
			wall_html = vgui.Create( "DHTML" )
				wall_html:SetSize( 512, 512 )
				wall_html:SetPaintedManually( true )
				wall_html:Hide()
		end

		wall_html:SetHTML( wall_html_fmt:format( url ) )

		wall_html_prepared = false
		
		timer.Simple( 1.5, function() wall_html_prepared = true end ) --some DHTML callbacks are broken
	end

	wall_mode = mode
	wall_color = col
	wall_url = url
end

function APP.DrawWallpaper( x, y, w, h )
	if wall_mode == "color" and wall_color then
		surface.SetDrawColor( wall_color.r, wall_color.g, wall_color.b, 255 )
		surface.DrawRect( x, y, w, h )
	elseif wall_mode == "url" then
		surface.SetDrawColor( 0, 0, 0, 255 )
		surface.DrawRect( x, y, w, h )

		if wall_html_prepared and IsValid( wall_html ) then
			wall_html:UpdateHTMLTexture()

			local mat = wall_html:GetHTMLMaterial()

			if mat then
				local dmax = math.max( w, h )

				local uo = w / dmax
				local vo = h / dmax

				surface.SetDrawColor( 255, 255, 255, 255 )
				surface.SetMaterial( mat )
				surface.DrawTexturedRectUV( 
					x, y, w, h, 
					(1 - uo) / 2, (1 - vo) / 2, 
					(1 + uo) / 2, (1 + vo) / 2
				)
			end
		end
	end
end
