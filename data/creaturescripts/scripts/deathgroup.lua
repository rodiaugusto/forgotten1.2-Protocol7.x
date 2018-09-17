function onDeath(player, corpse, killer, mostDamage, unjustified, mostDamage_unjustified)
	if killer == nil then
		return true
	end
	if killer:isMonster() then
		return true
	end
	local killers_id = ''
	if player:isPlayer() then
		local victim_lvl = player:getLevel()
		if victim_lvl >= 25 and player:getStorageValue(deathgroup) > 1 then
			local damageMap = player:getDamageMap()
			if damageMap ~= nil then
				local killers = 0
				for countkillers, damage in pairs(damageMap) do
					killers = killers+1
				end
				local bonussoul = player:getSoul()
				if bonussoul == 0 then
					bonussoul = 1
				end

				local victim_exp = player:getExperience()

				local rewards = {}
				for creatureId, damage in pairs(damageMap) do
					local attacker = Player(creatureId)
					if attacker ~= nil then
						if damageMap[creatureId].total ~= nil then
							if damageMap[creatureId].total >= 10 then 
								local statusdeath = attacker:getStorageValue(deathgroup)
								if statusdeath > 1 and attacker:getLevel() >= 25 then
									if not contains(rewards,creatureId) then
										rewards[creatureId] = 1
										local atknm = attacker:getName()
										
										if attacker:getSoul() < 10 then
											attacker:addSoul(1)
								            attacker:say(deathtext, TALKTYPE_MONSTER_SAY)
									    end
										local deathxp = round_num((1 - (((attacker:getLevel() * 0.9)/victim_lvl) * 0.02 * victim_exp)*bonussoul),0)
										if deathxp < 1 then
											deathxp = deathxp*(-1)
										end
										local attacker_pos = attacker:getPosition()
										attacker:addExperience(deathxp)
							            attacker:say(deathxp, TALKTYPE_MONSTER_SAY)
							            attacker_pos:sendMagicEffect(CONST_ME_DRAWBLOOD)
							            killers_id = attacker:getGuid()..','..killers_id
									end
								end
							end
						end
					end
				end
			end
			player:addSoul(-10)

			if killers_id ~= nil then
				local pguid = player:getGuid()
			
				local deathListEnabled = true
				local maxDeathRecords = 4
				db.query("INSERT INTO `death_group` (`death_player`,`death_killers`,`death_time`,`death_view`,`death_type`) VALUES (".. db.escapeString(pguid) ..",'"..killers_id.."',".. os.time() ..",0,2)")
				local resultId = db.storeQuery("SELECT `death_group_id` FROM `death_group` WHERE `death_player` = " .. pguid)

				local deathRecords = 0
				local tmpResultId = resultId
				while tmpResultId ~= false do
					tmpResultId = result.next(resultId)
					deathRecords = deathRecords + 1
				end
				if resultId ~= false then
					result.free(resultId)
				end
				local limit = deathRecords - maxDeathRecords
				if limit > 0 then
					db.asyncQuery("DELETE FROM `death_group` WHERE `death_player` = " .. pguid .. " ORDER BY `death_time` LIMIT " .. limit)
				end
			end
		end
	end
end