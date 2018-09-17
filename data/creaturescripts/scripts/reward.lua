function onAdvance(player, skill, oldLevel, newLevel)
	if skill ~= SKILL_LEVEL or newLevel <= oldLevel and newLevel > 70 then
        return true
    end
	local rewardLevel = 25200

	local rewards_levels = {
		[20] = {gold=1000},
	}

	if newLevel > 20 and newLevel < 30 then
		newLevel = 20
	end

	if rewards_levels[newLevel] then
		if player:getVocation():getId() == 0 then
			return true
		end
		local storage = (rewardLevel+newLevel)
		local storage_v = player:getStorageValue(storage)

		if storage_v < 0 then
			player:addMoney(rewards_levels[newLevel].gold)

			present = player:addItem(1990,1)
			present:setActionId(storage)
			present:setAttribute(ITEM_ATTRIBUTE_DESCRIPTION, 'This present contain a item for your vocation and level. Can be used just one time.')

			player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE,'You received a present by advanced to level '.. newLevel ..' and '.. rewards_levels[newLevel].gold ..' gold coins in your bank balance.')
			player:setStorageValue(storage,0)
		end
	end
	return true
end