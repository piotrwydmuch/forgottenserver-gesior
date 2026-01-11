--[[
    Task Definitions
    This file contains all task definitions for the Modern Task System.
    Edit this file to add, modify, or remove tasks.

    -- HOW TO ADD A NEW TASK --
    Add a new entry to the 'tasks' table below.
    [ID] = {
        name = "Task Name",
        category = "Category", -- Options: "Daily", "Story", "Hardcore", "All"
        mobs = {"monster1", "monster2"}, -- Exact names from monsters.xml
        count = 100, -- Kills required
        rewards = {
            {type = "exp", value = 1000},
            {type = "money", value = 500},
            {type = "points", value = 1},
            {type = "item", id = 2160, count = 1}
        },
        repeatable = true/false, -- Can repeat?
        cooldown = 20 * 3600, -- Only for Daily/Repeatable (Seconds). 20 * 3600 = 20 Hours.
        desc = "Description visible in UI."
    }
    
    -- HOW TO ADD COOLDOWNS --
    To add a cooldown, define the time in seconds.
    Example: 
       cooldown = 2 * 3600 -- 2 Hours
       cooldown = 30 * 60 -- 30 Minutes
    * Note: Cooldowns only work if 'repeatable = true'.

    -- HOW TO ADD CATEGORIES --
    1. Server: You can write ANY text in 'category', e.g., "Event", "VIP".
    2. Client: You MUST add a button in 'modern_tasks.otui' to filter by that name.
       Example Button in OTUI:
       Button
         id: tabEvent
         text: Event
         @onClick: modules.game_modern_tasks.selectCategory('Event')
]]

return {
    [1] = {
        name = "Rats Clean Up",
        category = "Daily",
        mobs = {"rat", "cave rat"},
        count = 50,
        rewards = {
            {type = "exp", value = 1000},
            {type = "points", value = 1},
            {type = "money", value = 500}
        },
        repeatable = true,
        cooldown = 20 * 3600, -- 20 Hours
        desc = "Clean the sewers."
    },
    [2] = {
        name = "Dragon Lord Hunt",
        category = "Story",
        mobs = {"dragon lord"},
        count = 100,
        rewards = {
            {type = "exp", value = 200000},
            {type = "points", value = 10},
            {type = "item", id = 2498, count = 1} -- Royal Helmet
        },
        repeatable = false,
        desc = "Prove your worth against the lords of dragons."
    },
    [3] = {
        name = "Demon Slayer",
        category = "Hardcore",
        mobs = {"demon"},
        count = 666,
        rewards = {
            {type = "exp", value = 666666},
            {type = "points", value = 50}
        },
        repeatable = true,
        desc = "The ultimate challenge."
    },
    [4] = {
        name = "Trolls Hunt",
        category = "Daily",
        mobs = {"troll", "troll champion", "swamp troll"},
        count = 10,
        rewards = {
            {type = "exp", value = 10000},
            {type = "points", value = 100}
        },
        repeatable = true,
        desc = "Hunt trolls and their champions."
    },
    [5] = {
        name = "Metins Hunt",
        category = "Daily",
        mobs = {"metin bitwy",},
        count = 2,
        rewards = {
            {type = "exp", value = 600000},
            {type = "points", value = 200},
            {type = "item", id = 1985, count = 1} -- Sword FightingSkill Book
        },
        repeatable = true,
        cooldown = 1 * 3600, -- 1 Hour
        desc = "Metins are coming!"
    },
}
