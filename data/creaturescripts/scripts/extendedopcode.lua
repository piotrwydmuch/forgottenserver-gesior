dofile("data/lib/tasks.lua")

local OPCODE_TASK = 125
local OPCODE_MONSTER_STATS = 126

-- Lista potworów do śledzenia (musi być zgodna z monster_statistics.lua)
local MONSTERS_TO_TRACK = {
  ["rat"] = {name = "Rat", storageBase = 20000}
  -- Można dodać więcej potworów, np:
  -- ["spider"] = {name = "Spider", storageBase = 20001},
  -- ["troll"] = {name = "Troll", storageBase = 20002},
}

function onExtendedOpcode(player, opcode, buffer)
  if opcode == OPCODE_TASK then
    local allTasks = {}

    for taskId, task in pairs(TASKS) do
      local storage = task.storage or (10000 + taskId)
      local progress = math.max(0, player:getStorageValue(storage))
      local rewards = {}
      local monsters = {}

      -- Validate rewards
      if type(task.reward) == "table" then
        for _, reward in ipairs(task.reward) do
          local item = ItemType(reward.itemId)
          if item and item:getId() ~= 0 and item:getClientId() ~= 0 then
            table.insert(rewards, {
              itemId = item:getClientId(),
              count = reward.count
            })
          else
            print(string.format("[Task Opcode] Invalid reward itemId %s in task '%s'", tostring(reward.itemId), task.name))
          end
        end
      end

      -- Support both single monster and list
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

    player:sendExtendedOpcode(OPCODE_TASK, serializeTaskTable(allTasks))
  elseif opcode == OPCODE_MONSTER_STATS then
    -- Żądanie statystyk potworów
    local stats = {}
    
    for monsterKey, monsterData in pairs(MONSTERS_TO_TRACK) do
      local kills = math.max(0, player:getStorageValue(monsterData.storageBase))
      table.insert(stats, {
        name = monsterData.name,
        kills = kills
      })
    end
    
    -- Serializacja do JSON używając istniejącej funkcji
    local jsonData = serializeTaskTable(stats)
    player:sendExtendedOpcode(OPCODE_MONSTER_STATS, jsonData)
  end
end
