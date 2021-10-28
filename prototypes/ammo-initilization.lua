require("libs.ammo-functions")

local vars = require("libs.vars")
local directAmmoArray = require("ammo-variants.direct")
local projectileAmmoArray = require("ammo-variants.projectile")

local dankAmmoArray = {}

local function CreateDankAmmo(originalItemName)
    local ammo = table.deepcopy(data.raw["ammo"][originalItemName])
    local dankItemName = "dank-" .. originalItemName

    ammo.name = dankItemName
    ammo.localised_name = {"item-name.dank-ammo", {"item-name." .. originalItemName}}

    ammo.icons = CreateDankIconFromAmmo(ammo)

    ammo = CreateVariationsFromAmmo(ammo)

    return ammo
end

-- For use with ammo that directly deals damage
local function AddDankAmmoDirect(originalItemName)
    local dankAmmo = CreateDankAmmo(originalItemName)

    if dankAmmo
    and dankAmmo.ammo_type
    and dankAmmo.ammo_type.action
    and dankAmmo.ammo_type.action.action_delivery
    and dankAmmo.ammo_type.action.action_delivery.target_effects then
        dankAmmo = AddDankToTargetEffectsOfAmmo(dankAmmo)
        table.insert(dankAmmoArray, dankAmmo)
        log("Added dankified " .. originalItemName .. "!")
    else
        log("Couldn't dankify " .. originalItemName .. "!")
    end
end

-- For use with ammo that uses a projectile to deal damage
local function AddDankAmmoProjectile(originalItemName)
    local dankAmmo = CreateDankAmmo(originalItemName)

    local dankProjectileName = "dank-" .. NameOfFirstProjectileInAmmo(dankAmmo)

    dankAmmo = ValidateProjectileBasedAmmo(dankAmmo,  dankProjectileName)

    log("Searching for " .. dankProjectileName)

    if dankAmmo
    and dankAmmo.ammo_type
    and dankAmmo.ammo_type.action then
        for _, action in ipairs(dankAmmo.ammo_type.action) do
            if action.action_delivery
            and action.action_delivery.type == "projectile" then
                if action.action_delivery.projectile == dankProjectileName then
                    table.insert(dankAmmoArray, dankAmmo)
                    log("Added dankified " .. originalItemName .. "!")
                    return
                end
            end
            for _, action_delivery in ipairs(action.action_delivery) do
                if action_delivery and action_delivery.type == "projectile" then
                    if action_delivery.projectile == dankProjectileName then
                        table.insert(dankAmmoArray, dankAmmo)
                        log("Added dankified " .. originalItemName .. "!")
                    end
                end
            end
        end
    else
        log("Couldn't dankify " .. originalItemName .. "!")
    end

    log(serpent.block(dankAmmo))
end


for _, directAmmo in ipairs(directAmmoArray) do
    AddDankAmmoDirect(directAmmo)
end

for _, projectileAmmo in ipairs(projectileAmmoArray) do
    AddDankAmmoProjectile(projectileAmmo)
end

for _, dankAmmo in ipairs(dankAmmoArray) do
    data:extend({
        dankAmmo
    })
end