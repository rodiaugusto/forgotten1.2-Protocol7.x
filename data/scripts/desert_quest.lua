function onUse(player, item, fromPosition, target, toPosition, isHotkey)

	local sqm_place = Position(32673,32089,8)
	playerTile = Tile(sqm_place):getTopCreature()
	if not playerTile or not playerTile:isPlayer() then
		player:sendTextMessage(MESSAGE_STATUS_SMALL, "You need enter the right place.")
	else
		if playerTile:getLevel() >= 20 then
			local quest_pos = Position(32672,32070,8)
			player:teleportTo(quest_pos)
			player:setDirection(DIRECTION_SOUTH)
			player:getPosition():sendMagicEffect(CONST_ME_MAGIC_BLUE)
		else 
			player:sendTextMessage(MESSAGE_STATUS_SMALL, "You need to be level 20 or higher.")
		end
	end
	return true
end