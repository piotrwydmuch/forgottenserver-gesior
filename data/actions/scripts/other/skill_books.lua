-- Uniwersalny skrypt dla ksiąg umiejętności
-- Aby dodać nową księgę, wystarczy dodać wpis do tabeli skillBooks poniżej

local skillBooks = {
	-- Magic Level Skill Book - dodaje ekwiwalent zużycia 5000 many
	[1984] = {
		type = "magic_level",
		value = 5000,
		name = "Magic Level Skill Book",
		message = "You have gained the equivalent of 5000 mana spent."
	},
	
	-- Sword Fighting Skill Book - dodaje 500 trafień
	[1985] = {
		type = "skill",
		skill = SKILL_SWORD,
		value = 500,
		name = "Sword Fighting Skill Book",
		message = "You have gained 500 sword fighting skill tries."
	},
	
	-- Distance Fighting Skill Book - dodaje 500 trafień
	[1983] = {
		type = "skill",
		skill = SKILL_DISTANCE,
		value = 500,
		name = "Distance Fighting Skill Book",
		message = "You have gained 500 distance fighting skill tries."
	}
}

function onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local bookData = skillBooks[item:getId()]
	if not bookData then
		return false
	end
	
	-- Sprawdź czy gracz nie jest w PZ
	if player:isPzLocked() then
		player:sendCancelMessage(RETURNVALUE_YOUMAYNOTATTACKTHISPLAYER)
		return true
	end
	
	-- Obsługa magic level
	if bookData.type == "magic_level" then
		player:addManaSpent(bookData.value)
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, bookData.message)
		player:getPosition():sendMagicEffect(CONST_ME_MAGIC_BLUE)
	
	-- Obsługa umiejętności (skill)
	elseif bookData.type == "skill" then
		player:addSkillTries(bookData.skill, bookData.value)
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, bookData.message)
		player:getPosition():sendMagicEffect(CONST_ME_MAGIC_GREEN)
	
	-- Nieznany typ
	else
		return false
	end
	
	-- Usuń przedmiot po użyciu
	item:remove(1)
	return true
end

