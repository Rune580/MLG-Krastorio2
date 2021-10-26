local allAmmo = require("ammo-variants.all")

local recipes = {}

local function AddDankRecipe(originalItemName)
  local recipe = table.deepcopy(data.raw["recipe"][originalItemName])

  local dankItemName = "dank-" .. originalItemName

  recipe.name = dankItemName
  recipe.result = dankItemName

  table.insert(recipes, recipe)
end

for _, ammo in ipairs(allAmmo) do
  AddDankRecipe(ammo)
end

for _, recipe in ipairs(recipes) do
  data:extend({
    recipe
  })
end