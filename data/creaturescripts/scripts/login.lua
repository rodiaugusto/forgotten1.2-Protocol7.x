-- Ordered as in creaturescripts.xml
local events = {
	'loots',
	'spell',
	'Reward',
	'deathgroup',
	'PlayerDeath',
	'DropLoot',
	'AdvanceSave',
	'FirstItems'
}

function onLogin(player)
	if player:getStorageValue(deathgroup) > 1 then
		local resultId = db.storeQuery("SELECT * FROM `death_group` WHERE `death_type`='1' AND `death_player`=".. db.escapeString(player:getGuid()) .." LIMIT 1")
		if resultId ~= false then
			db.asyncQuery("UPDATE `death_group` SET `death_view`='0',`death_time`='".. os.time() .."' WHERE `death_player`=".. db.escapeString(player:getGuid()) .." AND `death_type`='1'")
			result.free(resultId)
		else
			db.asyncQuery("INSERT INTO `death_group` (`death_player`,`death_time`,`death_view`,`death_type`) VALUES (".. db.escapeString(player:getGuid()) ..",".. os.time() ..",0,1)")
		end
	end


	local loginStr = ""
	local timeZone = ""

	if os.date("%Z").isdst ~= nil then
		timeZone = "CET"
	else
		timeZone = "(GMT -3)"
	end

	loginStr = string.format("Your last visit in " .. configManager.getString(configKeys.SERVER_NAME) .. ": %s " .. timeZone .. ".", os.date("%d %b %Y %X", player:getLastLoginSaved()))
	player:sendTextMessage(MESSAGE_STATUS_DEFAULT, loginStr)

	-- CHANNELS
	player:openChannel(9)
	player:openChannel(7)

	-- EVENTS
	for i = 1, #events do
		player:registerEvent(events[i])
	end

	return true
end
