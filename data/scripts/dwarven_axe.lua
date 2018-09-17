function onUse(player, item, fromPosition, target, toPosition)
    if item.uid == 21225 then
        queststatus = player:getStorageValue(21225)
        if queststatus == -1 then
            player:sendTextMessage(MESSAGE_INFO_DESCR,"You have found a dwarven axe.")
            player:addItem(2435, 1)
            player:setStorageValue(21225, 1)
        else
            player:sendTextMessage(MESSAGE_INFO_DESCR,"It's empty.")
        end
    end
    return true
end
