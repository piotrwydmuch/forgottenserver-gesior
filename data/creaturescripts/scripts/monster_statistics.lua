-- Skrypt do śledzenia statystyk zabójstw potworów
-- Używa storage do przechowywania liczby zabitych potworów
-- Storage ID: 20000 + monsterId (gdzie monsterId to hash nazwy potwora)

-- Lista potworów do śledzenia (można rozszerzyć)
local MONSTERS_TO_TRACK = {
  ["rat"] = {name = "Rat", storageBase = 20000}
  -- Można dodać więcej potworów, np:
  -- ["spider"] = {name = "Spider", storageBase = 20001},
  -- ["troll"] = {name = "Troll", storageBase = 20002},
}

-- Funkcja do generowania storage ID dla potwora
local function getMonsterStorageId(monsterName)
  local monsterData = MONSTERS_TO_TRACK[monsterName:lower()]
  if monsterData then
    return monsterData.storageBase
  end
  return nil
end

-- Funkcja do zwiększania statystyk zabójstw
function onKill(creature, target)
  local player = creature:getPlayer()
  if not player or not target:isMonster() then 
    return true 
  end

  local targetName = target:getName():lower()
  local storageId = getMonsterStorageId(targetName)
  
  if storageId then
    local currentKills = math.max(0, player:getStorageValue(storageId))
    player:setStorageValue(storageId, currentKills + 1)
  end

  return true
end

