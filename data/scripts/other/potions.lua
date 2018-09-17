local potions = {
	[5115] = {mana = {75, 125}, flask = 2006},
	[5116] = {health = {125, 175}, flask = 2006},
}
function onUse(player, item, fromPosition, target, toPosition)
	if type(target) == "userdata" and not target:isPlayer() then
		return false
	end

	local potion = potions[item:getId()]

	if potion.health then
		doTargetCombatHealth(0, target, COMBAT_HEALING, potion.health[1], potion.health[2])
	end

	if potion.mana then
		doTargetCombatMana(0, target, potion.mana[1], potion.mana[2])
	end

	if potion.antidote then
		target:removeCondition(CONDITION_POISON)
	end
	
	if player:getStorageValue(VIAL_STORAGE) == 1 then
		player:addItem(potion.flask,0)
	end
	target:say("Aaaah...", TALKTYPE_MONSTER_SAY)
	target:getPosition():sendMagicEffect(CONST_ME_MAGIC_BLUE)

	item:remove(1)
	
	return true
end