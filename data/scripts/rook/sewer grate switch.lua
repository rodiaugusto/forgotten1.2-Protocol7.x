local config = {
	bridgePositions = {
		{position = Position(32099, 32205, 8, 0), groundId = 4645, itemId = 4645},
		{position = Position(32100, 32205, 8, 1), groundId = 1284},
		{position = Position(32101, 32205, 8, 0), groundId = 4647, itemId = 4647}
	},
	leverPositions = {
		Position(32098, 32204, 8),
		Position(32104, 32204, 8)
	},
	relocatePosition = Position(32102, 32205, 8),
	relocateMonsterPosition = Position(32103, 32205, 8),
	bridgeId = 1284
}

function onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local leverLeft, lever = item.itemid == 1945
	for i = 1, #config.leverPositions do
		lever = Tile(config.leverPositions[i]):getItemById(leverLeft and 1945 or 1946)
		if lever then
			lever:transform(leverLeft and 1946 or 1945)
		end
	end

	local tile, tmpItem, bridge
	if leverLeft then
		for i = 1, #config.bridgePositions do
			bridge = config.bridgePositions[i]
			tile = Tile(bridge.position)



			tmpItem = tile:getGround()
			if tmpItem then
				tmpItem:transform(config.bridgeId)
			end

			if bridge.itemId then
				tmpItem = tile:getItemById(bridge.itemId)
				if tmpItem then
					tmpItem:remove()
				end
			end
		end
	else
		for i = 1, #config.bridgePositions do
			bridge = config.bridgePositions[i]
			tile = Tile(bridge.position)

			tile:relocateTo(config.relocatePosition, true, config.relocateMonsterPosition)
			tile:getGround():transform(bridge.groundId)
			
			if bridge.itemId then
				Game.createItem(bridge.itemId, 1, bridge.position)
			end
		end
	end
	return true
end