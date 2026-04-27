--[[
-- File name: avante.lua
-- Project: 
-- Author: Lasantha M Senanayake
-- Date created: 2026-03-20 00:37:13
-- Date modified: 2026-03-20 00:37:21
-- ------
--]]

return {
  "yetone/avante.nvim",
  event = "VeryLazy",
  version = false,
  build = "make",
  opts = {
    provider = "claude-code",
    acp_providers = {
      ["claude-code"] = {
        command = "claude",
        args = { "--acp" },
      },
    },
  },
  keys = {
    { "<leader>aa", "<cmd>AvanteAsk<CR>", desc = "Avante Ask", mode = { "n", "v" } },
    { "<leader>ac", "<cmd>AvanteChat<CR>", desc = "Avante Chat" },
    { "<leader>ae", "<cmd>AvanteEdit<CR>", desc = "Avante Edit", mode = { "n", "v" } },
    { "<leader>at", "<cmd>AvanteToggle<CR>", desc = "Avante Toggle" },
    { "<leader>ar", "<cmd>AvanteRefresh<CR>", desc = "Avante Refresh" },
    { "<leader>af", "<cmd>AvanteFocus<CR>", desc = "Avante Focus" },
    { "<leader>ah", "<cmd>AvanteHistory<CR>", desc = "Avante History" },
    { "<leader>am", "<cmd>AvanteModels<CR>", desc = "Avante Switch Model" },
    { "<leader>an", "<cmd>AvanteChatNew<CR>", desc = "Avante New Chat" },
  },
  dependencies = {
    "nvim-lua/plenary.nvim",
    "MunifTanjim/nui.nvim",
    "nvim-tree/nvim-web-devicons",
  },
}
