--[[
-- File name: cpp-tools.lua
-- Project: 
-- Author: Lasantha M Senanayake
-- Date created: 2026-04-03 16:17:54
-- Date modified: 2026-04-03 16:45:50
-- ------
--]]

-- lua/plugins/cpp-tools.lua
return {
  {
    "Badhi/nvim-treesitter-cpp-tools",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    ft = { "cpp", "c" },
    opts = function()
      local options = {
        preview = {
          quit = "q",
          accept = "<tab>",
        },
        header_extension = "hpp",
        source_extension = "cpp",
        custom_define_class_function_commands = {
          TSCppImplWrite = {
            output_handle = require("nt-cpp-tools.output_handlers").get_add_to_cpp(),
          },
        },
      }
      return options
    end,
    config = true,
    keys = {
      { "<leader>ci", "<cmd>TSCppDefineClassFunc<cr>", desc = "Preview impl in buffer" },
      { "<leader>cI", "<cmd>TSCppImplWrite<cr>", desc = "Write impl to .cpp file" },
      -- NOTE: intentionally <leader>cM, not <leader>cm -- LazyVim's core
      -- lsp/init.lua already binds <leader>cm to `:Mason`. Because both
      -- are plain (non-buffer-local) keymaps registered at plugin-load
      -- time, opening any C/C++ file used to make this plugin's mapping
      -- win the collision and silently shadow the global Mason shortcut
      -- for the rest of the session.
      { "<leader>cM", "<cmd>TSCppMakeConcreteClass<cr>", desc = "Make concrete class" },
      { "<leader>c3", "<cmd>TSCppRuleOf3<cr>", desc = "Rule of 3" },
      { "<leader>c5", "<cmd>TSCppRuleOf5<cr>", desc = "Rule of 5" },
    },
  },
}
