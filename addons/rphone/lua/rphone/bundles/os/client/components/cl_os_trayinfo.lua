
local BatteryIcon = "dan/rphone/icons/battery.png"
local BarsIcon = "dan/rphone/icons/bars_full.png"


surface.CreateFont( "rphone_os_tray_clockfont", {
	font = "Trebuchet18",
	size = 18
} )


local note_padding = 2
local batt_mat = Material( BatteryIcon, "smooth" )
local bars_mat = Material( BarsIcon )

rPhone.RegisterEventCallback( "OS_Initialize", function( pk_os )
	pk_os.AddTrayNotification( {
		Draw = function( self, w, h )
			local dinfo = os.date( "*t", os.time() )

			local min = dinfo.min
			min = tostring( (min < 10) and ('0' .. min) or min )

			draw.SimpleText(
				min,
				"rphone_os_tray_clockfont",
				0, h / 2,
				Color( 255, 255, 255, 255 ),
				TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER
			)
		end
	}, 8, "right" )

	pk_os.AddTrayNotification( {
		Draw = function( self, w, h )
			local dinfo = os.date( "*t", os.time() )

			local hr = dinfo.hour
			hr = tostring( hr > 12 and hr - 12 or (hr == 0 and 12 or hr) )

			draw.SimpleText(
				hr .. ':',
				"rphone_os_tray_clockfont",
				w, h / 2,
				Color( 255, 255, 255, 255 ),
				TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER
			)
		end
	}, 7, "right" )

	pk_os.AddTrayNotification( {
		Draw = function( self, w, h )
			surface.SetDrawColor( 255, 255, 255, 255 )
			surface.SetMaterial( batt_mat )
			surface.DrawTexturedRect( 
				note_padding, note_padding, 
				w - (note_padding * 2), 
				h - (note_padding * 2)
			)
		end
	}, 6, "right" )

	pk_os.AddTrayNotification( {
		Draw = function( self, w, h )
			surface.SetDrawColor( 255, 255, 255, 255 )
			surface.SetMaterial( bars_mat )
			surface.DrawTexturedRect( 
				note_padding, note_padding, 
				w - (note_padding * 2), 
				h - (note_padding * 2)
			)
		end
	}, 5, "right" )

end )
