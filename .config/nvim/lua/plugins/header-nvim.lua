-- Create source file header descriptions when creating and saving a file

return {
  "attilarepka/header.nvim",
  config = function()
    require("header").setup({
      allow_autocmds = true,
      file_name = true,
      author = "Lasantha M Senanayake",
      project = "",
      date_created = true,
    })
  end,
}
