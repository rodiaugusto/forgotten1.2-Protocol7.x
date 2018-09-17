function onDeath(creature, corpse, lasthitkiller, mostdamagekiller, lasthitunjustified, mostdamageunjustified)
		if creature:isPlayer() or creature:getMaster() then
			return true
		end
		if creature:isMonster() then
			local n = string.lower(creature:getName())
			local damageMap = creature:getDamageMap()
			local rewards = {}
			for creatureId, damage in pairs(damageMap) do
				if not contains(rewards,creatureId) then
					local player_attacker = Player(creatureId)
					if damageMap[creatureId].total >= 1 then
						if player_attacker ~= nil then
							local task_status = player_attacker:getStorageValue(taskglobal) -- TASK STATUS
							if task_status > 0 then -- TASK ACTIVE 
								local getid = gtask(task_status)
								if contains(tasks_name[task_status].monsters,n) then
									local progress = player_attacker:getStorageValue(getid)
									if progress ~= tasks_name[task_status].amount then
										local now = progress+1
										if now == tasks_name[task_status].amount then
											player_attacker:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, 'You finished the '.. tasks_name[task_status].name ..' task. Report your result to claim for your reward.')
										else
											player_attacker:sendTextMessage(MESSAGE_STATUS_CONSOLE_RED, 'Your progress in '.. tasks_name[task_status].name ..' task is '..now..'/'.. tasks_name[task_status].amount..'.')
										end
										player_attacker:setStorageValue(getid,now)
									end
									rewards[creatureId] = 1
								end
							end
						end
					end
				end
			end
			rewards = nil
		end

	return true
end