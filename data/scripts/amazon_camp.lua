function onUse(player, item, fromPosition, target, toPosition)
   if item.uid == 21219 then
        queststatus = player:getStorageValue(21219)
        if queststatus == -1 then
            player:sendTextMessage(MESSAGE_INFO_DESCR,"You have found a bag.")
            bag = player:addItem(1987, 1)
            bag:addItem(2125, 1)
            bag:addItem(2144, 1)
            player:setStorageValue(21219, 1)
        else
            player:sendTextMessage(MESSAGE_INFO_DESCR,"It's empty.")
        end
    end
    return true
end