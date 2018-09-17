local function getEternalStorage(key, parser)
--    local value = result.getNumber(db.storeQuery("SELECT `value` FROM `global_storage` WHERE `key` = ".. key .. ";"), "value")
    if not value then
        if parser then
            return false
        else
            return -1
        end
    end
    return value
end

local function setEternalStorage(key, value)
    if getEternalStorage(key, true) then
        db.query("UPDATE `global_storage` SET `value` = '".. value .. "' WHERE `key` = ".. key .. ";")
    else
        db.query("INSERT INTO `global_storage` (`key`, `value`) VALUES (".. key ..", ".. value ..");")
    end
    return true
end

function onThink(interval, lastExecution, thinkInterval)
    --if tonumber(os.date("%d")) ~= getEternalStorage(23856) then
      --  setEternalStorage(23856, (tonumber(os.date("%d"))))
        --db.query("UPDATE `players_stats` SET `onlinetime7`=`onlinetime6`, `onlinetime6`=`onlinetime5`, `onlinetime5`=`onlinetime4`, `onlinetime4`=`onlinetime3`, `onlinetime3`=`onlinetime2`, `onlinetime2`=`onlinetime1`, `onlinetime1`=`onlinetimetoday`, `onlinetimetoday`=0;")
        --db.query("UPDATE `players_stats` `z` INNER JOIN `players` `p` ON `p`.`id`=`z`.`player_id` SET `z`.`exphist7`=`z`.`exphist6`,  `z`.`exphist6`=`z`.`exphist5`, `z`.`exphist5`=`z`.`exphist4`, `z`.`exphist4`=`z`.`exphist3`, `z`.`exphist3`=`z`.`exphist2`, `z`.`exphist2`=`z`.`exphist1`, `z`.`exphist1`=`p`.`experience`-`z`.`exphist_lastexp`, `z`.`exphist_lastexp`=`p`.`experience`;")
    --end
    --db.query("UPDATE `players_stats` SET `onlinetimetoday` = `onlinetimetoday` + 60, `onlinetimeall` = `onlinetimeall` + 60 WHERE `player_id` IN (SELECT `player_id` FROM `players_online` WHERE `players_online`.`player_id` = `players_stats`.`player_id`)")
    print('Powergamers saved')
    return true
end
