-- Custom Tasks

dofile("data/lib/tasks.lua")

function onLogin(player)
  player:addItem(2160, 1)

  local serverName = configManager.getString(configKeys.SERVER_NAME)
  local loginStr = "Welcome to " .. serverName .. "!"
  if player:getLastLoginSaved() <= 0 then
    loginStr = loginStr .. " Please choose your outfit."
    player:sendOutfitWindow()
  else
    player:sendTextMessage(MESSAGE_STATUS_DEFAULT, loginStr)
    loginStr = string.format("Your last visit in %s: %s.", serverName, os.date("%d %b %Y %X", player:getLastLoginSaved()))
    player:sendTextMessage(MESSAGE_STATUS_DEFAULT, loginStr)
  end

  -- Promotion
  local vocation = player:getVocation()
  local promotion = vocation:getPromotion()
  if player:isPremium() and player:getStorageValue(PlayerStorageKeys.promotion) == 1 then
    player:setVocation(promotion)
  elseif not promotion then
    player:setVocation(vocation:getDemotion())
  end

  -- Register events
  player:registerEvent("PlayerDeath")
  player:registerEvent("DropLoot")
  player:registerEvent("TaskKill")
  player:registerEvent("TaskExtendedOpcode")
  player:registerEvent("MonsterStatistics")
  
  -- Inicjalizacja storage dla questu statystyk potworów (storage 19999 = quest zawsze aktywny)
  if player:getStorageValue(19999) < 1 then
    player:setStorageValue(19999, 1)
  end

  -- Send task data after login
  addEvent(function()
    local allTasks = {}

    for taskId, task in pairs(TASKS) do
      local storage = task.storage or (10000 + taskId)
      local progress = math.max(0, player:getStorageValue(storage))
      local rewards = {}
      local monsters = {}

      if type(task.reward) == "table" then
        for _, reward in ipairs(task.reward) do
          if reward.itemId then
            local item = ItemType(reward.itemId)
            if item and item:getId() ~= 0 and item:getClientId() ~= 0 then
              table.insert(rewards, {
                itemId = item:getClientId(),
                count = reward.count
              })
            else
              print(string.format("[Task Login] Invalid reward itemId %s in task '%s'", tostring(reward.itemId), task.name))
            end
          else
            print(string.format("[Task Login] Missing itemId in task '%s'", task.name))
          end
        end
      end

      if type(task.monster) == "table" then
        for _, monster in ipairs(task.monster) do
          table.insert(monsters, {
            name = monster.name,
            lookType = monster.lookType,
            points = monster.points
          })
        end
      else
        table.insert(monsters, {
          name = task.monster,
          lookType = task.lookType,
          points = 1
        })
      end

      table.insert(allTasks, {
        name = task.name,
        progress = progress,
        total = task.amount,
        rewards = rewards,
        lookType = task.lookType,
        monster = monsters
      })
    end

    player:sendExtendedOpcode(125, serializeTaskTable(allTasks))
  end, 100)

  return true
end
