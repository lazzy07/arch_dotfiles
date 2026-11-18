-- IDE-style breadcrumb winbar (LSP/treesitter-aware path to the cursor).
-- Nothing else in this config provides this -- snacks.nvim already covers
-- zen mode, dim/twilight, indent guides and image previews (see
-- snacks.lua), so this is the one genuinely missing UI piece.
return {
  "Bekaboo/dropbar.nvim",
  event = "VeryLazy",
  keys = {
    {
      "<leader>uB",
      function()
        require("dropbar.api").pick()
      end,
      desc = "Winbar Pick",
    },
  },
}
