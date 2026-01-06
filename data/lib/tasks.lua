TASKS = {
  [1] = { storage = 91001, name = "Kill 10 Rats", monster = "Rat", amount = 10, reward = { { itemId = 2148, count = 100 } }, lookType = 21 },
  [2] = { storage = 91002, name = "Kill 25 Spiders", monster = "Spider", amount = 25, reward = { { itemId = 2148, count = 150 } }, lookType = 26 },
  [3] = { storage = 91003, name = "Kill 50 Rotworms", monster = "Rotworm", amount = 50, reward = { { itemId = 2148, count = 200 } }, lookType = 88 },
  [4] = { storage = 91004, name = "Kill 10 Trolls", monster = "Troll", amount = 10, reward = { { itemId = 2148, count = 80 } }, lookType = 30 },
  [5] = { storage = 91005, name = "Kill 100 Orcs", monster = "Orc", amount = 100, reward = { { itemId = 2160, count = 1 } }, lookType = 2 },
  [6] = { storage = 91006, name = "Kill 75 Amazons", monster = "Amazon", amount = 75, reward = { { itemId = 2160, count = 1 } }, lookType = 98 },
  [7] = { storage = 91007, name = "Kill 200 Skeletons", monster = "Skeleton", amount = 200, reward = { { itemId = 2160, count = 2 } }, lookType = 48 },
  [8] = { storage = 91008, name = "Kill 30 Ghouls", monster = "Ghoul", amount = 30, reward = { { itemId = 2152, count = 10 } }, lookType = 47 },
  [9] = { storage = 91009, name = "Kill 40 Cyclops", monster = "Cyclops", amount = 40, reward = { { itemId = 2152, count = 20 } }, lookType = 22 },
  [10] = { storage = 91010, name = "Kill 20 Dwarfs", monster = "Dwarf", amount = 20, reward = { { itemId = 2148, count = 300 } }, lookType = 31 },

  [11] = { storage = 91011, name = "Kill 10 Minotaurs", monster = "Minotaur", amount = 10, reward = { { itemId = 2148, count = 150 } }, lookType = 20 },
  [12] = { storage = 91012, name = "Kill 150 Slimes", monster = "Slime", amount = 150, reward = { { itemId = 2152, count = 15 } }, lookType = 55 },
  [13] = { storage = 91013, name = "Kill 100 Elves", monster = "Elf", amount = 100, reward = { { itemId = 2152, count = 25 } }, lookType = 34 },
  [14] = { storage = 91014, name = "Kill 300 Orc Spearmen",
    monster = {
      { name = "Orc Spearman", lookType = 23, points = 1 },
      { name = "Orc Leader", lookType = 7, points = 2 }
    },
    amount = 300,
    reward = {
      { itemId = 2160, count = 2 },
      { itemId = 2152, count = 20 },
      { itemId = 2152, count = 200 },
      { itemId = 2152, count = 200 },
      { itemId = 2152, count = 25 },
      { itemId = 2152, count = 82 }
    }, lookType = 23
  },
  [15] = { storage = 91015, name = "Kill 1000 Demons", monster = "Demon", amount = 1000, reward = { { itemId = 2160, count = 10 } }, lookType = 35 },
  [16] = { storage = 91016, name = "Kill 60 Fire Elementals", monster = "Fire Elemental", amount = 60, reward = { { itemId = 2152, count = 50 } }, lookType = 49 },
  [17] = { storage = 91017, name = "Kill 25 Dragon Lords", monster = "Dragon Lord", amount = 25, reward = { { itemId = 2160, count = 3 } }, lookType = 39 },
  [18] = { storage = 91018, name = "Kill 80 Dragons", monster = "Dragon", amount = 80, reward = { { itemId = 2152, count = 30 } }, lookType = 34 },
  [19] = { storage = 91019, name = "Kill 50 Beholders", monster = "Beholder", amount = 50, reward = { { itemId = 2152, count = 40 } }, lookType = 18 },
  [20] = { storage = 91020, name = "Kill 20 Vampire", monster = "Vampire", amount = 20, reward = { { itemId = 2160, count = 1 } }, lookType = 68 },

  [21] = { storage = 91021, name = "Kill 10 Warlocks", monster = "Warlock", amount = 10, reward = { { itemId = 2160, count = 2 } }, lookType = 130 },
  [22] = { storage = 91022, name = "Kill 15 Dark Magicians", monster = "Dark Magician", amount = 15, reward = { { itemId = 2160, count = 1 } }, lookType = 129 },
  [23] = { storage = 91023, name = "Kill 35 Witches", monster = "Witch", amount = 35, reward = { { itemId = 2152, count = 25 } }, lookType = 46 },
  [24] = { storage = 91024, name = "Kill 90 Frost Dragons", monster = "Frost Dragon", amount = 90, reward = { { itemId = 2160, count = 4 } }, lookType = 248 },
  [25] = { storage = 91025, name = "Kill 120 Hydras", monster = "Hydra", amount = 120, reward = { { itemId = 2160, count = 6 } }, lookType = 61 }
}




function jsonEscape(str)
  return str:gsub('[%c\\"]', {
    ['"']  = '\\"',
    ['\\'] = '\\\\',
    ['\b'] = '\\b',
    ['\f'] = '\\f',
    ['\n'] = '\\n',
    ['\r'] = '\\r',
    ['\t'] = '\\t',
  })
end

function serializeTaskTable(value)
  local function serialize(v)
    local t = type(v)
    if t == "nil" then
      return "null"
    elseif t == "number" or t == "boolean" then
      return tostring(v)
    elseif t == "string" then
      return '"' .. jsonEscape(v) .. '"'
    elseif t == "table" then
      -- Check if it's an array
      local isArray = true
      local index = 1
      for k, _ in pairs(v) do
        if k ~= index then
          isArray = false
          break
        end
        index = index + 1
      end

      local items = {}
      if isArray then
        for _, item in ipairs(v) do
          table.insert(items, serialize(item))
        end
        return "[" .. table.concat(items, ",") .. "]"
      else
        for k, item in pairs(v) do
          table.insert(items, '"' .. jsonEscape(tostring(k)) .. '":' .. serialize(item))
        end
        return "{" .. table.concat(items, ",") .. "}"
      end
    else
      error("Unsupported value type: " .. t)
    end
  end

  return serialize(value)
end
