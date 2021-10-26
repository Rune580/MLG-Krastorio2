require("libs.ammo-functions")

local projectileAmmoArray = require("ammo-variants.projectile")

local dankProjectiles = {}

local function AddDankProjectile(originalItemName)
    local dankProjectile = table.deepcopy(data.raw["projectile"][originalItemName])
    dankProjectile.name = "dank-" .. originalItemName

    if dankProjectile
    and dankProjectile.action
    and dankProjectile.action.action_delivery
    and dankProjectile.action.action_delivery.target_effects then
        dankProjectile = AddDankToTargetEffectsOfProjectile(dankProjectile)
        table.insert(dankProjectiles, dankProjectile)
        log("Added dankified " .. originalItemName .. "!")
    else
        log("Couldn't dankify " .. originalItemName .. "!")
    end
end

local function AddDankProjectileFromAmmoName(ammoName)
    local projectileName = NameOfFirstProjectileInAmmo(data.raw.ammo[ammoName])

    AddDankProjectile(projectileName)
end

for _, projectileAmmo in ipairs(projectileAmmoArray) do
    AddDankProjectileFromAmmoName(projectileAmmo)
end

for _, dankProjectile in ipairs(dankProjectiles) do
    data:extend({
        dankProjectile
    })
end