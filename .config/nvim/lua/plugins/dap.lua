-- IMPORTANT: this file only ever uses `opts` (a side-effect function),
-- never `config`. LazyVim's own dap extras (clangd/rust/python/typescript)
-- all configure "mfussenegger/nvim-dap" via `opts` functions, which
-- lazy.nvim chains together across every merged spec for the plugin. The
-- core dap setup (mason-nvim-dap install, DAP UI signs, launch.json
-- decoding) lives in LazyVim's `dap.core` extra as a `config` function --
-- and lazy.nvim keeps only ONE `config` per plugin across merged specs
-- (whichever spec is merged last wins outright, it does not compose).
-- This file used to define its own `config`, which silently replaced
-- LazyVim's: DAP signs and mason-nvim-dap auto-install silently stopped
-- working, and separately `dap.configurations.cpp = {}` wiped out the
-- codelldb configs the clangd extra had just set up -- that combination
-- is why debugging (especially C/C++) was broken.
return {
  {
    "mfussenegger/nvim-dap",
    dependencies = { "Joakker/lua-json5" },
    opts = function()
      local dap = require("dap")

      -- Optional extra adapter for launch.json entries using
      -- "type": "lldb" (e.g. exported from the CodeLLDB VSCode
      -- extension). The mason-managed `codelldb` adapter set up by
      -- LazyVim's clangd extra remains the default for plain
      -- launch/attach configs with no launch.json present.
      if vim.fn.executable("lldb-dap") == 1 and not dap.adapters.lldb then
        dap.adapters.lldb = {
          type = "executable",
          command = "lldb-dap",
          name = "lldb",
        }
      end
      -- Same adapter under the name the LLVM "lldb-dap" VSCode extension
      -- writes into launch.json ("type": "lldb-dap"). Without this alias
      -- those entries fail with "Config references missing adapter".
      if dap.adapters.lldb and not dap.adapters["lldb-dap"] then
        dap.adapters["lldb-dap"] = dap.adapters.lldb
      end

      -- nvim-dap auto-discovers `.vscode/launch.json` for every language
      -- on demand (see `:h dap-providers-configs`), so it no longer needs
      -- to be read manually here. LazyVim's dap.core extra already
      -- decodes it as JSONC (strips comments). Upgrade that to full json5
      -- (adds tolerance for trailing commas, which VSCode itself writes)
      -- with vim.schedule so this applies *after* dap.core's own `config`
      -- sets its default decoder: every `opts` function across all merged
      -- specs runs before the plugin's single `config`, so assigning this
      -- synchronously here would just get overwritten a moment later.
      vim.schedule(function()
        require("dap.ext.vscode").json_decode = require("json5").parse
      end)
    end,
  },
}
