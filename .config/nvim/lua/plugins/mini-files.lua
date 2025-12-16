return {
  "nvim-mini/mini.files",
  opts = {
    options = {
      use_as_default_exporer = true,
    },

    content = {
      filter = function()
        return true
      end,
    },
  },
}
