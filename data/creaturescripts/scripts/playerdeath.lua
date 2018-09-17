local maxDeathRecords = 6

local function addAssistsPoints(attackerId, target)
	if not attackerId or type(attackerId) ~= 'number' then
		return
	end

	if not target or type(target) ~= 'userdata' or not target:isPlayer() then
		return
	end

	local ignoreIds = {attackerId, target:getId()}
	for id in pairs(target:getDamageMap()) do
		local tmpPlayer = Player(id)
		if tmpPlayer and not isInArray(ignoreIds, id) then
			tmpPlayer:setStorageValue(STORAGEVALUE_ASSISTS, math.max(0, tmpPlayer:getStorageValue(STORAGEVALUE_ASSISTS)) + 1)
		end
	end
end
function onDeath(player, corpse, killer, mostDamageKiller, unjustified, mostDamageUnjustified)
	local playerId = player:getId()

	player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You are dead.")
	local byPlayer = 0
	local killerName
	if killer ~= nil then
		if killer:isPlayer() then
			byPlayer = 1
		else
			local master = killer:getMaster()
			if master and master ~= killer and master:isPlayer() then
				killer = master
				byPlayer = 1
			end
		end
		killerName = killer:getName()
	else
		killerName = "field item"
	end

	if byPlayer == 1 then
		addAssistsPoints(killer:getId(), player)
		player:setStorageValue(STORAGEVALUE_DEATHS, math.max(0, player:getStorageValue(STORAGEVALUE_DEATHS)) + 1)
		killer:setStorageValue(STORAGEVALUE_KILLS, math.max(0, killer:getStorageValue(STORAGEVALUE_KILLS)) + 1)
	end

	local byPlayerMostDamage = 0
	local mostDamageKillerName
	if mostDamageKiller ~= nil then
		if mostDamageKiller:isPlayer() then
			byPlayerMostDamage = 1
		else
			local master = mostDamageKiller:getMaster()
			if master and master ~= mostDamageKiller and master:isPlayer() then
				mostDamageKiller = master
				byPlayerMostDamage = 1
			end
		end
		mostDamageName = mostDamageKiller:getName()
	else
		mostDamageName = "field item"
	end

	local playerGuid = player:getGuid()
	db.query("INSERT INTO `player_deaths` (`player_id`, `time`, `level`, `killed_by`, `is_player`, `mostdamage_by`, `mostdamage_is_player`, `unjustified`, `mostdamage_unjustified`) VALUES (" .. playerGuid .. ", " .. os.time() .. ", " .. player:getLevel() .. ", " .. db.escapeString(killerName) .. ", " .. byPlayer .. ", " .. db.escapeString(mostDamageName) .. ", " .. byPlayerMostDamage .. ", " .. (unjustified and 1 or 0) .. ", " .. (mostDamageUnjustified and 1 or 0) .. ")")
	local resultId = db.storeQuery("SELECT `player_id` FROM `player_deaths` WHERE `player_id` = " .. playerGuid)

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
		db.asyncQuery("DELETE FROM `player_deaths` WHERE `player_id` = " .. playerGuid .. " ORDER BY `time` LIMIT " .. limit)
	end

	local fragTime = configManager.getNumber(configKeys.FRAG_TIME)
	if fragTime <= 0 then
		return true
	end

	local accountId = getAccountNumberByPlayerName(killer:getName())
	if accountId == 0 then
		return false
	end

	local skullTime = killer:getSkullTime()
	if skullTime <= 0 then
		return true
	end

	local kills = math.ceil(skullTime / fragTime)
	local remainingSeconds = math.floor((skullTime % fragTime) / 1000)

	local hours = math.floor(remainingSeconds / 3600)
	local minutes = math.floor((remainingSeconds % 3600) / 60)
	local seconds = remainingSeconds % 60

	if kills > 0 then
		killer:sendTextMessage(MESSAGE_STATUS_CONSOLE_RED, 'Frags to red skull '.. kills ..'/4.\nFrags to ban '.. kills ..'/8.')
	end

	if kills >= 8 then
		local timeNow = os.time()
		db.query("INSERT INTO `account_bans` (`account_id`, `reason`, `banned_at`, `expires_at`, `banned_by`) VALUES (" ..accountId .. ", 'Player Killing', " .. timeNow .. ", " .. timeNow + (3 * 86400) .. ", " .. player:getGuid() .. ")")
		killer:remove()
	end
end
