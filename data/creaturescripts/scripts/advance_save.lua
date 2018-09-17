function onAdvance(player, skill, oldLevel, newLevel)
    if newLevel <= oldLevel then
    	return true
    end
    if skill == SKILL_LEVEL then 	
		player:addHealth(player:getMaxHealth())
		player:addMana(player:getMaxMana())
    end
	player:save()
	return true
end