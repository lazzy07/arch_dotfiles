-- CMake integration. The main point of adding this is
-- `cmake_compile_commands_options.action = "soft_link"`: it symlinks
-- build/compile_commands.json to the project root on every generate, so
-- clangd (see lsp.lua) always finds a complete compilation database
-- instead of falling back to guessed flags -- that fallback is what was
-- causing missing code actions / failed header auto-import.
return {
  {
    "Civitasv/cmake-tools.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    ft = { "cmake", "cpp", "c" },
    opts = {
      cmake_generate_options = { "-DCMAKE_EXPORT_COMPILE_COMMANDS=1" },
      cmake_compile_commands_options = {
        action = "soft_link",
      },
      cmake_build_directory = "build",
    },
    keys = {
      { "<leader>ckg", "<cmd>CMakeGenerate<cr>", desc = "CMake Generate" },
      { "<leader>ckb", "<cmd>CMakeBuild<cr>", desc = "CMake Build" },
      { "<leader>ckr", "<cmd>CMakeRun<cr>", desc = "CMake Run" },
      { "<leader>ckd", "<cmd>CMakeDebug<cr>", desc = "CMake Debug" },
      { "<leader>cks", "<cmd>CMakeStop<cr>", desc = "CMake Stop" },
      { "<leader>ckc", "<cmd>CMakeClean<cr>", desc = "CMake Clean" },
      { "<leader>ckt", "<cmd>CMakeSelectBuildType<cr>", desc = "CMake Select Build Type" },
    },
  },

  {
    "folke/which-key.nvim",
    opts = function(_, opts)
      local wk = require("which-key")
      wk.add({ { "<leader>ck", group = "cmake" } })
      return opts
    end,
  },
}
