function Player:onLook(thing, position, distance)
	local description = "You see " .. thing:getDescription(distance)
	if thing:isCreature() and thing:isPlayer() then
		if thing:getStorageValue(deathgroup) > 1 then
			description = description .. " Member of death group."
		end
		local kills = thing:getStorageValue(STORAGEVALUE_KILLS)

		if kills >= 1 then
			self:sendTextMessage(MESSAGE_STATUS_CONSOLE_RED, 'Warning! This player killed '..kills..' players, died '.. math.max(0,thing:getStorageValue(STORAGEVALUE_DEATHS)+1) ..' times, and cooperate with '.. math.max(0,thing:getStorageValue(STORAGEVALUE_ASSISTS)+1) ..' deaths.')
		end
	end
	if self:getGroup():getAccess() then
		if thing:isItem() then
			description = string.format("%s\nItem ID: %d", description, thing:getId())

			local actionId = thing:getActionId()
			if actionId ~= 0 then
				description = string.format("%s, Action ID: %d", description, actionId)
			end

			local uniqueId = thing:getAttribute(ITEM_ATTRIBUTE_UNIQUEID)
			if uniqueId > 0 and uniqueId < 65536 then
				description = string.format("%s, Unique ID: %d", description, uniqueId)
			end

			local itemType = thing:getType()

			local transformEquipId = itemType:getTransformEquipId()
			local transformDeEquipId = itemType:getTransformDeEquipId()
			if transformEquipId ~= 0 then
				description = string.format("%s\nTransforms to: %d (onEquip)", description, transformEquipId)
			elseif transformDeEquipId ~= 0 then
				description = string.format("%s\nTransforms to: %d (onDeEquip)", description, transformDeEquipId)
			end

			local decayId = itemType:getDecayId()
			if decayId ~= -1 then
				description = string.format("%s\nDecays to: %d", description, decayId)
			end
		elseif thing:isCreature() then
			local str = "%s\nHealth: %d / %d"
			if thing:getMaxMana() > 0 then
				str = string.format("%s, Mana: %d / %d", str, thing:getMana(), thing:getMaxMana())
			end
			description = string.format(str, description, thing:getHealth(), thing:getMaxHealth()) .. "."
		end

		local position = thing:getPosition()
		description = string.format(
			"%s\nPosition: %d, %d, %d",
			description, position.x, position.y, position.z
		)

		if thing:isCreature() then
			if thing:isPlayer() then
				description = string.format("%s\nIP: %s.", description, Game.convertIpToString(thing:getIp()))
			end
		end
	end
	self:sendTextMessage(MESSAGE_INFO_DESCR, description)
end

function Player:onLookInBattleList(creature, distance)
	local description = "You see " .. creature:getDescription(distance)
	if creature:isPlayer() then
		if creature:getStorageValue(deathgroup) > 1 then
			description = description .. " Member of death group."
		end

		local kills = creature:getStorageValue(STORAGEVALUE_KILLS)
		if kills >= 1 then
			self:sendTextMessage(MESSAGE_STATUS_CONSOLE_RED, 'Warning! This player killer '..kills..' players, died '.. creature:getStorageValue(STORAGEVALUE_DEATHS) ..' times, and cooperate with '.. creature:getStorageValue(STORAGEVALUE_ASSISTS) ..' deaths.')
		end
	end
	if self:getGroup():getAccess() then
		local str = "%s\nHealth: %d / %d"
		if creature:getMaxMana() > 0 then
			str = string.format("%s, Mana: %d / %d", str, creature:getMana(), creature:getMaxMana())
		end
		description = string.format(str, description, creature:getHealth(), creature:getMaxHealth()) .. "."

		local position = creature:getPosition()
		description = string.format(
			"%s\nPosition: %d, %d, %d",
			description, position.x, position.y, position.z
		)

		if creature:isPlayer() then
			description = string.format("%s\nIP: %s", description, Game.convertIpToString(creature:getIp()))
		end
	end
	self:sendTextMessage(MESSAGE_INFO_DESCR, description)
end

function Player:onLookInTrade(partner, item, distance)
	self:sendTextMessage(MESSAGE_INFO_DESCR, "You see " .. item:getDescription(distance))
end

function Player:onLookInShop(itemType, count)
	return true
end

function Player:onMoveItem(item, count, fromPosition, toPosition)
	local tile = Tile(toPosition)
	if tile and tile:getItemCount() > 20 then
		self:sendCancelMessage(RETURNVALUE_NOTPOSSIBLE)
		return false
	end

	if item:getId() == 2180 then
		self:sendCancelMessage(RETURNVALUE_NOTPOSSIBLE)
		return false
	end
	return true
end

function Player:onMoveCreature(creature, fromPosition, toPosition)
	return true
end

function Player:onTurn(direction)
	return true
end

function Player:onTradeRequest(target, item)
	return true
end

function Player:onTradeAccept(target, item, targetItem)
	return true
end

function Player:onGainExperience(source, exp, rawExp)
	if not source or source:isPlayer() then
		return exp
	end

	local function round(num, numDecimalPlaces)
	  local mult = 10^(numDecimalPlaces or 0)
	  return math.floor(num * mult + 0.5) / mult
	end

	local bonus = self:getSoul()

	if self:getStorageValue(taskbonus_fifth) >= os.time() then
		bonus = bonus + 50
	end
	if self:getPremiumDays() >= 1 then
		bonus = bonus + 10
	end
	-- Apply experience stage multiplier
	exp = exp * Game.getExperienceStage(self:getLevel())
	exp = exp + round(((exp*bonus)/100),0)
	
	return exp
end

function Player:onLoseExperience(exp)
	if self:getLevel() == 8 then
		return 0
	end
	if self:getStorageValue(deathgroup) > 1 then
		exp = exp * 1.5
	end
	return exp
end

function Player:onGainSkillTries(skill, tries)
	if APPLY_SKILL_MULTIPLIER == false then
		return tries
	end

	if skill == SKILL_MAGLEVEL then
		local magstag = configManager.getNumber(configKeys.RATE_MAGIC)
		local skillmag = self:getMagicLevel(SKILL_MAGLEVEL)
		if skillmag >= 30 and skillmag <= 50 then
			magstag = 3
		elseif skillmag >= 51 and skillmag <= 120 then
			magstag = 2
		elseif skillmag >= 121 and skillmag <= 220 then
			magstag = 1
		end	
		return tries * magstag
	end
	return tries * configManager.getNumber(configKeys.RATE_SKILL)
end
