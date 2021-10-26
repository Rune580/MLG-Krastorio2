local vars = require("libs.vars")

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
        icon = "__mlg-krastorio2__/graphics/dank-background.png",
        icon_size = 64
    }

    table.insert(icons, 1, backgroundIcon)

    return icons
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