
local ImageHtmlFormat = [[
<html>
	<head>
		<style>
			.container {
				width: 100%%;
				height: 100%%;
				
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

				var fw = window.innerWidth;
				var fh = window.innerHeight;

				var mode = %d; // mode 0 - FILL, mode 1 - FIT

				var scale = Math.max(fw / iw, fh / ih);

				if (mode != 0)
				{
					scale = Math.min(fw / iw, fh / ih);
				}

				var sw = scale * iw;
				var sh = scale * ih;
				
				img.style.width = sw + "px";
				img.style.height = sh + "px";
				img.style.left = ((fw - sw) / 2) + "px";
				img.style.top = ((fh - sh) / 2)  + "px";
			}
		</script>
	</head>

	<body>
		<div class="container">
			<img id="img" src="%s" onLoad="onLoad();"/>
		</div>
	</body>
</html>]]

local cachedFonts = {}

local function bool2num( b )
	return b and 1 or 0
end


function Signs.GetFont( name, size, bold, italic, outline ) -- does not do any real input validation (allowed fonts, sizes, etc.)
	local fontName = ('signfont_%s%d_%d%d%d'):format( 
		name, size,
		bool2num( bold ), bool2num( italic ), bool2num( outline )
	)

	if !cachedFonts[fontName] then
		surface.CreateFont( fontName, {
			font = name,
			size = size,
			weight = bold and Signs.FontBoldWeight or Signs.FontWeightDefault,
			italic = italic,
			outline = outline
		} )

		cachedFonts[fontName] = true
	end

	return fontName
end

function Signs.GetImageHtml( url, mode )
	mode = tonumber( mode ) or 0

	return ImageHtmlFormat:format( mode, url )
end


function removeHTML()
	if signs_htmlpanels then
		for k,v in pairs(signs_htmlpanels) do
			v:Remove()
		end
		
		signs_htmlpanels = {}
		print("HTML removed")
	end
end
concommand.Add( "signs_removehtml", removeHTML)
