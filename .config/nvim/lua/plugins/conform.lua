--[[
-- File name: conform.lua
-- Project: 
-- Author: Lasantha M Senanayake
-- Date created: 2026-04-27 13:03:26
-- Date modified: 2026-04-27 13:03:33
-- ------
--]]

return {
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        xml = { "xmllint" },
      },
    },
  },
}
