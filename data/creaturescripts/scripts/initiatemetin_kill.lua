function onKill(player, target)
	if not target:isMonster() then
		return true
	end

	local targetName = target:getName():lower()
	if targetName == "initiate metin" then
		-- Sprawdzamy czy gracz ma rozpoczęty quest (storage >= 1)
		local questStatus = player:getStorageValue(PlayerStorageKeys.initiateMetinQuest)
		if questStatus >= 1 and questStatus < 2 then
			-- Ustawiamy storage na 2 (zabito metina)
			player:setStorageValue(PlayerStorageKeys.initiateMetinQuest, 2)
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You have killed Initiate Metin! Return to the quest giver.")
		end
	end
	return true
end

