function onAdvance(player, skill, oldLevel, newLevel)
    if skill ~= SKILL_LEVEL or newLevel <= oldLevel then
        return true
    end
	if newLevel == 25 and player:getStorageValue(brotherarm) > 0 then
		player:addPremiumDays(1)
		player:sendTextMessage(MESSAGE_STATUS_CONSOLE_RED,'You finished your cooperation with your brother. Premium account day has been added to your account.')
		player:setStorageValue(brotherarm,0)
	end
	return true
end