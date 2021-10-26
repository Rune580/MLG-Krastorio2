local direct = require("direct")
local projectile = require("projectile")

local all = {}

for _, directAmmo in ipairs(direct) do
    table.insert(all, directAmmo)
end

for _, projectileAmmo in ipairs(projectile) do
    table.insert(all, projectileAmmo)
end

return all