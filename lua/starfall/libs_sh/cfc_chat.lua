local registerprivilege = SF.Permissions.registerPrivilege
local haspermission = SF.Permissions.hasAccess

registerprivilege( "chattext", "ChatText", "Allows the user to see your chat prints.", { client = { default = 1 } } )

-- Requires the 'ChatText' permission.
-- NOTE: Does not apply to player chat messages, see http://wiki.facepunch.com/gmod/GM:ChatText
-- @name ChatText
-- @class hook
-- @client
-- @param number index Index of the player
-- @param string name Name of the player
-- @param string text Content of the message
-- @param string type Chat filter type (See http://wiki.facepunch.com/gmod/GM:ChatText).
SF.hookAdd( "ChatText", "chattext", nil, function( instance )
    if instance.player == SF.Superuser or haspermission( instance, nil, "chattext" ) then return true end
end )

return function() end
