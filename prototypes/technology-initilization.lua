local allAmmo = require("ammo-variants.all")

local itemsToFind = {}
local itemTechnologyDict = {}

local function AddDankToTechnology(originalItemName)
    local dankItemName = "dank-" .. originalItemName

    itemsToFind[originalItemName] = dankItemName
end

local function RemoveItemIfFound()
    local foundItem = nil

    for originalItemName, dankItemName in pairs(itemsToFind) do
        if dankItemName ~= nil then
            if itemTechnologyDict[dankItemName] ~= nil then
                log("Removing " .. dankItemName .. " from search queue...")
                foundItem = originalItemName
            end
        end
    end

    if foundItem ~= nil then
        itemsToFind[foundItem] = nil
    end
end

local function ParseItemsToFind(technology)
    for originalItemName, dankItemName in pairs(itemsToFind) do
        if dankItemName ~= nil then
            if data.raw.technology[technology.name] and data.raw.technology[technology.name].effects then
                for _, effect in ipairs(data.raw.technology[technology.name].effects) do
                    if effect.type == "unlock-recipe" and effect.recipe == originalItemName then
                        log("Adding " .. dankItemName .. " to " .. technology.name .. "!")
                        itemTechnologyDict[dankItemName] = technology.name
                    end
                end
            end
        end
    end

    RemoveItemIfFound()
end

local function FindTechnologyForItems()
    log("Finding Technologies to add dank variants to")
    for _, technology in pairs(data.raw["technology"]) do
        ParseItemsToFind(technology)
    end
end

for _, ammo in ipairs(allAmmo) do
    AddDankToTechnology(ammo)
end

FindTechnologyForItems()

-- Enable recipes that we couldn't find a matching technology for
for originalItemName, dankItemName in pairs(itemsToFind) do
    if originalItemName ~= nil and dankItemName ~= nil then
        log("Couldn't find a technology for " .. dankItemName .. " assuming it's enabled by default...")
        data.raw["recipe"][originalItemName].enabled = true
    end
end

-- Register recipes to the matching technology
for dankItemName, technologyName in pairs(itemTechnologyDict) do
    if dankItemName ~= nil and technologyName ~= nil then
        table.insert(data.raw["technology"][technologyName].effects, {type="unlock-recipe",recipe=dankItemName})
    end
end