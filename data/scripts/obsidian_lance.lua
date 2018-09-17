function onUse(player, item, fromPosition, target, toPosition)
    if item.uid == 21224 then
        queststatus = player:getStorageValue(21224)
        if queststatus == -1 then
            player:sendTextMessage(MESSAGE_INFO_DESCR,"You have found a obsidian lance.")
            player:addItem(2425, 1)
            player:setStorageValue(21224, 1)
        else
            player:sendTextMessage(MESSAGE_INFO_DESCR,"It's empty.")
        end
    end
    return true
end
