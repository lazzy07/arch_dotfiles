--[[
-- File name: transparent.lua
-- Project: 
-- Author: Lasantha M Senanayake
-- Date created: 2026-04-05 23:55:54
-- Date modified: 2026-04-05 23:56:01
-- ------
--]]

return {
  "xiyaowong/transparent.nvim",
  lazy = false,
  config = function()
    require("transparent").setup({
      extra_groups = {
        "NormalFloat",
        "NvimTreeNormal",
        "NvimTreeNormalNC",
      },
    })
    require("transparent").clear_prefix("BufferLine")
    require("transparent").clear_prefix("NeoTree")
    require("transparent").clear_prefix("Lazy")
  end,
}
