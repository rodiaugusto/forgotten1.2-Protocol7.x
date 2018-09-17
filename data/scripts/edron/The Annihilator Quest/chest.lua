function onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if player:getStorageValue(6666) < 1 then
		if item.uid == 2494 then
			player:addItem(2494,1)
		elseif item.uid == 2400 then
			player:addItem(2400,1)
		elseif item.uid == 2431 then
			player:addItem(2431,1)
		elseif item.uid == 2326 then
			bag = player:addItem(1990,1)
			bag:addItem(2326,1)
		end
		player:setStorageValue(6666,1)
	else
        player:sendTextMessage(MESSAGE_INFO_DESCR,"It's empty.")
	end
	return true
end