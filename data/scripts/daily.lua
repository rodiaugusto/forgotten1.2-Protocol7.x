local config = {
     storage = 45392,
     exstorage = 40822,
     days = {
         ["Monday"] = {
             {itemid = 2152, count = {1, 30}}
         },
         ["Tuesday"] = {
             {itemid = 2152, count = {1}},
         },
         ["Wednesday"] = {
             {itemid = 2152, count = {1, 10}},
         },
         ["Thursday"] = {
             {itemid = 2152, count = {2, 15}},
         },
         ["Friday"] = {
             {itemid = 2152, count = {1, 3}}
         },
         ["Saturday"] = {
             {itemid = 2152, count = {1}}
         },
         ["Sunday"] = {
             {itemid = 2152, count = {2, 12}},
         }
     }
}
 
function onUse(cid, item, fromPosition, itemEx, toPosition, isHotkey)
     local player = Player(cid)
     local x = config.days[os.date("%A")]
     if player:getStorageValue(config.storage) == tonumber(os.date("%w")) and player:getStorageValue(config.exstorage) > os.time() then
         return player:sendCancelMessage("The chest is empty, come back tomorrow for a new reward.")
     end
     local c = math.random(#x)
     local info, count = ItemType(x[c].itemid), x[c].count[2] and math.random(x[c].count[1], x[c].count[2]) or x[c].count[1]
     if count > 1 then
         text = count .. " " .. info:getPluralName()
     else
         text = info:getArticle() .. " " .. info:getName()
     end
     local itemx = Game.createItem(x[c].itemid, count)
     if player:addItemEx(itemx) ~= RETURNVALUE_NOERROR then
         player:getPosition():sendMagicEffect(CONST_ME_POFF)
         text = "You have found a reward weighing " .. itemx:getWeight() .. " oz. It is too heavy or you have not enough space."
     else
         text = "You have received " .. text .. "."
         player:setStorageValue(config.storage, tonumber(os.date("%w")))
         player:setStorageValue(config.exstorage, os.time() + 24*60*60)
     end
     player:sendTextMessage(MESSAGE_INFO_DESCR, text)
     return true
end