--[[
-- File name: json5.lua
-- Project: 
-- Author: Lasantha M Senanayake
-- Date created: 2026-02-03 17:39:56
-- Date modified: 2026-02-03 17:40:05
-- ------
--]]

return {
  {
    "Joakker/lua-json5",
    build = "./install.sh", -- builds the native module that provides `require("json5")`
    lazy = true,
  },
}
