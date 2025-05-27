-- lua/custom/plugins/scope.lua
return {
  "tiagovla/scope.nvim",
  config = function()
    require("scope").setup({})
  end,
}