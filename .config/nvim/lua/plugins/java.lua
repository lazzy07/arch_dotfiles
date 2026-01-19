--[[
-- File name: java.lua
-- Project: 
-- Author: Lasantha M Senanayake
-- Date created: 2026-01-18 15:36:58
-- Date modified: 2026-01-18 15:37:13
-- ------
--]]

return {
  -- Java is mostly handled by :LazyExtras -> lang.java.
  -- This file is for Maven-/project-specific tweaks.

  {
    "mfussenegger/nvim-jdtls",
    opts = function(_, opts)
      -- (A) Better root detection for multi-module Maven:
      -- Prefer git root if present, otherwise fall back to the default marker logic.
      opts.root_dir = function(fname)
        local git_root = vim.fs.root(fname, { ".git" })
        if git_root then
          return git_root
        end
        -- default from LazyVim extra uses vim.lsp.config.jdtls.root_markers
        return vim.fs.root(fname, vim.lsp.config.jdtls.root_markers)
      end

      -- (B) Point jdtls Maven resolver at your settings.xml (optional)
      -- NOTE: some users report globalSettings may not be respected consistently by jdtls;
      -- userSettings tends to work. :contentReference[oaicite:2]{index=2}
      local home = vim.env.HOME
      opts.settings = opts.settings or {}
      opts.settings.java = opts.settings.java or {}
      opts.settings.java.maven = {
        userSettings = home .. "/.m2/settings.xml",
        -- globalSettings = "/etc/maven/settings.xml", -- enable if you actually use this
      }

      -- (C) If your project is huge and startup is slow, consider disabling main scan:
      -- opts.dap_main = false

      return opts
    end,
  },

  -- Convenience keymaps to run Maven from inside LazyVim
  {
    "folke/which-key.nvim",
    opts = function(_, opts)
      local wk = require("which-key")
      wk.add({
        { "<leader>m", group = "maven" },
        { "<leader>mm", "<cmd>terminal mvn -q test<cr>", desc = "mvn test" },
        { "<leader>mp", "<cmd>terminal mvn -q -DskipTests package<cr>", desc = "mvn package" },
        { "<leader>mi", "<cmd>terminal mvn -q install<cr>", desc = "mvn install" },
      })
      return opts
    end,
  },
}
