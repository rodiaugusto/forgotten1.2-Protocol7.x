function onLogin(player)
	if player:getStorageValue(3362) == -1 then
		local container = player:addItem(1988, 1)
		local voc = player:getVocation():getId()
		if voc == 1 then
			player:addItem(2190, 1, true, 1, CONST_SLOT_LEFT)
		elseif voc == 2 then
			player:addItem(2182, 1, true, 1, CONST_SLOT_LEFT)
		elseif voc == 3 then
			player:addItem(2389, 4, true, 1, CONST_SLOT_LEFT)
		elseif voc == 4 then
			player:addItem(2397, 1, true, 1, CONST_SLOT_LEFT)
			container:addItem(2422, 1)
			container:addItem(2428, 1)
		end

		player:addItem(2465, 1, true, 1, CONST_SLOT_ARMOR)
		player:addItem(2478, 1, true, 1, CONST_SLOT_LEGS)
		player:addItem(2509, 1, true, 1, CONST_SLOT_RIGHT)
		player:addItem(2460, 1, true, 1, CONST_SLOT_HEAD)
		player:addItem(2643, 1, true, 1, CONST_SLOT_FEET)
		
		container:addItem(2789, 5)
		container:addItem(5115, 5)
		container:addItem(5116, 5)
		container:addItem(2120, 1)
		container:addItem(2554, 1)
		container:addItem(2152, 3)
		player:setStorageValue(3362,1)
		--player:addItem(player:getSex() == 0 and 2467 or 2467, 1)
	end
	return true
end
