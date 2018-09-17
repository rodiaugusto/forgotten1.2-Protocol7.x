function onLogout(player)
	local playerId = player:getId()
	
	if player:getStorageValue(deathgroup) > 1 then
		local resultId = db.storeQuery("SELECT * FROM `death_group` WHERE `death_type`='0' AND `death_player`=".. db.escapeString(player:getGuid()) .." LIMIT 1")
		if resultId ~= false then
			db.asyncQuery("UPDATE `death_group` SET `death_view`='0',`death_time`='".. os.time() .."' WHERE `death_player`=".. db.escapeString(player:getGuid()) .." AND `death_type`='0'")
			result.free(resultId)
		else
			db.asyncQuery("INSERT INTO `death_group` (`death_player`,`death_time`,`death_view`,`death_type`) VALUES (".. db.escapeString(player:getGuid()) ..",".. os.time() ..",0,0)")
		end
	end
	return true
end
