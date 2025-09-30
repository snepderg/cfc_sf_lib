local registerprivilege = SF.Permissions.registerPrivilege
local haspermission = SF.Permissions.hasAccess

registerprivilege( "chat.text", "Chat", "Allows users to see your chat prints.", { client = { default = 1 } } )
registerprivilege( "chat.hide", "Chat", "Allows users to hide chat prints.", { client = { default = 1 } } )
registerprivilege( "chat.onchataddtext", "Chat", "Allows users to see your chat prints (chat.addText).", { client = { default = 1 } } )

--- Called when GM:ChatText is called
-- Requires the 'chat.text' permission.
-- Optionally requires the 'chat.hide' permission for hiding messages.
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
    if ret[1] and haspermission( instance, nil, "chat.hide" ) and ret[2] == true then return true end
end )

chat._AddText = chat._AddText or chat.AddText
local oldChatAddText = chat._AddText

chat.AddText = function( ... )
    print( "[Detour] chat.AddText called", ... )
    hook.Run( "OnChatAddText", ... )

    return oldChatAddText( ... )
end

--- Called when the client calls chat.AddText
-- Requires the 'chat.onchataddtext' permission.
-- NOTE: Attempting to print from the hook will result in a stack overflow!
-- @name OnChatAddText
-- @class hook
-- @client
-- @param ... vararg A sequence of arguments passed to chat.AddText.
--   These can be:
--   • Color objects
--   • Player entities
--   • Strings
SF.hookAdd( "OnChatAddText", nil, function( instance, ... )
    local wrapObject = instance.WrapObject
    local args = { ... }

    for i, arg in ipairs( args ) do
        args[i] = wrapObject( arg )
    end

    if instance.player == SF.Superuser or haspermission( instance, nil, "chat.onchataddtext" ) then return true, args end
    return false
end )

return function() end
