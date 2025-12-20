return {
  "danymat/neogen",
  dependencies = "nvim-treesitter/nvim-treesitter",
  config = function()
    require("neogen").setup({
      enabled = true,
      languages = {
        cpp = {
          template = {
            annotation_convention = "doxygen",
          },
        },
        java = {
          template = {
            annotation_convention = "javadoc",
          },
        },
        typescript = {
          template = {
            annotation_convention = "tsdoc",
          },
        },
      },
    })
  end,
}
