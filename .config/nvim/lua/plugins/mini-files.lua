return {
  "nvim-mini/mini.files",
  opts = {
    options = {
      use_as_default_explorer = true,
    },

    content = {
      filter = function()
        return true
      end,
    },
  },
}
