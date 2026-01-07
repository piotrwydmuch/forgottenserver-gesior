local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)

function onCreatureAppear(cid)              npcHandler:onCreatureAppear(cid)            end
function onCreatureDisappear(cid)           npcHandler:onCreatureDisappear(cid)         end
function onCreatureSay(cid, type, msg)      npcHandler:onCreatureSay(cid, type, msg)    end
function onThink()                          npcHandler:onThink()                        end

local function creatureSayCallback(cid, type, msg)
	if not npcHandler:isFocused(cid) then
		return false
	end

	local player = Player(cid)
	local questStatus = player:getStorageValue(PlayerStorageKeys.initiateMetinQuest)

	if msgcontains(msg, "hi") or msgcontains(msg, "hello") then
		if questStatus < 0 then
			-- Quest nie rozpoczęty
			npcHandler:say("Hello! I need your help. There is a dangerous creature called Initiate Metin that needs to be eliminated. Will you help me?", cid)
			npcHandler.topic[cid] = 0
		elseif questStatus == 1 then
			-- Quest rozpoczęty, sprawdzamy czy zabito metina
			npcHandler:say("Have you completed the mission? Did you kill Initiate Metin?", cid)
			npcHandler.topic[cid] = 1
		elseif questStatus >= 2 then
			-- Quest ukończony
			npcHandler:say("Thank you for your help! The Initiate Metin has been defeated. You have completed the quest!", cid)
			npcHandler.topic[cid] = 0
		end
		return true
	end

	if msgcontains(msg, "mission") then
		if questStatus < 0 then
			npcHandler:say("I need you to kill an Initiate Metin. It's a dangerous creature that threatens our safety. Will you accept this mission?", cid)
			npcHandler.topic[cid] = 0
		elseif questStatus == 1 then
			npcHandler:say("Have you completed the mission? Did you kill Initiate Metin?", cid)
			npcHandler.topic[cid] = 1
		elseif questStatus >= 2 then
			npcHandler:say("You have already completed this quest. Thank you!", cid)
			npcHandler.topic[cid] = 0
		end
		return true
	end

	if msgcontains(msg, "yes") then
		if npcHandler.topic[cid] == 0 then
			-- Rozpoczęcie questu
			if questStatus < 0 then
				player:setStorageValue(PlayerStorageKeys.initiateMetinQuest, 1)
				npcHandler:say("Excellent! I will summon the Initiate Metin for you. Be prepared!", cid)
				
				-- Przywołujemy potwora obok gracza
				local playerPos = player:getPosition()
				local summonPos = Position(playerPos.x + 1, playerPos.y, playerPos.z)
				
				local monster = Game.createMonster("Initiate Metin", summonPos)
				if monster then
					summonPos:sendMagicEffect(CONST_ME_TELEPORT)
					player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Initiate Metin has been summoned! Defeat it and return to me.")
				else
					-- Jeśli nie można przywołać na tej pozycji, próbujemy innych
					local positions = {
						Position(playerPos.x + 1, playerPos.y, playerPos.z),
						Position(playerPos.x - 1, playerPos.y, playerPos.z),
						Position(playerPos.x, playerPos.y + 1, playerPos.z),
						Position(playerPos.x, playerPos.y - 1, playerPos.z),
					}
					
					for _, pos in ipairs(positions) do
						monster = Game.createMonster("Initiate Metin", pos)
						if monster then
							pos:sendMagicEffect(CONST_ME_TELEPORT)
							player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Initiate Metin has been summoned! Defeat it and return to me.")
							break
						end
					end
				end
				
				npcHandler.topic[cid] = 0
			end
		elseif npcHandler.topic[cid] == 1 then
			-- Sprawdzamy czy gracz zabił metina
			if questStatus >= 2 then
				-- Quest ukończony
				npcHandler:say("Excellent work! You have successfully defeated the Initiate Metin. Your quest is complete!", cid)
				player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Quest completed! You can now open the quest doors.")
				npcHandler.topic[cid] = 0
			else
				npcHandler:say("I don't see that you have killed the Initiate Metin yet. Please defeat it and return to me.", cid)
				npcHandler.topic[cid] = 0
			end
		end
		return true
	end

	return true
end

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())

