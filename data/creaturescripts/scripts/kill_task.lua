dofile("data/lib/tasks.lua")

local taskSendQueue = {}
local taskSendScheduled = {}

local function queueTaskUpdate(player, taskData)
  local pid = player:getId()
  taskSendQueue[pid] = taskSendQueue[pid] or {}
  table.insert(taskSendQueue[pid], taskData)

  if not taskSendScheduled[pid] then
    taskSendScheduled[pid] = true
    addEvent(function()
      for _, data in ipairs(taskSendQueue[pid] or {}) do
        player:sendExtendedOpcode(125, serializeTaskTable(data))
      end
      taskSendQueue[pid] = nil
      taskSendScheduled[pid] = nil
    end, 50) -- delay to merge multiple kills
  end
end

function onKill(creature, target)
  local player = creature:getPlayer()
  if not player or not target:isMonster() then return true end

  local targetName = target:getName():lower()

  for taskId, task in pairs(TASKS) do
    local match = false
    local multiplier = 1

    if type(task.monster) == "string" then
      match = (targetName == task.monster:lower())
    elseif type(task.monster) == "table" then
      for _, m in ipairs(task.monster) do
        if targetName == m.name:lower() then
          multiplier = m.points
          match = true
          break
        end
      end
    end

    if match then
      local key = task.storage or (10000 + taskId)
      local current = math.max(0, player:getStorageValue(key))
      if current >= task.amount then goto continue end

      local newProgress = math.min(current + multiplier, task.amount)
      player:setStorageValue(key, newProgress)

      local rewards = {}
      for _, reward in ipairs(task.reward or {}) do
        local item = ItemType(reward.itemId)
        if item and item:getId() ~= 0 and item:getClientId() ~= 0 then
          table.insert(rewards, {
            itemId = item:getClientId(),
            count = reward.count
          })
        else
          print(string.format("[Task] Invalid reward itemId %s in task '%s'", tostring(reward.itemId), task.name))
        end
      end

      queueTaskUpdate(player, {
        progress = newProgress,
        total = task.amount,
        name = task.name,
        rewards = rewards,
        lookType = task.lookType,
        monster = task.monster
      })

      if newProgress >= task.amount then
        for _, reward in ipairs(task.reward or {}) do
          player:addItem(reward.itemId, reward.count)
        end
        player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You completed the task: " .. task.name .. "!")
      end
    end
    ::continue::
  end

  return true
end
