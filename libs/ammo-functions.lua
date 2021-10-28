local vars = require("libs.vars")
local resources = require("libs.resources")

local function IsTableAnArray(table)
    if table
    and table[1] then
        return true
    end

    return false
end

local function ConvertTableToTableArray(inputTable)
    if IsTableAnArray(inputTable) then
        return inputTable
    end

    local new_table = {}
    table.insert(new_table, inputTable)

    return new_table
end

local function ValidateIcons(ammo)
    local icons = {}

    if ammo.icons then
        icons = ammo.icons
    elseif ammo.icon then
        local icon = {}
        icon["icon"] = ammo.icon
        table.insert(icons, icon)
    end

    return icons
end

function CreateDankIconFromAmmo(ammo)
    local icons = ValidateIcons(ammo)

    local backgroundIcon = {
        icon = resources.dank_background_path,
        icon_size = 64
    }

    table.insert(icons, 1, backgroundIcon)

    return icons
end

-- Ensures that the "pictures" table has a valid "layers" table
local function ValidatePictures(ammo)
    local pictures = {}
    local layers = {}

    if IsTableAnArray(ammo.pictures) then -- If the picture table is an array of pictures, copy each entry into the layers table, then finally assign the key "layers" in the picture table to the layers table.
        for _, picture in ipairs(ammo.pictures) do
            local copy = table.deepcopy(picture)
            table.insert(layers, copy)
        end

        pictures["layers"] = layers
        ammo.pictures = pictures
    elseif not ammo.pictures.layers  then -- Otherwise if the picture isn't an array and it doesn't have the key "layers", create said key.
        local copy = table.deepcopy(ammo.pictures)
        table.insert(layers, copy)

        pictures["layers"] = layers
        ammo.pictures = pictures
    end

    return ammo
end

function CreateVariationsFromAmmo(ammo)
    -- First check to see if the ammo needs to modified in the first place.
    if not ammo.pictures then
        return ammo -- Ammo doesn't have any variations, no need to modify any.
    end

    ammo = ValidatePictures(ammo) -- Validate the picture table before we modify it.

    local picture = {
        size = 64,
        filename = resources.dank_background_path,
        scale = 0.25
    }

    table.insert(ammo.pictures.layers, 1, picture)

    return ammo
end

function AddDankToTargetEffectsOfAmmo(ammo)
    local target_effects = ConvertTableToTableArray(ammo.ammo_type.action.action_delivery.target_effects)

    table.insert(target_effects, 1, {type = "damage", damage = { amount = vars.dank_damage, type = "ProAsHeck" }})
    table.insert(target_effects, {type = "create-entity", entity_name = "hitmarker", offsets = {{0, 1}}, offset_deviation = {{-1, -1}, {1, 1}}})

    ammo.ammo_type.action.action_delivery.target_effects = target_effects

    return ammo
end

function AddDankToTargetEffectsOfProjectile(projectile)
    local target_effects = ConvertTableToTableArray(projectile.action.action_delivery.target_effects)

    table.insert(target_effects, 1, {type = "damage", damage = { amount = vars.dank_damage, type = "ProAsHeck" }})
    table.insert(target_effects, {type = "create-entity", entity_name = "hitmarker", offsets = {{0, 1}}, offset_deviation = {{-1, -1}, {1, 1}}})

    projectile.action.action_delivery.target_effects = target_effects

    return projectile
end

function ValidateProjectileBasedAmmo(ammo, dankProjectileName)
    if ammo
    and ammo.ammo_type
    and ammo.ammo_type.action then
        for _, action in ipairs(ammo.ammo_type.action) do
            local action_delivery_array = ConvertTableToTableArray(action.action_delivery)
            for _, action_delivery in ipairs(action_delivery_array) do
                if action_delivery and action_delivery.type == "projectile" then
                    action_delivery.projectile = dankProjectileName
                end
            end
        end
    elseif ammo
    and ammo.ammo_type then
        ammo.ammo_type.action = ConvertTableToTableArray(ammo.ammo_type.action)
        for _, action in ipairs(ammo.ammo_type.action) do
            local action_delivery_array = ConvertTableToTableArray(action.action_delivery)
            for _, action_delivery in ipairs(action_delivery_array) do
                if action_delivery and action_delivery.type == "projectile" then
                    action_delivery.projectile = dankProjectileName
                end
            end
        end
    end

    return ammo
end

function NameOfFirstProjectileInAmmo(ammo)
    if ammo
    and ammo.ammo_type
    and ammo.ammo_type.action then
        for _, action in ipairs(ammo.ammo_type.action) do
            local action_delivery_array = ConvertTableToTableArray(action.action_delivery)
            for _, action_delivery in ipairs(action_delivery_array) do
                if action_delivery and action_delivery.type == "projectile" then
                    return action_delivery.projectile
                end
            end
        end
    end

    return nil
end