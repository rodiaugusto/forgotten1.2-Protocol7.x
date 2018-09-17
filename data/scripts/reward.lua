function onUse(player, item, fromPosition, target, toPosition)

	local actid = item.actionid
	if actid == 0 then
		return false
	end	
	if player:getStorageValue(actid) == 1 then
		return player:sendTextMessage(MESSAGE_INFO_DESCR,'You can\'t use this item anymore.')
	end

	if actid > 1 then 
		local bagid = math.random(1,3)
		local baglist = {
			[1]={id=1995,effect=CONST_ME_SOUND_BLUE},
			[2]={id=1992,effect=CONST_ME_SOUND_YELLOW},
			[3]={id=1994,effect=CONST_ME_SOUND_PURPLE},
		}
		local rewardlist = {
			[20] = {
					[1]={items={{2188,1},{2304,20},{2525,1}},cap=70},
					[2]={items={{2185,1},{2304,20},{2525,1}},cap=70},
					[3]={items={{2455,1},{2543,50},{2273,5}},cap=90},
					[4]={items={{2525,1},{2273,5}},cap=125},
					},
		}

		local rewardLevel = 25200
		local levelrewarded = (actid-rewardLevel)

		if item.itemid == 1990 and actid >= rewardLevel and player:getStorageValue(actid) == 0 then	
			local vocid = player:getVocation():getId()
			if vocid > 4 then
				vocid = vocid-4
			end

			if (player:getFreeCapacity()/100) >= rewardlist[levelrewarded][vocid].cap then
				local ctbp = player:addItem(baglist[bagid].id,1)
			    for i,t in ipairs(rewardlist[levelrewarded][vocid].items) do
					ctbp:addItem(t[1],t[2])
				end

				if vocid == 4 then
					local club = player:getEffectiveSkillLevel(SKILL_CLUB)
					local axe = player:getEffectiveSkillLevel(SKILL_AXE)
					local sword = player:getEffectiveSkillLevel(SKILL_SWORD)

					local ofwep = 3
					if club > sword and club > axe then
						ofwep = 1
					elseif sword > club and sword > axe then
						ofwep = 2
					elseif axe > club and axe > sword then
						ofwep = 3
					end

					if ofwep ~= nil then
						local weaponlist = {
							[20] = {2423,2409,2429},
						}
						if weaponlist[levelrewarded] then
							ctbp:addItem(weaponlist[levelrewarded][ofwep],1)
						end
					end
				end
				player:getPosition():sendMagicEffect(baglist[bagid].effect)
				player:setStorageValue(actid,1)
				item:remove()
			else
				player:sendTextMessage(MESSAGE_INFO_DESCR,'You need '.. rewardlist[levelrewarded][vocid].cap ..' capacity available.')
			end
		else
			player:sendTextMessage(MESSAGE_INFO_DESCR,'You can\'t use this item.')
		end
	end
	return true
end
