-- Electron debug configurations.
--
-- There's no official LazyVim "electron" extra, but Electron apps are just
-- Node (main process) + Chromium (renderer process), and LazyVim's
-- typescript extra already registers the `pwa-node`/`pwa-chrome` adapters
-- (backed by `js-debug-adapter`, mason-installed) via dap.core + the
-- typescript extra imported in lua/config/lazy.lua. This file only adds
-- two extra entries to the existing javascript/typescript configurations
-- list -- it never replaces `dap.configurations[...]`, only appends to it,
-- so it can't clobber the "Launch file" / "Attach" defaults.
--
-- See README.md > Debugging > Electron for how to use these day to day.
return {
  {
    "mfussenegger/nvim-dap",
    optional = true,
    opts = function()
      local dap = require("dap")

      local js_filetypes = { "typescript", "javascript", "typescriptreact", "javascriptreact" }
      local electron_bin = "${workspaceFolder}/node_modules/.bin/electron"

      for _, language in ipairs(js_filetypes) do
        dap.configurations[language] = dap.configurations[language] or {}
        vim.list_extend(dap.configurations[language], {
          {
            type = "pwa-node",
            request = "launch",
            name = "Electron: Main",
            runtimeExecutable = electron_bin,
            runtimeArgs = { "--remote-debugging-port=9222", "." },
            program = "${workspaceFolder}/main.js",
            cwd = "${workspaceFolder}",
            protocol = "inspector",
            sourceMaps = true,
            console = "integratedTerminal",
            skipFiles = { "<node_internals>/**", "node_modules/**" },
            resolveSourceMapLocations = { "${workspaceFolder}/**", "!**/node_modules/**" },
          },
          {
            type = "pwa-chrome",
            request = "attach",
            name = "Electron: Renderer",
            port = 9222,
            webRoot = "${workspaceFolder}",
            sourceMaps = true,
          },
        })
      end
    end,
  },
}
