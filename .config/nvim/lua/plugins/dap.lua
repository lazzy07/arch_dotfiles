return {
  {
    "mfussenegger/nvim-dap",
    dependencies = { "Joakker/lua-json5" },
    config = function()
      local dap = require("dap")

      dap.adapters.lldb = {
        type = "executable",
        command = "lldb-dap",
        name = "lldb",
      }

      dap.configurations.cpp = {}
      dap.configurations.c = dap.configurations.cpp

      -- Load .vscode/launch.json automatically
      local json5 = require("json5")
      local launch_path = vim.fn.getcwd() .. "/.vscode/launch.json"

      if vim.fn.filereadable(launch_path) == 1 then
        local f = assert(io.open(launch_path, "r"))
        local content = f:read("*a")
        f:close()

        local ok, data = pcall(json5.parse, content)
        if ok and data.configurations then
          for _, cfg in ipairs(data.configurations) do
            table.insert(dap.configurations.cpp, cfg)
          end
        end
      end
    end,
  },
}
