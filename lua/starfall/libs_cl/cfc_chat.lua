local registerprivilege = SF.Permissions.registerPrivilege
local haspermission = SF.Permissions.hasAccess

registerprivilege( "chat.text", "Chat", "Allows users to see ALL of your chat prints.", { client = { default = 1 } } )
registerprivilege( "chat.hide", "Chat", "Allows users to hide chat prints.", { client = { default = 1 } } )

-- Requires the 'ChatText' permission.
-- NOTE: Does not apply to player chat messages, see http://wiki.facepunch.com/gmod/GM:ChatText
-- @name ChatText
-- @class hook
-- @client
-- @param number index Index of the player
-- @param string name Name of the player
-- @param string text Content of the message
-- @param string type Chat filter type (See http://wiki.facepunch.com/gmod/GM:ChatText).
SF.hookAdd( "ChatText", "chattext", function( instance, ... )
    if instance.player == SF.Superuser or haspermission( instance, nil, "chat.text" ) then return true, { ... } end
    return false
end,
function( instance, ret )
    if haspermission( instance, nil, "chat.hide" ) and ret then return true end
end )

return function() end
