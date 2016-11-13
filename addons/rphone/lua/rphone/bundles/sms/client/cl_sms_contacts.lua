
local APP = rPhone.AssertPackage( "sms" )

local apk_contacts

rPhone.RegisterEventCallback( "CONTACTS_Initialize", function( _apk_contacts )
	apk_contacts = _apk_contacts 
end )

rPhone.RegisterEventCallback( "CONTACTS_AddContactActions", function( apk_contacts )
	apk_contacts.AddContactAction( APP.DisplayName, function( num )
		local params = { Number = num }
		local pk_os = rPhone.AssertPackage( "os" )

		pk_os.LaunchApp( APP.PackageName, params )
	end )
end )



function APP.GetContactName( num )
	if apk_contacts then
		return apk_contacts.GetContactName( num )
	end
end

function APP.GetDisplayAlias( num )
	return APP.GetContactName( num ) or rPhone.ToNiceNumber( num )
end
