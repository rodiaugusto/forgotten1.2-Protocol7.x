function onUse(player, item, fromPosition, target, toPosition)
   if item.actionid == 21220 then
        if item.uid == 21221 then
            queststatus = player:getStorageValue(21221)
            if queststatus == -1 then
                player:sendTextMessage(MESSAGE_INFO_DESCR,"You have found a bag.")
                bag = player:addItem(1987, 1)
                bag:addItem(2143, 1)
                bag:addItem(2320, 1)
                player:setStorageValue(21221, 1)
            else
                player:sendTextMessage(MESSAGE_INFO_DESCR,"It's empty.")
            end
        elseif item.uid == 21222 then
            queststatus = player:getStorageValue(21222)
            if queststatus == -1 then
                player:sendTextMessage(MESSAGE_INFO_DESCR,"You have found a bag.")
                bag = player:addItem(1987, 1)
                bag:addItem(2129, 1)
                bag:addItem(2213, 1)
                player:setStorageValue(21222, 1)
            else
                player:sendTextMessage(MESSAGE_INFO_DESCR,"It's empty.")
            end
        end
    end
    return true
end
